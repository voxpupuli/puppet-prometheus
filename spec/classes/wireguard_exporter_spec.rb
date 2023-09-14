# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::wireguard_exporter' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end

      context 'without parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('prometheus') }
        it { is_expected.to contain_file('/etc/wireguard_exporter_web-config.yml') }
        it { is_expected.to contain_package('prometheus-wireguard-exporter') }
        it { is_expected.to contain_prometheus__daemon('prometheus-wireguard-exporter') }
        it { is_expected.to contain_service('prometheus-wireguard-exporter') }
        it { is_expected.to contain_sudo__conf('prometheus-wireguard-exporter') }

        if os_facts[:os]['family'] == 'RedHat'
          it { is_expected.to contain_file('/etc/sysconfig/prometheus-wireguard-exporter') }
          it { is_expected.not_to contain_file('/etc/default/prometheus-wireguard-exporter') }
          it { is_expected.not_to contain_file('/etc/conf.d/prometheus-wireguard-exporter') }
        elsif os_facts[:os]['name'] == 'Archlinux'
          it { is_expected.to contain_file('/etc/conf.d/prometheus-wireguard-exporter') }
          it { is_expected.not_to contain_file('/etc/sysconfig/prometheus-wireguard-exporter') }
          it { is_expected.not_to contain_file('/etc/default/prometheus-wireguard-exporter') }
        elsif os_facts[:os]['family'] == 'Debian'
          it { is_expected.to contain_file('/etc/default/prometheus-wireguard-exporter') }
          it { is_expected.not_to contain_file('/etc/sysconfig/prometheus-wireguard-exporter') }
          it { is_expected.not_to contain_file('/etc/conf.d/prometheus-wireguard-exporter') }
        end
      end
    end
  end
end
