# @summary This define managed prometheus daemons that don't have their own class
# @param version
#  The binary release version
# @param real_download_url
#  Complete URL corresponding to the where the release binary archive can be downloaded
# @param notify_service
#  The service to notify when something changes in this define
# @param user
#  User which runs the service
# @param install_method
#  Installation method: url or package
# @param download_extension
#  Extension for the release binary archive
# @param os
#  Operating system (linux is the only one supported)
# @param arch
#  Architecture (amd64 or i386)
# @param bin_dir
#  Directory where binaries are located
# @param bin_name
#  The name of the binary to execute
# @param package_name
#  The binary package name
# @param package_ensure
#  If package, then use this for package ensure default 'installed'
# @param manage_user
#  Whether to create user or rely on external code for that
# @param extra_groups
#  Extra groups of which the user should be a part
# @param manage_group
#  Whether to create a group for or rely on external code for that
# @param service_ensure
#  State ensured for the service (default 'running')
# @param service_enable
#  Whether to enable the service from puppet (default true)
# @param manage_service
#  Should puppet manage the service? (default true)
# @param extract_command
#  Custom command passed to the archive resource to extract the downloaded archive.
# @param extract_path
#  Path where to find extracted binary
# @param archive_bin_path
#  Path to the binary in the downloaded archive.
# @param init_style
#  Service startup scripts style (e.g. rc, upstart or systemd).
#  Can also be set to `none` when you don't want the class to create a startup script/unit_file for you.
#  Typically this can be used when a package is already providing the file.
# @param proxy_server
#  Optional proxy server, with port number if needed. ie: https://example.com:8080
# @param proxy_type
#  Optional proxy server type (none|http|https|ftp)
# @param ensure
#  Whether to install or remove the instance
define prometheus::daemon (
  String[1] $version,
  Prometheus::Uri $real_download_url,
  Variant[Type[Exec],Type[Service],Undef] $notify_service,
  String[1] $user,
  String[1] $group,
  Prometheus::Install $install_method                        = $prometheus::install_method,
  String $download_extension                                 = $prometheus::download_extension,
  String[1] $os                                              = $prometheus::os,
  String[1] $arch                                            = $prometheus::real_arch,
  Stdlib::Absolutepath $bin_dir                              = $prometheus::bin_dir,
  String[1] $bin_name                                        = $name,
  Boolean $manage_bin_link                                   = true,
  Optional[String] $package_name                             = undef,
  String[1] $package_ensure                                  = 'installed',
  Boolean $manage_user                                       = true,
  Array $extra_groups                                        = [],
  Boolean $manage_group                                      = true,
  Boolean $purge                                             = true,
  String $options                                            = '', # lint:ignore:params_empty_string_assignment
  Prometheus::Initstyle $init_style                          = $prometheus::init_style,
  Stdlib::Ensure::Service $service_ensure                    = 'running',
  Boolean $service_enable                                    = true,
  Boolean $manage_service                                    = true,
  Hash[String[1], Scalar] $env_vars                          = {},
  Stdlib::Absolutepath $env_file_path                        = $prometheus::env_file_path,
  Optional[String[1]] $extract_command                       = $prometheus::extract_command,
  Stdlib::Absolutepath $extract_path                         = '/opt',
  Stdlib::Absolutepath $archive_bin_path                     = "/opt/${name}-${version}.${os}-${arch}/${name}",
  Boolean $export_scrape_job                                 = false,
  Stdlib::Host $scrape_host                                  = $facts['networking']['fqdn'],
  Optional[Stdlib::Port] $scrape_port                        = undef,
  String[1] $scrape_job_name                                 = $name,
  Hash $scrape_job_labels                                    = { 'alias' => $scrape_host },
  Stdlib::Absolutepath $usershell                            = $prometheus::usershell,
  Optional[String[1]] $proxy_server                          = undef,
  Optional[Enum['none', 'http', 'https', 'ftp']] $proxy_type = undef,
  Enum['present', 'absent'] $ensure                          = 'present',
) {
  $real_package_ensure = $ensure ? { 'absent' => 'absent', default => $package_ensure }
  $real_service_ensure = $ensure ? { 'absent' => 'stopped', default => $service_ensure }

  case $install_method {
    'url': {
      if $download_extension == '' {
        file { "/opt/${name}-${version}.${os}-${arch}":
          ensure => stdlib::ensure($ensure, 'directory'),
          owner  => 'root',
          group  => 0, # 0 instead of root because OS X uses "wheel".
          mode   => '0755',
        }
        -> archive { "/opt/${name}-${version}.${os}-${arch}/${name}":
          ensure          => $ensure,
          source          => $real_download_url,
          checksum_verify => false,
          before          => File["/opt/${name}-${version}.${os}-${arch}/${name}"],
          proxy_server    => $proxy_server,
          proxy_type      => $proxy_type,
        }
      } else {
        archive { "/tmp/${name}-${version}.${download_extension}":
          ensure          => $ensure,
          extract         => true,
          extract_path    => $extract_path,
          source          => $real_download_url,
          checksum_verify => false,
          creates         => $archive_bin_path,
          cleanup         => true,
          before          => File[$archive_bin_path],
          extract_command => $extract_command,
          proxy_server    => $proxy_server,
          proxy_type      => $proxy_type,
        }
      }
      file { $archive_bin_path:
        ensure => stdlib::ensure($ensure, 'file'),
        owner  => 'root',
        group  => 0, # 0 instead of root because OS X uses "wheel".
        mode   => '0555',
      }
      if $manage_bin_link {
        file { "${bin_dir}/${bin_name}":
          ensure  => stdlib::ensure($ensure, 'link'),
          notify  => $notify_service,
          target  => $archive_bin_path,
          require => File[$archive_bin_path],
        }
      }
    }
    'package': {
      package { $package_name:
        ensure => $real_package_ensure,
        notify => $notify_service,
      }
      if $manage_user {
        User[$user] -> Package[$package_name]
      }
    }
    'none': {}
    default: {}
  }
  if $manage_user {
    # if we manage the service, we need to reload it if our user changes
    # important for cases where another group gets added
    if $manage_service and $real_service_ensure == 'running' {
      User[$user] ~> $notify_service
    }
    ensure_resource('user', [$user], {
        ensure => $ensure,
        system => true,
        groups => $extra_groups,
        shell  => $usershell,
    })

    if $manage_group {
      if $ensure == 'present' {
        Group[$group] -> User[$user]
      } else {
        User[$user] -> Group[$group]
        Service[$name] -> User[$user]
      }
    }
  }
  if $manage_group {
    ensure_resource('group', [$group], {
        ensure => $ensure,
        system => true,
    })
  }

  case $init_style { # lint:ignore:case_without_default
    'upstart': {
      file { "/etc/init/${name}.conf":
        ensure  => stdlib::ensure($ensure, 'file'),
        mode    => '0444',
        owner   => 'root',
        group   => 'root',
        content => template('prometheus/daemon.upstart.erb'),
      }
      file { "/etc/init.d/${name}":
        ensure => stdlib::ensure($ensure, 'file'),
        target => '/lib/init/upstart-job',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
      if $notify_service !~ Undef {
        if $ensure == 'present' {
          File["/etc/init/${name}.conf"] ~> $notify_service
        } else {
          $notify_service -> File["/etc/init/${name}.conf"]
        }
      }
    }
    'systemd': {
      include 'systemd'
      systemd::manage_unit { "${name}.service":
        ensure        => $ensure,
        unit_entry    => {
          'Description' => "Prometheus ${name}",
          'Wants'       => 'network-online.target',
          'After'       => 'network-online.target',
        },
        service_entry => {
          'User'            => $user,
          'Group'           => $group,
          'EnvironmentFile' => "-${env_file_path}/${name}",
          'ExecStart'       => sprintf('%s/%s %s', $bin_dir, $bin_name, $options),
          'ExecReload'      => '/bin/kill -HUP $MAINPID',
          'KillMode'        => 'process',
          'Restart'         => 'always',
        },
        install_entry => {
          'WantedBy' => 'multi-user.target',
        },
      }
      if $notify_service !~ Undef {
        if $ensure == 'present' {
          Systemd::Manage_unit["${name}.service"] ~> $notify_service
        } else {
          $notify_service -> Systemd::Manage_unit["${name}.service"]
        }
      }
    }
    'sysv': {
      file { "/etc/init.d/${name}":
        ensure  => stdlib::ensure($ensure, 'file'),
        mode    => '0555',
        owner   => 'root',
        group   => 'root',
        content => template('prometheus/daemon.sysv.erb'),
      }
      if $notify_service !~ Undef {
        if $ensure == 'present' {
          File["/etc/init.d/${name}"] ~> $notify_service
        } else {
          $notify_service -> File["/etc/init.d/${name}"]
        }
      }
    }
    'sles': {
      file { "/etc/init.d/${name}":
        ensure  => stdlib::ensure($ensure, 'file'),
        mode    => '0555',
        owner   => 'root',
        group   => 'root',
        content => template('prometheus/daemon.sles.erb'),
      }
      if $notify_service !~ Undef {
        if $ensure == 'present' {
          File["/etc/init.d/${name}"] ~> $notify_service
        } else {
          $notify_service -> File["/etc/init.d/${name}"]
        }
      }
    }
    'launchd': {
      file { "/Library/LaunchDaemons/io.${name}.daemon.plist":
        ensure  => stdlib::ensure($ensure, 'file'),
        mode    => '0644',
        owner   => 'root',
        group   => 'wheel',
        content => template('prometheus/daemon.launchd.erb'),
      }
      if $notify_service !~ Undef {
        if $ensure == 'present' {
          File["/Library/LaunchDaemons/io.${name}.daemon.plist"] ~> $notify_service
        } else {
          $notify_service -> File["/Library/LaunchDaemons/io.${name}.daemon.plist"]
        }
      }
    }
    'none': {}
  }

  if $init_style == 'none' and $install_method == 'package' {
    $env_vars_merged = $env_vars + {
      'ARGS' => $options,
    }
  } else {
    $env_vars_merged = $env_vars
  }

  if $install_method == 'package' and $real_package_ensure == 'absent' {
    # purge the environment file if the package is removed
    #
    # this is to make sure we can garbage-collect the files created by
    # this module, when purging it.
    file { "${env_file_path}/${name}":
      ensure => absent,
    }
  } elsif $install_method == 'package' or !$env_vars_merged.empty {
    # manage the environment file if the package is installed *or*, in
    # any other case, if there's something to add to it
    #
    # the logic here is that the package-managed .service files *need*
    # those files to be present, even if empty, so it's critical that
    # the file not get removed
    file { "${env_file_path}/${name}":
      ensure  => stdlib::ensure($ensure, 'file'),
      mode    => '0644',
      owner   => 'root',
      group   => '0', # Darwin uses wheel
      content => epp(
        'prometheus/daemon.env.epp',
        {
          'env_vars' => $env_vars_merged,
        }
      ),
      notify  => $notify_service,
    }
  }

  $init_selector = $init_style ? {
    'launchd' => "io.${name}.daemon",
    default   => $name,
  }

  $real_provider = $init_style ? {
    'sles'  => 'redhat', # mimics puppet's default behaviour
    'sysv'  => 'redhat', # all currently used cases for 'sysv' are redhat-compatible
    'none'  => undef,
    default => $init_style,
  }

  if $manage_service {
    service { $name:
      ensure   => $real_service_ensure,
      name     => $init_selector,
      enable   => $service_enable,
      provider => $real_provider,
    }
  }

  if $export_scrape_job {
    if $scrape_port == undef {
      fail('must set $scrape_port on exported daemon')
    }

    @@prometheus::scrape_job { "${scrape_job_name}_${scrape_host}_${scrape_port}":
      ensure   => $ensure,
      job_name => $scrape_job_name,
      targets  => ["${scrape_host}:${scrape_port}"],
      labels   => $scrape_job_labels,
    }
  }
}
