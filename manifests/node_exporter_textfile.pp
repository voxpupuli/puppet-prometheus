# @summary ThThis module manages text file based metrics for node_exporter and a systemd timer for updating values if they are not static.
# @param update_script_location
#  The path where the scraping script is located.
# @param cleanup_script_location
#  The path where the cleanup script is located
# @param metrics
#  A hash of metrics that will be exported, with the key being the attribute name, and the value being the command that gets the data, these will be parsed in the system timer
# @param on_calendar
#  Determines when the systemd timer will be executed
# @param seluser
#  The SELinux user context for the files
# @param seltype
#  The SELinux type context for the files
# @param selrole
#  The SELinux role context for the files
class prometheus::node_exporter_textfile (
  String $update_script_location = '/usr/local/bin/update_metrics.sh',
  String $cleanup_script_location  = '/usr/local/bin/cleanup_metrics.sh',
  Hash $metrics                  = {},
  String $on_calendar            = '*:0/2:30',
  Optional[String] $seluser      = undef,
  Optional[String] $seltype      = undef,
  Optional[String] $selrole      = undef,
) {
  $textfile_directory = $prometheus::node_exporter::textfile_directory
  $group = $prometheus::node_exporter::group
  $user = $prometheus::node_exporter::user

  file { $update_script_location:
    ensure   => file,
    audit    => 'content',
    owner    => $user,
    group    => $group,
    mode     => '0750',
    content  => epp('prometheus/update_metrics.sh.epp', {
      'metrics'           => $metrics,
      'textfile_directory'  => $textfile_directory,
    }),
    require  => File[$textfile_directory],
    notify   => Exec['prometheus-clean-metrics'],
    seluser  => $seluser,
    seltype  => $seltype,
    selrole  => $selrole,
  }

  file { $cleanup_script_location:
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0750',
    content => epp('prometheus/cleanup_metrics.sh.epp', {
      'metrics'           => $metrics,
      'textfile_directory'  => $textfile_directory,
    }),
    seluser => $seluser,
    seltype => $seltype,
    selrole => $selrole,
  }

  file { $textfile_directory:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0750',
    require => File[$cleanup_script_location],
    seluser => $seluser,
    seltype => $seltype,
    selrole => $selrole,
  }

  exec { 'prometheus-clean-metrics':
    command     => "/bin/bash ${cleanup_script_location}",
    user        => $user,
  }

  systemd::timer { 'prometheus-scrape-metrics.timer':
    timer_content   => epp('prometheus/update_metrics_timer.epp', {
      'on_calendar' => $on_calendar,
    }),
    service_content => epp('prometheus/update_metrics_service.epp', {
      'update_script_location'  => $update_script_location,
    }),
  }

  service { 'prometheus-scrape-metrics.timer':
    ensure    => $metrics != {} ? {
      true  => running,
      false => stopped,
    },
    enable    => $metrics != {},
    subscribe => Systemd::Timer['prometheus-scrape-metrics.timer'],
    require   => File[$update_script_location],
  }
}
