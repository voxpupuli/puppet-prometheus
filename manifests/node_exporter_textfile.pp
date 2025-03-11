# @summary Manages text file metrics for node_exporter & a systemd timer (if systemd is used), scripts are always created & managed.
# @param update_script_location
#  The path where the updating script is located.
# @param cleanup_script_location
#  The path where the cleanup script is located
# @param metrics
#  A hash of metrics where a key is a metric name and the corresponding value is a hash of two key value pairs:
#   - 'command': The bash command used to collect or update the metric.
#   - 'static': A boolean that indicates whether the metric will be updated regularly by a timer (false), or will be updated only upon change in puppet, e.g. in hiera (true).
# @param on_calendar
#  Determines when the systemd timer will be executed
# @param seluser
#  The SELinux user context for the files
# @param seltype
#  The SELinux type context for the files
# @param selrole
#  The SELinux role context for the files

type Metric = Struct[
  {
    'command' => String[1],
    'static'  => Boolean
  }
]

class prometheus::node_exporter_textfile (
  Stdlib::Absolutepath $update_script_location  = '/usr/local/bin/update_metrics.sh',
  Stdlib::Absolutepath $cleanup_script_location = '/usr/local/bin/cleanup_metrics.sh',
  Hash[String[1], Metric] $metrics                   = {},
  String $on_calendar             = '*:0/2:30',
  Optional[String] $seluser       = undef,
  Optional[String] $seltype       = undef,
  Optional[String] $selrole       = undef,
) {
  $textfile_directory = $prometheus::node_exporter::textfile_directory
  $group = $prometheus::node_exporter::group
  $user = $prometheus::node_exporter::user

  file { $update_script_location:
    ensure  => file,
    audit   => 'content',
    owner   => $user,
    group   => $group,
    mode    => '0750',
    content => epp('prometheus/update_metrics.sh.epp', {
        'metrics'            => $metrics,
        'textfile_directory' => $textfile_directory,
    }),
    require => File[$textfile_directory],
    notify  => Exec['prometheus-cleanup-metrics'],
    seluser => $seluser,
    seltype => $seltype,
    selrole => $selrole,
  }

  file { $cleanup_script_location:
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0750',
    content => epp('prometheus/cleanup_metrics.sh.epp', {
        'metrics'            => $metrics,
        'textfile_directory' => $textfile_directory,
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

  exec { 'prometheus-cleanup-metrics':
    command => "/bin/bash ${cleanup_script_location}",
    user    => $user,
  }

  systemd::timer_wrapper { 'prometheus-update-metrics-timer':
    ensure      => $metrics != {} ? {
      true  => 'present',
      false => 'absent',
    },
    on_calendar => $on_calendar,
    command     => "/bin/bash ${update_script_location}",
  }

  $metrics.each |$key, $value| {
    if $value['static'] {
      exec { "update_${key}_metric":
        command     => "/bin/bash -c \"echo '${key} '$( ${value['command']} ) > ${textfile_directory}/${key}.prom\"",
        refreshonly => false,
        path        => ['/bin', '/usr/bin'],
        require     => File[$textfile_directory],
      }
    }
  }
}
