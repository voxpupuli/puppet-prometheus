# @summary Configuration class for prometheus monitoring system
class prometheus::config {
  assert_private()

  $max_open_files = $prometheus::server::max_open_files

  $enable_tracing = $prometheus::server::enable_tracing

  if $prometheus::server::include_default_scrape_configs {
    $default_scrape_configs = [
      {
        'job_name'        => 'prometheus',
        'scrape_interval' => '10s',
        'scrape_timeout'  => '10s',
        'static_configs'  => [
          {
            'targets' => ['localhost:9090'],
            'labels'  => {
              'alias' => 'Prometheus',
            },
          },
        ],
      }
    ]
    $scrape_configs = $default_scrape_configs + $prometheus::server::scrape_configs
  } else {
    $scrape_configs = $prometheus::server::scrape_configs
  }

  # Formatting
  $web_page_title = if ($prometheus::web_page_title) { "\"${prometheus::web_page_title}\"" } else { undef }
  $web_cors_origin = if ($prometheus::web_cors_origin) { "\"${prometheus::web_cors_origin}\"" } else { undef }
  $command_line_flags = {
    'config.file'                              => "${prometheus::server::config_dir}/${prometheus::server::configname}",
    'web.listen-address'                       => $prometheus::web_listen_address,
    'web.read-timeout'                         => $prometheus::web_read_timeout,
    'web.max-connections'                      => $prometheus::web_max_connections,
    'web.external-url'                         => $prometheus::server::external_url,
    'web.route-prefix'                         => $prometheus::web_route_prefix,
    'web.user-assets'                          => $prometheus::web_user_assets,
    'web.enable-lifecycle'                     => $prometheus::web_enable_lifecycle,
    'web.enable-admin-api'                     => $prometheus::web_enable_admin_api,
    'web.console.templates'                    => "${prometheus::shared_dir}/consoles",
    'web.console.libraries'                    => "${prometheus::shared_dir}/console_libraries",
    'web.page-title'                           => $web_page_title,
    'web.cors.origin'                          => $web_cors_origin,
    'storage.tsdb.path'                        => $prometheus::server::localstorage,
    'storage.tsdb.retention.time'              => $prometheus::server::storage_retention,
    'storage.tsdb.retention.size'              => $prometheus::storage_retention_size,
    'storage.tsdb.no-lockfile'                 => $prometheus::storage_no_lockfile,
    'storage.tsdb.allow-overlapping-blocks'    => $prometheus::storage_allow_overlapping_blocks,
    'storage.tsdb.wal-compression'             => $prometheus::storage_wal_compression,
    'storage.remote.flush-deadline'            => $prometheus::storage_flush_deadline,
    'storage.remote.read-sample-limit'         => $prometheus::storage_read_sample_limit,
    'storage.remote.read-concurrent-limit'     => $prometheus::storage_read_concurrent_limit,
    'storage.remote.read-max-bytes-in-frame'   => $prometheus::storage_read_max_bytes_in_frame,
    'rules.alert.for-outage-tolerance'         => $prometheus::alert_for_outage_tolerance,
    'rules.alert.for-grace-period'             => $prometheus::alert_for_grace_period,
    'rules.alert.resend-delay'                 => $prometheus::alert_resend_delay,
    'alertmanager.notification-queue-capacity' => $prometheus::alertmanager_notification_queue_capacity,
    'alertmanager.timeout'                     => $prometheus::alertmanager_timeout,
    'query.lookback-delta'                     => $prometheus::query_lookback_delta,
    'query.timeout'                            => $prometheus::query_timeout,
    'query.max-concurrency'                    => $prometheus::query_max_concurrency,
    'query.max-samples'                        => $prometheus::query_max_samples,
    'log.level'                                => $prometheus::log_level,
    'log.format'                               => $prometheus::log_format,
  }

  $extra_options = [$prometheus::server::extra_options].filter |$opts| { $opts and $opts != '' }
  $flags         =  $command_line_flags
  .filter |$flag, $value| {
    $value ? {
      Boolean => $value,
      String  => $value != '',
      Undef   => false,
      default => fail("Illegal value for ${flag} parameter")
    }
  }
  .map    |$flag, $value| {
    $value ? {
      Boolean => "--${flag}",
      String  => "--${flag}=${value}",
      default => fail("Illegal value for ${flag} parameter")
    }
  }
  $daemon_flags = $flags + $extra_options

  # Service files (init-files/systemd unit files) need to trigger a full service restart
  # prometheus.yaml and associated scrape file changes should only trigger a reload (and not use $notify)
  $notify = $prometheus::server::restart_on_change ? {
    true    => Class['prometheus::run_service'],
    default => undef,
  }

  if $prometheus::env_file_path {
    file { "${prometheus::env_file_path}/prometheus":
      mode    => '0644',
      owner   => 'root',
      group   => '0', # Darwin uses wheel
      content => "ARGS='${join(sort($daemon_flags), ' ')}'\n",
      notify  => $notify,
    }
  }

