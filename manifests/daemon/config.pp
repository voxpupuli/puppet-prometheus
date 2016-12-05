class prometheus::daemon::config(
  $purge = true,
  $init_style,
  $daemon_name,
  $user,
  $group,
  $options,
  ) {
    if $init_style {

      case $init_style {
        'upstart' : {
          file { "/etc/init/${daemon_name}.conf":
            mode    => '0444',
            owner   => 'root',
            group   => 'root',
            content => template('prometheus/daemon.upstart.erb'),
          }
          file { "/etc/init.d/${daemon_name}":
            ensure => link,
            target => '/lib/init/upstart-job',
            owner  => 'root',
            group  => 'root',
            mode   => '0755',
          }
        }
        'systemd' : {
          file { "/lib/systemd/system/${daemon_name}.service":
            mode    => '0644',
            owner   => 'root',
            group   => 'root',
            content => template('prometheus/daemon.systemd.erb'),
          }~>
          exec { "${daemon_name}-systemd-reload":
            command     => 'systemctl daemon-reload',
            path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
            refreshonly => true,
          }
        }
        'sysv' : {
          file { "/etc/init.d/${daemon_name}":
            mode    => '0555',
            owner   => 'root',
            group   => 'root',
            content => template('prometheus/daemon.sysv.erb'),
          }
        }
        'debian' : {
          file { "/etc/init.d/${daemon_name}":
            mode    => '0555',
            owner   => 'root',
            group   => 'root',
            content => template('prometheus/daemon.debian.erb'),
          }
        }
        'sles' : {
          file { "/etc/init.d/${daemon_name}":
            mode    => '0555',
            owner   => 'root',
            group   => 'root',
            content => template('prometheus/daemon.sles.erb'),
          }
        }
        'launchd' : {
          file { "/Library/LaunchDaemons/io.${daemon_name}.daemon.plist":
            mode    => '0644',
            owner   => 'root',
            group   => 'wheel',
            content => template('prometheus/daemon.launchd.erb'),
          }
        }
        default : {
          fail("I don't know how to create an init script for style ${init_style}")
        }
      }
    }
  }
