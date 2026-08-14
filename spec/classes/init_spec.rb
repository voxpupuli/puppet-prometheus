# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'without parameters' do
        it {
          is_expected.to compile.with_all_deps
        }

        it {
          is_expected.not_to contain_file('/opt/prometheus')
        }
      end

      context 'with activated url release cleaning' do
        let(:params) do
          {
            clean_url_releases: true,
          }
        end

        it {
          is_expected.to compile.with_all_deps
        }

        it {
          is_expected.to contain_file('/opt/prometheus').with(
            ensure: 'directory',
            owner: 'root',
            group: 'root',
            mode: '0755',
            backup: false,
            force: true,
            purge: true,
            recurse: true
          )
        }
      end
    end
  end
end
