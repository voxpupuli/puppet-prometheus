# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::jmx_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'with version specified' do
        let(:params) do
          {
            version: '0.17.1',
            port: 8080,
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
          }
        end

        describe 'compile manifest' do
          it { is_expected.to compile.with_all_deps }
        end

        describe 'install correct binary' do
          it { is_expected.to contain_file('/opt/jmx_exporter-0.17.1.linux-amd64/jmx_exporter') }
        end

        describe 'generate empty configuration file' do
          it {
            is_expected.to contain_file('/etc/jmx-exporter.yaml').with(
              'content' => <<~EOL
                --- {}
              EOL
            )
          }
        end
      end

      context 'with configuration' do
        let(:params) do
          {
            version: '0.17.1',
            port: 8080,
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            configuration: {
              startDelaySeconds: 2,
              rules: [
                {
                  pattern: 'something'
                }
              ]
            }
          }
        end

        describe 'compile manifest' do
          it { is_expected.to compile.with_all_deps }
        end

        describe 'generate empty configuration file' do
          it {
            is_expected.to contain_file('/etc/jmx-exporter.yaml').with(
              'content' => <<~EOL
                ---
                startDelaySeconds: 2
                rules:
                - pattern: something
              EOL
            )
          }
        end
      end

      context 'as javaagent deployment' do
        let(:params) do
          {
            version: '0.17.1',
            deployment: 'javaagent',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            configuration: {
              startDelaySeconds: 2,
              rules: [
                {
                  pattern: 'something'
                }
              ]
            }
          }
        end

        describe 'compile manifest' do
          it { is_expected.to compile.with_all_deps }
        end
      end
    end
  end
end
