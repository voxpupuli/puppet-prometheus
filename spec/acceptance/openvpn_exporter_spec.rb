# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'prometheus openvpn_exporter' do
  it 'openvpn_exporter works idempotently with no errors' do
    pp = 'include prometheus::openvpn_exporter'
    # Run it twice and test for idempotency
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe service('openvpn_exporter') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe port(9176) do
    it { is_expected.to be_listening.with('tcp6') }
  end
end
