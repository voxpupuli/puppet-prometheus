# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::lvm_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'without parameters' do
        let(:version) { catalogue.resource('Class[prometheus::lvm_exporter]').parameters[:version] }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('prometheus') }

        it { is_expected.not_to contain_user('lvm-exporter') }
        it { is_expected.not_to contain_group('lvm-exporter') }

        it { is_expected.not_to contain_file("/opt/prometheus-lvm-exporter_#{version}_linux_amd64/prometheus-lvm-exporter") }

        it { is_expected.not_to contain_file('/usr/local/bin/prometheus-lvm-exporter') }
        it { is_expected.not_to contain_systemd__unit_file('lvm_exporter.service') }
        it { is_expected.to contain_service('prometheus-lvm-exporter') }
        it { is_expected.to contain_prometheus__daemon('prometheus-lvm-exporter').with(options: '') }

        # rubocop:disable RSpec/RepeatedExample
        if facts[:os]['family'] == 'RedHat'
          it { is_expected.not_to contain_file('/etc/sysconfig/lvm_exporter') }
        elsif facts[:os]['name'] == 'Archlinux'
          it { is_expected.to contain_file('/etc/conf.d/prometheus-lvm-exporter') }
          it { is_expected.not_to contain_file('/etc/sysconfig/lvm_exporter') }
          it { is_expected.not_to contain_file('/etc/default/lvm_exporter') }
        else
          it { is_expected.not_to contain_file('/etc/default/lvm_exporter') }
          it { is_expected.not_to contain_file('/etc/sysconfig/lvm_exporter') }
        end
        # rubocop:enable RSpec/RepeatedExample
      end

      context 'with version specified' do
        let(:params) do
          {
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            service_name: 'lvm_exporter',
          }
        end
        let(:version) { catalogue.resource('Class[prometheus::lvm_exporter]').parameters[:version] }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_archive("/tmp/prometheus-lvm-exporter_#{version}_linux_amd64.tar.gz") }
        it { is_expected.to contain_file("/opt/prometheus-lvm-exporter-#{version}_linux_amd64/prometheus-lvm-exporter") }

        describe 'install correct binary' do
          it { is_expected.to contain_file('/usr/local/bin/prometheus-lvm-exporter').with('target' => "/opt/prometheus-lvm-exporter_#{version}_linux_amd64/prometheus-lvm-exporter") }
        end
      end

      context 'with non default scrape port' do
        let(:params) do
          {
            scrape_port: 9101
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_prometheus__daemon('prometheus-lvm-exporter').with(options: '--web.listen-address=\':9101\'') }
      end
    end
  end
end