  if $prometheus::server::manage_init_file {
    case $prometheus::server::init_style {
      'upstart': {
        file { '/etc/init/prometheus.conf':
          ensure  => file,
          mode    => '0444',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/prometheus.upstart.erb'),
          notify  => $notify,
        }
        file { '/etc/init.d/prometheus':
          ensure => link,
          target => '/lib/init/upstart-job',
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
          notify => $notify,
        }
      }
      'systemd': {
        if $max_open_files {
          $systemd_service_options = $prometheus::systemd_service_options + { 'LimitNOFILE' => $max_open_files }
        } else {
          $systemd_service_options = $prometheus::systemd_service_options
        }
        systemd::manage_unit { 'prometheus.service':
          unit_entry    => {
            'Description' => 'Prometheus Monitoring framework',
            'Wants'       => 'basic.target',
            'After'       => ['basic.target', 'network.target'],
          } + $prometheus::systemd_unit_options,
          service_entry => {
            'User'                   => $prometheus::server::user,
            'Group'                  => $prometheus::server::group,
            'ExecStart'              => sprintf('%s/prometheus %s', $prometheus::server::bin_dir,  $daemon_flags.join(' ')),
            'ExecReload'             => '/bin/kill -HUP $MAINPID',
            'KillMode'               => 'process',
            'Restart'                => 'always',
            'NoNewPrivileges'        => true,
            'ProtectHome'            => true,
            'ProtectSystem'          => 'full',
            'ProtectHostname'        => true,
            'ProtectControlGroups'   => true,
            'ProtectKernelModules'   => true,
            'ProtectKernelTunables'  => true,
            'LockPersonality'        => true,
            'RestrictRealtime'       => true,
            'RestrictNamespaces'     => true,
            'MemoryDenyWriteExecute' => true,
            'PrivateDevices'         => true,
            'CapabilityBoundingSet'  => '',
          } + $systemd_service_options,
          install_entry => {
            'WantedBy' => 'multi-user.target',
          } + $prometheus::systemd_install_options,
          notify        => $notify,
        }
      }
      'sysv', 'sles': {
        file { "/etc/init.d/${prometheus::server::service_name}":
          ensure  => file,
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template("prometheus/prometheus.${prometheus::server::init_style}.erb"),
          notify  => $notify,
        }
      }
      'launchd': {
        file { '/Library/LaunchDaemons/io.prometheus.daemon.plist':
          ensure  => file,
          mode    => '0644',
          owner   => 'root',
          group   => 'wheel',
          content => template('prometheus/prometheus.launchd.erb'),
          notify  => $notify,
        }
      }
      default, 'none': {}
    }
  }

  # TODO: promtool currently does not support checking the syntax of file_sd_config "includes".
  # Ideally we'd check them the same way the other config files are checked.
  file { "${prometheus::config_dir}/file_sd_config.d":
    ensure  => directory,
    group   => $prometheus::server::group,
    purge   => $prometheus::purge_config_dir,
    recurse => true,
    notify  => Class['prometheus::service_reload'], # After purging, a reload is needed
  }

  $prometheus::server::collect_scrape_jobs.each |Hash $job_definition| {
    if ! ('job_name' in $job_definition) {
      fail('collected scrape job has no job_name!')
    }

    $job_name = $job_definition['job_name']

    $node_tag = $prometheus::server::collect_tag ? {
      Undef   => 'prometheus::scrape_job',
      default => $prometheus::server::collect_tag,
    }

    Prometheus::Scrape_job <<| job_name == $job_name and tag == $node_tag |>> {
      collect_dir => "${prometheus::config_dir}/file_sd_config.d",
      notify      => Class['prometheus::service_reload'],
    }
  }
  # assemble the scrape jobs in a single list that gets appended to
  # $scrape_configs in the template
  $collected_scrape_jobs = $prometheus::server::collect_scrape_jobs.map |$job_definition| {
    $job_name = $job_definition['job_name']
    $job_definition + {
      file_sd_configs => [{
          files => ["${prometheus::config_dir}/file_sd_config.d/${job_name}_*.yaml"]
      }]
    }
  }

  if versioncmp($prometheus::server::version, '2.0.0') >= 0 {
    $cfg_verify_cmd = 'check config'
  } else {
    $cfg_verify_cmd = 'check-config'
  }

  if $prometheus::server::manage_config {
    file { 'prometheus.yaml':
      ensure       => file,
      path         => "${prometheus::server::config_dir}/${prometheus::server::configname}",
      owner        => 'root',
      group        => $prometheus::server::group,
      mode         => $prometheus::server::config_mode,
      notify       => Class['prometheus::service_reload'],
      show_diff    => $prometheus::config_show_diff,
      content      => template($prometheus::server::config_template),
      validate_cmd => "${prometheus::server::bin_dir}/promtool ${cfg_verify_cmd} %",
    }
  }
}
