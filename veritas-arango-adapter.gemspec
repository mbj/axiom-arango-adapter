# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name     = 'veritas-arango-adapter'
  s.version  = '0.0.1'

  s.authors  = ['Markus Schirp']
  s.email    = 'mbj@seonic.net'
  s.summary  = 'The ArangoDB veritas adaper'
  s.homepage = 'http://github.com/mbj/veritas-arango-adapter'

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.require_paths    = %w(lib)
  s.extra_rdoc_files = %w(README.md)

  s.add_dependency('aql',           '~> 0.0.1')
  s.add_dependency('veritas',       '~> 0.0.7')
  s.add_dependency('ashikawa-core', '~> 0.6.0')
  s.add_dependency('adamantium',    '~> 0.0.6')
  s.add_dependency('equalizer',     '~> 0.0.4')
  s.add_dependency('abstract_type', '~> 0.0.4')
  s.add_dependency('composition',   '~> 0.0.1')
  s.add_dependency('null_logger',   '~> 0.0.1')
end
