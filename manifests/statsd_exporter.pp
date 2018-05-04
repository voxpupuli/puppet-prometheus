# Class: prometheus::statsd_exporter
#
# This module manages prometheus statsd_exporter
#
# Parameters:
#  [*arch*]
#  Architecture (amd64 or i386)
#
#  [*bin_dir*]
#  Directory where binaries are located
#
#  [*config_mode*]
#  The permissions of the configuration files
#
#  [*download_extension*]
#  Extension for the release binary archive
#
#  [*download_url*]
#  Complete URL corresponding to the where the release binary archive can be downloaded
#
#  [*download_url_base*]
#  Base URL for the binary archive
#
#  [*extra_groups*]
#  Extra groups to add the binary user to
#
#  [*extra_options*]
#  Extra options added to the startup command
#
#  [*group*]
#  Group under which the binary is running
#
#  [*init_style*]
#  Service startup scripts style (e.g. rc, upstart or systemd)
#
#  [*install_method*]
#  Installation method: url or package (only url is supported currently)
#
#  [*manage_group*]
#  Whether to create a group for or rely on external code for that
#
#  [*manage_service*]
#  Should puppet manage the service? (default true)
#
#  [*manage_user*]
#  Whether to create user or rely on external code for that
#
#  [*os*]
#  Operating system (linux is the only one supported)
#
#  [*package_ensure*]
#  If package, then use this for package ensure default 'latest'
#
#  [*package_name*]
#  The binary package name - not available yet
#
#  [*purge_config_dir*]
#  Purge config files no longer generated by Puppet
#
#  [*restart_on_change*]
#  Should puppet restart the service on configuration change? (default true)
#
#  [*service_enable*]
#  Whether to enable the service from puppet (default true)
#
#  [*service_ensure*]
#  State ensured for the service (default 'running')
#
#  [*statsd_maps*]
#  The hiera array for mappings:
#    - map: 'test.dispatcher.*.*.*'
#      name: 'dispatcher_events_total'
#      labels:
#        processor: '$2'
#        action: '$1'
#
#  [*user*]
#  User which runs the service
#
#  [*version*]
#  The binary release version

class prometheus::statsd_exporter (
  String $download_extension,
  Variant[Stdlib::HTTPSUrl, Stdlib::HTTPUrl] $download_url_base,
  Array $extra_groups,
  String $group,
  Stdlib::Absolutepath $mapping_config_path,
  String $package_ensure,
  String $package_name,
  Array[Hash] $statsd_maps,
  String $user,
  String $version,
  String $arch                                                       = lookup('prometheus::arch'),
  Stdlib::Absolutepath $bin_dir                                      = lookup('prometheus::bin_dir'),
  String $config_mode                                                = lookup('prometheus::config_mode'),
  Boolean $purge_config_dir                                          = true,
  Boolean $restart_on_change                                         = true,
  Boolean $service_enable                                            = true,
  String $service_ensure                                             = 'running',
  String $os                                                         = lookup('prometheus::os'),
  Optional[String] $init_style                                       = lookup('prometheus::init_style'),
  String $install_method                                             = lookup('prometheus::install_method'),
  Boolean $manage_group                                              = true,
  Boolean $manage_service                                            = true,
  Boolean $manage_user                                               = true,
  String $extra_options                                              = '',
  Optional[Variant[Stdlib::HTTPSUrl, Stdlib::HTTPUrl]] $download_url = undef,
) {

  $real_download_url    = pick($download_url,"${download_url_base}/download/${version}/${package_name}-${version}.${os}-${arch}.${download_extension}")
  $notify_service = $restart_on_change ? {
    true    => Service['statsd_exporter'],
    default => undef,
  }

  $extra_statsd_maps = hiera_array('prometheus::statsd_exporter::statsd_maps',[])
  $real_statsd_maps = concat($extra_statsd_maps, $prometheus::statsd_exporter::statsd_maps)

  file { $mapping_config_path:
    ensure  => 'file',
    mode    => $config_mode,
    owner   => $user,
    group   => $group,
    content => template('prometheus/statsd_mapping.conf.erb'),
    notify  => $notify_service,
  }

  $options = "-statsd.mapping-config=\'${prometheus::statsd_exporter::mapping_config_path}\' ${prometheus::statsd_exporter::extra_options}"

  prometheus::daemon { 'statsd_exporter':
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
