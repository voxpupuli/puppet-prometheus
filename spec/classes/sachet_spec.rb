# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus::sachet' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'with version specified' do
        let(:params) do
          {
            version: '0.2.6',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url',
            receivers: [{
              name: 'telegram',
              provider: 'telegram',
              to: ['123456789'],
              text: '{{ .Status | title }}: {{ .CommonAnnotations.summary }}'
            }],
            providers: {
              telegram: {
                token: '724679217:aa26V5mK3e2qkGsSlTT-iHreaa5FUyy3Z_0'
              }
            }
          }
        end

        describe 'with specific params' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_archive('/tmp/sachet-0.2.6.tar.gz') }
          it { is_expected.to contain_class('prometheus') }
          it { is_expected.to contain_group('sachet') }
          it { is_expected.to contain_user('sachet') }
          it { is_expected.to contain_prometheus__daemon('sachet') }
          it { is_expected.to contain_service('sachet') }
        end

        describe 'install correct binary' do
          it { is_expected.to contain_file('/usr/local/bin/sachet').with('target' => '/opt/sachet-0.2.6.linux-amd64/sachet') }
        end

        describe 'config file contents' do
          it {
            is_expected.to contain_file('/etc/sachet/sachet.yaml').
              with_notify('Service[sachet]').
              with_content(%r{^---\n}).
              with_content(%r{^templates: \[\]\n}).
              with_content(%r{^receivers:\n}).
              with_content(%r{^- name: telegram\n}).
              with_content(%r{^  provider: telegram\n}).
              with_content(%r{^  to:\n}).
              with_content(%r{^  - '123456789'\n}).
              with_content(%r{^  text: "{{ .Status \| title }}: {{ .CommonAnnotations.summary }}"\n}).
              with_content(%r{^providers:\n}).
              with_content(%r{^  telegram:\n}).
              with_content(%r{^    token: 724679217:aa26V5mK3e2qkGsSlTT-iHreaa5FUyy3Z_0\n})
          }
        end
      end

      context 'with version specified and templates' do
        let(:params) do
          {
            version: '0.2.6',
            arch: 'amd64',
            os: 'linux',
            bin_dir: '/usr/local/bin',
            install_method: 'url',
            templates: [{
              name: 'notifications',
              template: "{{ define \"telegram_message\" }}\n" \
                        "{{ .Status | title }}: {{ .CommonAnnotations.summary }}\n" \
                        '{{ end }}'
            }],
            receivers: [{
              name: 'telegram',
              provider: 'telegram',
              to: ['123456789'],
              text: '{{ template "telegram_message" . }}'
            }],
            providers: {
              telegram: {
                token: '724679217:aa26V5mK3e2qkGsSlTT-iHreaa5FUyy3Z_0'
              }
            }
          }
        end

        it {
          is_expected.to contain_file('/etc/sachet/templates/notifications.tmpl').
            with_content(%r{^{{ define "telegram_message" }}\n}).
            with_content(%r{^{{ .Status \| title }}: {{ .CommonAnnotations.summary }}\n}).
            with_content(%r{^{{ end }}})
        }

        it {
          is_expected.to contain_file('/etc/sachet/sachet.yaml').
            with_notify('Service[sachet]').
            with_content(%r{^---\n}).
            with_content(%r{^templates:\n}).
            with_content(%r{^- "/etc/sachet/templates/notifications.tmpl"\n}).
            with_content(%r{^receivers:\n}).
            with_content(%r{^- name: telegram\n}).
            with_content(%r{^  provider: telegram\n}).
            with_content(%r{^  to:\n}).
            with_content(%r{^  - '123456789'\n}).
            with_content(%r{^  text: '{{ template "telegram_message" . }}'\n}).
            with_content(%r{^providers:\n}).
            with_content(%r{^  telegram:\n}).
            with_content(%r{^    token: 724679217:aa26V5mK3e2qkGsSlTT-iHreaa5FUyy3Z_0\n})
        }
      end
    end
  end
end
