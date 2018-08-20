require 'spec_helper_acceptance'

describe 'prometheus mysqld exporter' do
  it 'mysqld_exporter works idempotently with no errors' do
    if default[:platform] =~ %r{ubuntu-18.04-amd64}
      pp = "package{'iproute2': ensure => present}"
      apply_manifest(pp, catch_failures: true)
    end
    pp = 'include prometheus::mysqld_exporter'
    # Run it twice and test for idempotency
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe 'default install' do
    describe service('mysqld_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end
    # the class installs an the mysqld_exporter that listens on port 9104
    describe port(9104) do
      it { is_expected.to be_listening.with('tcp6') }
    end
    describe process('mysqld_exporter') do
      its(:args) { is_expected.to match %r{\ -config.my-cnf} }
    end
  end

  describe 'update prometheus mysqld exporter' do
    it 'update mysqld_exporter to 0.11.0' do
      pp = "class {'prometheus::mysqld_exporter': version => '0.11.0' }"
      apply_manifest(pp, catch_failures: true)
    end
    describe process('mysqld_exporter') do
      its(:args) { is_expected.to match %r{\ --config.my-cnf} }
    end
  end
end
