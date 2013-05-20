# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name     = 'axiom-arango-adapter'
  s.version  = '0.0.2'

  s.authors  = ['Markus Schirp']
  s.email    = 'mbj@seonic.net'
  s.summary  = 'The ArangoDB axiom adapter'
  s.homepage = 'http://github.com/mbj/axiom-arango-adapter'
  s.license  = 'MIT'

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.require_paths    = %w(lib)
  s.extra_rdoc_files = %w(README.md)

  s.add_dependency('aql',           '~> 0.0.3')
  s.add_dependency('axiom',         '~> 0.1.0')
  s.add_dependency('ashikawa-core', '~> 0.7.1')
  s.add_dependency('adamantium',    '~> 0.0.7')
  s.add_dependency('equalizer',     '~> 0.0.5')
  s.add_dependency('abstract_type', '~> 0.0.5')
  s.add_dependency('concord',       '~> 0.1.0')
  s.add_dependency('null_logger',   '~> 0.0.1')
end
