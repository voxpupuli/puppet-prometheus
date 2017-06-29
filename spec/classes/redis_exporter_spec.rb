require 'spec_helper'

describe 'prometheus::redis_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with version specified' do
        let(:params) do
          {
            version: '0.11.2',
            arch: 'amd64',
            os: 'linux'
          }
        end

        describe 'install correct binary' do
          it { is_expected.to contain_file('/usr/local/bin/redis_exporter').with('target' => '/opt/redis_exporter-0.11.2.linux-amd64/redis_exporter') }
        end
      end
    end
  end
end
