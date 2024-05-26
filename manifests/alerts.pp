# @summary This module manages prometheus alert files for prometheus
# @param alerts
#  alert definitions
# @param location
#  Where to create the alert file for prometheus
define prometheus::alerts (
  Hash $alerts,
  String[1] $location = "${prometheus::config_dir}/rules",
  String[1] $version  = $prometheus::version,
  String[1] $user     = $prometheus::user,
  String[1] $group    = $prometheus::group,
  String[1] $bin_dir  = $prometheus::bin_dir,
) {
  file { "${location}/${name}.rules":
    ensure       => 'file',
    owner        => 'root',
    group        => $group,
    notify       => Class['prometheus::service_reload'],
    content      => $alerts.stdlib::to_yaml,
    validate_cmd => "${bin_dir}/promtool check rules %",
    require      => Class['prometheus::install'],
    before       => Class['prometheus::config'],
  }
}
