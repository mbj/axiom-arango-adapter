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
      FOR `left` IN (FOR `base` IN `name` RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`})
        FOR `right` IN (FOR `base` IN `name_c` RETURN {"baz": `base`.`baz`, "bar": `base`.`bar`})
          FILTER (`left`.`bar` == `right`.`bar`)
          RETURN {"foo": `left`.`foo`, "bar": `left`.`bar`, "baz": `right`.`baz`}
    AQL
  end

  context 'product' do
    let(:relation) { base.product(base_b) }

    expect_aql <<-AQL
      FOR `left` IN (FOR `base` IN `name` RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`})
        FOR `right` IN (FOR `base` IN `name_b` RETURN {"baz": `base`.`baz`, "boz": `base`.`boz`})
          RETURN {"foo": `left`.`foo`, "bar": `left`.`bar`, "baz": `right`.`baz`, "boz": `right`.`boz`}
    AQL
  end

  context 'no restriction' do
    let(:relation) { base }

    expect_aql <<-AQL
      FOR `base` IN `name`
        RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`}
    AQL
  end

  context 'rename' do
    let(:relation) { base.rename(:bar => :baz) }

    expect_aql <<-AQL
      FOR `rename` IN
        (FOR `base` IN `name` RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`})
        RETURN {"foo": `rename`.`foo`, "baz": `rename`.`bar`}
    AQL
  end

  context 'extension' do
    let(:relation) { base.extend { |r| r.add(:baz, r.bar * 2) } }

    expect_aql <<-AQL
      FOR `extension` IN
        (FOR `base` IN `name` RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`})
        RETURN MERGE(`extension`, {"baz": (`extension`.`bar` * 2)})
    AQL
  end

  context 'projection' do
    let(:relation) { base.project([:bar]) }

    expect_aql <<-AQL
      FOR `projection` IN
        (FOR `base` IN `name`
        RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`})
        RETURN {"bar": `projection`.`bar`}
    AQL
  end

  context 'simple restriction' do
    let(:relation) { base.restrict { |r| r.foo.eq('bar') } }

    expect_aql <<-AQL
      FOR `base` IN `name`
        FILTER (`base`.`foo` == "bar")
        RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`}
    AQL
  end

  context 'complex restriction' do
    let(:relation) { base.restrict { |r| r.foo.eq('bar').or(r.foo.eq('baz')) } }

    expect_aql <<-AQL
      FOR `base` IN `name`
        FILTER ((`base`.`foo` == "bar") || (`base`.`foo` == "baz"))
        RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`}
    AQL
  end

  context 'nested restriction' do
    let(:relation) do 
      base.
        restrict { |r| r.foo.eq('bar') }.
        restrict { |r| r.bar.eq('baz') } 
    end

    expect_aql <<-AQL
      FOR `base` IN `name`
        FILTER (`base`.`foo` == "bar")
        FILTER (`base`.`bar` == "baz")
        RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`}
    AQL
  end

  let(:ordered) do
    base.
      sort_by { |r| [r.foo.asc, r.bar.asc] }
  end

  context 'ordered' do
    let(:relation) { ordered }

    expect_aql <<-AQL
      FOR `base` IN `name`
        SORT `base`.`foo` ASC, `base`.`bar` ASC
        RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`}
    AQL
  end

  context 'offset on base relation' do
    let(:relation) do 
      ordered.drop(10)
    end

    expect_aql <<-AQL
      FOR `base` IN `name`
        SORT `base`.`foo` ASC, `base`.`bar` ASC
        LIMIT 10, 2147483647
        RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`}
    AQL
  end

  context 'limit on base relation' do
    let(:relation) do 
      ordered.take(10)
    end

    expect_aql <<-AQL
      FOR `base` IN `name`
        SORT `base`.`foo` ASC, `base`.`bar` ASC
        LIMIT 0, 10
        RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`}
    AQL
  end

  context 'reversing relation' do
    let(:relation) { ordered.reverse }

    expect_aql <<-AQL
      REVERSE((FOR `base` IN `name`
        SORT `base`.`foo` ASC, `base`.`bar` ASC
        RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`}))
    AQL
  end
end
