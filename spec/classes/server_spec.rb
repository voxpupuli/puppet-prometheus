# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::server' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      parameters = { version: '2.52.0', bin_dir: '/usr/local/bin', install_method: 'url', init_style: 'systemd', configname: 'prometheus.yaml' }

      context "with parameters #{parameters}" do
        let(:params) do
          parameters
        end

        prom_version = parameters[:version] || '1.5.2'
        prom_major = prom_version[0]
        context 'on non Archlinux', if: facts[:os]['name'] != 'Archlinux' do
          it { is_expected.to contain_class('systemd') }

          it {
            expect(subject).to contain_systemd__unit_file('prometheus.service').with(
              'content' => File.read(File.join('spec', 'fixtures', 'files', "prometheus#{prom_major}.systemd"))
            )
          }
        end

        it {
          content = catalogue.resource('file', 'prometheus.yaml').send(:parameters)[:content]
          expect(content).to include('job_name: prometheus')
        }

        context 'without default scrape configs' do
          let(:params) do
            super().merge('include_default_scrape_configs' => false)
          end

          it {
            content = catalogue.resource('file', 'prometheus.yaml').send(:parameters)[:content]
            expect(content).not_to include('job_name: prometheus')
          }
        end

        describe 'scrape_config_files' do
          context 'by default' do
            it {
              content = catalogue.resource('file', 'prometheus.yaml').send(:parameters)[:content]
              expect(content).not_to include('scrape_config_files:')
            }
          end

          context 'when set with a glob' do
            let(:params) do
              super().merge(scrape_config_files: ['/etc/prometheus/scrape_configs.d/*.yaml'])
            end

            it {
              content = catalogue.resource('file', 'prometheus.yaml').send(:parameters)[:content]
              expect(content).to include('scrape_config_files:')
              expect(content).to include('- "/etc/prometheus/scrape_configs.d/*.yaml"')
            }
          end
        end

        describe 'max_open_files', if: facts[:os]['name'] != 'Archlinux' do
          context 'by default' do
            it {
              content = catalogue.resource('systemd::unit_file', 'prometheus.service').send(:parameters)[:content]
              expect(content).not_to include('LimitNOFILE')
            }
          end

          context 'when set to 1000000', if: facts[:os]['name'] != 'Archlinux' do
            let(:params) do
              super().merge('max_open_files' => 1_000_000)
            end

            it {
              content = catalogue.resource('systemd::unit_file', 'prometheus.service').send(:parameters)[:content]
              expect(content).to include('LimitNOFILE=1000000')
            }
          end
        end

        describe 'tsdb-disabled', if: facts[:os]['name'] != 'Archlinux' do
          context 'by default' do
            it {
              content = catalogue.resource('systemd::unit_file', 'prometheus.service').send(:parameters)[:content]
              expect(content).to include('storage.tsdb.path')
              expect(content).to include('storage.tsdb.retention')
            }
          end

          context 'when retention set to false', if: facts[:os]['name'] != 'Archlinux' do
            let(:params) do
              super().merge('storage_retention' => false)
            end

            it {
              content = catalogue.resource('systemd::unit_file', 'prometheus.service').send(:parameters)[:content]
              expect(content).not_to include('storage.tsdb.retention')
            }
          end

          context 'when storage path set to false', if: facts[:os]['name'] != 'Archlinux' do
            let(:params) do
              super().merge('localstorage' => false)
            end

            it {
              content = catalogue.resource('systemd::unit_file', 'prometheus.service').send(:parameters)[:content]
              expect(content).not_to include('storage.tsdb.path')
            }
          end
        end
      end
    end
  end
end
