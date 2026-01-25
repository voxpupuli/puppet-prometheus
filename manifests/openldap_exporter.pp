# @summary This module manages prometheus openldap_exporter
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
# @param options
#  Additionnal arguments to command line of openldap_exporter, use to specify the URL of the LDAP to scrap if not ldap://localhost:389
#  Do not use for user/password authentication
# @param group
#  Group under which the binary is running
# @param init_style
#  Service startup scripts style (e.g. rc or systemd)
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
#  The binary package name - used to reference the name in the archive.
# @param restart_on_change
#  Should puppet restart the service on configuration change? (default true)
# @param service_enable
#  Whether to enable the service from puppet (default true)
# @param service_ensure
#  State ensured for the service (default 'running')
# @param service_name
#  Name of the node exporter service (default 'openldap_exporter')
# @param user
#  User which runs the service
# @param version
#  The binary release version
# @param ldap_binddn
#  DN (LDAP User) used to authenticate to openldap cn=monitor tree
# @param ldap_password
#  Password used to authenticate to openldap cn=monitor tree
# @param proxy_server
#  Optional proxy server, with port number if needed. ie: https://example.com:8080
# @param proxy_type
#  Optional proxy server type (none|http|https|ftp)
class prometheus::openldap_exporter (
  String $download_extension                                 = 'tar.gz',
  Array[String] $extra_groups                                = [],
  String[1] $group                                           = 'openldap-exporter',
  String[1] $package_ensure                                  = 'latest',
  String[1] $user                                            = 'openldap-exporter',
  # renovate: depName=hm-edu/openldap-exporter
  String[1] $version                                         = 'v2.7.0',
  Prometheus::Uri $download_url_base                         = 'https://github.com/hm-edu/openldap-exporter/releases',
  String[1] $package_name                                    = 'openldap-exporter',
  String[1] $service_name                                    = 'openldap_exporter',
  Boolean $restart_on_change                                 = true,
  Boolean $service_enable                                    = true,
  Stdlib::Ensure::Service $service_ensure                    = 'running',
  Prometheus::Initstyle $init_style                          = $prometheus::init_style,
  Prometheus::Install $install_method                        = $prometheus::install_method,
  Boolean $manage_group                                      = true,
  Boolean $manage_service                                    = true,
  Boolean $manage_user                                       = true,
  String[1] $os                                              = downcase($facts['kernel']),
  String $options                                            = '', # lint:ignore:params_empty_string_assignment
  Optional[Prometheus::Uri] $download_url                    = undef,
  Stdlib::Absolutepath $bin_dir                              = $prometheus::bin_dir,
  Boolean $export_scrape_job                                 = false,
  Optional[Stdlib::Host] $scrape_host                        = undef,
  Stdlib::Port $scrape_port                                  = 9330,
  String[1] $scrape_job_name                                 = 'openldap',
  Optional[Hash] $scrape_job_labels                          = undef,
  Optional[String[1]] $ldap_binddn                           = undef,
  Optional[String[1]] $ldap_password                         = undef,
  Optional[String[1]] $proxy_server                          = undef,
  Optional[Enum['none', 'http', 'https', 'ftp']] $proxy_type = undef,
) inherits prometheus {
  # package does not follow the $prometheus::real_arch naming for x86_64
  # but also does not follw the $prometheus::arch naming for aarch64 and armv6l
  # there are no other arch released
  $real_arch = $prometheus::arch ? {
    'aarch64' => $prometheus::real_arch,
    'armv6l'  => $prometheus::real_arch,
    'amd64'   => 'x86_64',
    default   => $prometheus::arch,
  }
  $real_download_url = pick($download_url,"${download_url_base}/download/${version}/${package_name}_${os}_${real_arch}.${download_extension}")

  # For compatibility with previous versions, we keep the previous name for the service
  # but since the binary has changed name, we need to specify it manually.
  $extract_path = "/opt/${service_name}-${version}.${os}-${real_arch}"
  $archive_bin_path = "${extract_path}/${package_name}"
  file { $extract_path:
    ensure => 'directory',
    owner  => 'root',
    group  => 0, # 0 instead of root because OS X uses "wheel".
    mode   => '0755',
    before => Prometheus::Daemon[$service_name],
  }

  $notify_service = $restart_on_change ? {
    true    => Service[$service_name],
    default => undef,
  }
  if $ldap_binddn != undef and $ldap_password != undef {
    $env_vars = {
      'LDAP_USER' => $ldap_binddn,
      'LDAP_PASS' => $ldap_password,
    }
  } else {
    $env_vars = {}
  }

  prometheus::daemon { $service_name:
    install_method     => $install_method,
    version            => $version,
    download_extension => $download_extension,
    os                 => $os,
    real_download_url  => $real_download_url,
    extract_path       => $extract_path,
    archive_bin_path   => $archive_bin_path,
    bin_dir            => $bin_dir,
    notify_service     => $notify_service,
    package_name       => $package_name,
    package_ensure     => $package_ensure,
    manage_user        => $manage_user,
    user               => $user,
    extra_groups       => $extra_groups,
    group              => $group,
    manage_group       => $manage_group,
    options            => $options,
    init_style         => $init_style,
    service_ensure     => $service_ensure,
    service_enable     => $service_enable,
    manage_service     => $manage_service,
    env_vars           => $env_vars,
    export_scrape_job  => $export_scrape_job,
    scrape_host        => $scrape_host,
    scrape_port        => $scrape_port,
    scrape_job_name    => $scrape_job_name,
    scrape_job_labels  => $scrape_job_labels,
    proxy_server       => $proxy_server,
    proxy_type         => $proxy_type,
  }
}
