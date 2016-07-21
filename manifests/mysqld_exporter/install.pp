# Class prometheus::mysqld_exporter::install
# Install prometheus mysqld mysqld_exporter via different methods with parameters from init
# Currently only the install from url is implemented, when Prometheus will deliver packages for some Linux distros I will
# implement the package install method as well
# The package method needs specific yum or apt repo settings which are not made yet by the module
class prometheus::mysqld_exporter::install
{

  case $::prometheus::mysqld_exporter::install_method {
    'url': {
      include staging
      $staging_file = "mysqld_exporter-${prometheus::mysqld_exporter::version}.${prometheus::mysqld_exporter::download_extension}"
      if( versioncmp($::prometheus::mysqld_exporter::version, '0.8.1') == -1 ){
        $binary = "${::staging::path}/mysqld_exporter"
      } else {
          $binary = "${::staging::path}/mysqld_exporter-${::prometheus::mysqld_exporter::version}.${::prometheus::mysqld_exporter::os}-${::prometheus::mysqld_exporter::arch}/mysqld_exporter"
      }
      staging::file { $staging_file:
        source => $prometheus::mysqld_exporter::real_download_url,
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
        "${::prometheus::mysqld_exporter::bin_dir}/mysqld_exporter":
          ensure => link,
          notify => $::prometheus::mysqld_exporter::notify_service,
          target => $binary,
      }
    }
    'package': {
      package { $::prometheus::mysqld_exporter::package_name:
        ensure => $::prometheus::mysqld_exporter::package_ensure,
      }
      if $::prometheus::mysqld_exporter::manage_user {
        User[$::prometheus::mysqld_exporter::user] -> Package[$::prometheus::mysqld_exporter::package_name]
      }
    }
    'none': {}
    default: {
      fail("The provided install method ${::prometheus::install_method} is invalid")
    }
  }
  if $::prometheus::mysqld_exporter::manage_user {
    ensure_resource('user', [ $::prometheus::mysqld_exporter::user ], {
      ensure => 'present',
      system => true,
      groups => $::prometheus::mysqld_exporter::extra_groups,
    })

    if $::prometheus::mysqld_exporter::manage_group {
      Group[$::prometheus::mysqld_exporter::group] -> User[$::prometheus::mysqld_exporter::user]
    }
  }
  if $::prometheus::mysqld_exporter::manage_group {
    ensure_resource('group', [ $::prometheus::mysqld_exporter::group ], {
      ensure => 'present',
      system => true,
    })
  }
}
