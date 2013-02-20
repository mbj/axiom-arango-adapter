source 'https://rubygems.org'

gemspec

gem 'aql',           :git => 'https://github.com/mbj/aql.git'
gem 'veritas',       :git => 'https://github.com/mbj/veritas.git'
gem 'composition',   :git => 'https://github.com/mbj/composition.git'
gem 'ashikawa-core', :git => 'https://github.com/mbj/ashikawa-core.git', :branch => 'devtools'

# This commit fixes a false positive in mutant 
gem 'rspec-core',    :git => 'https://github.com/rspec/rspec-core', :ref => '56078dad21f7c1d55dcfb54045ff34423acc8873'

gem 'devtools',    :git => 'https://github.com/datamapper/devtools.git'
eval File.read('Gemfile.devtools')
