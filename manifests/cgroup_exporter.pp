# @summary This module manages prometheus cgroup_exporter (https://github.com/treydock/cgroup_exporter)
class prometheus::cgroup_exporter (
  String[1]                                      $package_name       = 'cgroup_exporter',
  String                                         $download_extension = 'tar.gz',
  # renovate: depName=treydock/cgroup_exporter
  String[1]                                      $version            = '1.0.1',
  String[1]                                      $package_ensure     = 'latest',
  String[1]                                      $user               = 'cgroup-exporter',
  String[1]                                      $group              = 'cgroup-exporter',
  Prometheus::Uri                                $download_url_base  = 'https://github.com/treydock/cgroup_exporter/releases',
  Array[String]                                  $extra_groups       = [],
  Prometheus::Initstyle                          $init_style         = $prometheus::init_style,
  Boolean                                        $purge_config_dir   = true,
  String[1]                                      $config_mode        = $prometheus::config_mode,
  String[1]                                      $arch               = $prometheus::real_arch,
  Stdlib::Absolutepath                           $bin_dir            = $prometheus::bin_dir,
  Boolean                                        $restart_on_change  = true,
  Boolean                                        $service_enable     = true,
  Stdlib::Ensure::Service                        $service_ensure     = 'running',
  String[1]                                      $service_name       = 'cgroup_exporter',
  Prometheus::Install                            $install_method     = $prometheus::install_method,
  Boolean                                        $manage_group       = true,
  Boolean                                        $manage_service     = true,
  Boolean                                        $manage_user        = true,
  String[1]                                      $os                 = downcase(fact('kernel')),
  Stdlib::Absolutepath $archive_bin_path                             = "/opt/${package_name}-${version}.${os}-${arch}/${package_name}",
  Optional[String[1]]                            $extra_options      = undef,
  Optional[Prometheus::Uri]                      $download_url       = undef,
  Optional[Stdlib::Host]                         $scrape_host        = undef,
  Boolean                                        $export_scrape_job  = false,
  Stdlib::Port                                   $scrape_port        = 9306,
  String[1]                                      $scrape_job_name    = 'cgroup',
  Optional[Hash]                                 $scrape_job_labels  = undef,
  Optional[String[1]]                            $bin_name           = undef,
  Hash                                           $modules            = {},
  Optional[String[1]]                            $proxy_server       = undef,
  Optional[Enum['none', 'http', 'https', 'ftp']] $proxy_type         = undef,
  Enum['slurm']                                  $cgroup_paths       = 'slurm',
) inherits prometheus {
  $real_download_url = pick(
    $download_url,
    "${download_url_base}/download/v${version}/${package_name}-${version}.${os}-${arch}.${download_extension}"
  )

  $notify_service = $restart_on_change ? {
    true    => Service[$service_name],
    default => undef,
  }

  $paths_option = "--config.paths=/${cgroup_paths}"

  if $scrape_port != 9306 {
    $listen_address = "--web.listen-address=':${scrape_port}'"
  } else {
    $listen_address = undef
  }

  $options = [
    $extra_options,
    $listen_address,
    $paths_option,
  ].filter |$x| { !$x.empty }.join(' ')

  prometheus::daemon { $service_name:
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
    export_scrape_job  => $export_scrape_job,
    scrape_host        => $scrape_host,
    scrape_port        => $scrape_port,
    scrape_job_name    => $scrape_job_name,
    scrape_job_labels  => $scrape_job_labels,
    bin_name           => $bin_name,
    proxy_server       => $proxy_server,
    proxy_type         => $proxy_type,
    archive_bin_path   => $archive_bin_path,
  }
  -> exec {'setcap cgroup_exporter':
    command => "/usr/sbin/setcap cap_sys_ptrace=eip ${archive_bin_path}",
    unless  => "/usr/sbin/getcap ${archive_bin_path} | grep -q cap_sys_ptrace=eip",
  }
}
