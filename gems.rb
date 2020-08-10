source "https://rubygems.org"

# Specify your gem's dependencies in thread-local.gemspec
gemspec

group :maintenance, optional: true do
	gem "bake-bundler"
	gem "bake-modernize"
	
	gem "utopia-project", path: "../utopia-project"
end
