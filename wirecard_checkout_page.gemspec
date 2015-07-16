# -*- encoding: utf-8 -*-
# stub: wirecard_checkout_page 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "wirecard_checkout_page"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Florian Frank"]
  s.date = "2015-07-16"
  s.description = "This library allows you to use the Wirecard Checkout Page service."
  s.email = "flori@ping.de"
  s.extra_rdoc_files = ["README.md", "lib/wirecard_checkout_page.rb", "lib/wirecard_checkout_page/checked_response.rb", "lib/wirecard_checkout_page/errors.rb", "lib/wirecard_checkout_page/fingerprint.rb", "lib/wirecard_checkout_page/gateway.rb", "lib/wirecard_checkout_page/init_request.rb", "lib/wirecard_checkout_page/init_response.rb", "lib/wirecard_checkout_page/request.rb", "lib/wirecard_checkout_page/response_checksum.rb", "lib/wirecard_checkout_page/toolkit/recur_payment.rb", "lib/wirecard_checkout_page/toolkit/request.rb", "lib/wirecard_checkout_page/toolkit/response.rb", "lib/wirecard_checkout_page/utils.rb", "lib/wirecard_checkout_page/version.rb", "lib/wirecard_checkout_page/wirecard_checkout_page_error.rb"]
  s.files = [".gitignore", ".rspec", ".travis.yml", ".utilsrc", "Gemfile", "README.md", "Rakefile", "VERSION", "lib/wirecard_checkout_page.rb", "lib/wirecard_checkout_page/checked_response.rb", "lib/wirecard_checkout_page/errors.rb", "lib/wirecard_checkout_page/fingerprint.rb", "lib/wirecard_checkout_page/gateway.rb", "lib/wirecard_checkout_page/init_request.rb", "lib/wirecard_checkout_page/init_response.rb", "lib/wirecard_checkout_page/request.rb", "lib/wirecard_checkout_page/response_checksum.rb", "lib/wirecard_checkout_page/toolkit/recur_payment.rb", "lib/wirecard_checkout_page/toolkit/request.rb", "lib/wirecard_checkout_page/toolkit/response.rb", "lib/wirecard_checkout_page/utils.rb", "lib/wirecard_checkout_page/version.rb", "lib/wirecard_checkout_page/wirecard_checkout_page_error.rb", "spec/spec_helper.rb", "spec/wirecard_checkout_page/checked_response_spec.rb", "spec/wirecard_checkout_page/gateway_spec.rb", "spec/wirecard_checkout_page/init_request_spec.rb", "spec/wirecard_checkout_page/request_spec.rb", "spec/wirecard_checkout_page/response_checksum_spec.rb", "spec/wirecard_checkout_page/toolkit/recur_payment_spec.rb", "spec/wirecard_checkout_page/toolkit/request_spec.rb", "spec/wirecard_checkout_page/toolkit/response_spec.rb", "wirecard_checkout_page.gemspec"]
  s.homepage = "http://flori.github.com/wirecard_checkout_page"
  s.licenses = ["Apache-2.0"]
  s.rdoc_options = ["--title", "WirecardCheckoutPage -- Wirecard Checkout Page implementation", "--main", "README.md"]
  s.rubygems_version = "2.4.8"
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
