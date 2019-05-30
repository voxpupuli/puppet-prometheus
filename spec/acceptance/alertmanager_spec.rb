require 'spec_helper_acceptance'

describe 'prometheus alertmanager' do
  it 'alertmanager works idempotently with no errors' do
    pp = 'class { "prometheus::alertmanager": version => "0.17.0", extra_options => "--web.listen-address=127.0.0.1:9093"}'
    # Run it twice and test for idempotency
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe service('alertmanager') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end
  # the class installs an the alertmanager that listens on port 9093
  describe port(9093) do
    it { is_expected.to be_listening.with('tcp6') }
  end
end
