# == Class prometheus::push_gateway::service
#
# This class is meant to be called from prometheus::push_gateway
# It ensure the push_gateway service is running
#
class prometheus::push_gateway::run_service {

  $init_selector = $prometheus::push_gateway::init_style ? {
    'launchd' => 'io.push_gateway.daemon',
    default   => 'push_gateway',
  }

  if $prometheus::push_gateway::manage_service == true {
    service { 'push_gateway':
      ensure => $prometheus::push_gateway::service_ensure,
      name   => $init_selector,
      enable => $prometheus::push_gateway::service_enable,
    }
  }
}
