require 'spec_helper'

describe 'prometheus::server' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      parameters = { version: '2.0.0-rc.1', bin_dir: '/usr/local/bin', install_method: 'url', init_style: 'systemd', configname: 'prometheus.yaml' }

      context "with parameters #{parameters}" do
        let(:params) do
          parameters
        end

        prom_version = parameters[:version] || '1.5.2'
        prom_major = prom_version[0]
        it { is_expected.to contain_class('systemd') }

        it {
          is_expected.to contain_systemd__unit_file('prometheus.service').with(
            'content' => File.read(fixtures('files', "prometheus#{prom_major}.systemd"))
          )
        }

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

        describe 'max_open_files' do
          context 'by default' do
            it {
              content = catalogue.resource('systemd::unit_file', 'prometheus.service').send(:parameters)[:content]
              expect(content).not_to include('LimitNOFILE')
            }
          end

          context 'when set to 1000000' do
            let(:params) do
              super().merge('max_open_files' => 1_000_000)
            end

            it {
              content = catalogue.resource('systemd::unit_file', 'prometheus.service').send(:parameters)[:content]
              expect(content).to include('LimitNOFILE=1000000')
            }
          end
        end
      end
    end
  end
end
