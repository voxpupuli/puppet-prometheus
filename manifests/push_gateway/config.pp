# Class prometheus::push_gateway::config
# Configuration class for prometheus node exporter
class prometheus::push_gateway::config(
  $purge = true,
) {

  if $prometheus::push_gateway::init_style {

    case $prometheus::push_gateway::init_style {
      'upstart' : {
        file { '/etc/init/push_gateway.conf':
          mode    => '0444',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/push_gateway.upstart.erb'),
        }
        file { '/etc/init.d/push_gateway':
          ensure => link,
          target => '/lib/init/upstart-job',
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
        }
      }
      'systemd' : {
        file { '/lib/systemd/system/push_gateway.service':
          mode    => '0644',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/push_gateway.systemd.erb'),
        }~>
        exec { 'push_gateway-systemd-reload':
          command     => 'systemctl daemon-reload',
          path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
          refreshonly => true,
        }
      }
      'sysv' : {
        file { '/etc/init.d/push_gateway':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/push_gateway.sysv.erb')
        }
      }
      'debian' : {
        file { '/etc/init.d/push_gateway':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/push_gateway.debian.erb')
        }
      }
      'sles' : {
        file { '/etc/init.d/push_gateway':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/push_gateway.sles.erb')
        }
      }
      'launchd' : {
        file { '/Library/LaunchDaemons/io.push_gateway.daemon.plist':
          mode    => '0644',
          owner   => 'root',
          group   => 'wheel',
          content => template('prometheus/push_gateway.launchd.erb')
        }
      }
      default : {
        fail("I don't know how to create an init script for style ${prometheus::push_gateway::init_style}")
      }
    }
  }

}
