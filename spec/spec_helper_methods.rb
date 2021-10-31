# frozen_string_literal: true

def os_specific_facts(facts)
  return { service_provider: 'systemd' } if %w[Archlinux Debian RedHat].include?(facts[:os]['family'])
end
