# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::bird_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      # rubocop:disable RSpec/RepeatedExample
      context 'without parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('prometheus') }

        # Arch Linux has a native package that we install by default, other distributions get a go binary curled from GitHub
        if facts[:os]['family'] == 'Archlinux'
          it { is_expected.to contain_service('prometheus-bird-exporter') }
          it { is_expected.to contain_package('prometheus-bird-exporter') }
          it { is_expected.to contain_prometheus__daemon('prometheus-bird-exporter') }
          it { is_expected.not_to contain_prometheus__daemon('bird_exporter') }
          it { is_expected.not_to contain_service('bird_exporter') }
          it { is_expected.not_to contain_systemd__unit_file('bird_exporter.service') }
          it { is_expected.not_to contain_group('bird-exporter') }
          it { is_expected.not_to contain_user('bird-exporter') }
          it { is_expected.not_to contain_file('/usr/local/bin/bird_exporter') }
          it { is_expected.not_to contain_archive('/opt/bird_exporter-1.2.5.linux-amd64/bird_exporter') }
          it { is_expected.not_to contain_file('/opt/bird_exporter-1.2.5.linux-amd64/bird_exporter') }
          it { is_expected.not_to contain_file('/opt/bird_exporter-1.2.5.linux-amd64').with_ensure('directory') }
          it { is_expected.not_to contain_file('/etc/sysconfig/bird_exporter') }
          it { is_expected.not_to contain_file('/etc/default/bird_exporter') }
        else
          it { is_expected.not_to contain_prometheus__daemon('prometheus-bird-exporter') }
          it { is_expected.to contain_prometheus__daemon('bird_exporter') }
          it { is_expected.to contain_systemd__unit_file('bird_exporter.service') }
          it { is_expected.not_to contain_package('prometheus-bird-exporter') }
          it { is_expected.not_to contain_service('prometheus-bird-exporter.service') }
          it { is_expected.to contain_service('bird_exporter') }
          it { is_expected.to contain_group('bird-exporter') }
          it { is_expected.to contain_user('bird-exporter') }
          it { is_expected.to contain_file('/usr/local/bin/bird_exporter') }
          it { is_expected.to contain_archive('/opt/bird_exporter-1.2.5.linux-amd64/bird_exporter') }
          it { is_expected.to contain_file('/opt/bird_exporter-1.2.5.linux-amd64/bird_exporter') }
          it { is_expected.to contain_file('/opt/bird_exporter-1.2.5.linux-amd64').with_ensure('directory') }

          if facts[:os]['family'] == 'RedHat'
            it { is_expected.not_to contain_file('/etc/sysconfig/bird_exporter') }
          else
            it { is_expected.not_to contain_file('/etc/default/bird_exporter') }
          end
        end
      end

      context 'with env vars' do
        let :params do
          {
            env_vars: {
              blub: 'foobar'
            }
          }
        end

        it { is_expected.to compile.with_all_deps }

        case facts[:os]['family']
        when 'RedHat'
          it { is_expected.to contain_file('/etc/sysconfig/bird_exporter') }
          it { is_expected.not_to contain_file('/etc/default/bird_exporter') }
          it { is_expected.not_to contain_file('/etc/conf.d/prometheus-bird-exporter') }
        when 'Archlinux'
          it { is_expected.to contain_file('/etc/conf.d/prometheus-bird-exporter') }
          it { is_expected.not_to contain_file('/etc/default/bird_exporter') }
          it { is_expected.not_to contain_file('/etc/sysconfig/bird_exporter') }
        else
          it { is_expected.to contain_file('/etc/default/bird_exporter') }
          it { is_expected.not_to contain_file('/etc/sysconfig/bird_exporter') }
          it { is_expected.not_to contain_file('/etc/conf.d/prometheus-bird-exporter') }
        end
        # rubocop:enable RSpec/RepeatedExample
      end
    end
  end
end
