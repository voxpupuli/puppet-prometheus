# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::daemon' do
  let :title do
    'smurf_exporter'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      let :pre_condition do
        'include prometheus'
      end

      [
        {
          version: '1.2.3',
          real_download_url: 'https://github.com/prometheus/smurf_exporter/releases/v1.2.3/smurf_exporter-1.2.3.any.tar.gz',
          notify_service: ResourceReference.new('Service[smurf_exporter]'),
          user: 'smurf_user',
          group: 'smurf_group',
          env_vars: { SOMEVAR: 42 },
          bin_dir: '/usr/local/bin',
          install_method: 'url',
          export_scrape_job: true,
          scrape_host: 'localhost',
          scrape_port: 1234
        }
      ].each do |parameters|
        context "with parameters #{parameters}" do
          let(:params) do
            parameters
          end

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('prometheus') }

          prom_os = facts[:kernel].downcase
          prom_arch = facts[:architecture] == 'i386' ? '386' : 'amd64'

          it {
            expect(subject).to contain_archive("/tmp/smurf_exporter-#{parameters[:version]}.tar.gz").with(
              'ensure' => 'present',
              'extract' => true,
              'extract_path' => '/opt',
              'source' => params[:real_download_url],
              'checksum_verify' => false,
              'creates' => "/opt/smurf_exporter-#{parameters[:version]}.#{prom_os}-#{prom_arch}/smurf_exporter",
              'cleanup' => true
            ).that_comes_before("File[/opt/smurf_exporter-#{parameters[:version]}.#{prom_os}-#{prom_arch}/smurf_exporter]")
          }

          it {
            expect(subject).to contain_file("/opt/smurf_exporter-#{parameters[:version]}.#{prom_os}-#{prom_arch}/smurf_exporter").with(
              'owner' => 'root',
              'group' => 0,
              'mode' => '0555'
            )
          }

          it {
            expect(subject).to contain_file('/usr/local/bin/smurf_exporter').with(
              'ensure' => 'link',
              'target' => "/opt/smurf_exporter-#{parameters[:version]}.#{prom_os}-#{prom_arch}/smurf_exporter"
            ).that_notifies('Service[smurf_exporter]')
          }

          it {
            expect(subject).to contain_user('smurf_user').with(
              'ensure' => 'present',
              'system' => true,
              'groups' => []
            )
          }

          it {
            expect(subject).to contain_group('smurf_group').with(
              'ensure' => 'present',
              'system' => true
            )
          }

          context 'with overidden extract_path' do
            let(:params) do
              parameters.merge(extract_path: '/opt/foo')
            end

            it { is_expected.to contain_archive("/tmp/smurf_exporter-#{parameters[:version]}.tar.gz").with_extract_path('/opt/foo') }
          end

          it { is_expected.to contain_class('systemd') }

          it {
            expect(subject).to contain_systemd__unit_file('smurf_exporter.service').that_notifies(
              'Service[smurf_exporter]'
            ).with_content(
              %r{User=smurf_user\n}
            ).with_content(
              %r{ExecStart=/usr/local/bin/smurf_exporter \nExecReload=}
            )
          }

          context 'with overidden bin_name' do
            let(:params) do
              super().merge(bin_name: 'notsmurf_exporter')
            end

            it {
              expect(subject).to contain_systemd__unit_file('smurf_exporter.service').with_content(
                %r{ExecStart=/usr/local/bin/notsmurf_exporter}
              )
            }
          end

          context 'with options' do
            let(:params) do
              super().merge(options: '--foo bar')
            end

            it {
              expect(subject).to contain_systemd__unit_file('smurf_exporter.service').with_content(
                %r{ExecStart=/usr/local/bin/smurf_exporter --foo bar}
              )
            }
          end

          if os == 'ubuntu-16.04-x86_64'
            it {
              expect(subject).to contain_file('/etc/default/smurf_exporter').with(
                'mode' => '0644',
                'owner' => 'root',
                'group' => '0'
              ).with_content(
                %r{SOMEVAR="42"\n}
              )
            }
          end

          it {
            expect(subject).to contain_service('smurf_exporter').with(
              'ensure' => 'running',
              'name' => 'smurf_exporter',
              'enable' => true
            )
          }

          context 'exported resources' do
            subject { exported_resources }

            it {
              expect(subject).to contain_prometheus__scrape_job('smurf_exporter_localhost_1234').with(
                'labels' => {
                  'alias' => 'localhost'
                }
              )
            }
          end
        end
      end

      context 'with scrape_job_labels specified' do
        let(:params) do
          {
            version: '1.2.3',
            real_download_url: 'https://github.com/prometheus/smurf_exporter/releases/v1.2.3/smurf_exporter-1.2.3.any.tar.gz',
            notify_service: ResourceReference.new('Service[smurf_exporter]'),
            user: 'smurf_user',
            group: 'smurf_group',
            env_vars: { SOMEVAR: 42 },
            bin_dir: '/usr/local/bin',
            install_method: 'url',
            export_scrape_job: true,
            scrape_host: 'localhost',
            scrape_port: 1234,
            scrape_job_labels: { 'instance' => 'smurf1' }
          }
        end

        context 'exported resources' do
          subject { exported_resources }

          it {
            expect(subject).to contain_prometheus__scrape_job('smurf_exporter_localhost_1234').with(
              'labels' => {
                'instance' => 'smurf1'
              }
            )
          }
        end
      end
    end
  end
end
