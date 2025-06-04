# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::alertmanager' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'with version specified' do
        let(:params) do
          {
            version: '0.27.0',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url'
          }
        end

        describe 'with specific params' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_archive('/tmp/alertmanager-0.27.0.tar.gz') }
          it { is_expected.to contain_class('prometheus') }
          it { is_expected.to contain_group('alertmanager') }
          it { is_expected.to contain_user('alertmanager') }
          it { is_expected.to contain_prometheus__daemon('alertmanager') }
          it { is_expected.to contain_service('alertmanager') }
        end

        describe 'install correct binary' do
          it { is_expected.to contain_file('/usr/local/bin/alertmanager').with('target' => '/opt/alertmanager-0.27.0.linux-amd64/alertmanager') }
        end

        describe 'config file contents' do
          it {
            expect(subject).to contain_file('/etc/alertmanager/alertmanager.yaml').
              with_notify('Service[alertmanager]').
              with_content(%r{^---\n}).
              with_content(%r{^global:\n}).
              with_content(%r{^  smtp_smarthost: localhost:25\n}).
              with_content(%r{^  smtp_from: alertmanager@localhost\n})
          }
        end

        describe 'service reload' do
          it {
            expect(subject).to contain_exec('alertmanager-reload').with(
              # 'command'     => 'systemctl reload alertmanager',
              'path' => ['/usr/bin', '/bin', '/usr/sbin', '/sbin'],
              'refreshonly' => true
            )
          }
        end
      end

      context 'with latest version specified and mute_time_intervals' do
        let(:params) do
          {
            version: '0.27.0',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url',
            mute_time_intervals: [
              { 'name' => 'weekend', 'time_intervals' => [{ 'weekdays' => %w[saturday sunday] }] }
            ],
          }
        end

        it {
          expect(subject).to contain_file('/etc/alertmanager/alertmanager.yaml').
            with_content(%r{mute_time_intervals:}).
            with_content(%r{- name: weekend}).
            with_content(%r{  time_intervals:}).
            with_content(%r{  - weekdays:}).
            with_content(%r{    - saturday}).
            with_content(%r{    - sunday})
        }
      end

      context 'with latest version specified and time_intervals' do
        let(:params) do
          {
            version: '0.27.0',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url',
            mute_time_intervals: [
              { 'name' => 'weekend', 'time_intervals' => [{ 'weekdays' => %w[saturday sunday] }] }
            ],
            time_intervals: [
              { 'name' => 'weekend', 'time_intervals' => [{ 'weekdays' => %w[saturday sunday] }] }
            ],
          }
        end

        it { is_expected.to contain_file('/etc/alertmanager/alertmanager.yaml').without(content: %r{mute_time_intervals}) }

        it {
          expect(subject).to contain_file('/etc/alertmanager/alertmanager.yaml').
            with_content(%r{time_intervals:}).
            with_content(%r{- name: weekend}).
            with_content(%r{  time_intervals:}).
            with_content(%r{  - weekdays:}).
            with_content(%r{    - saturday}).
            with_content(%r{    - sunday})
        }
      end

      context 'when reload_on_change => true' do
        let(:params) { { reload_on_change: true } }

        it {
          expect(subject).to contain_file('/etc/alertmanager/alertmanager.yaml').with_notify('Exec[alertmanager-reload]')
        }
      end

      context 'with manage_config => false' do
        [
          {
            version: '0.27.0',
            manage_config: false
          }
        ].each do |parameters|
          context "with alertmanager verions #{parameters[:version]}" do
            let(:params) do
              parameters
            end

            it {
              expect(subject).not_to contain_file('/etc/alertmanager/alertmanager.yaml')
            }
          end
        end
      end

      context 'with validate_config => false' do
        let(:params) do
          {
            manage_config: true,
            install_method: 'package',
            validate_config: false,
          }
        end

        it {
          expect(subject).to contain_file('/etc/alertmanager/alertmanager.yaml').without_validate_cmd
        }
      end

      context 'with validate_config => true' do
        let(:params) do
          {
            manage_config: true,
            install_method: 'package',
            validate_config: true,
            bin_dir: '/bin',
          }
        end

        it {
          expect(subject).to contain_file('/etc/alertmanager/alertmanager.yaml').with_validate_cmd('/bin/amtool check-config --alertmanager.url=\'\' %')
        }
      end
    end
  end
end
