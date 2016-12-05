# Class prometheus::node_exporter::config
# Configuration class for prometheus node exporter
class prometheus::node_exporter::config(
  $purge = true,
) {

  $collectors = join($prometheus::node_exporter::collectors, ',')
  $options = "-collectors.enabled=${collectors} ${prometheus::node_exporter::extra_options}"
  $user = $prometheus::node_exporter::user
  $group = $prometheus::node_exporter::group
  $exporter_name = 'node_exporter'

  if $prometheus::node_exporter::init_style {

    case $prometheus::node_exporter::init_style {
      'upstart' : {
        file { '/etc/init/node_exporter.conf':
          mode    => '0444',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/exporter.upstart.erb'),
        }
        file { '/etc/init.d/node_exporter':
          ensure => link,
          target => '/lib/init/upstart-job',
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
        }
      }
      'systemd' : {
        file { '/lib/systemd/system/node_exporter.service':
          mode    => '0644',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/exporter.systemd.erb'),
        }~>
        exec { 'node_exporter-systemd-reload':
          command     => 'systemctl daemon-reload',
          path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
          refreshonly => true,
        }
      }
      'sysv' : {
        file { '/etc/init.d/node_exporter':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/exporter.sysv.erb')
        }
      }
      'debian' : {
        file { '/etc/init.d/node_exporter':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/exporter.debian.erb')
        }
      }
      'sles' : {
        file { '/etc/init.d/node_exporter':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/node_exporter.sles.erb')
        }
      }
      'launchd' : {
        file { '/Library/LaunchDaemons/io.node_exporter.daemon.plist':
          mode    => '0644',
          owner   => 'root',
          group   => 'wheel',
          content => template('prometheus/exporter.launchd.erb')
        }
      }
      default : {
        fail("I don't know how to create an init script for style ${prometheus::node_exporter::init_style}")
      }
    }
  }

}
