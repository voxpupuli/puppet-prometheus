# @summary This module manages prometheus rabbitmq_exporter
# @param arch
#  Architecture (amd64 or i386)
# @param bin_dir
#  Directory where binaries are located
# @param download_extension
#  Extension for the release binary archive
# @param download_url
#  Complete URL corresponding to the where the release binary archive can be downloaded
# @param download_url_base
#  Base URL for the binary archive
# @param extra_groups
#  Extra groups to add the binary user to
# @param extra_options
#  Extra options added to the startup command
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
#  Name of the rabbitmq exporter service (default 'rabbitmq_exporter')
# @param user
#  User which runs the service
# @param version
#  The binary release version
# @param rabbit_url
#  URL of the RabbitMQ management plugin
# @param rabbit_user
#  User to authenticate against RabbitMQ
# @param rabbit_password
#  Password to authenticate against RabbitMQ
# @param queues_include_regex
#  Regular expression used by the exported to chose which queues to export
# @param queues_exclude_regex
#  Regular expression used by the exported to chose which queues NOT to export
# @param rabbit_capabilities
#  Special capabilities supported by the RabbitMQ version. See README for more details.
#  (default '')
# @param rabbit_exporters
#  Which exporter modules should be loaded by default
#  (default 'exchange,node,overview,queue')
# @param extra_env_vars
#  Additional environment variables that should be supplied to the exporter, as a hash of key:value
#  (default {})
# @param proxy_server
#  Optional proxy server, with port number if needed. ie: https://example.com:8080
# @param proxy_type
#  Optional proxy server type (none|http|https|ftp)
class prometheus::rabbitmq_exporter (
  Prometheus::Uri $download_url_base,
  Array[String] $extra_groups,
  String[1] $group,
  String[1] $package_ensure,
  String[1] $package_name,
  String[1] $service_name,
  String $download_extension,
  String[1] $user,
  String[1] $version,
  String[1] $rabbit_url,
  String[1] $rabbit_user,
  String[1] $rabbit_password,
  String[1] $queues_include_regex,
  String[1] $queues_exclude_regex,
  Array[String] $rabbit_capabilities,
  Array[String] $rabbit_exporters,
  String[1] $arch                                            = $prometheus::real_arch,
  Stdlib::Absolutepath $bin_dir                              = $prometheus::bin_dir,
  Optional[Prometheus::Uri] $download_url                    = undef,
  Optional[String[1]] $extra_options                         = undef,
  Prometheus::Initstyle $init_style                          = $prometheus::init_style,
  Prometheus::Install $install_method                        = $prometheus::install_method,
  Boolean $manage_group                                      = true,
  Boolean $manage_service                                    = true,
  Boolean $manage_user                                       = true,
  String[1] $os                                              = downcase($facts['kernel']),
  Boolean $purge_config_dir                                  = true,
  Boolean $restart_on_change                                 = true,
  Boolean $service_enable                                    = true,
  Stdlib::Ensure::Service $service_ensure                    = 'running',
  Hash[String,String] $extra_env_vars                        = {},
  Boolean $export_scrape_job                                 = false,
  Optional[Stdlib::Host] $scrape_host                        = undef,
  Stdlib::Port $scrape_port                                  = 9090,
  String[1] $scrape_job_name                                 = 'rabbitmq',
  Optional[Hash] $scrape_job_labels                          = undef,
  Optional[String[1]] $proxy_server                          = undef,
  Optional[Enum['none', 'http', 'https', 'ftp']] $proxy_type = undef,
) inherits prometheus {
  if versioncmp($version, '0.9') < 0 {
    $real_download_url    = pick($download_url, "${download_url_base}/download/v${version}/${package_name}-${version}.${os}-${arch}.${download_extension}")
  } else {
    $real_download_url    = pick($download_url, "${download_url_base}/download/v${version}/${package_name}-${version}_${os}-${arch}.${download_extension}")
  }
  $notify_service = $restart_on_change ? {
    true    => Service[$service_name],
    default => undef,
  }

  $env_vars = {
    'RABBIT_URL'          => $rabbit_url,
    'RABBIT_USER'         => $rabbit_user,
    'RABBIT_PASSWORD'     => $rabbit_password,
    'INCLUDE_QUEUES'      => $queues_include_regex,
    'SKIP_QUEUES'         => $queues_exclude_regex,
    'RABBIT_CAPABILITIES' => join($rabbit_capabilities, ','),
    'RABBIT_EXPORTERS'    => join($rabbit_exporters, ','),
  }

  $real_env_vars = merge($env_vars, $extra_env_vars)

  prometheus::daemon { 'rabbitmq_exporter':
    install_method     => $install_method,
    version            => $version,
    download_extension => $download_extension,
    os                 => $os,
    arch               => $arch,
    real_download_url  => $real_download_url,
    bin_dir            => $bin_dir,
    notify_service     => $notify_service,
    package_name       => $package_name,
    package_ensure     => $package_ensure,
    manage_user        => $manage_user,
    user               => $user,
    extra_groups       => $extra_groups,
    group              => $group,
    manage_group       => $manage_group,
    purge              => $purge_config_dir,
    options            => $extra_options,
    init_style         => $init_style,
    service_ensure     => $service_ensure,
    service_enable     => $service_enable,
    manage_service     => $manage_service,
    env_vars           => $real_env_vars,
    export_scrape_job  => $export_scrape_job,
    scrape_host        => $scrape_host,
    scrape_port        => $scrape_port,
    scrape_job_name    => $scrape_job_name,
    scrape_job_labels  => $scrape_job_labels,
    proxy_server       => $proxy_server,
    proxy_type         => $proxy_type,
  }
}
