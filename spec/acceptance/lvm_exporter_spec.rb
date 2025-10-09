# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'prometheus lvm_exporter' do
  it 'lvm_exporter works idempotently with no errors' do
    pp = 'include prometheus::lvm_exporter'
    # Run it twice and test for idempotency
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe service('lvm_exporter') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe port(9845) do
    it { is_expected.to be_listening.with('tcp6') }
  end

  # rubocop:disable RSpec/RepeatedExampleGroupBody,RSpec/RepeatedExampleGroupDescription
  describe 'lvm_exporter update from 0.5.0 to 0.6.2' do
    it 'is idempotent' do
      pp = "class{'prometheus::lvm_exporter': version => '0.5.t0'}"
      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('lvm_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(9845) do
      it { is_expected.to be_listening.with('tcp6') }
    end

    it 'is idempotent' do
      pp = "class{'prometheus::lvm_exporter': version => '0.6.2'}"
      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('lvm_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(9845) do
      it { is_expected.to be_listening.with('tcp6') }
    end
  end
  # rubocop:enable RSpec/RepeatedExampleGroupBody,RSpec/RepeatedExampleGroupDescription
end
