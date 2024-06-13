# puppet-prometheus

[![Build Status](https://travis-ci.org/voxpupuli/puppet-prometheus.svg?branch=master)](https://travis-ci.org/voxpupuli/puppet-prometheus)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/prometheus.svg)](https://forge.puppetlabs.com/puppet/prometheus)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/prometheus.svg)](https://forge.puppetlabs.com/puppet/prometheus)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/prometheus.svg)](https://forge.puppetlabs.com/puppet/prometheus)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/prometheus.svg)](https://forge.puppetlabs.com/puppet/prometheus)
[![Apache-2 License](https://img.shields.io/github/license/voxpupuli/puppet-prometheus.svg)](LICENSE)

## Table of Contents

- [puppet-prometheus](#puppet-prometheus)
  - [Table of Contents](#table-of-contents)
  - [Compatibility](#compatibility)
  - [Background](#background)
    - [What This Module Affects](#what-this-module-affects)
    - [Example Usage](#example-usage)
    - [Monitored Nodes](#monitored-nodes)
  - [Example](#example)
  - [Known issues](#known-issues)
  - [Development](#development)
    - [Component versions](#component-versions)
  - [Transfer Notice](#transfer-notice)

----

## Compatibility

This module supports below Prometheus architectures:
- x86_64/amd64
- i386
- armv71 (Tested on raspberry pi 3)

The `prometheus::ipmi_exporter` class has a dependency on [saz/sudo](https://forge.puppet.com/modules/saz/sudo) Puppet module.

## Background

This module automates the install and configuration of Prometheus monitoring tool: [Prometheus web site](https://prometheus.io/docs/introduction/overview/)

### What This Module Affects

* Installs the prometheus daemon, alertmanager or exporters(via url or package)
  * The package method was implemented, but currently there isn't any package for prometheus
* Optionally installs a user to run it under (per exporter)
* Installs a configuration file for prometheus daemon (/etc/prometheus/prometheus.yaml) or for alertmanager (/etc/prometheus/alert.rules)
* Manages the services via upstart, sysv, or systemd
* Optionally creates alert rules

### Example Usage

```puppet
class { 'prometheus::server':
  version        => '2.52.0',
  alerts         => {
    'groups' => [
      {
        'name'  => 'alert.rules',
        'rules' => [
          {
            'alert'       => 'InstanceDown',
            'expr'        => 'up == 0',
            'for'         => '5m',
            'labels'      => {
              'severity' => 'page',
            },
            'annotations' => {
              'summary'     => 'Instance {{ $labels.instance }} down',
              'description' => '{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes.'
            }
          },
        ],
      },
    ],
  },
  scrape_configs => [
    {
      'job_name'        => 'prometheus',
      'scrape_interval' => '10s',
      'scrape_timeout'  => '10s',
      'static_configs'  => [
        {
          'targets' => [ 'localhost:9090' ],
          'labels'  => {
            'alias' => 'Prometheus',
          }
        }
      ],
    },
  ],
}
```


### Monitored Nodes

```puppet
include prometheus::node_exporter
```

or:

```puppet
class { 'prometheus::node_exporter':
  version            => '0.27.0',
  collectors_disable => ['loadavg', 'mdadm'],
}
```


## Example

Real Prometheus >=2.0.0 setup example including alertmanager and slack_configs.

```puppet
class { 'prometheus':
  manage_prometheus_server => true,
  version                  => '2.52.0',
  alerts                   => {
    'groups' => [
      {
        'name'  => 'alert.rules',
        'rules' => [
          {
            'alert'       => 'InstanceDown',
            'expr'        => 'up == 0',
            'for'         => '5m',
            'labels'      => {'severity' => 'page'},
            'annotations' => {
              'summary'     => 'Instance {{ $labels.instance }} down',
              'description' => '{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes.'
            },
          },
        ],
      },
    ],
  },
  scrape_configs           => [
    {
      'job_name'        => 'prometheus',
      'scrape_interval' => '10s',
      'scrape_timeout'  => '10s',
      'static_configs'  => [
        {
          'targets' => ['localhost:9090'],
          'labels'  => {'alias' => 'Prometheus'}
        }
      ],
    },
    {
      'job_name'        => 'node',
      'scrape_interval' => '5s',
      'scrape_timeout'  => '5s',
      'static_configs'  => [
        {
          'targets' => ['nodexporter.domain.com:9100'],
          'labels'  => {'alias' => 'Node'}
        },
      ],
    },
  ],
  alertmanagers_config     => [
    {
      'static_configs' => [{'targets' => ['localhost:9093']}],
    },
  ],
}

class { 'prometheus::alertmanager':
  version   => '0.27.0',
  route     => {
    'group_by'        => ['alertname', 'cluster', 'service'],
    'group_wait'      => '30s',
    'group_interval'  => '5m',
    'repeat_interval' => '3h',
    'receiver'        => 'slack',
  },
  receivers => [
    {
      'name'          => 'slack',
      'slack_configs' => [
        {
          'api_url'       => 'https://hooks.slack.com/services/ABCDEFG123456',
          'channel'       => '#channel',
          'send_resolved' => true,
          'username'      => 'username'
        },
      ],
    },
  ],
}
```

And if you want to use Hiera to declare the values instead, you can simply include the `prometheus` class and set your Hiera data as shown below:

**Puppet Code**
```puppet
include prometheus
```

**Hiera Data (in yaml)**
```yaml
---
prometheus::manage_prometheus_server: true

prometheus::version: '2.52.0'

prometheus::alerts:
  groups:
    - name: 'alert.rules'
      rules:
        - alert: 'InstanceDown'
          expr: 'up == 0'
          for: '5m'
          labels:
            severity: 'page'
          annotations:
            summary: 'Instance {{ $labels.instance }} down'
            description: '{{ $labels.instance }} of job {{ $labels.job }} has been
              down for more than 5 minutes.'

prometheus::scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: '10s'
    scrape_timeout: '10s'
    static_configs:
      - targets:
          - 'localhost:9090'
        labels:
          alias: 'Prometheus'
  - job_name: 'node'
    scrape_interval: '10s'
    scrape_timeout: '10s'
    static_configs:
      - targets:
          - 'nodexporter.domain.com:9100'
        labels:
          alias: 'Node'

prometheus::alertmanagers_config:
  - static_configs:
      - targets:
          - 'localhost:9093'

prometheus::alertmanager::version: '0.27.0'

prometheus::alertmanager::route:
  group_by:
    - 'alertname'
    - 'cluster'
    - 'service'
  group_wait: '30s'
  group_interval: '5m'
  repeat_interval: '3h'
  receiver: 'slack'

prometheus::alertmanager::receivers:
  - name: 'slack'
    slack_configs:
      - api_url: 'https://hooks.slack.com/services/ABCDEFG123456'
        channel: "#channel"
        send_resolved: true
        username: 'username'
```

## Known issues

Postfix is not supported on Archlinux because it relies on puppet-postfix, which does not support Archlinux.

## Development

See https://voxpupuli.org/docs/how_to_run_tests/ for information on how to run test locally.

### Component versions

For this repository a renovate github action is enabled. It will create PRs for updating the versions of the components. Each version defintion (in data/defaults.yaml or in the manifests directly) has a comment in the form of `# renovate: depName=<github-repo-slug>` which is used by renovate to identify the components to update. If new components (usually exporters) are added, please ensure to add the comment to the version definition.
The PRs created by renovate have to be classified on a case-by-case basis by the reiviewer. Most of these PRs should be simple einhancements, but some might require more attention and be classiefied as backward-incompatible.

## Transfer Notice
This plugin was originally authored by [brutus333](https://github.com/brutus333/)
