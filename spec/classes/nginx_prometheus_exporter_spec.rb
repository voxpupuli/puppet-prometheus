# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::nginx_prometheus_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'with all defaults' do
        it { is_expected.to compile.with_all_deps }

        if facts[:os]['release']['major'].to_i == 6
          it { is_expected.to contain_file('/etc/init.d/nginx_prometheus_exporter') }
        else
          it { is_expected.to contain_systemd__unit_file('nginx_prometheus_exporter.service') }
        end

        if facts[:os]['name'] == 'Archlinux'
          it { is_expected.to contain_package('nginx-prometheus-exporter') }
          it { is_expected.not_to contain_archive('/tmp/nginx-prometheus-exporter-0.9.0.tar.gz') }
          it { is_expected.not_to contain_file('/opt/nginx-prometheus-exporter-0.9.0.linux-amd64') }
        else
          it { is_expected.not_to contain_package('nginx-prometheus-exporter') }
          it { is_expected.to contain_archive('/tmp/nginx-prometheus-exporter-0.9.0.tar.gz') }
          it { is_expected.to contain_file('/opt/nginx-prometheus-exporter-0.9.0.linux-amd64') }
        end
      end

      context 'with some params' do
        let(:params) do
          {
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url'
          }
        end

        describe 'with specific params' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_archive('/tmp/nginx-prometheus-exporter-0.9.0.tar.gz') }
          it { is_expected.to contain_class('prometheus') }
          it { is_expected.to contain_group('nginx-prometheus-exporter') }
          it { is_expected.to contain_user('nginx-prometheus-exporter') }
          it { is_expected.to contain_prometheus__daemon('nginx_prometheus_exporter').with('options' => "-nginx.scrape-uri 'http://localhost:8080/stub_status' ") }
          it { is_expected.to contain_service('nginx_prometheus_exporter') }
        end

        describe 'install correct binary' do
          it { is_expected.to contain_file('/usr/local/bin/nginx-prometheus-exporter').with('target' => '/opt/nginx-prometheus-exporter-0.9.0.linux-amd64/nginx-prometheus-exporter') }
          it { is_expected.to contain_file('/opt/nginx-prometheus-exporter-0.9.0.linux-amd64') }
        end
      end

      context 'with scrape_uri and extra options specified' do
        let(:params) do
          {
            scrape_uri: 'http://127.0.0.1/stub_status',
            extra_options: '-test',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url'
          }
        end

        describe 'with specific params' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_archive('/tmp/nginx-prometheus-exporter-0.9.0.tar.gz') }
          it { is_expected.to contain_class('prometheus') }
          it { is_expected.to contain_group('nginx-prometheus-exporter') }
          it { is_expected.to contain_user('nginx-prometheus-exporter') }
          it { is_expected.to contain_prometheus__daemon('nginx_prometheus_exporter').with('options' => "-nginx.scrape-uri 'http://127.0.0.1/stub_status' -test") }
          it { is_expected.to contain_service('nginx_prometheus_exporter') }
        end

        describe 'install correct binary' do
          it { is_expected.to contain_file('/usr/local/bin/nginx-prometheus-exporter').with('target' => '/opt/nginx-prometheus-exporter-0.9.0.linux-amd64/nginx-prometheus-exporter') }
          it { is_expected.to contain_file('/opt/nginx-prometheus-exporter-0.9.0.linux-amd64') }
        end
      end
    end
  end
end
