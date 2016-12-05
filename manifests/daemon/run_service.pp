class prometheus::daemon::run_service(
  $init_style,
  $daemon_name,
  $service_enable,
  $service_ensure,
  $manage_service,
  ) {

  $init_selector = $init_style ? {
    'launchd' => "io.${daemon_name}.daemon",
    default   => $daemon_name,
  }

  if $manage_service == true {
    service { $daemon_name:
      ensure => $service_ensure,
      name   => $init_selector,
      enable => $service_enable,
    }
  }
}
