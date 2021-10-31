# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::openvpn_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'with version specified' do
        let(:params) do
          {
            version: 'v0.3.0.3',
            bin_dir: '/usr/local/bin',
            install_method: 'url'
          }
        end

        describe 'with all defaults' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('/usr/local/bin/openvpn_exporter').with('target' => '/opt/openvpn_exporter-v0.3.0.3.linux-amd64/openvpn_exporter') }
          it { is_expected.to contain_prometheus__daemon('openvpn_exporter') }
          it { is_expected.to contain_user('openvpn-exporter') }
          it { is_expected.to contain_group('openvpn-exporter') }
          it { is_expected.to contain_service('openvpn_exporter') }
        end
      end
    end
  end
end
