# Managed by modulesync - DO NOT EDIT
# https://voxpupuli.org/docs/updating-files-managed-with-modulesync/

source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :test do
  gem 'voxpupuli-test', '~> 5.4',   :require => false
  gem 'coveralls',                  :require => false
  gem 'simplecov-console',          :require => false
  gem 'puppet_metadata', '~> 2.0',  :require => false
end

group :development do
  gem 'guard-rake',               :require => false
  gem 'overcommit', '>= 0.39.1',  :require => false
end

group :system_tests do
  gem 'beaker', '~> 5.1'
  gem 'beaker-puppet', git: 'https://github.com/bastelfreak/beaker-puppet', branch: 'eol'
  gem 'beaker_puppet_helpers', git: 'https://github.com/bastelfreak/beaker_puppet_helpers', branch: 'ruby32'
  gem 'beaker-module_install_helper'
  gem 'voxpupuli-acceptance', git: 'https://github.com/bastelfreak/voxpupuli-acceptance', branch: 'drop-puppet-install-helper'
end

group :release do
  gem 'github_changelog_generator', '>= 1.16.1',  :require => false if RUBY_VERSION >= '2.5'
  gem 'voxpupuli-release', '>= 1.2.0',            :require => false
  gem 'puppet-strings', '>= 2.2',                 :require => false
end

gem 'rake', :require => false
gem 'facter', ENV['FACTER_GEM_VERSION'], :require => false, :groups => [:test]

puppetversion = ENV['PUPPET_GEM_VERSION'] || '>= 6.0'
gem 'puppet', puppetversion, :require => false, :groups => [:test]

# vim: syntax=ruby
