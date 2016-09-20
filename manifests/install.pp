# Class prometheus::install
# Install prometheus via different methods with parameters from init
# Currently only the install from url is implemented, when Prometheus will deliver packages for some Linux distros I will
# implement the package install method as well
# The package method needs specific yum or apt repo settings which are not made yet by the module
class prometheus::install
{
  if $::prometheus::localstorage {
    file { $::prometheus::localstorage:
      ensure => 'directory',
      owner  => $::prometheus::user,
      group  =>  $::prometheus::group,
      mode   => '0755',
    }
  }
  case $::prometheus::install_method {
    'url': {
      include staging
      staging::file { "prometheus-${prometheus::version}.${prometheus::download_extension}":
        source => $prometheus::real_download_url,
      } ->
      file { "${::staging::path}/prometheus-${prometheus::version}":
        ensure => directory,
      } ->
      staging::extract { "prometheus-${prometheus::version}.${prometheus::download_extension}":
        target  => $::staging::path,
        creates => "${::staging::path}/prometheus-${prometheus::version}.${prometheus::os}-${prometheus::arch}/prometheus",
      } ->
      file {
        "${::staging::path}/prometheus-${prometheus::version}.${prometheus::os}-${prometheus::arch}/prometheus":
          owner => 'root',
          group => 0, # 0 instead of root because OS X uses "wheel".
          mode  => '0555';
        "${::prometheus::bin_dir}/prometheus":
          ensure => link,
          notify => $::prometheus::notify_service,
          target => "${::staging::path}/prometheus-${prometheus::version}.${prometheus::os}-${prometheus::arch}/prometheus";
        $::prometheus::shared_dir:
          ensure => directory,
          owner  => $::prometheus::user,
          group  => $::prometheus::group,
          mode   => '0755';
        "${::prometheus::shared_dir}/consoles":
          ensure => link,
          notify => $::prometheus::notify_service,
          target => "${::staging::path}/prometheus-${prometheus::version}.${prometheus::os}-${prometheus::arch}/consoles";
        "${::prometheus::shared_dir}/console_libraries":
          ensure => link,
          notify => $::prometheus::notify_service,
          target => "${::staging::path}/prometheus-${prometheus::version}.${prometheus::os}-${prometheus::arch}/console_libraries";
      }
    }
    'package': {
      package { $::prometheus::package_name:
        ensure => $::prometheus::package_ensure,
      }
      if $::prometheus::manage_user {
        User[$::prometheus::user] -> Package[$::prometheus::package_name]
      }
    }
    'none': {}
    default: {
      fail("The provided install method ${::prometheus::install_method} is invalid")
    }
  }
  if $::prometheus::manage_user {
    ensure_resource('user', [ $::prometheus::user ], {
      ensure => 'present',
      system => true,
      groups => $::prometheus::extra_groups,
    })

    if $::prometheus::manage_group {
      Group[$::prometheus::group] -> User[$::prometheus::user]
    }
  }
  if $::prometheus::manage_group {
    ensure_resource('group', [ $::prometheus::group ],{
      ensure => 'present',
      system => true,
    })
  }
}
