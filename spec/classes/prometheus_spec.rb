require 'spec_helper'

describe 'prometheus' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      [{ manage_prometheus_server: true, version: '2.0.0-rc.1', bin_dir: '/usr/local/bin', install_method: 'url', rule_files: ['/etc/prometheus/rules.d/*.rules'] }].each do |parameters|
        context "with parameters #{parameters}" do
          let(:params) do
            parameters
          end

          # prometheus::install
          dbpath = case facts[:os]['family']
                   when 'FreeBSD'
                     '/var/db/prometheus'
                   else
                     '/var/lib/prometheus'
                   end
          it {
            is_expected.to contain_file(dbpath).with(
              'ensure' => 'directory',
              'owner'  => 'prometheus',
              'group'  => 'prometheus',
              'mode'   => '0755'
            )
          }

          prom_version = parameters[:version] || '1.5.2'
          prom_major = prom_version[0]
          prom_os = facts[:kernel].downcase
          prom_arch = facts[:architecture] == 'i386' ? '386' : 'amd64'

          it {
            is_expected.to contain_archive("/tmp/prometheus-#{prom_version}.tar.gz").with(
              'ensure' => 'present',
              'extract' => true,
              'extract_path' => '/opt',
              'source' => "https://github.com/prometheus/prometheus/releases/download/v#{prom_version}/prometheus-#{prom_version}.#{prom_os}-#{prom_arch}.tar.gz",
              'checksum_verify' => false,
              'creates' => "/opt/prometheus-#{prom_version}.#{prom_os}-#{prom_arch}/prometheus",
              'cleanup' => true
            ).that_comes_before("File[/opt/prometheus-#{prom_version}.#{prom_os}-#{prom_arch}/prometheus]")
          }

          it {
            is_expected.to contain_file("/opt/prometheus-#{prom_version}.#{prom_os}-#{prom_arch}/prometheus").with(
              'owner'  => 'root',
              'group'  => 0,
              'mode'   => '0555'
            )
          }

          it {
            is_expected.to contain_file('/usr/local/bin/prometheus').with(
              'ensure' => 'link',
              'target' => "/opt/prometheus-#{prom_version}.#{prom_os}-#{prom_arch}/prometheus"
            ).that_notifies('Service[prometheus]')
          }

          it {
            is_expected.to contain_file('/usr/local/share/prometheus').with(
              'ensure'  => 'directory',
              'owner'   => 'prometheus',
              'group'   => 'prometheus',
              'mode'    => '0755'
            )
          }

          it {
            is_expected.to contain_file('/usr/local/share/prometheus/consoles').with(
              'ensure' => 'link',
              'target' => "/opt/prometheus-#{prom_version}.#{prom_os}-#{prom_arch}/consoles"
            ).that_notifies('Service[prometheus]')
          }

          it {
            is_expected.to contain_file('/usr/local/share/prometheus/console_libraries').with(
              'ensure' => 'link',
              'target' => "/opt/prometheus-#{prom_version}.#{prom_os}-#{prom_arch}/console_libraries"
            ).that_notifies('Service[prometheus]')
          }

          it {
            is_expected.to contain_user('prometheus').with(
              'ensure' => 'present',
              'system' => true,
              'groups' => []
            )
          }

          it {
            is_expected.to contain_group('prometheus').with(
              'ensure' => 'present',
              'system' => true
            )
          }

          # prometheus::config
          if ['debian-7-x86_64'].include?(os)
            # init_style = 'debian'

            it {
              is_expected.to contain_file('/etc/init.d/prometheus').with(
                'mode'   => '0555',
                'owner'  => 'root',
                'group'  => 'root',
                'content' => File.read(fixtures('files', "prometheus#{prom_major}.debian"))
              )
            }
          elsif ['centos-6-x86_64', 'redhat-6-x86_64'].include?(os)
            # init_style = 'sysv'

            it {
              is_expected.to contain_file('/etc/init.d/prometheus').with(
                'mode'   => '0555',
                'owner'  => 'root',
                'group'  => 'root',
                'content' => File.read(fixtures('files', "prometheus#{prom_major}.sysv"))
              )
            }
          elsif ['centos-7-x86_64', 'debian-8-x86_64', 'debian-9-x86_64', 'redhat-7-x86_64', 'ubuntu-16.04-x86_64', 'ubuntu-18.04-x86_64', 'archlinux-4-x86_64'].include?(os)
            # init_style = 'systemd'

            it { is_expected.to contain_class('systemd') }

            it {
              is_expected.to contain_systemd__unit_file('prometheus.service').with(
                'content' => File.read(fixtures('files', "prometheus#{prom_major}.systemd"))
              )
            }
          elsif ['ubuntu-14.04-x86_64'].include?(os)
            # init_style = 'upstart'

            it {
              is_expected.to contain_file('/etc/init/prometheus.conf').with(
                'mode'    => '0444',
                'owner'   => 'root',
                'group'   => 'root',
                'content' => File.read(fixtures('files', "prometheus#{prom_major}.upstart"))
              )
            }

            it {
              is_expected.to contain_file('/etc/init.d/prometheus').with(
                'ensure' => 'link',
                'target' => '/lib/init/upstart-job',
                'owner' => 'root',
                'group' => 'root',
                'mode'  => '0755'
              )
            }
          elsif ['freebsd-10-amd64', 'freebsd-11-amd64', 'freebsd-12-amd64'].include?(os)
            it {
              is_expected.to contain_file('/usr/local/etc/rc.d/prometheus')
            }
          else
            it {
              is_expected.to raise_error(Puppet::Error, %r{I don't know how to create an init script for style})
            }
          end

          unless facts[:os]['family'] == 'FreeBSD'
            it {
              is_expected.to contain_file('/etc/prometheus').with(
                'ensure'  => 'directory',
                'owner'   => 'prometheus',
                'group'   => 'prometheus',
                'purge'   => true,
                'recurse' => true
              )
            }

            it {
              is_expected.to contain_file('prometheus.yaml').with(
                'ensure'  => 'present',
                'path'    => '/etc/prometheus/prometheus.yaml',
                'owner'   => 'prometheus',
                'group'   => 'prometheus',
                'mode'    => '0660',
                'content' => File.read(fixtures('files', "prometheus#{prom_major}.yaml"))
              ).that_notifies('Class[prometheus::run_service]')
            }
          end

          # prometheus::alerts
          it {
            is_expected.not_to contain_file('/etc/prometheus/alert.rules')
          }

          # prometheus::run_service
          it {
            is_expected.to contain_service('prometheus').with(
              'ensure'     => 'running',
              'name'       => 'prometheus',
              'enable'     => true
            )
          }

          # prometheus::service_reload
          it {
            is_expected.to contain_exec('prometheus-reload').with(
              # 'command'     => 'systemctl reload prometheus',
              'path'        => ['/usr/bin', '/bin', '/usr/sbin', '/sbin'],
              'refreshonly' => true
            )
          }
        end
      end

      context 'with alerts configured', alerts: true do
        [
          {
            manage_prometheus_server: true,
            version: '1.5.3',
            alerts: [{
              'name'         => 'alert_name',
              'condition'    => 'up == 0',
              'timeduration' => '5min',
              'labels'       => [{ 'name' => 'severity', 'content' => 'woops' }],
              'annotations'  => [{ 'name' => 'summary', 'content' => 'did a woops {{ $labels.instance }}' }]
            }]
          },
          {
            manage_prometheus_server: true,
            version: '2.0.0-rc.1',
            alerts: {
              'groups' => [{
                'name' => 'alert.rules',
                rules: [
                  {
                    'alert'       => 'alert_name',
                    'expr'        => 'up == 0',
                    'for'         => '5min',
                    'labels'      => { 'severity' => 'woops' },
                    'annotations' => {
                      'summary' => 'did a woops {{ $labels.instance }}'
                    }
                  }
                ]
              }]
            }
          }
        ].each do |parameters|
          context "with prometheus version #{parameters[:version]}" do
            let(:params) do
              parameters
            end

            prom_version = parameters[:version]
            prom_major = prom_version[0]

            path = case facts[:os]['family']
                   when 'FreeBSD'
                     '/usr/local/etc/alert.rules'
                   else
                     '/etc/prometheus/alert.rules'
                   end
            it {
              is_expected.to compile
            }
            it {
              is_expected.to contain_file(path).with(
                'ensure'  => 'file',
                'owner'   => 'prometheus',
                'group'   => 'prometheus',
                'content' => File.read(fixtures('files', "prometheus#{prom_major}.alert.rules"))
              ).that_notifies('Class[prometheus::service_reload]')
            }
          end
        end
      end

      context 'with remote write configured' do
        [
          {
            manage_prometheus_server: true,
            version: '2.0.0-rc.1',
            remote_write_configs: [
              'url' => 'http://domain.tld/path'
            ]
          }
        ].each do |parameters|
          context "with prometheus version #{parameters[:version]}" do
            let(:params) do
              parameters
            end

            path = case facts[:os]['family']
                   when 'FreeBSD'
                     '/usr/local/etc/prometheus.yml'
                   else
                     '/etc/prometheus/prometheus.yaml'
                   end
            it {
              is_expected.to compile
            }
            it {
              is_expected.to contain_file('prometheus.yaml').with(
                'ensure'  => 'present',
                'path'    => path,
                'owner'   => 'prometheus',
                'group'   => 'prometheus',
                'content' => %r{http://domain.tld/path}
              )
            }
          end
        end
      end

      context 'with manage_config => false' do
        [
          {
            version: '1.5.3',
            manage_config: false
          },
          {
            version: '2.0.0-rc.1',
            manage_config: false
          }
        ].each do |parameters|
          context "with prometheus verions #{parameters[:version]}" do
            let(:params) do
              parameters
            end

            it {
              is_expected.not_to contain_file('/etc/prometheus/prometheus.yaml')
            }
          end
        end
      end
    end
  end
end
