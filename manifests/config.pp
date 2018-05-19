# Class prometheus::config
# Configuration class for prometheus monitoring system
class prometheus::config {

  assert_private()

  if $prometheus::server::init_style {
    if( versioncmp($prometheus::server::version, '2.0.0') < 0 ){
      # helper variable indicating prometheus version, so we can use on this information in the template
      $prometheus_v2 = false
      if $prometheus::server::remote_read_configs != [] {
        fail('remote_read_configs requires prometheus 2.X')
      }
      if $prometheus::server::remote_write_configs != [] {
        fail('remote_write_configs requires prometheus 2.X')
      }
      $_daemon_flags = [
        '-log.format logger:stdout',
        "-config.file=${prometheus::server::config_dir}/${prometheus::server::configname}",
        "-storage.local.path=${prometheus::server::localstorage}",
        "-storage.local.retention=${prometheus::server::storage_retention}",
        "-web.console.templates=${prometheus::shared_dir}/consoles",
        "-web.console.libraries=${prometheus::shared_dir}/console_libraries",
      ]
      if $prometheus::server::extra_options {
        $daemon_flags = $_daemon_flags + $prometheus::server::extra_options
      } else {
        $daemon_flags = $_daemon_flags
      }
    } else {
      # helper variable indicating prometheus version, so we can use on this information in the template
      $prometheus_v2 = true
      $daemon_flags_basic = [
        "--config.file=${prometheus::server::config_dir}/${prometheus::server::configname}",
        "--storage.tsdb.path=${prometheus::server::localstorage}",
        "--storage.tsdb.retention=${prometheus::server::storage_retention}",
        "--web.console.templates=${prometheus::server::shared_dir}/consoles",
        "--web.console.libraries=${prometheus::server::shared_dir}/console_libraries",
      ]

      if $prometheus::server::external_url {
        $_daemon_flags = $daemon_flags_basic + "--web.external-url=${prometheus::server::external_url}"
      } else {
        $_daemon_flags = $daemon_flags_basic
      }
      if $prometheus::server::extra_options {
        $daemon_flags = $_daemon_flags + $prometheus::server::extra_options
      } else {
        $daemon_flags = $_daemon_flags
      }
    }

    # the vast majority of files here are init-files
    # so any change there should trigger a full service restart
    if $prometheus::server::restart_on_change {
      File {
        notify => Class['prometheus::run_service'],
      }
      $notify = Class['prometheus::run_service']
    } else {
      $notify = undef
    }

    case $prometheus::server::init_style {
      'upstart' : {
        file { '/etc/init/prometheus.conf':
          mode    => '0444',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/prometheus.upstart.erb'),
        }
        file { '/etc/init.d/prometheus':
          ensure => link,
          target => '/lib/init/upstart-job',
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
        }
      }
      'systemd' : {
        include 'systemd'
        systemd::unit_file {'prometheus.service':
          content => template('prometheus/prometheus.systemd.erb'),
        }
      }
      'sysv', 'redhat' : {
        file { '/etc/init.d/prometheus':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/prometheus.sysv.erb'),
        }
      }
      'debian' : {
        file { '/etc/init.d/prometheus':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/prometheus.debian.erb'),
        }
      }
      'sles' : {
        file { '/etc/init.d/prometheus':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/prometheus.sles.erb'),
        }
      }
      'launchd' : {
        file { '/Library/LaunchDaemons/io.prometheus.daemon.plist':
          mode    => '0644',
          owner   => 'root',
          group   => 'wheel',
          content => template('prometheus/prometheus.launchd.erb'),
        }
      }
      'freebsd': {
        file { '/usr/local/etc/rc.d/prometheus':
          mode    => '0555',
          owner   => 'root',
          group   => 'wheel',
          content => epp('prometheus/prometheus.freebsd.epp'),
        }
        if ( ! defined(File['/etc/rc.conf.local']) ) {
          file{'/etc/rc.conf.local':
            ensure => 'file',
          }
        }
        file_line{'prometheus_config_rc_conf_local':
          ensure => 'present',
          path   => '/etc/rc.conf.local',
          line   => "prometheus_config='${prometheus::server::config_dir}/${prometheus::server::configname}'",
          match  => '^prometheus_config',
        }
      }
      default : {
        fail("I don't know how to create an init script for style ${prometheus::server::init_style}")
      }
    }
  }

  # TODO: promtool currently does not support checking the syntax of file_sd_config "includes".
  # Ideally we'd check them the same way the other config files are checked.
  file { "${prometheus::config_dir}/file_sd_config.d":
    ensure  => directory,
    group   => $prometheus::server::group,
    purge   => true,
    recurse => true,
  }

  $prometheus::server::collect_scrape_jobs.each |Hash $job_definition| {
    if !has_key($job_definition, 'job_name') {
      fail('collected scrape job has no job_name!')
    }

    $job_name = $job_definition['job_name']

    Prometheus::Scrape_job <<| job_name == $job_name |>> {
      collect_dir => "${prometheus::config_dir}/file_sd_config.d",
      notify      => Class['::prometheus::service_reload'],
    }
  }
  # assemble the scrape jobs in a single list that gets appended to
  # $scrape_configs in the template
  $collected_scrape_jobs = $prometheus::server::collect_scrape_jobs.map |$job_definition| {
    $job_name = $job_definition['job_name']
    merge($job_definition, {
      file_sd_configs => [{
        files => [ "${prometheus::config_dir}/file_sd_config.d/${job_name}_*.yaml" ]
      }]
    })
  }

  if versioncmp($prometheus::server::version, '2.0.0') >= 0 {
    $cfg_verify_cmd = 'check config'
  } else {
    $cfg_verify_cmd = 'check-config'
  }

  if $prometheus::server::manage_config {
    file { 'prometheus.yaml':
      ensure       => present,
      path         => "${prometheus::server::config_dir}/${prometheus::server::configname}",
      owner        => $prometheus::server::user,
      group        => $prometheus::server::group,
      mode         => $prometheus::server::config_mode,
      notify       => $notify,
      content      => template($prometheus::server::config_template),
      validate_cmd => "${prometheus::server::bin_dir}/promtool ${cfg_verify_cmd} %",
    }
  }
}
