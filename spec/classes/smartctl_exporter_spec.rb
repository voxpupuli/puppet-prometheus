# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::smartctl_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'with version specified' do
        let(:params) do
          {
            version: '0.12.0',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url',
          }
        end

        describe 'with all defaults' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('/usr/local/bin/smartctl_exporter').with('target' => '/opt/smartctl_exporter-0.12.0.linux-amd64/smartctl_exporter') }
          it { is_expected.to contain_prometheus__daemon('smartctl_exporter') }
          it { is_expected.to contain_user('root') }
          it { is_expected.to contain_group('root') }
          it { is_expected.to contain_service('smartctl_exporter') }
        end

        context 'with tls set in web-config.yml' do
          let(:params) do
            super().merge(
              web_config_content: {
                tls_server_config: {
                  cert_file: '/etc/smartctl_exporter/foo.cert',
                  key_file: '/etc/smartctl_exporter/foo.key'
                }
              }
            )
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('/etc/smartctl_exporter_web-config.yml').with(ensure: 'file') }
          it { is_expected.to contain_prometheus__daemon('smartctl_exporter').with(options: '--web.config.file=/etc/smartctl_exporter_web-config.yml') }
        end
      end
    end
  end
end
