require 'spec_helper_acceptance'

describe 'prometheus rabbitmq_exporter' do
  it 'rabbitmq_exporter works idempotently with no errors' do
    pp = 'include prometheus::rabbitmq_exporter'
    # Run it twice and test for idempotency
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe service('rabbitmq_exporter') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe port(9090) do
    it { is_expected.to be_listening.with('tcp6') }
  end

  describe 'rabbitmq_exporter update from 0.25.2 to 0.29.0' do
    it 'is idempotent' do
      pp = "class{'prometheus::rabbitmq_exporter': version => '0.25.2'}"
      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('rabbitmq_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(9090) do
      it { is_expected.to be_listening.with('tcp6') }
    end
    it 'is idempotent' do
      pp = "class{'prometheus::rabbitmq_exporter': version => '0.29.0'}"
      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('rabbitmq_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(9090) do
      it { is_expected.to be_listening.with('tcp6') }
    end
  end
end
