# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'daemon' do
  describe 'install node_exporter' do
    it 'installs node_exporter with no errors' do
      pp = "
      include prometheus
      $notify_service = Service[node_exporter]
      prometheus::daemon { 'node_exporter':
        version => '1.8.2',
        real_download_url => 'https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz',
        notify_service => $notify_service,
        user => 'node-exporter',
        group => 'node-exporter',
        export_scrape_job => true,
        scrape_host => 'localhost',
        scrape_port => 9100,
       }
      "
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('node_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(9100) do
      it { is_expected.to be_listening.with('tcp6') }
    end
  end

  describe 'uninstall' do
    it 'deletes node_exporter with no errors' do
      pp = "
      include prometheus
      $notify_service = Service[node_exporter]
      prometheus::daemon { 'node_exporter':
        ensure => 'absent',
        version => '1.8.2',
        real_download_url => 'https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz',
        notify_service => $notify_service,
        user => 'node-exporter',
        group => 'node-exporter',
        export_scrape_job => true,
        scrape_host => 'localhost',
        scrape_port => 9100,
       }
      "
      apply_manifest(pp, catch_failures: true)
    end

    describe process('node_exporter') do
      it { is_expected.not_to be_running }
    end

    # rubocop:disable RSpec/RepeatedExampleGroupBody
    describe user('node-exporter') do
      it { is_expected.not_to exist }
    end

    describe file('/usr/local/bin/node_exporter') do
      it { is_expected.not_to exist }
    end

    describe file('/etc/systemd/system/node_exporter.service') do
      it { is_expected.not_to exist }
    end

    describe file('/opt/node_exporter-1.8.2.linux-amd64/node_exporter') do
      it { is_expected.not_to exist }
    end
    # rubocop:enable RSpec/RepeatedExampleGroupBody
  end
end
