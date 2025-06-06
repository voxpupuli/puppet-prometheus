# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::alerts' do
  let :title do
    'extra_alerts'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      let :pre_condition do
        'include prometheus::server'
      end

      [
        {
          version: '2.52.0',
          alerts: {
            groups: [
              {
                name: 'alert.rules',
                rules: [
                  {
                    'alert' => 'alert_name',
                    'expr' => 'up == 0',
                    'for' => '5min',
                    'labels' => { 'severity' => 'woops' },
                    'annotations' => {
                      'summary' => 'did a woops {{ $labels.instance }}'
                    }
                  }
                ]
              }
            ]
          },
          # location: '/etc/prometheus/rules',
          # user: 'prometheus',
          # group: 'prometheus',
          # bin_dir: '/usr/local/bin',
        }
      ].each do |parameters|
        context "with parameters #{parameters}" do
          let(:params) do
            parameters
          end

          prom_version = parameters[:version]
          prom_major = prom_version[0]

          it {
            expect(subject).to contain_file('/etc/prometheus/rules/extra_alerts.rules').with(
              'ensure' => 'file',
              'owner' => 'root',
              'group' => 'prometheus',
              'content' => File.read(File.join('spec', 'fixtures', 'files', "prometheus#{prom_major}.alert.rules"))
            ) # .that_notifies('Class[prometheus::service_reload]')
          }
        end
      end
    end
  end
end
