# @summary This module manages prometheus node postgres_exporter
# @param arch
#  Architecture (amd64 or i386)
# @param bin_dir
#  Directory where binaries are located
# @param data_source_custom
#  Hash of key:value pair to use for alternate environment variables when using param 'postgres_auth_method'
# @param download_extension
#  Extension for the release binary archive
# @param download_url
#  Complete URL corresponding to the where the release binary archive can be downloaded
# @param download_url_base
#  Base URL for the binary archive
# @param extra_groups
#  Extra groups to add the binary user to
# @param group
#  Group under which the binary is running
# @param init_style
#  Service startup scripts style (e.g. rc, upstart or systemd)
# @param install_method
#  Installation method: url or package (only url is supported currently)
# @param manage_group
#  Whether to create a group for or rely on external code for that
# @param manage_service
#  Should puppet manage the service? (default true)
# @param manage_user
#  Whether to create user or rely on external code for that
# @param os
#  Operating system (linux is the only one supported)
# @param package_ensure
#  If package, then use this for package ensure default 'latest'
# @param package_name
#  The binary package name - not available yet
# @param purge_config_dir
#  Purge config files no longer generated by Puppet
# @param restart_on_change
#  Should puppet restart the service on configuration change? (default true)
# @param service_enable
#  Whether to enable the service from puppet (default true)
# @param service_ensure
#  State ensured for the service (default 'running')
# @param service_name
#  Name of the node exporter service (default 'postgres_exporter')
# @param user
#  User which runs the service
# @param version
#  The binary release version
# @param postgres_user
#  User to authenticate against postgres
# @param postgres_pass
#  Password to authenticate against postgres
# @param postgres_auth_method
#  method for presenting username and password to the exporter
#  This can be file, or env (default 'env')
#  Using 'custom' requires 'data_source_custom' values
# @param data_source_uri
#  Uri on howto connect to the database
# @param proxy_server
#  Optional proxy server, with port number if needed. ie: https://example.com:8080
# @param proxy_type
#  Optional proxy server type (none|http|https|ftp)
# @param env_vars_sensitive
#  Do not show diff in case environment variables are sensitive
# @param env_file_path
#  The path to the file with the environment variable that is read from the init script/systemd unit
class prometheus::postgres_exporter (
  String $download_extension,
  Prometheus::Uri $download_url_base,
  Array[String[1]] $extra_groups,
  String[1] $group,
  String[1] $package_ensure,
  String[1] $package_name,
  String[1] $user,
  String[1] $version,
  String[1] $data_source_uri,
  Enum['custom', 'env', 'file'] $postgres_auth_method,
  Hash[String[1],String[1]] $data_source_custom              = {},
  Boolean $purge_config_dir                                  = true,
  Boolean $restart_on_change                                 = true,
  Boolean $service_enable                                    = true,
  Stdlib::Ensure::Service $service_ensure                    = 'running',
  String[1] $service_name                                    = 'postgres_exporter',
  Prometheus::Initstyle $init_style                          = $facts['service_provider'],
  Prometheus::Install $install_method                        = $prometheus::install_method,
  Boolean $manage_group                                      = true,
  Boolean $manage_service                                    = true,
  Boolean $manage_user                                       = true,
  String[1] $os                                              = downcase($facts['kernel']),
  String $options                                            = '',
  Optional[Prometheus::Uri] $download_url                    = undef,
  Optional[String] $postgres_pass                            = undef,
  Optional[String] $postgres_user                            = undef,
  String[1] $arch                                            = $prometheus::real_arch,
  Stdlib::Absolutepath $bin_dir                              = $prometheus::bin_dir,
  Boolean $export_scrape_job                                 = false,
  Optional[Stdlib::Host] $scrape_host                        = undef,
  Stdlib::Port $scrape_port                                  = 9187,
  String[1] $scrape_job_name                                 = 'postgres',
  Optional[Hash] $scrape_job_labels                          = undef,
  Optional[String[1]] $proxy_server                          = undef,
  Optional[Enum['none', 'http', 'https', 'ftp']] $proxy_type = undef,
  Boolean $env_vars_sensitive                                = false,
  Stdlib::Absolutepath $env_file_path                        = $prometheus::env_file_path,
) inherits prometheus {
  $release = "v${version}"

  if versioncmp($version, '0.9.0') < 0 {
    $real_download_url = pick($download_url, "${download_url_base}/download/${release}/${package_name}_${release}_${os}-${arch}.${download_extension}")
  } else {
    $real_download_url = pick($download_url, "${download_url_base}/download/${release}/${package_name}-${version}.${os}-${arch}.${download_extension}")
  }

  $notify_service = $restart_on_change ? {
    true    => Service[$service_name],
    default => undef,
  }

  case $postgres_auth_method {
    'env': {
      $env_vars = {
        'DATA_SOURCE_URI'       => $data_source_uri,
        'DATA_SOURCE_USER'      => $postgres_user,
        'DATA_SOURCE_PASS'      => $postgres_pass,
      }
    }
    'file': {
      $env_vars = {
        'DATA_SOURCE_URI'       => $data_source_uri,
        'DATA_SOURCE_USER_FILE' => $postgres_user,
        'DATA_SOURCE_PASS_FILE' => $postgres_pass,
      }
    }
    'custom': {
      $env_vars = $data_source_custom
    }
    default: {
      $env_vars = {}
    }
  }

  if $install_method == 'url' {
    # Not a big fan of copypasting but prometheus::daemon takes for granted
    # a specific path embedded in the prometheus *_exporter tarball, which
    # postgres_exporter lacks.
    # TODO: patch prometheus::daemon to support custom extract directories
    $exporter_install_method = 'none'
    $install_dir = "/opt/${service_name}-${version}.${os}-${arch}"
    file { $install_dir:
      ensure => 'directory',
      owner  => 'root',
      group  => 0, # 0 instead of root because OS X uses "wheel".
      mode   => '0555',
    }
    -> archive { "/tmp/${service_name}-${version}.${download_extension}":
      ensure          => present,
      extract         => true,
      extract_path    => $install_dir,
      extract_flags   => '--strip-components=1 -xzf',
      source          => $real_download_url,
      checksum_verify => false,
      creates         => "${install_dir}/${service_name}",
      cleanup         => true,
    }
    -> file { "${bin_dir}/${service_name}":
      ensure => link,
      notify => $notify_service,
      target => "${install_dir}/${service_name}",
      before => Prometheus::Daemon[$service_name],
    }
  } else {
    $exporter_install_method = $install_method
  }

  prometheus::daemon { $service_name:
    install_method     => $exporter_install_method,
    version            => $version,
    download_extension => $download_extension,
    env_vars_sensitive => $env_vars_sensitive,
    env_vars           => $env_vars,
    env_file_path      => $env_file_path,
    os                 => $os,
    arch               => $arch,
    bin_dir            => $bin_dir,
    notify_service     => $notify_service,
    package_name       => $package_name,
    package_ensure     => $package_ensure,
    manage_user        => $manage_user,
    user               => $user,
    extra_groups       => $extra_groups,
    real_download_url  => $real_download_url,
    group              => $group,
    manage_group       => $manage_group,
    purge              => $purge_config_dir,
    options            => $options,
    init_style         => $init_style,
    service_ensure     => $service_ensure,
    service_enable     => $service_enable,
    manage_service     => $manage_service,
    export_scrape_job  => $export_scrape_job,
    scrape_host        => $scrape_host,
    scrape_port        => $scrape_port,
    scrape_job_name    => $scrape_job_name,
    scrape_job_labels  => $scrape_job_labels,
    proxy_server       => $proxy_server,
    proxy_type         => $proxy_type,
  }
}
