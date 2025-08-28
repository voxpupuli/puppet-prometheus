# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::ipmi_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'without parameters' do
        let(:version) { catalogue.resource('Class[prometheus::ipmi_exporter]').parameters[:version] }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('prometheus') }
        it { is_expected.to contain_service('ipmi_exporter') }
        it { is_expected.to contain_user('ipmi-exporter') }
        it { is_expected.to contain_group('ipmi-exporter') }
        it { is_expected.to contain_file("/opt/ipmi_exporter-#{version}.linux-amd64/ipmi_exporter") }
        it { is_expected.to contain_file('/usr/local/bin/ipmi_exporter') }

        if facts[:os]['name'] == 'Archlinux'
          it { is_expected.to contain_systemd__unit_file('ipmi_exporter.service') }
          it { is_expected.to contain_prometheus__daemon('ipmi_exporter').with(options: '--config.file=/etc/ipmi_exporter.yaml  ') }
        else
          it { is_expected.to contain_prometheus__daemon('ipmi_exporter').with(options: '--config.file=/etc/ipmi_exporter.yaml  --freeipmi.path=/usr/local/bin') }
        end

        if facts[:os]['family'] == 'RedHat'
          it { is_expected.not_to contain_file('/etc/sysconfig/bird_exporter') }
        else
          it { is_expected.not_to contain_file('/etc/default/bird_exporter') }
        end
      end

      context 'with modules defined' do
        let(:params) do
          {
            modules: { 'default' => { 'collectors' => ['bmc'] } },
            install_method: 'url',
            version: '1.3.1'
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_archive('/tmp/ipmi_exporter-1.3.1.tar.gz') }
        it { is_expected.to contain_file('/usr/local/bin/ipmi_exporter') }
        it { is_expected.not_to contain_file('/usr/bin/ipmi_exporter') }

        if facts[:os]['name'] == 'Archlinux'
          it { is_expected.to contain_prometheus__daemon('ipmi_exporter').with(options: '--config.file=/etc/ipmi_exporter.yaml  ') }
        else
          it { is_expected.to contain_prometheus__daemon('ipmi_exporter').with(options: '--config.file=/etc/ipmi_exporter.yaml  --freeipmi.path=/usr/local/bin') }
        end
        it {
          is_expected.to contain_file('/etc/ipmi_exporter.yaml').
            with_content(%r{^modules:\n}).
            with_content(%r{^  default:\n}).
            with_content(%r{^    collectors:\n}).
            with_content(%r{^    - bmc\n})
        }
      end

      context 'with version specified' do
        let(:params) do
          {
            version: '1.0.0',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url'
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_archive('/tmp/ipmi_exporter-1.0.0.tar.gz') }
        it { is_expected.to contain_file('/opt/ipmi_exporter-1.0.0.linux-amd64/ipmi_exporter') }

        describe 'install correct binary' do
          it { is_expected.to contain_file('/usr/local/bin/ipmi_exporter').with('target' => '/opt/ipmi_exporter-1.0.0.linux-amd64/ipmi_exporter') }
        end
      end

      context 'with extra options' do
        let(:params) do
          {
            extra_options: '--path.procfs /host/proc --path.sysfs /host/sys'
          }
        end

        it { is_expected.to compile.with_all_deps }

        if facts[:os]['name'] == 'Archlinux'
          it { is_expected.to contain_prometheus__daemon('ipmi_exporter').with(options: '--config.file=/etc/ipmi_exporter.yaml --path.procfs /host/proc --path.sysfs /host/sys ') }
        else
          it { is_expected.to contain_prometheus__daemon('ipmi_exporter').with(options: '--config.file=/etc/ipmi_exporter.yaml --path.procfs /host/proc --path.sysfs /host/sys --freeipmi.path=/usr/local/bin') }
        end
      end

      context 'with no download_extension' do
        let(:params) do
          {
            download_extension: '',
          }
        end

        it { is_expected.to contain_prometheus__daemon('ipmi_exporter').with_download_extension('') }
      end
    end
  end
end
