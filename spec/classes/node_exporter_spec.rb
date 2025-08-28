# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::node_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'without parameters' do
        let(:version) { catalogue.resource('Class[prometheus::node_exporter]').parameters[:version] }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('prometheus') }

        if facts[:os]['name'] == 'Archlinux'
          it { is_expected.not_to contain_user('node-exporter') }
          it { is_expected.not_to contain_group('node-exporter') }

          it { is_expected.not_to contain_file("/opt/node_exporter-#{version}.linux-amd64/node_exporter") }

          it { is_expected.not_to contain_file('/usr/local/bin/node_exporter') }
          it { is_expected.to contain_package('prometheus-node-exporter') }
          it { is_expected.not_to contain_systemd__unit_file('node_exporter.service') }
          it { is_expected.to contain_service('prometheus-node-exporter') }
          it { is_expected.to contain_prometheus__daemon('prometheus-node-exporter').with(options: '') }
        else
          it { is_expected.to contain_user('node-exporter') }
          it { is_expected.to contain_group('node-exporter') }
          it { is_expected.to contain_file("/opt/node_exporter-#{version}.linux-amd64/node_exporter") }

          it { is_expected.to contain_file('/usr/local/bin/node_exporter') }
          it { is_expected.to contain_service('node_exporter') }
          it { is_expected.to contain_prometheus__daemon('node_exporter').with(options: '') }
          it { is_expected.to contain_systemd__unit_file('node_exporter.service') }
        end
        # rubocop:disable RSpec/RepeatedExample
        if facts[:os]['family'] == 'RedHat'
          it { is_expected.not_to contain_file('/etc/sysconfig/node_exporter') }
        elsif facts[:os]['name'] == 'Archlinux'
          it { is_expected.to contain_file('/etc/conf.d/prometheus-node-exporter') }
          it { is_expected.not_to contain_file('/etc/sysconfig/node_exporter') }
          it { is_expected.not_to contain_file('/etc/default/node_exporter') }
        else
          it { is_expected.not_to contain_file('/etc/default/node_exporter') }
          it { is_expected.not_to contain_file('/etc/sysconfig/node_exporter') }
        end
        # rubocop:enable RSpec/RepeatedExample
      end

      context 'without collector parameters' do
        let(:params) do
          {
            collectors_enable: %w[foo bar],
            collectors_disable: %w[baz qux],
            init_style: 'systemd',
            service_name: 'node_exporter',
            install_method: 'url'
          }
        end
        let(:version) { catalogue.resource('Class[prometheus::node_exporter]').parameters[:version] }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_archive("/tmp/node_exporter-#{version}.tar.gz") }
        it { is_expected.to contain_prometheus__daemon('node_exporter').with(options: '--collector.foo --collector.bar --no-collector.baz --no-collector.qux') }

        if facts[:os]['name'] != 'Archlinux'
          it { is_expected.to contain_file('/usr/local/bin/node_exporter') }
          it { is_expected.not_to contain_file('/usr/bin/node_exporter') }
        end
      end

      context 'without collector parameters and extra options' do
        let(:params) do
          {
            collectors_enable: %w[foo bar],
            collectors_disable: %w[baz qux],
            extra_options: '--path.procfs /host/proc --path.sysfs /host/sys',
            service_name: 'node_exporter',
            install_method: 'url'
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_prometheus__daemon('node_exporter').with(options: '--path.procfs /host/proc --path.sysfs /host/sys --collector.foo --collector.bar --no-collector.baz --no-collector.qux') }
      end

      context 'with version specified' do
        let(:params) do
          {
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            service_name: 'node_exporter',
            install_method: 'url',
            package_name: 'node_exporter', # reuired to override defaults for Archlinux
            bin_name: 'node_exporter' # reuired to override defaults for Archlinux
          }
        end
        let(:version) { catalogue.resource('Class[prometheus::node_exporter]').parameters[:version] }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_archive("/tmp/node_exporter-#{version}.tar.gz") }
        it { is_expected.to contain_file("/opt/node_exporter-#{version}.linux-amd64/node_exporter") }

        describe 'install correct binary' do
          it { is_expected.to contain_file('/usr/local/bin/node_exporter').with('target' => "/opt/node_exporter-#{version}.linux-amd64/node_exporter") }
        end
      end

      context 'with no download_extension' do
        let(:params) do
          {
            install_method: 'url',
            download_extension: '',
            service_name: 'node_exporter'
          }
        end

        it { is_expected.to contain_prometheus__daemon('node_exporter').with_download_extension('') }
      end

      context 'without web-config.yml' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/node_exporter_web-config.yml').with(ensure: 'absent') }

        if facts[:os]['name'] == 'Archlinux'
          it { is_expected.to contain_prometheus__daemon('prometheus-node-exporter').with(options: '') }
        else
          it { is_expected.to contain_prometheus__daemon('node_exporter').with(options: '') }
        end
      end

      context 'with tls set in web-config.yml version lower than 1.5.0' do
        let(:params) do
          {
            version: '1.4.0',
            web_config_content: {
              tls_server_config: {
                cert_file: '/etc/node_exporter/foo.cert',
                key_file: '/etc/node_exporter/foo.key'
              }
            }
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/node_exporter_web-config.yml').with(ensure: 'file') }

        if facts[:os]['name'] == 'Archlinux'
          it { is_expected.to contain_prometheus__daemon('prometheus-node-exporter').with(options: '--web.config=/etc/node_exporter_web-config.yml') }
        else
          it { is_expected.to contain_prometheus__daemon('node_exporter').with(options: '--web.config=/etc/node_exporter_web-config.yml') }
        end
      end

      context 'with tls set in web-config.yml version equal to 1.5.0' do
        let(:params) do
          {
            version: '1.5.0',
            web_config_content: {
              tls_server_config: {
                cert_file: '/etc/node_exporter/foo.cert',
                key_file: '/etc/node_exporter/foo.key'
              }
            }
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/node_exporter_web-config.yml').with(ensure: 'file') }

        if facts[:os]['name'] == 'Archlinux'
          it { is_expected.to contain_prometheus__daemon('prometheus-node-exporter').with(options: '--web.config.file=/etc/node_exporter_web-config.yml') }
        else
          it { is_expected.to contain_prometheus__daemon('node_exporter').with(options: '--web.config.file=/etc/node_exporter_web-config.yml') }
        end
      end

      context 'with tls set in web-config.yml version higher than 1.5.0' do
        let(:params) do
          {
            version: '1.5.1',
            web_config_content: {
              tls_server_config: {
                cert_file: '/etc/node_exporter/foo.cert',
                key_file: '/etc/node_exporter/foo.key'
              }
            }
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/node_exporter_web-config.yml').with(ensure: 'file') }

        if facts[:os]['name'] == 'Archlinux'
          it { is_expected.to contain_prometheus__daemon('prometheus-node-exporter').with(options: '--web.config.file=/etc/node_exporter_web-config.yml') }
        else
          it { is_expected.to contain_prometheus__daemon('node_exporter').with(options: '--web.config.file=/etc/node_exporter_web-config.yml') }
        end
      end

      context 'with non default scrape port' do
        let(:params) do
          {
            scrape_port: 9101
          }
        end

        it { is_expected.to compile.with_all_deps }

        if facts[:os]['name'] == 'Archlinux'
          it { is_expected.to contain_prometheus__daemon('prometheus-node-exporter').with(options: '--web.listen-address=\':9101\'') }
        else
          it { is_expected.to contain_prometheus__daemon('node_exporter').with(options: '--web.listen-address=\':9101\'') }
        end
      end
    end
  end
end
