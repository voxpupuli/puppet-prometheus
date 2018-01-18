# Class prometheus::params
# Include default parameters for prometheus class
class prometheus::params {
  $alert_relabel_config = []
  $alertmanagers_config = []
  $alertmanager_config_dir = '/etc/alertmanager'
  $alertmanager_config_file = "${alertmanager_config_dir}/alertmanager.yaml"
  $alertmanager_download_extension = 'tar.gz'
  $alertmanager_download_url_base = 'https://github.com/prometheus/alertmanager/releases'
  $alertmanager_extra_groups = []
  $alertmanager_global = { 'smtp_smarthost' =>'localhost:25', 'smtp_from'=>'alertmanager@localhost' }
  $alertmanager_group = 'alertmanager'
  $alertmanager_inhibit_rules = [ { 'source_match' => { 'severity'=> 'critical' },'target_match'=> { 'severity'=>'warning'},'equal'=>['alertname','cluster','service']}]
  $alertmanager_package_ensure = 'latest'
  $alertmanager_package_name = 'alertmanager'
  $alertmanager_receivers = [ { 'name'             => 'Admin', 'email_configs'=> [ { 'to'=> 'root@localhost' }] }]
  $alertmanager_route = { 'group_by'               =>  [ 'alertname', 'cluster', 'service' ], 'group_wait'=> '30s', 'group_interval'=> '5m', 'repeat_interval'=> '3h', 'receiver'=> 'Admin' }
  $alertmanager_storage_path='/var/lib/alertmanager'
  $alertmanager_templates = [ "${alertmanager_config_dir}/*.tmpl" ]
  $alertmanager_user = 'alertmanager'
  $alertmanager_version = '0.5.1'
  $alerts = []
  $bin_dir = '/usr/local/bin'
  $config_dir = '/etc/prometheus'
  $config_mode = '0660'
  $config_template = 'prometheus/prometheus.yaml.erb'
  $download_extension = 'tar.gz'
  $download_url_base = 'https://github.com/prometheus/prometheus/releases'
  $elasticsearch_exporter_cnf_uri = 'http://localhost:9200'
  $elasticsearch_exporter_cnf_timeout = '5s'
  $elasticsearch_exporter_download_extension = 'tar.gz'
  $elasticsearch_exporter_download_url_base = 'https://github.com/justwatchcom/elasticsearch_exporter/releases'
  $elasticsearch_exporter_extra_groups = []
  $elasticsearch_exporter_group = 'elasticsearch-exporter'
  $elasticsearch_exporter_package_ensure = 'latest'
  $elasticsearch_exporter_package_name = 'elasticsearch_exporter'
  $elasticsearch_exporter_user = 'elasticsearch-exporter'
  $elasticsearch_exporter_version = '1.0.2rc1'
  $extra_groups = []
  $global_config = { 'scrape_interval'=> '15s', 'evaluation_interval'=> '15s', 'external_labels'=> { 'monitor'=>'master'}}
  $group = 'prometheus'
  $install_method = 'url'
  $localstorage = '/var/lib/prometheus'
  $mesos_exporter_server_type= 'master'
  $mesos_exporter_cnf_scrape_uri = 'http://localhost:5050'
  $mesos_exporter_download_extension = 'tar.gz'
  $mesos_exporter_download_url_base = 'https://github.com/mesosphere/mesos_exporter/releases'
  $mesos_exporter_extra_groups = []
  $mesos_exporter_group = 'mesos-exporter'
  $mesos_exporter_user = 'mesos-exporter'
  $mesos_exporter_package_ensure = 'latest'
  $mesos_exporter_package_name = 'mesos_exporter'
  $mesos_exporter_version = '1.0.0'
  $haproxy_exporter_cnf_scrape_uri = 'http://localhost:1234/haproxy?stats;csv'
  $haproxy_exporter_download_extension = 'tar.gz'
  $haproxy_exporter_download_url_base = 'https://github.com/prometheus/haproxy_exporter/releases'
  $haproxy_exporter_extra_groups = []
  $haproxy_exporter_group = 'haproxy-exporter'
  $haproxy_exporter_package_ensure = 'latest'
  $haproxy_exporter_package_name = 'haproxy_exporter'
  $haproxy_exporter_user = 'haproxy-user'
  $haproxy_exporter_version = '0.7.1'
  $nginx_vts_exporter_nginx_scrape_uri = 'http://localhost/status/format/json'
  $nginx_vts_exporter_download_extension = 'tar.gz'
  $nginx_vts_exporter_download_url_base = 'https://github.com/hnlq715/nginx-vts-exporter/releases'
  $nginx_vts_exporter_extra_groups = []
  $nginx_vts_exporter_group = 'nginx-vts-exporter'
  $nginx_vts_exporter_package_ensure = 'latest'
  $nginx_vts_exporter_package_name = 'nginx-vts-exporter'
  $nginx_vts_exporter_user = 'nginx-vts-exporter'
  $nginx_vts_exporter_version = '0.6'
  $process_exporter_download_extension = 'tar.gz'
  $process_exporter_download_url_base = 'https://github.com/ncabatoff/process-exporter/releases'
  $process_exporter_extra_groups = []
  $process_exporter_group = 'process-exporter'
  $process_exporter_package_ensure = 'latest'
  $process_exporter_package_name = 'process-exporter'
  $process_exporter_user = 'process-exporter'
  $process_exporter_version = '0.1.0'
  $process_exporter_config_path = '/etc/process-exporter.yaml'
  $pushgateway_download_extension = 'tar.gz'
  $pushgateway_download_url_base = 'https://github.com/prometheus/pushgateway/releases'
  $pushgateway_extra_groups = []
  $pushgateway_group = 'pushgateway'
  $pushgateway_package_ensure = 'latest'
  $pushgateway_package_name = 'pushgateway'
  $pushgateway_user = 'pushgateway'
  $pushgateway_version = '0.4.0'
  $mysqld_exporter_cnf_config_path = '/etc/.my.cnf'
  $mysqld_exporter_cnf_host = 'localhost'
  $mysqld_exporter_cnf_password = 'password'
  $mysqld_exporter_cnf_port = 3306
  $mysqld_exporter_cnf_user = 'login'
  $mysqld_exporter_download_extension = 'tar.gz'
  $mysqld_exporter_download_url_base = 'https://github.com/prometheus/mysqld_exporter/releases'
  $mysqld_exporter_extra_groups = []
  $mysqld_exporter_group = 'mysqld-exporter'
  $mysqld_exporter_package_ensure = 'latest'
  $mysqld_exporter_package_name = 'mysqld_exporter'
  $mysqld_exporter_user = 'mysqld-exporter'
  $mysqld_exporter_version = '0.9.0'
  $mongodb_exporter_cnf_uri = 'mongodb://localhost:27017'
  $mongodb_exporter_download_extension = 'tar.gz'
  $mongodb_exporter_download_url_base = 'https://github.com/percona/mongodb_exporter/releases'
  $mongodb_exporter_extra_groups = []
  $mongodb_exporter_group = 'mongodb-exporter'
  $mongodb_exporter_package_ensure = 'latest'
  $mongodb_exporter_package_name = 'mongodb_exporter'
  $mongodb_exporter_user = 'mongodb-exporter'
  $mongodb_exporter_version = '0.3.1'
  $node_exporter_download_extension = 'tar.gz'
  $node_exporter_download_url_base = 'https://github.com/prometheus/node_exporter/releases'
  $node_exporter_extra_groups = []
  $node_exporter_group = 'node-exporter'
  $node_exporter_package_ensure = 'latest'
  $node_exporter_package_name = 'node_exporter'
  $node_exporter_user = 'node-exporter'
  $node_exporter_version = '0.14.0'
  $beanstalkd_exporter_listen = ':9371'
  $beanstalkd_exporter_beanstalkd_address = '127.0.0.1:11300'
  $beanstalkd_exporter_download_extension = 'tar.gz'
  $beanstalkd_exporter_download_url_base = 'https://github.com/messagebird/beanstalkd_exporter/releases'
  $beanstalkd_exporter_extra_groups = []
  $beanstalkd_exporter_group = 'beanstalkd-exporter'
  $beanstalkd_exporter_package_ensure = 'latest'
  $beanstalkd_exporter_package_name = 'beanstalkd_exporter'
  $beanstalkd_exporter_user = 'beanstalkd-exporter'
  $beanstalkd_exporter_version = '1.0.0'
  $beanstalkd_exporter_mapping_config = '/etc/beanstalkd-exporter-mapping.conf'
  $beanstalkd_exporter_config = '/etc/beanstalkd-exporter.conf'
  $postgres_exporter_download_extension = 'tar.gz'
  $postgres_exporter_download_url_base = 'https://github.com/wrouesnel/postgres_exporter/releases'
  $postgres_exporter_extra_groups = []
  $postgres_exporter_group = 'postgres'
  $postgres_exporter_package_ensure = 'latest'
  $postgres_exporter_package_name = 'postgres_exporter'
  $postgres_exporter_user = 'postgres'
  $postgres_exporter_version = '0.4.1'
  $postgres_exporter_dsn = 'postgresql://localhost:5432/postgres'
  $package_ensure = 'latest'
  $package_name = 'prometheus'
  $rule_files = [ "${config_dir}/alert.rules" ]
  $scrape_configs = [ { 'job_name'=> 'prometheus', 'scrape_interval'=> '10s', 'scrape_timeout'=> '10s', 'static_configs'=> [ { 'targets'=> [ 'localhost:9090' ], 'labels'=> { 'alias'=> 'Prometheus'} } ] } ]
  $remote_read_configs = []
  $shared_dir = '/usr/local/share/prometheus'
  $statsd_exporter_download_extension = 'tar.gz'
  $statsd_exporter_download_url_base = 'https://github.com/prometheus/statsd_exporter/releases'
  $statsd_exporter_extra_groups = []
  $statsd_exporter_group = 'statsd-exporter'
  $statsd_exporter_mapping_config_path = '/etc/statsd_mappings.conf'
  $statsd_exporter_maps = [{'map' => 'test.dispatcher.*.*.*','name' =>'dispatcher_events_total','labels' => { 'processor'=>'$1', 'action'=>'$2', 'outcome'=>'$3', 'job'=>'test_dispatcher'}}]
  $statsd_exporter_package_ensure = 'latest'
  $statsd_exporter_package_name = 'statsd_exporter'
  $statsd_exporter_user = 'statsd-exporter'
  $statsd_exporter_version = '0.3.0'
  $blackbox_exporter_user = 'blackbox-exporter'
  $blackbox_exporter_group = 'blackbox-exporter'
  $blackbox_exporter_download_extension = 'tar.gz'
  $blackbox_exporter_download_url_base = 'https://github.com/prometheus/blackbox_exporter/releases'
  $blackbox_exporter_extra_groups = []
  $blackbox_exporter_package_ensure = 'latest'
  $blackbox_exporter_package_name = 'blackbox_exporter'
  $blackbox_exporter_modules = {}
  $blackbox_exporter_config_file = '/etc/blackbox-exporter.yaml'
  $blackbox_exporter_version = '0.7.0'
  $user = 'prometheus'
  $version = '1.5.2'
  case $::architecture {
    'x86_64', 'amd64': { $arch = 'amd64' }
    'i386':            { $arch = '386'   }
    default:           {
      fail("Unsupported kernel architecture: ${::architecture}")
    }
  }

