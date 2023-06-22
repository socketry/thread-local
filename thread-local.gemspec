# frozen_string_literal: true

require_relative "lib/thread/local/version"

Gem::Specification.new do |spec|
	spec.name = "thread-local"
	spec.version = Thread::Local::VERSION
	
	spec.summary = "Provides a class-level mixin to make thread local state easy."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.homepage = "https://github.com/socketry/thread-local"
	
	spec.files = Dir.glob(['{lib}/**/*', '*.md'], File::FNM_DOTMATCH, base: __dir__)
	
	spec.required_ruby_version = ">= 2.5.0"
	
	spec.add_development_dependency "bake-test"
	spec.add_development_dependency "bake-test-external"
	spec.add_development_dependency "bundler"
	spec.add_development_dependency "covered"
	spec.add_development_dependency "rspec"
end
