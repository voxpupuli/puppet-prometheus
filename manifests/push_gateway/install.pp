# Class prometheus::push_gateway::install
# Install prometheus node push_gateway via different methods with parameters from init
# Currently only the install from url is implemented, when Prometheus will deliver packages for some Linux distros I will
# implement the package install method as well
# The package method needs specific yum or apt repo settings which are not made yet by the module
class prometheus::push_gateway::install
{
  if $::prometheus::push_gateway::storage_path
  {
    file { $::prometheus::push_gateway::storage_path:
      ensure => 'directory',
      owner  => $::prometheus::user,
      group  =>  $::prometheus::group,
      mode   => '0755',
    }
  }
  case $::prometheus::push_gateway::install_method {
    'url': {
      include staging
      $staging_file = "push_gateway-${prometheus::push_gateway::version}.${prometheus::push_gateway::download_extension}"
      if( versioncmp($::prometheus::push_gateway::version, '0.1.0') == -1 ){
        $binary = "${::staging::path}/pushgateway-${::prometheus::push_gateway::version}.${::prometheus::os}-${::prometheus::arch}"
      } else {
        $binary = "${::staging::path}/pushgateway-${::prometheus::push_gateway::version}.${::prometheus::os}-${::prometheus::arch}/pushgateway"
      }
      staging::file { $staging_file:
        source => $prometheus::push_gateway::real_download_url,
      } ->
      staging::extract { $staging_file:
        target  => $::staging::path,
        creates => $binary,
      } ->
      file {
        $binary:
          owner => 'root',
          group => 0, # 0 instead of root because OS X uses "wheel".
          mode  => '0555';
        "${::prometheus::push_gateway::bin_dir}/push_gateway":
          ensure => link,
          notify => $::prometheus::push_gateway::notify_service,
          target => $binary,
      }
    }
    'package': {
      package { $::prometheus::push_gateway::package_name:
        ensure => $::prometheus::push_gateway::package_ensure,
      }
      if $::prometheus::push_gateway::manage_user {
        User[$::prometheus::push_gateway::user] -> Package[$::prometheus::push_gateway::package_name]
      }
    }
    'none': {}
    default: {
      fail("The provided install method ${::prometheus::install_method} is invalid")
    }
  }
  if $::prometheus::push_gateway::manage_user {
    ensure_resource('user', [ $::prometheus::push_gateway::user ], {
      ensure => 'present',
      system => true,
      groups => $::prometheus::push_gateway::extra_groups,
    })

    if $::prometheus::push_gateway::manage_group {
      Group[$::prometheus::push_gateway::group] -> User[$::prometheus::push_gateway::user]
    }
  }
  if $::prometheus::push_gateway::manage_group {
    ensure_resource('group', [ $::prometheus::push_gateway::group ], {
      ensure => 'present',
      system => true,
    })
  }
}
