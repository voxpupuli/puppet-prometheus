# Class: prometheus::push_gateway
#
# This module manages prometheus push_gateway
#
# Parameters:
#
#  [*manage_user*]
#  Whether to create user for prometheus or rely on external code for that
#
#  [*user*]
#  User running prometheus
#
#  [*manage_group*]
#  Whether to create user for prometheus or rely on external code for that
#
#  [*group*]
#  Group under which prometheus is running
#
#  [*bin_dir*]
#  Directory where binaries are located
#
#  [*arch*]
#  Architecture (amd64 or i386)
#
#  [*version*]
#  Prometheus push_gateway release
#
#  [*install_method*]
#  Installation method: url or package (only url is supported currently)
#
#  [*os*]
#  Operating system (linux is the only one supported)
#
#  [*download_url*]
#  Complete URL corresponding to the Prometheus push_gateway release, default to undef
#
#  [*download_url_base*]
#  Base URL for prometheus push_gateway
#
#  [*download_extension*]
#  Extension of Prometheus push_gateway binaries archive
#
#  [*package_name*]
#  Prometheus push_gateway package name - not available yet
#
#  [*package_ensure*]
#  If package, then use this for package ensure default 'latest'
#
#  [*extra_options*]
#  Extra options added to push gateway startup command
#
#  [*service_enable*]
#  Whether to enable or not prometheus push_gateway service from puppet (default true)
#
#  [*service_ensure*]
#  State ensured from prometheus push_gateway service (default 'running')
#
#  [*manage_service*]
#  Should puppet manage the prometheus push_gateway service? (default true)
#
#  [*restart_on_change*]
#  Should puppet restart prometheus push_gateway on configuration change? (default true)
#
#  [*init_style*]
#  Service startup scripts style (e.g. rc, upstart or systemd)
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class prometheus::push_gateway (
  $manage_user          = true,
  $user                 = $::prometheus::params::user,
  $manage_group         = true,
  $group                = $::prometheus::params::group,
  $bin_dir              = $::prometheus::params::bin_dir,
  $arch                 = $::prometheus::params::arch,
  $version              = $::prometheus::params::push_gateway_version,
  $install_method       = $::prometheus::params::install_method,
  $os                   = $::prometheus::params::os,
  $download_url         = undef,
  $download_url_base    = $::prometheus::params::push_gateway_download_url_base,
  $download_extension   = $::prometheus::params::push_gateway_download_extension,
  $package_name         = $::prometheus::params::push_gateway_package_name,
  $package_ensure       = $::prometheus::params::push_gateway_package_ensure,
  $extra_options        = '',
  $log_format           = $::prometheus::params::push_gateway_log_format,
  $log_level            = $::prometheus::params::push_gateway_log_level,
  $storage_path         = $::prometheus::params::push_gateway_storage_path,
  $persistence_file     = $::prometheus::params::push_gateway_persistence_file,
  $persistence_interval = $::prometheus::params::push_gateway_persistence_interval,
  $listen_address       = $::prometheus::params::push_gateway_listen_address,
  $telemetry_path       = $::prometheus::params::push_gateway_telemetry_path,
  $config_mode          = $::prometheus::params::config_mode,
  $service_enable       = true,
  $service_ensure       = 'running',
  $manage_service       = true,
  $restart_on_change    = true,
  $init_style           = $::prometheus::params::init_style,
) inherits prometheus::params {
  $real_download_url    = pick($download_url,
    "${download_url_base}/download/${version}/${package_name}-${version}.${os}-${arch}.${download_extension}")

  validate_bool($manage_user)
  validate_bool($manage_service)
  validate_bool($restart_on_change)
  $notify_service = $restart_on_change ? {
    true    => Class['::prometheus::push_gateway::run_service'],
    default => undef,
  }

  if $storage_path and $persistence_file {
    $persistence_path = "${storage_path}/${persistence_file}"
  }
  else {
    $persistence_path = ""
  }
  $cmd_options = "-log.format ${log_format} -log.level \"${log_level}\" -persistence.file \"${persistence_path}\" -persistence.interval \"${persistence_interval}\" -web.listen-address \"${listen_address}\" -web.telemetry-path \"${telemetry_path}\""

  anchor {'push_gateway_first': }
  ->
  class { '::prometheus::push_gateway::install': } ->
  class { '::prometheus::push_gateway::config':
    purge  => $purge_config_dir,
    notify => $notify_service,
  } ->
  class { '::prometheus::push_gateway::run_service': } ->
  anchor {'push_gateway_last': }
}
