require 'spec_helper'

describe Veritas::Adapter::Arango, 'aql generation' do

  subject { Veritas::Adapter::Arango::Visitor.run(relation) }

  def self.expect_aql(string)
    let(:header)  { Veritas::Relation::Header.coerce([[:foo, String], [:bar, Integer]]) }
    let(:base)    { Veritas::Relation::Base.new(:name, header) }
    let(:object)  { described_class.new(relation, context) }

    let(:header_b) { Veritas::Relation::Header.coerce([[:baz, String], [:boz, Integer]]) }
    let(:base_b)   { Veritas::Relation::Base.new(:name_b, header_b) }

    let(:header_c) { Veritas::Relation::Header.coerce([[:baz, String], [:bar, Integer]]) }
    let(:base_c)   { Veritas::Relation::Base.new(:name_c, header_c) }

    expected_aql = compress_aql(string)
    its(:aql) { should eql(expected_aql) }
  end

  context 'join' do
    let(:relation) { base.join(base_c) }

    expect_aql <<-AQL
      FOR `left` IN (FOR `local_name` IN `name` RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`})
        FOR `right` IN (FOR `local_name_c` IN `name_c` RETURN {"baz": `local_name_c`.`baz`, "bar": `local_name_c`.`bar`})
          FILTER (`left`.`bar` == `right`.`bar`)
          RETURN {"foo": `left`.`foo`, "bar": `left`.`bar`, "baz": `right`.`baz`}
    AQL
  end

  context 'product' do
    let(:relation) { base.product(base_b) }

    expect_aql <<-AQL
      FOR `left` IN (FOR `local_name` IN `name` RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`})
        FOR `right` IN (FOR `local_name_b` IN `name_b` RETURN {"baz": `local_name_b`.`baz`, "boz": `local_name_b`.`boz`})
          RETURN {"foo": `left`.`foo`, "bar": `left`.`bar`, "baz": `right`.`baz`, "boz": `right`.`boz`}
    AQL
  end

  context 'no restriction' do
    let(:relation) { base }

    expect_aql <<-AQL
      FOR `local_name` IN `name`
        RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
    AQL
  end

  context 'rename' do
    let(:relation) { base.rename(:bar => :baz) }

    expect_aql <<-AQL
      FOR `rename` IN
        (FOR `local_name` IN `name` RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`})
        RETURN {"foo": `rename`.`foo`, "baz": `rename`.`bar`}
    AQL
  end

  context 'extension' do
    let(:relation) { base.extend { |r| r.add(:baz, r.bar * 2) } }

    expect_aql <<-AQL
      FOR `extension` IN
        (FOR `local_name` IN `name` RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`})
        RETURN MERGE(`extension`, {"baz": (`extension`.`bar` * 2)})
    AQL
  end

  context 'projection' do
    let(:relation) { base.project([:bar]) }

    expect_aql <<-AQL
      FOR `projection` IN
        (FOR `local_name` IN `name`
        RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`})
        RETURN {"bar": `projection`.`bar`}
    AQL
  end

  context 'simple restriction' do
    let(:relation) { base.restrict { |r| r.foo.eq('bar') } }

    expect_aql <<-AQL
      FOR `local_name` IN `name`
        FILTER (`local_name`.`foo` == "bar")
        RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
    AQL
  end

  context 'complex restriction' do
    let(:relation) { base.restrict { |r| r.foo.eq('bar').or(r.foo.eq('baz')) } }

    expect_aql <<-AQL
      FOR `local_name` IN `name`
        FILTER ((`local_name`.`foo` == "bar") || (`local_name`.`foo` == "baz"))
        RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
    AQL
  end

  context 'nested restriction' do
    let(:relation) do 
      base.
        restrict { |r| r.foo.eq('bar') }.
        restrict { |r| r.bar.eq('baz') } 
    end

    expect_aql <<-AQL
      FOR `local_name` IN `name`
        FILTER (`local_name`.`foo` == "bar")
        FILTER (`local_name`.`bar` == "baz")
        RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
    AQL
  end

  let(:ordered) do
    base.
      sort_by { |r| [r.foo.asc, r.bar.asc] }
  end

  context 'ordered' do
    let(:relation) { ordered }

    expect_aql <<-AQL
      FOR `local_name` IN `name`
        SORT `local_name`.`foo` ASC, `local_name`.`bar` ASC
        RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
    AQL
  end

  context 'offset on base relation' do
    let(:relation) do 
      ordered.drop(10)
    end

    expect_aql <<-AQL
      FOR `local_name` IN `name`
        SORT `local_name`.`foo` ASC, `local_name`.`bar` ASC
        LIMIT 10, 2147483647
        RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
    AQL
  end

  context 'limit on base relation' do
    let(:relation) do 
      ordered.take(10)
    end

    expect_aql <<-AQL
      FOR `local_name` IN `name`
        SORT `local_name`.`foo` ASC, `local_name`.`bar` ASC
        LIMIT 0, 10
        RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
    AQL
  end

  context 'reversing relation' do
    let(:relation) { ordered.reverse }

    expect_aql <<-AQL
      REVERSE((FOR `local_name` IN `name`
        SORT `local_name`.`foo` ASC, `local_name`.`bar` ASC
        RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}))
    AQL
  end
end
