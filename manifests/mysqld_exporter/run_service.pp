# == Class prometheus::mysqld_exporter::service
#
# This class is meant to be called from prometheus::mysqld_exporter
# It ensure the mysqld_exporter service is running
#
class prometheus::mysqld_exporter::run_service {

  $init_selector = $prometheus::mysqld_exporter::init_style ? {
    'launchd' => 'io.mysqld_exporter.daemon',
    default   => 'mysqld_exporter',
  }

  if $prometheus::mysqld_exporter::manage_service == true {
    service { 'mysqld_exporter':
      ensure => $prometheus::mysqld_exporter::service_ensure,
      name   => $init_selector,
      enable => $prometheus::mysqld_exporter::service_enable,
    }
  }
}
