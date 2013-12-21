# -*- encoding: utf-8 -*-
# stub: memoizable 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "memoizable"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Kubb"]
  s.date = "2013-11-18"
  s.description = "Memoize method return values"
  s.email = "dan.kubb@gmail.com"
  s.extra_rdoc_files = ["LICENSE.md", "README.md", "CONTRIBUTING.md"]
  s.files = ["LICENSE.md", "README.md", "CONTRIBUTING.md"]
  s.homepage = "https://github.com/dkubb/memoizable"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.10"
  s.summary = "Memoize method return values"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thread_safe>, ["~> 0.1.3"])
      s.add_development_dependency(%q<bundler>, [">= 1.3.5", "~> 1.3"])
    else
      s.add_dependency(%q<thread_safe>, ["~> 0.1.3"])
      s.add_dependency(%q<bundler>, [">= 1.3.5", "~> 1.3"])
    end
  else
    s.add_dependency(%q<thread_safe>, ["~> 0.1.3"])
    s.add_dependency(%q<bundler>, [">= 1.3.5", "~> 1.3"])
  end
end
