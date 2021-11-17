# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::openldap_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'with version specified' do
        let(:params) do
          {
            version: '2.1',
            bin_dir: '/usr/local/bin',
            install_method: 'url'
          }
        end

        describe 'with all defaults' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('/usr/local/bin/openldap_exporter').with('target' => '/opt/openldap_exporter-2.1.linux-amd64/openldap_exporter') }
          it { is_expected.to contain_prometheus__daemon('openldap_exporter') }
          it { is_expected.to contain_user('openldap-exporter') }
          it { is_expected.to contain_group('openldap-exporter') }
          it { is_expected.to contain_service('openldap_exporter') }
        end
      end
    end
  end
end
