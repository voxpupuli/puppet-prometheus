class prometheus::mysqld_exporter (
  $manage_user          = true,
  $user                 = $::prometheus::params::mysqld_exporter_user,
  $manage_group         = true,
  $purge_config_dir     = true,
  $cnf_config_path      = $::prometheus::params::mysqld_exporter_cnf_config_path,
  $cnf_user             = $::prometheus::params::mysqld_exporter_cnf_user,
  $cnf_password         = $::prometheus::params::mysqld_exporter_cnf_password,
  $cnf_host             = $::prometheus::params::mysqld_exporter_cnf_host,
  $cnf_port             = $::prometheus::params::mysqld_exporter_cnf_port,
  $cnf_socket           = undef,
  $group                = $::prometheus::params::mysqld_exporter_group,
  $bin_dir              = $::prometheus::params::bin_dir,
  $arch                 = $::prometheus::params::arch,
  $version              = $::prometheus::params::mysqld_exporter_version,
  $install_method       = $::prometheus::params::install_method,
  $os                   = $::prometheus::params::os,
  $download_url         = undef,
  $extra_groups         = $::prometheus::params::mysqld_exporter_extra_groups,
  $download_url_base    = $::prometheus::params::mysqld_exporter_download_url_base,
  $download_extension   = $::prometheus::params::mysqld_exporter_download_extension,
  $package_name         = $::prometheus::params::mysqld_exporter_package_name,
  $package_ensure       = $::prometheus::params::mysqld_exporter_package_ensure,
  $extra_options        = '',
  $config_mode          = $::prometheus::params::config_mode,
  $service_enable       = true,
  $service_ensure       = 'running',
  $manage_service       = true,
  $restart_on_change    = true,
  $init_style           = $::prometheus::params::init_style,
) inherits prometheus::params {
  $real_download_url    = pick($download_url,"${download_url_base}/download/v${version}/${package_name}-${version}.${os}-${arch}.${download_extension}")
  validate_bool($purge_config_dir)
  validate_bool($manage_user)
  validate_bool($manage_service)
  validate_bool($restart_on_change)
  $notify_service = $restart_on_change ? {
    true    => Service['mysqld_exporter'],
    default => undef,
  }

  file { $cnf_config_path:
    ensure  => 'file',
    mode    => '0644',
    owner   => $user,
    group   => $group,
    content => template('prometheus/my.cnf.erb'),
    notify  => $notify_service,
  }

  $options = "-config.my-cnf=${cnf_config_path} ${extra_options}"

  prometheus::daemon { 'mysqld_exporter':
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
    options            => $options,
    init_style         => $init_style,
    service_ensure     => $service_ensure,
    service_enable     => $service_enable,
    manage_service     => $manage_service,
  }
}
