# encoding: utf-8

require 'axiom-arango-adapter'
require 'timeout'
require 'devtools'
Devtools.init_spec_helper

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
    let(:header)  { Axiom::Relation::Header.coerce([[:foo, String], [:bar, Integer]]) }
    let(:base)    { Axiom::Relation::Base.new(:name, header) }
    let(:object)  { described_class.new(relation, context) }

    # Disjunct header for projection
    let(:header_b) { Axiom::Relation::Header.coerce([[:baz, String]]) }
    let(:base_b)   { Axiom::Relation::Base.new(:name_b, header_b) }

    # Overlapping header for join
    let(:header_c) { Axiom::Relation::Header.coerce([[:baz, String], [:bar, Integer]]) }
    let(:base_c)   { Axiom::Relation::Base.new(:name_c, header_c) }

    unless instance_method_defined?(:context)
      let(:context) { nil }
    end

    expected_aql = compress_aql(string)
    it_should_behave_like 'an idempotent method'
    its(:aql) { should eql(expected_aql) }
  end
end

RSpec.configure do |config|
  config.include(Axiom)
  config.extend(AQLHelper)
  config.extend(InstanceMethodHelper)
  config.around do |example|
    Timeout.timeout(1) do
      example.run
    end
  end
end