  $os = downcase($::kernel)

  if $::operatingsystem == 'Ubuntu' {
    if versioncmp($::operatingsystemrelease, '8.04') < 1 {
      $init_style = 'debian'
    } elsif versioncmp($::operatingsystemrelease, '15.04') < 0 {
      $init_style = 'upstart'
    } else {
      $init_style = 'systemd'
    }
  } elsif $::operatingsystem =~ /Scientific|CentOS|RedHat|OracleLinux/ {
    if versioncmp($::operatingsystemrelease, '7.0') < 0 {
      $init_style = 'sysv'
    } else {
      $init_style  = 'systemd'
    }
  } elsif $::operatingsystem == 'Fedora' {
    if versioncmp($::operatingsystemrelease, '12') < 0 {
      $init_style = 'sysv'
    } else {
      $init_style = 'systemd'
    }
  } elsif $::operatingsystem == 'Debian' {
    if versioncmp($::operatingsystemrelease, '8.0') < 0 {
      $init_style = 'debian'
    } else {
      $init_style = 'systemd'
    }
  } elsif $::operatingsystem == 'Archlinux' {
    $init_style = 'systemd'
  } elsif $::operatingsystem == 'OpenSuSE' {
    $init_style = 'systemd'
  } elsif $::operatingsystem =~ /SLE[SD]/ {
    if versioncmp($::operatingsystemrelease, '12.0') < 0 {
      $init_style = 'sles'
    } else {
      $init_style = 'systemd'
    }
  } elsif $::operatingsystem == 'Darwin' {
    $init_style = 'launchd'
  } elsif $::operatingsystem == 'Amazon' {
    $init_style = 'sysv'
  } else {
    $init_style = undef
  }
  if $init_style == undef {
    fail('Unsupported OS')
  }
}
