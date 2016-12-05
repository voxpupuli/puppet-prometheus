# Class prometheus::alert_manager::config
# Configuration class for prometheus node exporter
class prometheus::alert_manager::config(
  $purge = true,
) {

  $options = "-config.file=${prometheus::alert_manager::config_file} -storage.path=${prometheus::alert_manager::storage_path} ${prometheus::alert_manager::extra_options}"
  $user = $prometheus::alert_manager::user
  $group = $prometheus::alert_manager::group
  $daemon_name = 'alert_manager'

  if $prometheus::alert_manager::init_style {

    case $prometheus::alert_manager::init_style {
      'upstart' : {
        file { '/etc/init/alert_manager.conf':
          mode    => '0444',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/daemon.upstart.erb'),
        }
        file { '/etc/init.d/alert_manager':
          ensure => link,
          target => '/lib/init/upstart-job',
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
        }
      }
      'systemd' : {
        file { '/lib/systemd/system/alert_manager.service':
          mode    => '0644',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/daemon.systemd.erb'),
        }~>
        exec { 'alert_manager-systemd-reload':
          command     => 'systemctl daemon-reload',
          path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
          refreshonly => true,
        }
      }
      'sysv' : {
        file { '/etc/init.d/alert_manager':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/daemon.sysv.erb'),
        }
      }
      'debian' : {
        file { '/etc/init.d/alert_manager':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/daemon.debian.erb'),
        }
      }
      'sles' : {
        file { '/etc/init.d/alert_manager':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/daemon.sles.erb'),
        }
      }
      'launchd' : {
        file { '/Library/LaunchDaemons/io.alert_manager.daemon.plist':
          mode    => '0644',
          owner   => 'root',
          group   => 'wheel',
          content => template('prometheus/daemon.launchd.erb'),
        }
      }
      default : {
        fail("I don't know how to create an init script for style ${prometheus::alert_manager::init_style}")
      }
    }
  }

  file { $prometheus::alert_manager::config_dir:
    ensure  => 'directory',
    owner   => $prometheus::alert_manager::user,
    group   => $prometheus::alert_manager::group,
    purge   => $purge,
    recurse => $purge,
  }

  file { $prometheus::alert_manager::config_file:
    ensure  => present,
    owner   => $prometheus::alert_manager::user,
    group   => $prometheus::alert_manager::group,
    mode    => $prometheus::alert_manager::config_mode,
    content => template('prometheus/alert_manager.yaml.erb'),
    require => File[$prometheus::alert_manager::config_dir],
  }

}
