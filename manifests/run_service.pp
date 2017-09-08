# == Class prometheus::service
#
# This class is meant to be called from prometheus
# It ensure the service is running
#
class prometheus::run_service {

  $init_selector = $prometheus::init_style ? {
    'launchd' => 'io.prometheus.daemon',
    default   => 'prometheus',
  }

  $restart_cmd = $prometheus::init_style ? {
    'systemd' => "systemctl reload-or-restart ${init_selector}",
    default   => '/usr/bin/pkill -HUP prometheus',
  }

  if $prometheus::manage_service == true {
    service { 'prometheus':
      ensure     => $prometheus::service_ensure,
      name       => $init_selector,
      enable     => $prometheus::service_enable,
      hasrestart => true,
      restart    => $restart_cmd,
    }
  }
}
