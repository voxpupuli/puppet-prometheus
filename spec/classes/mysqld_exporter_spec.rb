require 'spec_helper'

describe 'prometheus::mysqld_exporter' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(os_specific_facts(facts))
      end

      context 'default' do
        describe 'options is correct' do
          it { is_expected.to contain_prometheus__daemon('mysqld_exporter').with('options' => '-config.my-cnf=/etc/.my.cnf ') }
        end
      end

      context 'with version >= 0.11.0' do
        let(:params) do
          {
            version: '0.11.0'
          }
        end

        describe 'options is correct' do
          it { is_expected.to contain_prometheus__daemon('mysqld_exporter').with('options' => '--config.my-cnf=/etc/.my.cnf ') }
        end
      end
    end
  end
end
