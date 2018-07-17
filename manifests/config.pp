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
      $daemon_flags = [
        "-config.file=${prometheus::server::config_dir}/${prometheus::server::configname}",
        "-storage.local.path=${prometheus::server::localstorage}",
        "-storage.local.retention=${prometheus::server::storage_retention}",
        "-web.console.templates=${prometheus::shared_dir}/consoles",
        "-web.console.libraries=${prometheus::shared_dir}/console_libraries",
      ]
    } else {
      # helper variable indicating prometheus version, so we can use on this information in the template
      $prometheus_v2 = true
      $daemon_flags = [
        "--config.file=${prometheus::server::config_dir}/${prometheus::server::configname}",
        "--storage.tsdb.path=${prometheus::server::localstorage}",
        "--storage.tsdb.retention=${prometheus::server::storage_retention}",
        "--web.console.templates=${prometheus::server::shared_dir}/consoles",
        "--web.console.libraries=${prometheus::server::shared_dir}/console_libraries",
        "--web.external-url='${prometheus::server::external_url}'",
      ]
    }

    # the vast majority of files here are init-files
    # so any change there should trigger a full service restart
    if $prometheus::server::restart_on_change {
      File {
        notify => Class['prometheus::run_service'],
      }
      $systemd_notify = [Exec['prometheus-systemd-reload'], Class['prometheus::run_service']]
    } else {
      $systemd_notify = Exec['prometheus-systemd-reload']
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
        fail("I don't know how to create an init script for style ${prometheus::server::init_style}")
      }
    }
  }

  if versioncmp($prometheus::server::version, '2.0.0') >= 0 {
    $cfg_verify_cmd = 'check config'
  } else {
    $cfg_verify_cmd = 'check-config'
  }

  file { 'prometheus.yaml':
    ensure       => present,
    path         => "${prometheus::server::config_dir}/${prometheus::server::configname}",
    owner        => $prometheus::server::user,
    group        => $prometheus::server::group,
    mode         => $prometheus::server::config_mode,
    notify       => Class['prometheus::service_reload'],
    content      => template($prometheus::server::config_template),
    validate_cmd => "${prometheus::server::bin_dir}/promtool ${cfg_verify_cmd} %",
  }

}
