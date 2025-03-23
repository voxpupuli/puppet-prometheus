# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::apache_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end
      let(:version) { catalogue.resource('Class[prometheus::apache_exporter]').parameters[:version] }

      context 'with all defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_systemd__unit_file('apache_exporter.service') }
        it { is_expected.not_to contain_package('apache-exporter') }
        it { is_expected.to contain_archive("/tmp/apache_exporter-#{version}.tar.gz") }
        it { is_expected.to contain_file("/opt/apache_exporter-#{version}.linux-amd64/apache_exporter") }
      end

      context 'with some params' do
        let(:params) do
          {
            version: '1.0.0',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url'
          }
        end

        describe 'with specific params' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_archive('/tmp/apache_exporter-1.0.0.tar.gz') }
          it { is_expected.to contain_file('/opt/apache_exporter-1.0.0.linux-amd64/apache_exporter') }
          it { is_expected.to contain_class('prometheus') }
          it { is_expected.to contain_group('apache-exporter') }
          it { is_expected.to contain_user('apache-exporter') }
          it { is_expected.to contain_prometheus__daemon('apache_exporter').with('options' => "--scrape_uri 'http://localhost/server-status/?auto'") }
          it { is_expected.to contain_service('apache_exporter') }
        end

        describe 'install correct binary' do
          it { is_expected.to contain_file('/usr/local/bin/apache_exporter').with('target' => '/opt/apache_exporter-1.0.0.linux-amd64/apache_exporter') }
        end
      end

      context 'with version < 1.0.0' do
        let(:params) do
          {
            version: '0.13.4',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url'
          }
        end

        describe 'it should fail' do
          it { is_expected.to compile.and_raise_error(%r{Version 0.13.4 is not supported}) }
        end
      end

      context 'with version, scrape_uri and extra options specified' do
        let(:params) do
          {
            scrape_uri: 'http://127.0.0.1/server-status/?auto',
            extra_options: '--test',
            version: '1.0.7',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url'
          }
        end

        describe 'with specific params' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_archive('/tmp/apache_exporter-1.0.7.tar.gz') }
          it { is_expected.to contain_file('/opt/apache_exporter-1.0.7.linux-amd64/apache_exporter') }
          it { is_expected.to contain_class('prometheus') }
          it { is_expected.to contain_group('apache-exporter') }
          it { is_expected.to contain_user('apache-exporter') }
          it { is_expected.to contain_prometheus__daemon('apache_exporter').with('options' => "--scrape_uri 'http://127.0.0.1/server-status/?auto' --test") }
          it { is_expected.to contain_service('apache_exporter') }
        end

        describe 'install correct binary' do
          it { is_expected.to contain_file('/usr/local/bin/apache_exporter').with('target' => '/opt/apache_exporter-1.0.7.linux-amd64/apache_exporter') }
        end
      end

      context 'with tls set in web-config.yml' do
        let(:params) do
          {
            web_config_content: {
              tls_server_config: {
                cert_file: '/etc/apache_exporter/foo.cert',
                key_file: '/etc/apache_exporter/foo.key'
              }
            }
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/apache_exporter_web-config.yml').with(ensure: 'file') }

        it { is_expected.to contain_prometheus__daemon('apache_exporter').with(options: "--scrape_uri 'http://localhost/server-status/?auto' --web.config.file=/etc/apache_exporter_web-config.yml") }
      end
    end
  end
end
