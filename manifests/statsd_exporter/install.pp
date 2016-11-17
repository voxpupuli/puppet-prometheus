# Class prometheus::statsd_exporter::install
# Install prometheus node statsd_exporter via different methods with parameters from init
# Currently only the install from url is implemented, when Prometheus will deliver packages for some Linux distros I will
# implement the package install method as well
# The package method needs specific yum or apt repo settings which are not made yet by the module
class prometheus::statsd_exporter::install
{

  case $::prometheus::statsd_exporter::install_method {
    'url': {
      include staging
      $staging_file = "statsd_exporter-${prometheus::statsd_exporter::version}.${prometheus::statsd_exporter::download_extension}"
      if( versioncmp($::prometheus::statsd_exporter::version, '0.3.0') == -1 ){
        $binary = "${::staging::path}/statsd_exporter"
      } else {
          $binary = "${::staging::path}/statsd_exporter-${::prometheus::statsd_exporter::version}.${::prometheus::statsd_exporter::os}-${::prometheus::statsd_exporter::arch}/statsd_exporter"
      }
      staging::file { $staging_file:
        source => $prometheus::statsd_exporter::real_download_url,
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
        "${::prometheus::statsd_exporter::bin_dir}/statsd_exporter":
          ensure => link,
          notify => $::prometheus::statsd_exporter::notify_service,
          target => $binary,
      }
    }
    'package': {
      package { $::prometheus::statsd_exporter::package_name:
        ensure => $::prometheus::statsd_exporter::package_ensure,
      }
      if $::prometheus::statsd_exporter::manage_user {
        User[$::prometheus::statsd_exporter::user] -> Package[$::prometheus::statsd_exporter::package_name]
      }
    }
    'none': {}
    default: {
      fail("The provided install method ${::prometheus::install_method} is invalid")
    }
  }
  if $::prometheus::statsd_exporter::manage_user {
    ensure_resource('user', [ $::prometheus::statsd_exporter::user ], {
      ensure => 'present',
      system => true,
      groups => $::prometheus::statsd_exporter::extra_groups,
    })

    if $::prometheus::statsd_exporter::manage_group {
      Group[$::prometheus::statsd_exporter::group] -> User[$::prometheus::statsd_exporter::user]
    }
  }
  if $::prometheus::statsd_exporter::manage_group {
    ensure_resource('group', [ $::prometheus::statsd_exporter::group ], {
      ensure => 'present',
      system => true,
    })
  }
}
