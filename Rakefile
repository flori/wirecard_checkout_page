# vim: set filetype=ruby et sw=2 ts=2:

require 'gem_hadar'

GemHadar do
  name        'wirecard_checkout_page'
  author      'Florian Frank'
  email       'flori@ping.de'
  homepage    "http://flori.github.com/#{name}"
  summary     'Library for using Wirecard Checkout Page'
  description 'This library allows you to use the Wirecard Checkout Page service.'
  test_dir    'tests'
  ignore      '.*.sw[pon]', 'pkg', 'Gemfile.lock', 'coverage', '.rvmrc', '.AppleDouble', '.DS_Store'
  readme      'README.md'
  title       "#{name.camelize} -- Wirecard Checkout Page implementation"
  licenses    << 'Apache-2.0'

  dependency             'typhoeus'
  development_dependency 'rake'
  development_dependency 'simplecov'
  development_dependency 'rspec'
end

task :default => :spec
