# encoding: utf-8

require 'veritas-arango-adapter'
require 'rspec'
require 'timeout'

# require spec support files and shared behavior
Dir[File.expand_path('../{support,shared}/**/*.rb', __FILE__)].each { |f| require(f) }

if RUBY_VERSION < '1.9'
  require 'rspec/autorun'
end

module AQLHelper
  def compress_aql(string)
    string.gsub(/^[ ]*/, '').split("\n").join(' ')
  end

  def expect_aql(string)
    let(:header)  { Veritas::Relation::Header.coerce([[:foo, String]]) }
    let(:base)    { Veritas::Relation::Base.new(:name, header)         }
    let(:object)  { described_class.new(node, context) }

    expected_aql = compress_aql(string)
    it_should_behave_like 'an idempotent method'
    its(:aql) { should eql(expected_aql) }
  end
end

RSpec.configure do |config|
  config.include(Veritas)
  config.extend(AQLHelper)
  config.around do |example|
    Timeout.timeout(1) do
      example.run
    end
  end
end
