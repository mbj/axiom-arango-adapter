source 'https://rubygems.org'

gemspec

gem 'aql',           :git => 'https://github.com/mbj/aql.git'
gem 'composition',   :git => 'https://github.com/mbj/composition.git'
gem 'veritas',       :git => 'https://github.com/dkubb/veritas.git'

gem 'devtools',    :git => 'https://github.com/datamapper/devtools.git'
eval File.read('Gemfile.devtools')

group :fuzzer do
  gem 'diffy'
  gem 'terminal-table'
end
