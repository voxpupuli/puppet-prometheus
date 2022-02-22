# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'php-fpm exporter' do
  it 'php-fpm-exporter works idempotently with no errors' do
    pp = 'include prometheus::php_fpm_exporter'
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe 'default install' do
    describe service('php-fpm_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(9253) do
      it { is_expected.to be_listening.with('tcp6') }
    end

    # the describe process uses `ps -C` which truncates the cmd output to 15 characters on newer versions.
    if os == 'centos-7-x86_64'
      describe process('php-fpm_exporter') do
        its(:args) { is_expected.to match %r{\ server --phpfpm.scrape-uri tcp://127.0.0.1:9000/status} }
      end
    else
      describe process('php-fpm_exporte') do
        its(:args) { is_expected.to match %r{\ server --phpfpm.scrape-uri tcp://127.0.0.1:9000/status} }
      end
    end
  end
end
