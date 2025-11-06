# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::openldap_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'without parameters' do
        it { is_expected.to contain_class('prometheus') }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_prometheus__daemon('openldap_exporter') }
        it { is_expected.to contain_user('openldap-exporter') }
        it { is_expected.to contain_group('openldap-exporter') }
        it { is_expected.to contain_service('openldap_exporter') }
      end

      context 'with version specified' do
        let(:params) do
          {
            version: 'v2.4.4',
          }
        end

        describe 'with all defaults' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('/usr/local/bin/openldap_exporter').with('target' => '/opt/openldap_exporter-v2.4.4.linux-x86_64/openldap-exporter') }
          it { is_expected.to contain_prometheus__daemon('openldap_exporter') }
          it { is_expected.to contain_user('openldap-exporter') }
          it { is_expected.to contain_group('openldap-exporter') }
          it { is_expected.to contain_service('openldap_exporter') }

          it {
            expect(subject).to contain_prometheus__daemon('openldap_exporter').with(
              real_download_url: 'https://github.com/hm-edu/openldap-exporter/releases/download/v2.4.4/openldap-exporter_linux_x86_64.tar.gz'
            )
          }
        end
      end
    end
  end
end
