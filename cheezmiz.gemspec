# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cheezmiz}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["parasquid"]
  s.date = %q{2010-02-20}
  s.description = %q{a ruby library for Chikka}
  s.email = %q{parasquid@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "cheezmiz.geany",
     "cheezmiz.gemspec",
     "docs/chikka-1.capture",
     "examples/callbacks.rb",
     "lib/broker.rb",
     "lib/cheezmiz.rb",
     "lib/helper.rb",
     "lib/protocol.rb",
     "lib/protocol/buddy.rb",
     "lib/protocol/client_ready.rb",
     "lib/protocol/connection_established.rb",
     "lib/protocol/information.rb",
     "lib/protocol/keep_alive.rb",
     "lib/protocol/login.rb",
     "lib/protocol/message.rb",
     "lib/protocol/submit.rb",
     "lib/protocol/system_message.rb",
     "lib/protocol/unknown_operation.rb",
     "test/helper.rb",
     "test/test_cheezmiz.rb"
  ]
  s.homepage = %q{http://github.com/parasquid/cheezmiz}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{a ruby library for Chikka}
  s.test_files = [
    "test/test_cheezmiz.rb",
     "test/helper.rb",
     "examples/callbacks.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionpool>, [">= 0.2.3"])
    else
      s.add_dependency(%q<actionpool>, [">= 0.2.3"])
    end
  else
    s.add_dependency(%q<actionpool>, [">= 0.2.3"])
  end
end

