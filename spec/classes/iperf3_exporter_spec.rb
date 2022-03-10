# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::iperf3_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'without parameters' do
        it { is_expected.to contain_prometheus__daemon('iperf3_exporter') }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_group('iperf3-exporter') }
        it { is_expected.to contain_service('iperf3_exporter') }
        it { is_expected.to contain_user('iperf3-exporter') }
        it { is_expected.to contain_class('prometheus') }
      end

      context 'with params' do
        let :params do
          {
            install_method: 'url',
            version: '0.1.3'
          }
        end

        it { is_expected.to contain_archive('/tmp/iperf3_exporter-0.1.3.tar.gz') }
        it { is_expected.to contain_file('/opt/iperf3_exporter-0.1.3.linux-amd64/iperf3_exporter') }
      end
    end
  end
end
