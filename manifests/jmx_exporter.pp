# @summary Installs and configures the Prometheus JMX exporter
# @see https://github.com/prometheus/jmx_exporter
# @param version
#  Version of JMX exporter to download
# @param config_file_location
#  Location where the jmx-exporter configuration should be placed
# @param service_name
#  System service name for jmx exporter httpserver deployment
# @param user
#  Service user for httpserver deployment
# @param group
#  Service group for httpserver deployment
# @param extra_groups
#  Additional groups for httpserver deployment service user
# @param java_bin_path
#  Path to JAVA (required for httpserver deployment)
# @param configuration
#  jmx-exporter configuration (see website for details)
# @param deployment
#  Way of deploying jmx-exporter. Defaults to standalone httpserver deployment. If set to javaagent, requires
#  additional configuration on the target jmx service
# @param os
#  Operating system (linux is the only one supported)
# @param arch
#  Architecture (amd64 or i386)
# @param bin_dir
#  Directory where binaries are located
# @param config_mode
#  File mode for jmx exporter configuration file
# @param restart_on_change
#  Restart jmx exporter service when the configuration file was updated
# @param manage_user
#  Manage service user
# @param manage_group
#  Manage service group
# @param manage_service
#  Manage service
# @param port
#  Port that the JMX exporter should listen on (required for httpserver deployment)
# @param download_url
#  Download URL for JMX exporter
# @param proxy_server
#  Optional proxy server, with port number if needed. ie: https://example.com:8080
# @param proxy_type
#  Optional proxy server type (none|http|https|ftp)
# @param java_options
#  Optional options for the JVM of the standalone jmx exporter
class prometheus::jmx_exporter (
  String[1] $version,
  Stdlib::Absolutepath $config_file_location                 = '/etc/jmx-exporter.yaml',
  String[1] $service_name                                    = 'jmx_exporter',
  String[1] $user                                            = 'jmx_exporter',
  String[1] $group                                           = 'jmx-exporter',
  Array[String[1]] $extra_groups                             = [],
  Stdlib::Absolutepath $java_bin_path                        = '/usr/bin/java',
  Hash $configuration                                        = {},
  Enum['javaagent', 'httpserver'] $deployment                = 'httpserver',
  String[1] $os                                              = downcase($facts['kernel']),
  String[1] $arch                                            = $prometheus::real_arch,
  Stdlib::Absolutepath $bin_dir                              = $prometheus::bin_dir,
  String[1] $config_mode                                     = $prometheus::config_mode,
  Boolean $restart_on_change                                 = true,
  Boolean $manage_user                                       = true,
  Boolean $manage_group                                      = true,
  Boolean $manage_service                                    = true,
  Optional[Stdlib::Port::Unprivileged] $port                 = undef,
  Optional[Prometheus::Uri] $download_url                    = undef,
  Optional[String[1]] $proxy_server                          = undef,
  Optional[Enum['none', 'http', 'https', 'ftp']] $proxy_type = undef,
  Optional[String] $java_options                             = undef,
) inherits prometheus {
  if $deployment == 'httpserver' and $port == undef {
    fail('Port is required for httpserver deployment')
  }

  $base_url = 'https://repo1.maven.org/maven2/io/prometheus/jmx'
  $real_download_url = $download_url ? {
    undef   => "${base_url}/jmx_prometheus_${deployment}/${version}/jmx_prometheus_${deployment}-${version}.jar",
    default => $download_url
  }

  $_manage_service = $deployment ? {
    'javaagent' => false,
    default     => $manage_service
  }

  $notify_service = ($restart_on_change and $_manage_service) ? {
    true    => Service[$service_name],
    default => undef,
  }

  file { $config_file_location:
    ensure  => file,
    owner   => 'root',
    group   => $group,
    mode    => $config_mode,
    content => template('prometheus/jmx_exporter.yaml.erb'),
    notify  => $notify_service,
  }

  $_manage_group = $deployment ? {
    'javaagent' => false,
    default     => $manage_group
  }

  $_manage_user = $deployment ? {
    'javaagent' => false,
    default     => $manage_user
  }

  $_java_options = $java_options ? {
    undef   => '',
    default => "${java_options} "
  }

  prometheus::daemon { $service_name:
    notify_service     => $notify_service,
    install_method     => 'url',
    version            => $version,
    download_extension => '',
    real_download_url  => $real_download_url,
    proxy_server       => $proxy_server,
    proxy_type         => $proxy_type,
    manage_group       => $_manage_group,
    manage_service     => $_manage_service,
    manage_user        => $_manage_user,
    extra_groups       => $extra_groups,
    user               => $user,
    group              => $group,
    manage_bin_link    => false,
    bin_dir            => dirname($java_bin_path),
    bin_name           => basename($java_bin_path),
    options            => "${_java_options}-jar /opt/${service_name}-${version}.${os}-${arch}/${service_name} ${port} ${config_file_location}",
    os                 => $os,
    arch               => $arch,
  }
}
