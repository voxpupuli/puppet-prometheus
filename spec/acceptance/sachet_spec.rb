# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'prometheus sachet' do
  it 'sachet works idempotently with no errors' do
    pp = <<-EOS
     class { 'prometheus::sachet':
            version => '0.2.6',
            receivers => [
              {
                name => 'telegram',
                provider => 'telegram',
                to => ['123456789'],
                text => '{{ .Status | title }}: {{ .CommonAnnotations.summary }}'
              }
            ],
            providers => { telegram => { token => '724679217:aa26V5mK3e2qkGsSlTT-iHreaa5FUyy3Z_0' } }
          }
    EOS
    # Run it twice and test for idempotency
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe service('sachet') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end
  # the class installs sachet that listens on port 9876

  describe port(9876) do
    it { is_expected.to be_listening.with('tcp6') }
  end
end
