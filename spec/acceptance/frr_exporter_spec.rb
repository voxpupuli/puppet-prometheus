# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'prometheus frr exporter' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      class { 'prometheus::frr_exporter': }
      PUPPET
    end
  end

  describe service('frr_exporter') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe port(9342) do
    it { is_expected.to be_listening.with('tcp6') }
  end
end
