# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::graphite_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'without parameters' do
        it { is_expected.to contain_prometheus__daemon('graphite_exporter') }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_group('graphite-exporter') }
        it { is_expected.to contain_service('graphite_exporter') }
        it { is_expected.to contain_user('graphite-exporter') }
        it { is_expected.to contain_class('prometheus') }
      end

      context 'with params' do
        let(:version) { catalogue.resource('Class[prometheus::graphite_exporter]').parameters[:version] }
        let :params do
          {
            install_method: 'url'
          }
        end

        it { is_expected.to contain_archive("/tmp/graphite_exporter-#{version}.tar.gz") }
      end
    end
  end
end
