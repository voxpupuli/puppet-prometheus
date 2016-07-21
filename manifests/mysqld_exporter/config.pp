# Class prometheus::mysqld_exporter::config
# Configuration class for prometheus mysqld exporter
class prometheus::mysqld_exporter::config(
  $purge = true,
) {

  if $prometheus::mysqld_exporter::init_style {

    case $prometheus::mysqld_exporter::init_style {
      'upstart' : {
        file { '/etc/init/mysqld_exporter.conf':
          mode    => '0444',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/mysqld_exporter.upstart.erb'),
        }
        file { '/etc/init.d/mysqld_exporter':
          ensure => link,
          target => '/lib/init/upstart-job',
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
        }
      }
      'systemd' : {
        file { '/lib/systemd/system/mysqld_exporter.service':
          mode    => '0644',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/mysqld_exporter.systemd.erb'),
        }~>
        exec { 'mysqld_exporter-systemd-reload':
          command     => 'systemctl daemon-reload',
          path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
          refreshonly => true,
        }
      }
      'sysv' : {
        file { '/etc/init.d/mysqld_exporter':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/mysqld_exporter.sysv.erb')
        }
      }
      'debian' : {
        file { '/etc/init.d/mysqld_exporter':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/mysqld_exporter.debian.erb')
        }
      }
      'sles' : {
        file { '/etc/init.d/mysqld_exporter':
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/mysqld_exporter.sles.erb')
        }
      }
      'launchd' : {
        file { '/Library/LaunchDaemons/io.mysqld_exporter.daemon.plist':
          mode    => '0644',
          owner   => 'root',
          group   => 'wheel',
          content => template('prometheus/mysqld_exporter.launchd.erb')
        }
      }
      default : {
        fail("I don't know how to create an init script for style ${prometheus::mysqld_exporter::init_style}")
      }
    }
  }

}
