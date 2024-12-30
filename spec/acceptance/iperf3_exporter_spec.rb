# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'prometheus iperf3_exporter' do
  it 'iperf3_exporter works idempotently with no errors' do
    pp = 'include prometheus::iperf3_exporter'
    # Run it twice and test for idempotency
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe service('iperf3_exporter') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe port(9579) do
    it { is_expected.to be_listening.with('tcp6') }
  end

  # rubocop:disable RSpec/RepeatedExampleGroupBody,RSpec/RepeatedExampleGroupDescription
  describe 'iperf3_exporter update from 0.1.2 to 0.1.3' do
    it 'is idempotent' do
      pp = "class{'prometheus::iperf3_exporter': version => '0.1.2'}"
      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('iperf3_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(9579) do
      it { is_expected.to be_listening.with('tcp6') }
    end

    it 'is idempotent' do
      pp = "class{'prometheus::iperf3_exporter': version => '0.1.3'}"
      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('iperf3_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(9579) do
      it { is_expected.to be_listening.with('tcp6') }
    end
  end
  # rubocop:enable RSpec/RepeatedExampleGroupBody,RSpec/RepeatedExampleGroupDescription
end
