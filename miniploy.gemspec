$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'
require 'miniploy'

Gem::Specification.new do |s|
  s.name    = 'miniploy'
  s.version = Miniploy::VERSION
  s.summary = 'Minimalistic deployment tool'
  s.description = <<-eoh.gsub(/^ +/, '')
    A minimal deployment tool using ssh and git.
  eoh

  s.author  = 'Thibault Jouan'
  s.email   = 'tj@a13.fr'

  s.files       = `git ls-files`.split "\n"
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
end
