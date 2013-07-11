require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", 'tests/**/*.pp']

task :test => [:spec, :lint]

task :default => :test
