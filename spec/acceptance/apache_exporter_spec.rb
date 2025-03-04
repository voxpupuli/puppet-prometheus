# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'prometheus apache exporter' do
  it 'apache_exporter works idempotently with no errors' do
    pp = 'include prometheus::apache_exporter'
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe 'default install' do
    describe service('apache_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(9117) do
      it { is_expected.to be_listening.with('tcp6') }
    end

    describe process('apache_exporter') do
      its(:args) { is_expected.to match %r{\ --scrape_uri http://localhost/server-status/\?auto} }
    end
  end

  # rubocop:disable RSpec/RepeatedExampleGroupBody,RSpec/RepeatedExampleGroupDescription
  describe 'apache_exporter update from 1.0.0 to 1.0.9' do
    it 'is idempotent' do
      pp = "class{'prometheus::apache_exporter': version => '1.0.0'}"
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('apache_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe process('apache_exporter') do
      its(:args) { is_expected.to match %r{\ --scrape_uri http://localhost/server-status/\?auto} }
    end

    describe port(9117) do
      it { is_expected.to be_listening.with('tcp6') }
    end

    it 'is idempotent' do
      pp = "class{'prometheus::apache_exporter': version => '1.0.9'}"
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('apache_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe process('apache_exporter') do
      its(:args) { is_expected.to match %r{\ --scrape_uri http://localhost/server-status/\?auto} }
    end

    describe port(9117) do
      it { is_expected.to be_listening.with('tcp6') }
    end
  end
  # rubocop:enable RSpec/RepeatedExampleGroupBody,RSpec/RepeatedExampleGroupDescription
end
