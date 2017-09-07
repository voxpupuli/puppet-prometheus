# puppet-prometheus
[![Puppet Forge](https://img.shields.io/puppetforge/e/puppet/prometheus.svg)](https://forge.puppetlabs.com/puppet/prometheus)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/prometheus.svg)](https://forge.puppetlabs.com/puppet/prometheus)
[![Puppet Forge](https://img.shields.io/puppetforge/f/puppet/prometheus.svg)](https://forge.puppetlabs.com/puppet/prometheus)

## Compatibility

| Prometheus Version  | Recommended Puppet Module Version   |
| ----------------    | ----------------------------------- |
| >= 0.16.2           | latest                              |


## Background

This module automates the install and configuration of Prometheus monitoring tool: [Prometheus web site](https://prometheus.io/docs/introduction/overview/)

### What This Module Affects

* Installs the prometheus daemon, alertmanager or exporters(via url or package)
  * The package method was implemented, but currently there isn't any package for prometheus
* Optionally installs a user to run it under (per exporter)
* Installs a configuration file for prometheus daemon (/etc/prometheus/prometheus.yaml) or for alertmanager (/etc/prometheus/alert.rules)
* Manages the services via upstart, sysv, or systemd
* Optionally creates alert rules
* The following exporters are currently implemented: node_exporter, statsd_exporter, process_exporter, haproxy_exporter, mysqld_exporter

## Usage

To set up a prometheus daemon:
On the server (for prometheus version < 1.0.0):

```puppet
class { '::prometheus':
  global_config  => { 'scrape_interval'=> '15s', 'evaluation_interval'=> '15s', 'external_labels'=> { 'monitor'=>'master'}},
  rule_files     => [ "/etc/prometheus/alert.rules" ],
  scrape_configs => [ { 'job_name'=> 'prometheus', 'scrape_interval'=> '10s', 'scrape_timeout'=> '10s', 'target_groups'=> [ { 'targets'=> [ 'localhost:9090' ], 'labels'=> { 'alias'=> 'Prometheus'} } ] } ]
}
```

On the server (for prometheus version >= 1.0.0):

```puppet
class { 'prometheus':
    version => '1.0.0',
    scrape_configs => [ {'job_name'=>'prometheus','scrape_interval'=> '30s','scrape_timeout'=>'30s','static_configs'=> [{'targets'=>['localhost:9090'], 'labels'=> { 'alias'=>'Prometheus'}}]}],
    extra_options => '-alertmanager.url http://localhost:9093 -web.console.templates=/opt/prometheus-1.0.0.linux-amd64/consoles -web.console.libraries=/opt/prometheus-1.0.0.linux-amd64/console_libraries',
    localstorage => '/prometheus/prometheus',
}
```

or simply:
```puppet
include ::prometheus
```

To add alert rules, add the following to the class prometheus:
```puppet
    alerts => [{ 'name' => 'InstanceDown', 'condition' => 'up == 0', 'timeduration' => '5m', labels => [{ 'name' => 'severity', 'content' => 'page'}], 'annotations' => [{ 'name' => 'summary', content => 'Instance {{ $labels.instance }} down'}, {'name' => 'description', content => '{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes.' }]}]
```

or in hiera:
```yaml
alertrules:
    -
        name: 'InstanceDown'
        condition:  'up == 0'
        timeduration: '5m'
        labels:
            -
                name: 'severity'
                content: 'critical'
        annotations:
            -
                name: 'summary'
                content: 'Instance {{ $labels.instance }} down'
            -
                name: 'description'
                content: '{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes.'

```

On the monitored nodes:

```puppet
class { '::prometheus::node_exporter':
  collectors => ['diskstats','filesystem','loadavg','meminfo','netdev','stat','time']
}
```

or:

```puppet
class { 'prometheus::node_exporter':
    version => '0.12.0',
    collectors => ['diskstats','filesystem','loadavg','meminfo','logind','netdev','netstat','stat','time','interrupts','ntp','tcpstat'],
    extra_options => '-collector.ntp.server ntp1.orange.intra',
}
```

or simply:
```puppet
include ::prometheus::node_exporter
```

For more information regarding class parameters please take a look at class docstring.

## Limitations/Known issues

In version 0.1.14 of this module the alertmanager was configured to run as the service `alert_manager`. This has been changed in version 0.2.00 to be `alertmanager`.

Do not use version 1.0.0 of Prometheus: https://groups.google.com/forum/#!topic/prometheus-developers/vuSIxxUDff8 ; it does break the compatibility with thus module!

Even if the module has templates for several linux distributions, only RH family distributions were tested.

