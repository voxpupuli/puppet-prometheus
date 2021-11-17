# frozen_string_literal: true

require 'puppet'

Facter.add('prometheus_alert_manager_running') do
  setcode do
    service = Puppet::Type.type(:service).new(:name => 'alert_manager') # rubocop:disable Style/HashSyntax
    service.provider.status == :running
  rescue Puppet::Error
    false
  end
end
