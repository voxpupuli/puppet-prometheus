# Define: prometheus::daemon
#
# This define managed prometheus daemons that don't have their own class
#
#  [*version*]
#  The binary release version
#
#  [*real_download_url*]
#  Complete URL corresponding to the where the release binary archive can be downloaded
#
#  [*notify_service*]
#  The service to notify when something changes in this define
#
#  [*user*]
#  User which runs the service
#
#  [*install_method*]
#  Installation method: url or package
#
#  [*download_extension*]
#  Extension for the release binary archive
#
#  [*os*]
#  Operating system (linux is the only one supported)
#
#  [*arch*]
#  Architecture (amd64 or i386)
#
#  [*bin_dir*]
#  Directory where binaries are located
#
#  [*package_name*]
#  The binary package name
#
#  [*package_ensure*]
#  If package, then use this for package ensure default 'installed'
#
#  [*manage_user*]
#  Whether to create user or rely on external code for that
#
#  [*extra_groups*]
#  Extra groups of which the user should be a part
#
#  [*manage_group*]
#  Whether to create a group for or rely on external code for that
#
#  [*service_ensure*]
#  State ensured for the service (default 'running')
#
#  [*service_enable*]
#  Whether to enable the service from puppet (default true)
#
#  [*manage_service*]
#  Should puppet manage the service? (default true)
#
define prometheus::daemon (
  $version,
  $real_download_url,
  $notify_service,
  $user,
  $group,

  $install_method                 = $::prometheus::params::install_method,
  $download_extension             = $::prometheus::params::download_extension,
  $os                             = $::prometheus::params::os,
  $arch                           = $::prometheus::params::arch,
  $bin_dir                        = $::prometheus::params::bin_dir,
  $package_name                   = undef,
  $package_ensure                 = 'installed',
  $manage_user                    = true,
  $extra_groups                   = [],
  $manage_group                   = true,
  $purge                          = true,
  $options                        = '',
  $init_style                     = $::prometheus::params::init_style,
  $service_ensure                 = 'running',
  $service_enable                 = true,
  $manage_service                 = true,
  Hash[String, Scalar] $env_vars  = {},
  Optional[String] $env_file_path = $::prometheus::params::env_file_path,
  Boolean $export_scrape_job      = false,
  String $scrape_host             = $::fqdn,
  Optional[Integer] $scrape_port  = undef,
) {

  case $install_method {
    'url': {
      if $download_extension == '' {
        file { "/opt/${name}-${version}.${os}-${arch}":
          ensure => directory,
          owner  => 'root',
          group  => 0, # 0 instead of root because OS X uses "wheel".
          mode   => '0755',
        }
        -> archive { "/opt/${name}-${version}.${os}-${arch}/${name}":
          ensure          => present,
          source          => $real_download_url,
          checksum_verify => false,
          before          => File["/opt/${name}-${version}.${os}-${arch}/${name}"],
        }
      } else {
        archive { "/tmp/${name}-${version}.${download_extension}":
          ensure          => present,
          extract         => true,
          extract_path    => '/opt',
          source          => $real_download_url,
          checksum_verify => false,
          creates         => "/opt/${name}-${version}.${os}-${arch}/${name}",
          cleanup         => true,
          before          => File["/opt/${name}-${version}.${os}-${arch}/${name}"],
        }
      }
      file { "/opt/${name}-${version}.${os}-${arch}/${name}":
          owner => 'root',
          group => 0, # 0 instead of root because OS X uses "wheel".
          mode  => '0555',
      }
      -> file { "${bin_dir}/${name}":
          ensure => link,
          notify => $notify_service,
          target => "/opt/${name}-${version}.${os}-${arch}/${name}",
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
        include 'systemd'
        ::systemd::unit_file {"${name}.service":
          content => template('prometheus/daemon.systemd.erb'),
          notify  => $notify_service,
        }
      }
      'sysv' : {
        file { "/etc/init.d/${name}":
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('prometheus/daemon.sysv.erb'),
          notify  => $notify_service,
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

  if $env_file_path != undef {
    file { "${env_file_path}/${name}":
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('prometheus/daemon.env.erb'),
      notify  => $notify_service,
    }
  }

  $init_selector = $init_style ? {
    'launchd' => "io.${name}.daemon",
    default   => $name,
  }

  $real_provider = $init_style ? {
    'sles'  => 'redhat',  # mimics puppet's default behaviour
    'sysv'  => 'redhat',  # all currently used cases for 'sysv' are redhat-compatible
    default => $init_style,
  }

  if $manage_service == true {
    service { $name:
      ensure   => $service_ensure,
      name     => $init_selector,
      enable   => $service_enable,
      provider => $real_provider,
    }
  }

  if $export_scrape_job {
    if $scrape_port == undef {
      fail('must set $scrape_port on exported daemon')
    }

    @@prometheus::scrape_job { "${scrape_host}:${scrape_port}":
      job_name => $name,
      targets  => ["${scrape_host}:${scrape_port}"],
    }
  }
}
