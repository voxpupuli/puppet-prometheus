# @summary This module exports metrics regularly using a systemd timer
# @param base_directory
#  The base directory where your script and metrics will be
# @param scrape_script_location
#  The path where your scraping script will be
# @param clean_script_location
#  The path where the cleanup script will be
# @param metrics
#  A hash of metrics that will be exported, with the key being the attribute name, and the value being the command that gets the data
# @param on_calendar
#  Determines when the systemd timer will be executed
class prometheus::node_exporter_metrics (
  String $base_directory = '',
  String $scrape_script_location = '',
  String $clean_script_location = '',
  String $metrics_location = '',
  Hash $metrics = {},
  String $on_calendar = '',
) {
  file { "${base_directory}/${scrape_script_location}":
    ensure  => file,
    audit   => 'content',
    owner   => 'node-exporter',
    group   => 'root',
    mode    => '0750',
    content => epp('anutil/prometheus/scrape_metrics_sh.epp', {
      'metrics'           => $metrics,
      'base_directory'    => $base_directory,
      'metrics_location'  => $metrics_location,
    }),
    require => File["${base_directory}/${metrics_location}"],
    notify  => Exec['prometheus-clean-metrics'],
    seluser  => 'system_u',
    seltype  => 'bin_t',
    selrole  => 'object_r',
  }

  file { "${base_directory}/${clean_script_location}":
    ensure  => file,
    owner   => 'node-exporter',
    group   => 'root',
    mode    => '0750',
    content => epp('anutil/prometheus/clean_metrics_sh.epp', {
      'metrics'           => $metrics,
      'base_directory'    => $base_directory,
      'metrics_location'  => $metrics_location,
    }),
    seluser  => 'system_u',
    seltype  => 'bin_t',
    selrole  => 'object_r',
  }

  file { "${base_directory}/${metrics_location}":
    ensure  => directory,
    owner   => 'node-exporter',
    group   => 'root',
    mode    => '0750',
    require => File["${base_directory}/${clean_script_location}"],
    seluser  => 'system_u',
    seltype  => 'bin_t',
    selrole  => 'object_r',
  }

  exec { 'prometheus-clean-metrics':
    command     => "/bin/bash ${base_directory}/${clean_script_location}",
    user        => 'node-exporter',
  }

  systemd::timer { 'prometheus-scrape-metrics.timer':
    timer_content   => epp('anutil/prometheus/scrape_metrics_timer.epp', {
      'on_calendar' => $on_calendar,
    }),
    service_content => epp('anutil/prometheus/scrape_metrics_service.epp', {
      'base_directory'          => $base_directory,
      'scrape_script_location'  => $scrape_script_location,
    }),
  }

  service { 'prometheus-scrape-metrics.timer':
    ensure    => $metrics != {} ? {
      true  => running,
      false => stopped,
    },
    enable    => $metrics != {},
    subscribe => Systemd::Timer['prometheus-scrape-metrics.timer'],
    require   => File["${base_directory}/${scrape_script_location}"],
  }
}
