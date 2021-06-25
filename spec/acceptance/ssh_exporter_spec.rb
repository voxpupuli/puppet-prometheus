require 'spec_helper_acceptance'

describe 'prometheus ssh exporter' do
  it 'ssh_exporter works idempotently with no errors' do
    pp = 'include prometheus::ssh_exporter'
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe service('ssh_exporter') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end
  describe port(9312) do
    it { is_expected.to be_listening.with('tcp6') }
  end
end
