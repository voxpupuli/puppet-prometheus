require 'spec_helper'

describe "prometheus::node_exporter" do
  let :default_facts do
    {
        'operatingsystem' => 'CentOS',
        'osfamily' => 'Redhat',
        'operatingsystemrelease' => '7.0',
        'architecture' => 'amd64',
        'kernel' => 'Linux',
    }
  end

  context 'uses the correct binary path for version' do
    let(:facts) { default_facts }

    let(:params) { {:version => '0.10.0', :arch => 'amd64', :os => 'linux'} }

    it do
      should contain_file('/usr/local/bin/node_exporter').with({
        'target' => '/opt/staging/node_exporter-0.10.0.linux-amd64/node_exporter'
      })
    end
  end

  context 'uses the correct binary path for version' do
    let(:facts) { default_facts }

    let(:params) { {:version => '0.10.0', :arch => 'amd64', :os => 'linux'} }

    it do
      should contain_file('/usr/local/bin/node_exporter').with({
        'target' => '/opt/staging/node_exporter-0.10.0.linux-amd64/node_exporter'
      })
    end
  end
end
