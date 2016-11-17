# == Class prometheus::statsd_exporter::service
#
# This class is meant to be called from prometheus::statsd_exporter
# It ensure the statsd_exporter service is running
#
class prometheus::statsd_exporter::run_service {

  $init_selector = $prometheus::statsd_exporter::init_style ? {
    'launchd' => 'io.statsd_exporter.daemon',
    default   => 'statsd_exporter',
  }

  if $prometheus::statsd_exporter::manage_service == true {
    service { 'statsd_exporter':
      ensure => $prometheus::statsd_exporter::service_ensure,
      name   => $init_selector,
      enable => $prometheus::statsd_exporter::service_enable,
    }
  }
}
