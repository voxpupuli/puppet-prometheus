# Class prometheus::config
# Configuration class for prometheus monitoring system
class prometheus::config (
  $global_config,
  $rule_files,
  Array[Hash] $scrape_configs,
  $remote_read_configs,
  $config_template                 = $::prometheus::params::config_template,
  $storage_retention               = $::prometheus::params::storage_retention,
  Array[Hash] $collect_scrape_jobs = $::prometheus::params::collect_scraper_jobs,
) {

  if $prometheus::init_style {
    if( versioncmp($::prometheus::version, '2.0.0') < 0 ){
      # helper variable indicating prometheus version, so we can use on this information in the template
      $prometheus_v2 = false
      if $remote_read_configs != [] {
        fail('remote_read_configs requires prometheus 2.X')
      }
      $daemon_flags = [
        "-config.file=${::prometheus::config_dir}/prometheus.yaml",
        "-storage.local.path=${::prometheus::localstorage}",
        "-storage.local.retention=${storage_retention}",
        "-web.console.templates=${::prometheus::shared_dir}/consoles",
        "-web.console.libraries=${::prometheus::shared_dir}/console_libraries",
      ]
    } else {
      # helper variable indicating prometheus version, so we can use on this information in the template
      $prometheus_v2 = true
      $daemon_flags = [
        "--config.file=${::prometheus::config_dir}/prometheus.yaml",
        "--storage.tsdb.path=${::prometheus::localstorage}",
        "--storage.tsdb.retention=${storage_retention}",
        "--web.console.templates=${::prometheus::shared_dir}/consoles",
        "--web.console.libraries=${::prometheus::shared_dir}/console_libraries",
      ]
    }

    # the vast majority of files here are init-files
    # so any change there should trigger a full service restart
    if $::prometheus::restart_on_change {
      File {
        notify => [Class['::prometheus::run_service']],
      }
      $systemd_notify = [Exec['prometheus-systemd-reload'], Class['::prometheus::run_service']]
    } else {
      $systemd_notify = Exec['prometheus-systemd-reload']
    }

    case $prometheus::init_style {
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
        ::systemd::unit_file {'prometheus.service':
          content => template('prometheus/prometheus.systemd.erb'),
        }
      }
      'sysv' : {
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
      default : {
        fail("I don't know how to create an init script for style ${prometheus::init_style}")
      }
    }
  }

  # TODO: promtool currently does not support checking the syntax of file_sd_config "includes".
  # Ideally we'd check them the same way the other config files are checked.
  file { "${prometheus::config_dir}/collected_configs":
    ensure  => directory,
    owner   => $prometheus::user,
    group   => $prometheus::group,
    purge   => true,
    recurse => true,
  }

  $collect_scrape_jobs.each |Hash $job_definition| {
    if !has_key($job_definition, 'job_name') {
      fail('collected scrape job has no job_name!')
    }

    $job_name = $job_definition['job_name']

    Prometheus::Scrape_job <<| job_name == $job_name |>> {
      collect_dir => "${prometheus::config_dir}/collected_configs",
      notify      => Class['::prometheus::service_reload'],
    }
  }

  # we build the "real" scrape_configs by ensuring the exported configs have the right
  # file_sd_configs setting
  $collected_scrape_jobs = $collect_scrape_jobs.map |$job_definition| {
    $job_name = $job_definition['job_name']
    merge($job_definition, {
      file_sd_configs => [{
        files => [ "${prometheus::config_dir}/collected_configs/${job_name}_*.yaml" ]
      }]
    })
  }

  $real_scrape_configs = concat($scrape_configs, $collected_scrape_jobs)

  if versioncmp($prometheus::version, '2.0.0') >= 0 {
    $cfg_verify_cmd = 'check config'
  } else {
    $cfg_verify_cmd = 'check-config'
  }

  file { 'prometheus.yaml':
    ensure       => present,
    path         => "${prometheus::config_dir}/prometheus.yaml",
    owner        => $prometheus::user,
    group        => $prometheus::group,
    mode         => $prometheus::config_mode,
    notify       => Class['::prometheus::service_reload'],
    require      => File["${prometheus::config_dir}/${prometheus::alertfile_name}"],
    content      => template($config_template),
    validate_cmd => "${prometheus::bin_dir}/promtool ${cfg_verify_cmd} %",
  }

}
