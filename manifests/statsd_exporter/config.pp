# Class prometheus::statsd_exporter::config
# Configuration class for prometheus node exporter
class prometheus::statsd_exporter::config(
  $purge = true,
) {

  $extra_statsd_maps = hiera_array('prometheus::statsd_exporter::statsd_maps')
  $statsd_maps = join($extra_statsd_maps, $prometheus::statsd_exporter::statsd_maps)

  file { $prometheus::statsd_exporter::mapping_config_path:
    ensure  => 'file',
    mode    => '0644',
    owner   => $prometheus::statsd_exporter::user,
    group   => $prometheus::statsd_exporter::group,
    content => template('prometheus/statsd_mapping.conf.erb'),
    notify  => Service['statsd_exporter'],
  }

  if $prometheus::statsd_exporter::init_style {

    case $prometheus::statsd_exporter::init_style {
      'upstart' : {
        file { '/etc/init/statsd_exporter.conf':
          mode    => '0444',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/statsd_exporter.upstart.erb'),
        }
        file { '/etc/init.d/statsd_exporter':
          ensure => link,
          target => '/lib/init/upstart-job',
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
        }
      }
      'systemd' : {
        file { '/lib/systemd/system/statsd_exporter.service':
          mode    => '0644',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/statsd_exporter.systemd.erb'),
        }~>
        exec { 'statsd_exporter-systemd-reload':
          command     => 'systemctl daemon-reload',
          path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
          refreshonly => true,
        }
      }
      'sysv' : {
        file { '/etc/init.d/statsd_exporter':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/statsd_exporter.sysv.erb')
        }
      }
      'debian' : {
        file { '/etc/init.d/statsd_exporter':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/statsd_exporter.debian.erb')
        }
      }
      'sles' : {
        file { '/etc/init.d/statsd_exporter':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/statsd_exporter.sles.erb')
        }
      }
      'launchd' : {
        file { '/Library/LaunchDaemons/io.statsd_exporter.daemon.plist':
          mode    => '0644',
          owner   => 'root',
          group   => 'wheel',
          content => template('prometheus/statsd_exporter.launchd.erb')
        }
      }
      default : {
        fail("I don't know how to create an init script for style ${prometheus::statsd_exporter::init_style}")
      }
    }
  }

}
