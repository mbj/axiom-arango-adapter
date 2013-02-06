require 'spec_helper'

describe Veritas::Adapter::Arango, 'aql generation' do

  let(:header)        { Veritas::Relation::Header.coerce([[:foo, String]]) }
  let(:base_relation) { Veritas::Relation::Base.new(:collection, header)   }

  subject { Veritas::Adapter::Arango::Visitor.run(relation) }

  def compress_aql(string)
    string.split("\n").map { |str| str.gsub(/\A[ ]*/, '') }.join(' ')
  end

  def self.expect_aql(string)
    let(:expected_aql) { compress_aql(string) }
    it { should eql(expected_aql) }
  end

  context 'no restriction' do
    let(:relation) { base_relation }

    expect_aql <<-AQL
      FOR `local_collection` IN `collection`
        RETURN {"foo": `local_collection`.`foo`}
    AQL
  end

  context 'simple restriction' do
    let(:relation) { base_relation.restrict { |r| r.foo.eq("bar") } }

    expect_aql <<-AQL
      FILTER (`local_collection`.`foo` == "bar")
    AQL

    # With unwinding implemented:
    #
    #expect_aql <<-AQL
    #  FOR `local_collection` IN `collection`
    #    FILTER `local_collection`.`foo` == "bar"
    #    RETURN {"foo": `local_collection`.`foo`}'
    #AQL
  end
   
  context 'multiple restriction' do
    let(:relation) { base_relation.restrict { |r| r.foo.eq("bar").or(r.foo.eq("baz")) } }

    expect_aql <<-AQL
      FILTER ((`local_collection`.`foo` == "bar") || (`local_collection`.`foo` == "baz"))
    AQL

    # With unwinding implemented:
    #
    #expect_aql <<-AQL
    #  FOR `local_collection` IN `collection`
    #  FILTER ((`local_collection`.`foo` == "bar") || (`local_collection`.`foo` == "baz"))
    #    RETURN {"foo": `local_collection`.`foo`}'
    #AQL
  end
end
