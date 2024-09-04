# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::elasticsearch_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'with version specified' do
        let(:params) do
          {
            version: '1.7.0',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url'
          }
        end

        describe 'compile manifest' do
          it { is_expected.to compile.with_all_deps }
        end

        describe 'install correct binary' do
          it { is_expected.to contain_file('/usr/local/bin/elasticsearch_exporter').with('target' => '/opt/elasticsearch_exporter-1.7.0.linux-amd64/elasticsearch_exporter') }
        end

        context 'with tls set in web-config.yml' do
          let(:params) do
            super().merge(
              web_config_content: {
                tls_server_config: {
                  cert_file: '/etc/elasticsearch_exporter/foo.cert',
                  key_file: '/etc/elasticsearch_exporter/foo.key'
                }
              }
            )
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('/etc/elasticsearch_exporter_web-config.yml').with(ensure: 'file') }
          it { is_expected.to contain_prometheus__daemon('elasticsearch_exporter').with(options: '--es.uri=http://localhost:9200 --es.timeout=5s --web.config.file=/etc/elasticsearch_exporter_web-config.yml') }
        end
      end
    end
  end
end
