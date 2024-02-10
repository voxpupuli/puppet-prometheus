# frozen_string_literal: true

# Managed by modulesync - DO NOT EDIT
# https://voxpupuli.org/docs/updating-files-managed-with-modulesync/

require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  # there's a packaging bug on Debian 12, the distro packages don't pull in the *_core types
  install_puppet_module_via_pmt_on(host, 'puppetlabs-augeas_core') if fact_on(host, 'os.family') == 'Debian'
end

Dir['./spec/support/acceptance/**/*.rb'].sort.each { |f| require f }
