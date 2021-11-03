# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'prometheus openldap exporter' do
  it 'openldap_exporter works idempotently with no errors' do
    pp = 'include prometheus::openldap_exporter'
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe service('openldap_exporter') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe port(9330) do
    it { is_expected.to be_listening.with('tcp6') }
  end

  # rubocop:disable RSpec/RepeatedExampleGroupBody,RSpec/RepeatedExampleGroupDescription
  describe 'openldap_exporter works with ldap_binddn + ldap_password config' do
    it 'is idempotent' do
      pp = "class{'prometheus::openldap_exporter': version => '2.0', ldap_binddn => 'cn=user', ldap_password => 'password'}"
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('openldap_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(9330) do
      it { is_expected.to be_listening.with('tcp6') }
    end
  end

  describe 'openldap_exporter works with extra options defined' do
    it 'is idempotent' do
      pp = "class{'prometheus::openldap_exporter': version => '2.0', options => '--ldapAddr localhost:636'}"
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('openldap_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(9330) do
      it { is_expected.to be_listening.with('tcp6') }
    end
  end

  describe 'openldap_exporter update from 2.0 to 2.1' do
    it 'is idempotent' do
      pp = "class{'prometheus::openldap_exporter': version => '2.0'}"
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('openldap_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(9330) do
      it { is_expected.to be_listening.with('tcp6') }
    end

    it 'is idempotent' do
      pp = "class{'prometheus::openldap_exporter': version => '2.1'}"
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('openldap_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(9330) do
      it { is_expected.to be_listening.with('tcp6') }
    end
  end
  # rubocop:enable RSpec/RepeatedExampleGroupBody,RSpec/RepeatedExampleGroupDescription
end
