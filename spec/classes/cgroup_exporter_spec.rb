# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::cgroup_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'with version specified' do
        let(:params) do
          {
            version: '1.0.1',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url',
            modules: {
              'default' => {}
            }
          }
        end

        describe 'with all defaults' do
          it { is_expected.to contain_class('prometheus') }
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('/usr/local/bin/cgroup_exporter') }
          it { is_expected.to contain_prometheus__daemon('cgroup_exporter') }
          it { is_expected.to contain_user('cgroup-exporter') }
          it { is_expected.to contain_group('cgroup-exporter') }
          it { is_expected.to contain_service('cgroup_exporter') }
          it { is_expected.to contain_archive('/tmp/cgroup_exporter-1.0.1.tar.gz') }
          it { is_expected.to contain_file('/opt/cgroup_exporter-1.0.1.linux-amd64/cgroup_exporter') }
        end
      end
    end
  end
end
