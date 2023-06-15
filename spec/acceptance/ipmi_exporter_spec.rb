# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'prometheus ipmi exporter' do
  it 'ipmi_exporter works idempotently with no errors' do
    shell('puppet module install saz-sudo')
    pp = 'include prometheus::ipmi_exporter'
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe service('ipmi_exporter') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe port(9290) do
    it { is_expected.to be_listening.with('tcp6') }
  end
end
