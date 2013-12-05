require 'rubygems'
require 'rubygems/package_task'

spec = Gem::Specification.new do |gem|
  gem.name        = "hiera-multiyaml"
  gem.version     = "0.0.1"
  gem.summary     = "YAML backend supporting multiple datadirs for Hiera"
  gem.email       = "fpletz@fnordicwalking.de"
  gem.author      = "Franz Pletz"
  gem.homepage    = "http://github.com/fpletz/hiera-multiyaml"
  gem.description = "Hiera YAML backend that supports more than one datadir for the same hierachy"

  gem.require_path = "lib"
  gem.files        = Dir["lib/**/*"].select { |f| File.file? f }

  gem.add_dependency('hiera', '>=1.3.0')
end

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

task :default => :repackage
