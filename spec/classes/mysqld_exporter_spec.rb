# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::mysqld_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'default' do
        describe 'options is correct' do
          it { is_expected.to contain_prometheus__daemon('mysqld_exporter').with('options' => '--config.my-cnf=/etc/mysqld_exporter-my.cnf') }
        end
      end

      context 'with version >= 0.9.0' do
        let(:params) do
          {
            version: '0.9.0'
          }
        end

        describe 'options is correct' do
          it { is_expected.to contain_prometheus__daemon('mysqld_exporter').with('options' => '-config.my-cnf=/etc/mysqld_exporter-my.cnf') }
        end
      end

      context 'with Sensitive password' do
        let(:params) do
          {
            cnf_password: RSpec::Puppet::RawString.new("Sensitive('secret')")
          }
        end

        it do
          content = catalogue.resource('file', '/etc/mysqld_exporter-my.cnf').send(:parameters)[:content]
          expect(content).to include('secret')
          expect(content).not_to include('ssl-ca')
        end
      end

      context 'with tls parameters for exporter' do
        let(:params) do
          {
            cnf_ssl_ca: '/foo/bar/ca.pem',
            cnf_ssl_cert: '/foo/bar/cert.pem',
            cnf_ssl_key: '/foo/bar/key.pem'
          }
        end

        it do
          content = catalogue.resource('file', '/etc/mysqld_exporter-my.cnf').send(:parameters)[:content]
          expect(content).to include('ssl-ca = "/foo/bar/ca.pem"')
          expect(content).to include('ssl-cert = "/foo/bar/cert.pem"')
          expect(content).to include('ssl-key = "/foo/bar/key.pem"')
        end
      end

      context 'with tls set in web-config.yml' do
        let(:params) do
          {
            web_config_content: {
              tls_server_config: {
                cert_file: '/etc/mysqld_exporter/foo.cert',
                key_file: '/etc/mysqld_exporter/foo.key'
              }
            }
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/etc/mysqld_exporter_web-config.yml').with(ensure: 'file') }

        it { is_expected.to contain_prometheus__daemon('mysqld_exporter').with(options: '--config.my-cnf=/etc/mysqld_exporter-my.cnf --web.config.file=/etc/mysqld_exporter_web-config.yml') }
      end
    end
  end
end
