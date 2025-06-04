# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::ssh_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'with version specified' do
        let(:params) do
          {
            version: '1.2.0',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url',
            modules: {
              'default' => {
                'user' => 'prometheus',
                'private_key' => '/home/prometheus/.ssh/id_rsa',
              }
            }
          }
        end

        describe 'with all defaults' do
          it { is_expected.to contain_class('prometheus') }
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('/usr/local/bin/ssh_exporter').with('target' => '/opt/ssh_exporter-1.2.0.linux-amd64/ssh_exporter') }
          it { is_expected.to contain_prometheus__daemon('ssh_exporter') }
          it { is_expected.to contain_user('ssh-exporter') }
          it { is_expected.to contain_group('ssh-exporter') }
          it { is_expected.to contain_service('ssh_exporter') }
          it { is_expected.to contain_archive('/tmp/ssh_exporter-1.2.0.tar.gz') }
          it { is_expected.to contain_file('/opt/ssh_exporter-1.2.0.linux-amd64/ssh_exporter') }

          it {
            is_expected.to contain_file('/etc/ssh_exporter.yaml').
              with_content(%r{^---\n}).
              with_content(%r{^modules:\n}).
              with_content(%r{^  default:\n}).
              with_content(%r{^    user: prometheus\n}).
              with_content(%r{^    private_key: "/home/prometheus/.ssh/id_rsa"\n})
          }
        end
      end
    end
  end
end
