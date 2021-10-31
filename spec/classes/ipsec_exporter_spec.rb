# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::ipsec_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'without parameters' do
        it { is_expected.to contain_prometheus__daemon('ipsec_exporter') }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_group('ipsec-exporter') }
        it { is_expected.to contain_service('ipsec_exporter') }
        it { is_expected.to contain_user('ipsec-exporter') }
        it { is_expected.to contain_class('prometheus') }
      end

      context 'with params' do
        let :params do
          {
            install_method: 'url',
            version: '0.3.2'
          }
        end

        it { is_expected.to contain_archive('/tmp/ipsec_exporter-0.3.2.tar.gz') }
        it { is_expected.to contain_file('/opt/ipsec_exporter-0.3.2.linux-amd64/ipsec_exporter') }
      end
    end
  end
end
