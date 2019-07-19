require 'spec_helper_acceptance'

describe 'prometheus redis exporter' do
  it 'redis_exporter works idempotently with no errors' do
    pp = 'include prometheus::redis_exporter'
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe service('redis_exporter') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end
  describe port(9121) do
    it { is_expected.to be_listening.with('tcp6') }
  end

  describe 'redis_exporter update from 0.11.2 to 1.0.3' do
    it 'is idempotent' do
      pp = "class{'prometheus::redis_exporter': version => '0.11.2'}"
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('redis_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(9121) do
      it { is_expected.to be_listening.with('tcp6') }
    end
    it 'is idempotent' do
      pp = "class{'prometheus::redis_exporter': version => '1.0.3'}"
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('redis_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(9121) do
      it { is_expected.to be_listening.with('tcp6') }
    end
  end
end
