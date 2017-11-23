require 'spec_helper'

describe 'prometheus::postgres_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with version specified' do
        let(:params) do
          {
            version: '1.0.0',
            arch: 'amd64',
            os: 'linux'
          }
        end

        describe 'compile manifest' do
          it { is_expected.to compile.with_all_deps }
        end

        describe 'install correct binary' do
          it { is_expected.to contain_file('/usr/local/bin/postgres_exporter').with('target' => '/opt/postgres_exporter-1.0.0.linux-amd64/postgres_exporter') }
        end
      end
    end
  end
end
