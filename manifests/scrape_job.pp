# Define: prometheus::scrape_job
#
# This define is used to export prometheus scrape settings from nodes to be scraped to the node
# running prometheus itself.
# This can be used to make prometheus find instances of your running service or application.
#
#  [*job_name*]
#  The name of the scrape job. This will be used when collecting resources on the prometheus node.
#  Corresponds to the prometheus::collect_scrape_jobs parameter.
#
#  [*targets*]
#  Array of hosts and ports in the form "host:port"
#
#  [*labels*]
#  Labels added to the scraped metrics on the prometheus side, as label:values pairs
#
#  [*collect_dir*]
#  Directory used for collecting scrape definitions.
#  NOTE: this is a prometheus setting and will be overridden during collection.
#
define prometheus::scrape_job (
  String $job_name,
  Array[String] $targets,
  Hash[String, String] $labels = {},
  String $collect_dir          = undef,
) {
  $config = [
    {
      targets => $targets,
      labels  => $labels,
    },
  ]
  file { "${collect_dir}/${job_name}_${name}.yaml":
    ensure  => present,
    owner   => $prometheus::user,
    group   => $prometheus::group,
    mode    => $prometheus::config_mode,
    content => template("${module_name}/file_sd_config.yaml.erb"),
  }
}
