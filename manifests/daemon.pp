define prometheus::daemon (
  $install_method,
  $version,
  $download_extension,
  $os,
  $arch,
  $real_download_url,
  $bin_dir,
  $notify_service,
  $package_name,
  $package_ensure,
  $manage_user,
  $user,
  $extra_groups,
  $group,
  $manage_group,
  $purge,
  $options,
  $init_style,
  $service_ensure,
  $service_enable,
  $manage_service,
  ) {
    case $install_method {
      'url': {
        include staging
        $staging_file = "${name}-${version}.${download_extension}"
        $binary = "${::staging::path}/${name}-${version}.${os}-${arch}/${name}"
        staging::file { $staging_file:
          source => $real_download_url,
        } ->
        staging::extract { $staging_file:
          target  => $::staging::path,
          creates => $binary,
        } ->
        file { $binary:
            owner => 'root',
            group => 0, # 0 instead of root because OS X uses "wheel".
            mode  => '0555',
        } ->
        file { "${bin_dir}/${name}":
            ensure => link,
            notify => $notify_service,
            target => $binary,
        }
      }
      'package': {
        package { $package_name:
          ensure => $package_ensure,
        }
        if $manage_user {
          User[$user] -> Package[$package_name]
        }
      }
      'none': {}
      default: {
        fail("The provided install method ${install_method} is invalid")
      }
    }
    if $manage_user {
      ensure_resource('user', [ $user ], {
        ensure => 'present',
        system => true,
        groups => $extra_groups,
      })

      if $manage_group {
        Group[$group] -> User[$user]
      }
    }
    if $manage_group {
      ensure_resource('group', [ $group ], {
        ensure => 'present',
        system => true,
      })
    }


    if $init_style {

      case $init_style {
        'upstart' : {
          file { "/etc/init/${name}.conf":
            mode    => '0444',
            owner   => 'root',
            group   => 'root',
            content => template('prometheus/daemon.upstart.erb'),
            notify  => $notify_service,
          }
          file { "/etc/init.d/${name}":
            ensure => link,
            target => '/lib/init/upstart-job',
            owner  => 'root',
            group  => 'root',
            mode   => '0755',
          }
        }
        'systemd' : {
          file { "/etc/systemd/system/${name}.service":
            mode    => '0644',
            owner   => 'root',
            group   => 'root',
            content => template('prometheus/daemon.systemd.erb'),
          }~>
          exec { "${name}-systemd-reload":
            command     => 'systemctl daemon-reload',
            path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
            refreshonly => true,
            notify      => $notify_service,
          }
        }
        'sysv' : {
          file { "/etc/init.d/${name}":
            mode    => '0555',
            owner   => 'root',
            group   => 'root',
            content => template('prometheus/daemon.sysv.erb'),
          }
        }
        'debian' : {
          file { "/etc/init.d/${name}":
            mode    => '0555',
            owner   => 'root',
            group   => 'root',
            content => template('prometheus/daemon.debian.erb'),
            notify  => $notify_service,
          }
        }
        'sles' : {
          file { "/etc/init.d/${name}":
            mode    => '0555',
            owner   => 'root',
            group   => 'root',
            content => template('prometheus/daemon.sles.erb'),
            notify  => $notify_service,
          }
        }
        'launchd' : {
          file { "/Library/LaunchDaemons/io.${name}.daemon.plist":
            mode    => '0644',
            owner   => 'root',
            group   => 'wheel',
            content => template('prometheus/daemon.launchd.erb'),
            notify  => $notify_service,
          }
        }
        default : {
          fail("I don't know how to create an init script for style ${init_style}")
        }
      }
    }

    $init_selector = $init_style ? {
      'launchd' => "io.${name}.daemon",
      default   => $name,
    }

    if $manage_service == true {
      service { $name:
        ensure => $service_ensure,
        name   => $init_selector,
        enable => $service_enable,
      }
    }
  }
