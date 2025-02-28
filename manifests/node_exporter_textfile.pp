# @summary This module exports metrics regularly using a systemd timer
# @param base_directory
#  The base directory where your scripts will reside
# @param scrape_script_location
#  The path where your scraping script will be
# @param clean_script_location
#  The path where the cleanup script will be
# @param metrics
#  A hash of metrics that will be exported, with the key being the attribute name, and the value being the command that gets the data
# @param on_calendar
#  Determines when the systemd timer will be executed
class prometheus::node_exporter_textfile (
  String $scrape_script_location = '',
  String $clean_script_location  = '',
  Hash $metrics                  = {},
  String $on_calendar            = '',
  Optional[String] owner         = 'node-exporter',
  Optional[String] group         = 'root',
  Optional[String] mode          = '0750',
  Optional[String] $seluser      = undef,
  Optional[String] $seltype      = undef,
  Optional[String] $selrole      = undef,
) {
  $metrics_directory = $prometheus::node_exporter::textfile_directory

  file { $scrape_script_location:
    ensure   => file,
    audit    => 'content',
    owner    => $owner,
    group    => $group,
    mode     => $mode,
    content  => epp('prometheus/scrape_metrics.sh.epp', {
      'metrics'           => $metrics,
      'metrics_directory'  => $metrics_directory,
    }),
    require  => File[$metrics_directory],
    before   => File[$scrape_script_location],
    notify   => Exec['prometheus-clean-metrics'],
    seluser  => $seluser,
    seltype  => $seltype,
    selrole  => $selrole,
  }

  file { $clean_script_location:
    ensure  => file,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => epp('prometheus/clean_metrics.sh.epp', {
      'metrics'           => $metrics,
      'metrics_directory'  => $metrics_directory,
    }),
    seluser => $seluser,
    seltype => $seltype,
    selrole => $selrole,
  }

  file { $metrics_directory:
    ensure  => directory,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    require => File[$clean_script_location],
    seluser => $seluser,
    seltype => $seltype,
    selrole => $selrole,
  }

  exec { 'prometheus-clean-metrics':
    command     => "/bin/bash ${clean_script_location}",
    user        => $owner,
  }

  systemd::timer { 'prometheus-scrape-metrics.timer':
    timer_content   => epp('prometheus/prometheus/scrape_metrics_timer.epp', {
      'on_calendar' => $on_calendar,
    }),
    service_content => epp('prometheus/prometheus/scrape_metrics_service.epp', {
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
    require   => File[${scrape_script_location}],
  }
}
