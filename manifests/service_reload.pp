# @summary
#   This class implements prometheus service reload without
#   restarting the whole service when a config changes
# @api private
class prometheus::service_reload () {
  if $prometheus::server::manage_service == true {
    $init_selector = $prometheus::run_service::init_selector

    $prometheus_reload = $prometheus::server::init_style ? {
      'systemd'          => "systemctl reload-or-restart ${init_selector}",
      'none'             => "service ${init_selector} reload",
      /^(sysv|sles)$/    => "/etc/init.d/${init_selector} reload",
      'launchd'          => "launchctl stop ${init_selector} && launchctl start ${init_selector}",
    }

    exec { 'prometheus-reload':
      command     => $prometheus_reload,
      path        => ['/usr/bin', '/bin', '/usr/sbin', '/sbin'],
      refreshonly => true,
    }
  }
}
