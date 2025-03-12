# @summary This module manages text file metrics for node_exporter & a systemd timer (if systemd is used), scripts are always created & managed.
# @param update_script_location
#  The path where the updating script is located.
# @param metrics_config_path
#  The path where the active metrics configuration file is located
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
class prometheus::node_exporter_textfile (
  Stdlib::Absolutepath $update_script_location  = '/usr/local/bin/update_metrics.sh',
  Stdlib::Absolutepath $metrics_config_path = '/etc/sysconfig/textfile_active',
  Hash[String[1], Struct[
    {
      'command' => String[1],
      'static'  => Boolean
    }
  ]] $metrics                   = {},
  String $on_calendar             = '*:0/2:30',
  Optional[String] $seluser       = undef,
  Optional[String] $seltype       = undef,
  Optional[String] $selrole       = undef,
) {
  $textfile_directory = $prometheus::node_exporter::textfile_directory
  $group = $prometheus::node_exporter::group
  $user = $prometheus::node_exporter::user
  $static_metrics = $metrics.filter |$key, $value| { $value['static'] }

  file { $update_script_location:
    ensure  => file,
    audit   => 'content',
    owner   => $user,
    group   => $group,
    mode    => '0750',
    source  => 'puppet:///modules/prometheus/update_metrics.sh',
    require => File[$textfile_directory],
    notify  => Exec['prometheus-update-metrics'],
    seluser => $seluser,
    seltype => $seltype,
    selrole => $selrole,
  }

  file { $metrics_config_path:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('prometheus/textfile_metrics_config.epp', {
        'metrics' => $metrics,
      }
    ),
  }

  file { $textfile_directory:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0750',
    seluser => $seluser,
    seltype => $seltype,
    selrole => $selrole,
  }

  exec { 'prometheus-update-metrics':
    command => "/bin/bash ${update_script_location} ${metrics_config_path} ${textfile_directory}",
    user    => $user,
    path    => ['/bin', '/usr/bin'],
  }

  systemd::timer_wrapper { 'prometheus-update-metrics':
    ensure      => empty($metrics.filter |$key, $value| { !$value['static'] }) ? {
      true  => 'absent',
      false => 'present',
    },
    on_calendar => $on_calendar,
    command     => "/bin/bash ${update_script_location} ${metrics_config_path} ${textfile_directory}",
    user        => $user,
  }

  if empty($static_metrics) {
    file { "${textfile_directory}/static.prom":
      ensure  => absent,
      require => File[$textfile_directory],
    }
  } else {
    exec { 'clear-static-metrics':
      command     => "/bin/bash -c '> ${textfile_directory}/static.prom'",
      user        => $user,
      refreshonly => false,
      path        => ['/bin', '/usr/bin'],
    }

    $static_metrics.each |$key, $value| {
      exec { "update_${key}_metric":
        command     => "/bin/bash -c \"echo '${key} '$( ${value['command']} ) >> ${textfile_directory}/static.prom\"",
        user        => $user,
        refreshonly => false,
        path        => ['/bin', '/usr/bin'],
        require     => Exec['clear-static-metrics'],
      }
    }
  }
}
