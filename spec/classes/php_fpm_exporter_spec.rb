# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::php_fpm_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'with all defaults' do
        it { is_expected.to compile.with_all_deps }

        if facts[:os]['release']['major'].to_i == 6
          it { is_expected.to contain_file('/etc/init.d/php-fpm_exporter') }
        else
          it { is_expected.to contain_systemd__unit_file('php-fpm_exporter.service') }
        end

        if facts[:os]['name'] == 'Archlinux'
          it { is_expected.to contain_package('php-fpm_exporter') }
          it { is_expected.not_to contain_archive('/tmp/php-fpm_exporter-2.0.4.tar.gz') }
          it { is_expected.not_to contain_file('/opt/php-fpm_exporter-2.0.4.linux-amd64') }
        else
          it { is_expected.not_to contain_package('php-fpm_exporter') }
          it { is_expected.to contain_archive('/tmp/php-fpm_exporter-2.0.4.tar.gz') }
          it { is_expected.to contain_file('/opt/php-fpm_exporter-2.0.4.linux-amd64') }
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
          it { is_expected.to contain_archive('/tmp/php-fpm_exporter-2.0.4.tar.gz') }
          it { is_expected.to contain_class('prometheus') }
          it { is_expected.to contain_group('php-fpm_exporter') }
          it { is_expected.to contain_user('php-fpm_exporter') }
          it { is_expected.to contain_prometheus__daemon('php-fpm_exporter').with('options' => "server --phpfpm.scrape-uri 'tcp://127.0.0.1:9000/status' ") }
          it { is_expected.to contain_service('php-fpm_exporter') }
        end

        describe 'install correct binary' do
          it { is_expected.to contain_file('/usr/local/bin/php-fpm_exporter').with('target' => '/opt/php-fpm_exporter-2.0.4.linux-amd64/php-fpm_exporter') }
          it { is_expected.to contain_file('/opt/php-fpm_exporter-2.0.4.linux-amd64') }
        end
      end

      context 'with scrape_uri and extra options specified' do
        let(:params) do
          {
            scrape_uri: 'tcp://localhost:9000/status',
            extra_options: '-test',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url'
          }
        end

        describe 'with specific params' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_archive('/tmp/php-fpm_exporter-2.0.4.tar.gz') }
          it { is_expected.to contain_class('prometheus') }
          it { is_expected.to contain_group('php-fpm_exporter') }
          it { is_expected.to contain_user('php-fpm_exporter') }
          it { is_expected.to contain_prometheus__daemon('php-fpm_exporter').with('options' => "server --phpfpm.scrape-uri 'tcp://localhost:9000/status' -test") }
          it { is_expected.to contain_service('php-fpm_exporter') }
        end

        describe 'install correct binary' do
          it { is_expected.to contain_file('/usr/local/bin/php-fpm_exporter').with('target' => '/opt/php-fpm_exporter-2.0.4.linux-amd64/php-fpm_exporter') }
          it { is_expected.to contain_file('/opt/php-fpm_exporter-2.0.4.linux-amd64') }
        end
      end
    end
  end
end
