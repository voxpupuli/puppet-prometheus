# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'prometheus' do
  it 'prometheus do not clean URL releases' do
    pp_dirty_v0152 = <<-EOS
      class { 'prometheus':
        clean_url_releases => false,
      }
      class { 'prometheus::node_exporter':
        version => '0.15.2',
      }
    EOS

    pp_dirty_v0160 = <<-EOS
      class { 'prometheus':
        clean_url_releases => false,
      }
      class { 'prometheus::node_exporter':
        version => '0.16.0',
      }
    EOS

    # Run it twice and test for idempotency
    apply_manifest(pp_dirty_v0152, catch_failures: true)
    apply_manifest(pp_dirty_v0152, catch_changes: true)

    # Run it twice and test for idempotency
    apply_manifest(pp_dirty_v0160, catch_failures: true)
    apply_manifest(pp_dirty_v0160, catch_changes: true)
  end

  # rubocop:disable RSpec/RepeatedExampleGroupBody,RSpec/RepeatedExampleGroupDescription
  describe service('node_exporter') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe port(9100) do
    it { is_expected.to be_listening.with('tcp6') }
  end

  describe file('/opt/node_exporter-0.15.2.linux-amd64') do
    it { is_expected.to exist }
  end

  describe file('/opt/node_exporter-0.16.0.linux-amd64') do
    it { is_expected.to exist }
  end
  # rubocop:enable RSpec/RepeatedExampleGroupBody,RSpec/RepeatedExampleGroupDescription

  it 'prometheus do clean URL releases' do
    pp_clean_v0152 = <<-EOS
      class { 'prometheus':
        clean_url_releases => false,
      }
      class { 'prometheus::node_exporter':
        version => '0.15.2',
      }
    EOS

    pp_clean_v0160 = <<-EOS
      class { 'prometheus':
        clean_url_releases => false,
      }
      class { 'prometheus::node_exporter':
        version => '0.16.0',
      }
    EOS

    # Run it twice and test for idempotency
    apply_manifest(pp_clean_v0152, catch_failures: true)
    apply_manifest(pp_clean_v0152, catch_changes: true)

    # Run it twice and test for idempotency
    apply_manifest(pp_clean_v0160, catch_failures: true)
    apply_manifest(pp_clean_v0160, catch_changes: true)
  end

  # rubocop:disable RSpec/RepeatedExampleGroupBody,RSpec/RepeatedExampleGroupDescription
  describe service('node_exporter') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe port(9100) do
    it { is_expected.to be_listening.with('tcp6') }
  end

  describe file('/opt/prometheus/node_exporter-0.15.2.linux-amd64') do
    it { is_expected.not_to exist }
  end

  describe file('/opt/prometheus/node_exporter-0.16.0.linux-amd64') do
    it { is_expected.to exist }
  end
  # rubocop:enable RSpec/RepeatedExampleGroupBody,RSpec/RepeatedExampleGroupDescription
end
