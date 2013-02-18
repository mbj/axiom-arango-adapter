require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::For::Summarization, '#root' do

  let(:object) { described_class.new(relation, context) }
  let(:context) { mock('Context') }

  subject { object.root }

  context 'max' do
    let(:relation) { base.summarize([:foo]) { |r| r.add(:count, r.bar.max) } }

    expect_aql <<-AQL
      FOR `summarization` IN
        (FOR `base` IN `name` RETURN {\"foo\": `base`.`foo`, \"bar\": `base`.`bar`})
        COLLECT (`foo` = `summarization`.`foo`) INTO `collect`
        RETURN {"foo": `summarization`.`foo`, "count": MAX((FOR `aggregate` IN `collect` FILTER (`bar` != null) RETURN `aggregate`.`bar`))}
    AQL
  end

  context 'min' do
    let(:relation) { base.summarize([:foo]) { |r| r.add(:count, r.bar.min) } }

    expect_aql <<-AQL
      FOR `summarization` IN
        (FOR `base` IN `name` RETURN {\"foo\": `base`.`foo`, \"bar\": `base`.`bar`})
        COLLECT (`foo` = `summarization`.`foo`) INTO `collect`
        RETURN {"foo": `summarization`.`foo`, "count": MIN((FOR `aggregate` IN `collect` FILTER (`bar` != null) RETURN `aggregate`.`bar`))}
    AQL
  end

  context 'sum' do
    let(:relation) { base.summarize([:foo]) { |r| r.add(:count, r.bar.sum) } }

    expect_aql <<-AQL
      FOR `summarization` IN
        (FOR `base` IN `name` RETURN {\"foo\": `base`.`foo`, \"bar\": `base`.`bar`})
        COLLECT (`foo` = `summarization`.`foo`) INTO `collect`
        RETURN {"foo": `summarization`.`foo`, "count": SUM((FOR `aggregate` IN `collect` FILTER (`bar` != null) RETURN `aggregate`.`bar`))}
    AQL
  end

  context 'count' do
    let(:relation) { base.summarize([:bar]) { |r| r.add(:count, r.foo.count) } }

    expect_aql <<-AQL
      FOR `summarization` IN
        (FOR `base` IN `name` RETURN {\"foo\": `base`.`foo`, \"bar\": `base`.`bar`})
        COLLECT (`bar` = `summarization`.`bar`) INTO `collect`
        RETURN {"bar": `summarization`.`bar`, "count": LENGTH((FOR `aggregate` IN `collect` FILTER (`foo` != null) RETURN `aggregate`.`foo`))}
    AQL
  end
end
