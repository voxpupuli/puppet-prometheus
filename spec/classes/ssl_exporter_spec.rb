require 'spec_helper'

describe 'prometheus::ssl_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'with version specified' do
        let(:params) do
          {
            version: '2.2.1',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url',
            modules: {
              'https' => {
                'prober'  => 'https',
                'timeout' => '5s',
              },
            }
          }
        end

        describe 'with all defaults' do
          it { is_expected.to contain_class('prometheus') }
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('/usr/local/bin/ssl_exporter').with('target' => '/opt/ssl_exporter-2.2.1.linux-amd64/ssl_exporter') }
          it { is_expected.to contain_prometheus__daemon('ssl_exporter') }
          it { is_expected.to contain_user('ssl-exporter') }
          it { is_expected.to contain_group('ssl-exporter') }
          it { is_expected.to contain_service('ssl_exporter') }
          it { is_expected.to contain_archive('/tmp/ssl_exporter-2.2.1.tar.gz') }
          it { is_expected.to contain_file('/opt/ssl_exporter-2.2.1.linux-amd64/ssl_exporter') }
          it {
            is_expected.to contain_file('/etc/ssl_exporter.yaml')
            verify_contents(catalogue, '/etc/ssl_exporter.yaml', ['---', 'modules:', '  https:', '    prober: https', '    timeout: 5s'])
          }
        end
      end
    end
  end
end
