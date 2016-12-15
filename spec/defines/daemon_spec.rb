require 'spec_helper'

describe "prometheus::daemon" do
  let :title do
    'node_exporter'
  end

  let :default_params do
    {
      install_method: 'url',
      version: '0.13.0',
      download_extension: 'tar.gz',
      os: 'linux',
      arch: 'amd64',
      bin_dir: '/usr/local/bin',
      notify_service: true,
      manage_user: true,
      user: 'node_exporter',
      extra_groups: [],
      group: 'node_exporter',
      manage_group: true,
      purge: true,
      options: '',
      init_style: 'systemd',
      service_ensure: true,
      service_enable: true,
      manage_service: true,
      real_download_url: "https://github.com/prometheus/node_exporter/releases/download/v0.13.0/node_exporter-0.13.0.linux-amd64.tar.gz",
      package_name: 'node_exporter',
      package_ensure: false,
    }
  end

  context 'should define a service' do
    let(:params) { default_params }

    it do
      should contain_service('node_exporter').with({
        'ensure' => true,
        'enable' => true,
      })
    end
  end

  context 'should create a link to the downloaded binary' do
    let(:params) { default_params }

    it do
      should contain_file('/usr/local/bin/node_exporter').with({
        'ensure' => 'link',
        'target' => '/opt/staging/node_exporter-0.13.0.linux-amd64/node_exporter'
      })
    end
  end

  context 'should create a user and group' do
    let(:params) { default_params }

    it do
      should contain_user('node_exporter').with({
        'ensure' => 'present',
      })
      should contain_group('node_exporter').with({
        'ensure' => 'present',
      })
    end
  end
end
