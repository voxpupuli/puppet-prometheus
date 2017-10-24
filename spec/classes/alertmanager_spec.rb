require 'spec_helper'

describe 'prometheus::alertmanager' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with version specified' do
        let(:params) do
          {
            version: '0.9.1',
            arch: 'amd64',
            os: 'linux'
          }
        end

        describe 'install correct binary' do
          it { is_expected.to contain_file('/usr/local/bin/alertmanager').with('target' => '/opt/alertmanager-0.9.1.linux-amd64/alertmanager') }
        end
        describe 'config file contents' do
          it {
            is_expected.to contain_file('/etc/alertmanager/alertmanager.yaml')
            verify_contents(catalogue, '/etc/alertmanager/alertmanager.yaml', ['---', 'global:', '  smtp_smarthost: localhost:25', '  smtp_from: alertmanager@localhost'])
          }
        end
      end
    end
  end
end
