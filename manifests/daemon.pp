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
#  [*proxy*]
#  Will set the http_proxy and https_proxy env variables in
#  (example: proxy => 'http://proxy.company.com:8080)
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
  String $version,
  Variant[Stdlib::HTTPSUrl, Stdlib::HTTPUrl] $real_download_url,
  $notify_service,
  String $user,
  String $group,
  String $install_method          = $prometheus::install_method,
  String $download_extension      = $prometheus::download_extension,
  String $os                      = $prometheus::os,
  String $arch                    = $prometheus::real_arch,
  Stdlib::Absolutepath $bin_dir   = $prometheus::bin_dir,
  Optional[String] $package_name  = undef,
  Optional[String[1]] $proxy      = undef,
  String $package_ensure          = 'installed',
  Boolean $manage_user            = true,
  Array $extra_groups             = [],
  Boolean $manage_group           = true,
  Boolean $purge                  = true,
  String $options                 = '',
  String $init_style              = $prometheus::init_style,
  String $service_ensure          = 'running',
  Boolean $service_enable         = true,
  Boolean $manage_service         = true,
  Hash[String, Scalar] $env_vars  = {},
  Optional[String] $env_file_path = $prometheus::env_file_path,
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
          proxy           => $proxy,
          checksum_verify => false,
          before          => File["/opt/${name}-${version}.${os}-${arch}/${name}"],
        }
      } else {
        archive { "/tmp/${name}-${version}.${download_extension}":
          ensure          => present,
          extract         => true,
          extract_path    => '/opt',
          source          => $real_download_url,
          proxy           => $proxy,
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
}
