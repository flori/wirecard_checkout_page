# -*- encoding: utf-8 -*-
# stub: wirecard_checkout_page 0.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "wirecard_checkout_page"
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Florian Frank"]
  s.date = "2014-10-17"
  s.description = "This library allows you to use the Wirecard Checkout Page service."
  s.email = "flori@ping.de"
  s.extra_rdoc_files = ["README.md", "lib/wirecard_checkout_page.rb", "lib/wirecard_checkout_page/checksum_creation_failed.rb", "lib/wirecard_checkout_page/checksum_verification_failed.rb", "lib/wirecard_checkout_page/errors.rb", "lib/wirecard_checkout_page/request_checksum.rb", "lib/wirecard_checkout_page/response_checksum.rb", "lib/wirecard_checkout_page/utils.rb", "lib/wirecard_checkout_page/value_missing.rb", "lib/wirecard_checkout_page/version.rb", "lib/wirecard_checkout_page/wirecard_checkout_page_error.rb"]
  s.files = [".gitignore", ".rspec", ".travis.yml", "Gemfile", "README.md", "Rakefile", "VERSION", "lib/wirecard_checkout_page.rb", "lib/wirecard_checkout_page/checksum_creation_failed.rb", "lib/wirecard_checkout_page/checksum_verification_failed.rb", "lib/wirecard_checkout_page/errors.rb", "lib/wirecard_checkout_page/request_checksum.rb", "lib/wirecard_checkout_page/response_checksum.rb", "lib/wirecard_checkout_page/utils.rb", "lib/wirecard_checkout_page/value_missing.rb", "lib/wirecard_checkout_page/version.rb", "lib/wirecard_checkout_page/wirecard_checkout_page_error.rb", "spec/request_checksum_spec.rb", "spec/response_checksum_spec.rb", "spec/spec_helper.rb", "wirecard_checkout_page.gemspec"]
  s.homepage = "http://flori.github.com/wirecard_checkout_page"
  s.licenses = ["Apache-2.0"]
  s.rdoc_options = ["--title", "WirecardCheckoutPage -- Wirecard Checkout Page implementation", "--main", "README.md"]
  s.rubygems_version = "2.2.2"
  s.summary = "Library for using Wirecard Checkout Page"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<gem_hadar>, ["~> 1.0.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_runtime_dependency(%q<typhoeus>, [">= 0"])
    else
      s.add_dependency(%q<gem_hadar>, ["~> 1.0.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<typhoeus>, [">= 0"])
    end
  else
    s.add_dependency(%q<gem_hadar>, ["~> 1.0.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<typhoeus>, [">= 0"])
  end
end
