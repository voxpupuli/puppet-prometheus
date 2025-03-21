# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::memcached_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'with all defaults' do
        describe 'with all defaults' do
          let(:version) { catalogue.resource('Class[prometheus::memcached_exporter]').parameters[:version] }

          it { is_expected.to compile.with_all_deps }

          if facts[:os]['name'] == 'Archlinux'
            it { is_expected.to contain_package('prometheus-memcached-exporter') }
            it { is_expected.not_to contain_file('/usr/local/bin/memcached_exporter') }
            it { is_expected.not_to contain_archive("/tmp/memcached_exporter-#{version}.tar.gz") }
            it { is_expected.to contain_prometheus__daemon('prometheus-memcached-exporter') }
            it { is_expected.to contain_service('prometheus-memcached-exporter') }
          else
            it { is_expected.to contain_archive("/tmp/memcached_exporter-#{version}.tar.gz") }
            it { is_expected.to contain_file('/usr/local/bin/memcached_exporter').with('target' => "/opt/memcached_exporter-#{version}.linux-amd64/memcached_exporter") }
            it { is_expected.not_to contain_package('memcached_exporter') }
            it { is_expected.to contain_prometheus__daemon('memcached_exporter') }
            it { is_expected.to contain_user('memcached-exporter') }
            it { is_expected.to contain_group('memcached-exporter') }
            it { is_expected.to contain_service('memcached_exporter') }
          end
          it { is_expected.to contain_class('prometheus') }
        end
      end
    end
  end
end
