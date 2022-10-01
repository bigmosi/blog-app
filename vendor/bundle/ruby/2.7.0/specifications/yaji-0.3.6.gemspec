# -*- encoding: utf-8 -*-
# stub: yaji 0.3.6 ruby lib
# stub: ext/yaji/extconf.rb

Gem::Specification.new do |s|
  s.name = "yaji".freeze
  s.version = "0.3.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Couchbase".freeze]
  s.date = "2017-01-18"
  s.description = "YAJI is a ruby wrapper to YAJL providing iterator interface to streaming JSON parser".freeze
  s.email = "info@couchbase.com".freeze
  s.extensions = ["ext/yaji/extconf.rb".freeze]
  s.files = ["ext/yaji/extconf.rb".freeze]
  s.homepage = "https://github.com/avsej/yaji".freeze
  s.licenses = ["ASL-2".freeze]
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Yet another JSON iterator".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake-compiler>.freeze, [">= 0"])
    s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
    s.add_development_dependency(%q<curb>.freeze, [">= 0"])
  else
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rake-compiler>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, [">= 0"])
    s.add_dependency(%q<curb>.freeze, [">= 0"])
  end
end
