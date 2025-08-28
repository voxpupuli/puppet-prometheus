# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::haproxy_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'with version specified' do
        let(:params) do
          {
            version: '0.7.1',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url'
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/usr/local/bin/haproxy_exporter').with('target' => '/opt/haproxy_exporter-0.7.1.linux-amd64/haproxy_exporter') }
        it { is_expected.to contain_archive('/tmp/haproxy_exporter-0.7.1.tar.gz') }
        it { is_expected.to contain_class('prometheus') }
        it { is_expected.to contain_user('haproxy-user') }
        it { is_expected.to contain_group('haproxy-exporter') }
        it { is_expected.to contain_prometheus__daemon('haproxy_exporter') }
      end

      context 'with custom scraping uri' do
        let(:params) do
          {
            cnf_scrape_uri: 'unix:/var/haproxy/listen.sock',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url'
          }
        end

        scraping_uri = {
          http: 'http://host/stats',
          https: 'https://host/stats',
          socket: 'unix:/var/haproxy/listen.sock'
        }
        scraping_uri.each do |uri, value|
          context uri do
            let(:params) do
              super().merge(cnf_scrape_uri: value)
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_prometheus__daemon('haproxy_exporter').with('options' => "--haproxy.scrape-uri='#{value}'") }
          end
        end

        context 'bad format' do
          let(:params) do
            super().merge(cnf_scrape_uri: 'nosocket:/not/a/socket.format')
          end

          it { is_expected.to raise_error(Puppet::Error) }
        end
      end

      context 'with tls set in web-config.yml' do
        let(:params) do
          {
            web_config_content: {
              tls_server_config: {
                cert_file: '/etc/haproxy_exporter/foo.cert',
                key_file: '/etc/haproxy_exporter/foo.key'
              }
            }
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/haproxy_exporter_web-config.yml').with(ensure: 'file') }
        it { is_expected.to contain_prometheus__daemon('haproxy_exporter').with(options: '--haproxy.scrape-uri=\'http://localhost:1234/haproxy?stats;csv\' --web.config.file=/etc/haproxy_exporter_web-config.yml') }
      end
    end
  end
end
