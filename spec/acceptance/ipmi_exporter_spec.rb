require 'spec_helper_acceptance'

describe 'prometheus ipmi exporter' do
  it 'ipmi_exporter works idempotently with no errors' do
    # TODO: Remove --ignore-dependencies once > 6.0.0 is released with https://github.com/saz/puppet-sudo/pull/268
    on hosts, puppet('module', 'install', 'saz-sudo', '--version', '6.0.0', '--ignore-dependencies')
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
