# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'prometheus postgres exporter' do
  it 'postgres_exporter works idempotently with no errors' do
    pp = <<-EOS
      class{'prometheus::postgres_exporter':
       postgres_pass => 'password',
       postgres_user => 'username'
      }
    EOS
    # Run it twice and test for idempotency
    apply_manifest(pp, catch_failures: true)
    apply_manifest(pp, catch_changes: true)
  end

  describe service('postgres_exporter') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  # the class installs an the postgres_exporter that listens on port 9187
  describe port(9187) do
    it { is_expected.to be_listening.with('tcp6') }
  end

  # rubocop:disable RSpec/RepeatedExampleGroupBody,RSpec/RepeatedExampleGroupDescription
  describe 'postgres_exporter works with custom data config' do
    pp = <<-EOS
      class{ 'prometheus::postgres_exporter':
        postgres_auth_method => 'custom',
        group => 'postgres',
        user => 'postgres',
        data_source_custom => {'DATA_SOURCE_NAME' => 'user=postgres host=/var/run/postgresql/ sslmode=disable',}
      }
    EOS
    # Run it twice and test for idempotency
    it 'apply catalog' do
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('postgres_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(9187) do
      it { is_expected.to be_listening.with('tcp6') }
    end
  end

  describe 'postgres_exporter update from 0.4.6 to 0.5.1' do
    it 'is idempotent' do
      pp = <<-EOS
        class{'prometheus::postgres_exporter':
          postgres_auth_method => 'custom',
          group => 'postgres',
          user => 'postgres',
          data_source_custom => {'DATA_SOURCE_NAME' => 'user=postgres host=/var/run/postgresql/ sslmode=disable',},
          version => '0.4.6'}
      EOS
      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('postgres_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(9187) do
      it { is_expected.to be_listening.with('tcp6') }
    end

    it 'is idempotent' do
      pp = <<-EOS
        class{'prometheus::postgres_exporter':
          postgres_auth_method => 'custom',
          group => 'postgres',
          user => 'postgres',
          data_source_custom => {'DATA_SOURCE_NAME' => 'user=postgres host=/var/run/postgresql/ sslmode=disable',},
          version => '0.5.1'
        }
      EOS
      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('postgres_exporter') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(9187) do
      it { is_expected.to be_listening.with('tcp6') }
    end
  end
  # rubocop:enable RSpec/RepeatedExampleGroupBody,RSpec/RepeatedExampleGroupDescription
end
