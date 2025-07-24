# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::frr_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'with version specified' do
        let(:params) do
          {
            version: '1.8.0'
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('prometheus') }

        it {
          is_expected.to contain_prometheus__daemon('frr_exporter').with(
            install_method: 'url',
            version: '1.8.0',
            download_extension: 'tar.gz',
            os: 'linux',
            arch: 'amd64',
            real_download_url: 'https://github.com/tynany/frr_exporter/releases/download/v1.8.0/frr_exporter-1.8.0.linux-amd64.tar.gz',
            bin_dir: '/opt/prometheus',
            service_name: 'frr_exporter',
            user: 'frr-exporter',
            group: 'frr-exporter',
            manage_user: true,
            manage_group: true,
            extra_groups: ['frr'],
            options: '--frr.socket.dir-path=/var/run/frr --web.listen-address=:9342 --web.telemetry-path=/metrics --log.level=info --collector.bgp.peer-descriptions --collector.bgp.peer-types'
          )
        }
      end

      context 'with custom parameters' do
        let(:params) do
          {
            version: '1.8.0',
            web_listen_address: ':9999',
            frr_socket_dir: '/tmp/frr',
            peer_descriptions: false,
            peer_types: false,
            advertised_prefixes: true,
            log_level: 'debug'
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_prometheus__daemon('frr_exporter').with(
            options: '--frr.socket.dir-path=/tmp/frr --web.listen-address=:9999 --web.telemetry-path=/metrics --log.level=debug --collector.bgp.advertised-prefixes'
          )
        }
      end

      context 'with all collectors enabled' do
        let(:params) do
          {
            version: '1.8.0',
            peer_descriptions: true,
            peer_types: true,
            advertised_prefixes: true
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_prometheus__daemon('frr_exporter').with(
            options: '--frr.socket.dir-path=/var/run/frr --web.listen-address=:9342 --web.telemetry-path=/metrics --log.level=info --collector.bgp.peer-descriptions --collector.bgp.peer-types --collector.bgp.advertised-prefixes'
          )
        }
      end

      context 'with service management disabled' do
        let(:params) do
          {
            version: '1.8.0',
            manage_service: false
          }
        end

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_prometheus__daemon('frr_exporter').with(
            manage_service: false
          )
        }
      end
    end
  end
end