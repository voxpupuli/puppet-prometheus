# Class prometheus::alert_manager::install
# Install prometheus node alert_manager via different methods with parameters from init
# Currently only the install from url is implemented, when Prometheus will deliver packages for some Linux distros I will
# implement the package install method as well
# The package method needs specific yum or apt repo settings which are not made yet by the module
class prometheus::alert_manager::install
{
  if $::prometheus::alert_manager::storage_path
  {
    file { $::prometheus::alert_manager::storage_path:
      ensure => 'directory',
      owner  => $::prometheus::user,
      group  =>  $::prometheus::group,
      mode   => '0755',
    }
  }
  case $::prometheus::alert_manager::install_method {
    'url': {
      include staging
      $staging_file = "alert_manager-${prometheus::alert_manager::version}.${prometheus::alert_manager::download_extension}"
      $binary = "${::staging::path}/alertmanager-${::prometheus::alert_manager::version}.${::prometheus::os}-${::prometheus::arch}/alertmanager"
      staging::file { $staging_file:
        source => $prometheus::alert_manager::real_download_url,
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
        "${::prometheus::alert_manager::bin_dir}/alert_manager":
          ensure => link,
          notify => $::prometheus::alert_manager::notify_service,
          target => $binary,
      }
    }
    'package': {
      package { $::prometheus::alert_manager::package_name:
        ensure => $::prometheus::alert_manager::package_ensure,
      }
      if $::prometheus::alert_manager::manage_user {
        User[$::prometheus::alert_manager::user] -> Package[$::prometheus::alert_manager::package_name]
      }
    }
    'none': {}
    default: {
      fail("The provided install method ${::prometheus::install_method} is invalid")
    }
  }
  if $::prometheus::alert_manager::manage_user {
    ensure_resource('user', [ $::prometheus::alert_manager::user ], {
      ensure => 'present',
      system => true,
      groups => $::prometheus::alert_manager::extra_groups,
    })

    if $::prometheus::alert_manager::manage_group {
      Group[$::prometheus::alert_manager::group] -> User[$::prometheus::alert_manager::user]
    }
  }
  if $::prometheus::alert_manager::manage_group {
    ensure_resource('group', [ $::prometheus::alert_manager::group ], {
      ensure => 'present',
      system => true,
    })
  }
}
