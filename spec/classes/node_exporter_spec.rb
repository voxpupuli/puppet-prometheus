require 'spec_helper'

describe 'prometheus::node_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'without parameters' do
        it { is_expected.to contain_prometheus__daemon('node_exporter').with(options: '  ') }
        it { is_expected.not_to contain_class('prometheus::install') }
      end

      context 'without collector parameters' do
        let(:params) do
          {
            collectors_enable: %w[foo bar],
            collectors_disable: %w[baz qux]
          }
        end

        it { is_expected.to contain_prometheus__daemon('node_exporter').with(options: ' --collector.foo --collector.bar --no-collector.baz --no-collector.qux') }
      end

      context 'without collector parameters and extra options' do
        let(:params) do
          {
            collectors_enable: %w[foo bar],
            collectors_disable: %w[baz qux],
            extra_options: '--path.procfs /host/proc --path.sysfs /host/sys'
          }
        end

        it { is_expected.to contain_prometheus__daemon('node_exporter').with(options: '--path.procfs /host/proc --path.sysfs /host/sys --collector.foo --collector.bar --no-collector.baz --no-collector.qux') }
      end

      context 'with version specified' do
        let(:params) do
          {
            version: '0.13.0',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin'
          }
        end

        describe 'install correct binary' do
          it { is_expected.to contain_file('/usr/local/bin/node_exporter').with('target' => '/opt/node_exporter-0.13.0.linux-amd64/node_exporter') }
        end
      end
    end
  end
end
