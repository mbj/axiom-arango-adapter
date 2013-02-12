# encoding: utf-8

require 'veritas-arango-adapter'
require 'rspec'
require 'timeout'

# require spec support files and shared behavior
Dir[File.expand_path('../{support,shared}/**/*.rb', __FILE__)].each { |f| require(f) }

if RUBY_VERSION < '1.9'
  require 'rspec/autorun'
end

module InstanceMethodHelper
  def instance_method_defined?(name)
    instance_methods.map(&:to_sym).include?(name)
  end
end

module AQLHelper
  def compress_aql(string)
    string.gsub(/^[ ]*/, '').split("\n").join(' ')
  end

  def expect_aql(string)
    let(:header)  { Veritas::Relation::Header.coerce([[:foo, String], [:bar, Integer]]) }
    let(:base)    { Veritas::Relation::Base.new(:name, header) }
    let(:object)  { described_class.new(node, context) }

    let(:header_b) { Veritas::Relation::Header.coerce([[:baz, String]]) }
    let(:base_b)   { Veritas::Relation::Base.new(:name_b, header_b) }

    unless instance_method_defined?(:context)
      let(:context) { nil }
    end

    expected_aql = compress_aql(string)
    it_should_behave_like 'an idempotent method'
    its(:aql) { should eql(expected_aql) }
  end
end

RSpec.configure do |config|
  config.include(Veritas)
  config.extend(AQLHelper)
  config.extend(InstanceMethodHelper)
  config.around do |example|
    Timeout.timeout(1) do
      example.run
    end
  end
end
