require 'spec_helper'

describe Axiom::Adapter::Arango::Visitor::For::Summarization, '#root' do

  let(:object) { described_class.new(relation, context) }
  let(:context) { mock('Context') }

  subject { object.root }

  context 'max' do
    let(:relation) { base.summarize([:foo]) { |r| r.add(:count, r.bar.max) } }

    expect_aql <<-AQL
      FOR `summarization` IN
        (FOR `base` IN `name` RETURN {\"foo\": `base`.`foo`, \"bar\": `base`.`bar`})
        COLLECT `foo` = `summarization`.`foo` INTO `collect`
        RETURN {"foo": `foo`, "count": MAX((FOR `aggregate` IN `collect` FILTER (`aggregate`.`summarization`.`bar` != null) RETURN `aggregate`.`summarization`.`bar`))}
    AQL
  end

  context 'min' do
    let(:relation) { base.summarize([:foo]) { |r| r.add(:count, r.bar.min) } }

    expect_aql <<-AQL
      FOR `summarization` IN
        (FOR `base` IN `name` RETURN {\"foo\": `base`.`foo`, \"bar\": `base`.`bar`})
        COLLECT `foo` = `summarization`.`foo` INTO `collect`
        RETURN {"foo": `foo`, "count": MIN((FOR `aggregate` IN `collect` FILTER (`aggregate`.`summarization`.`bar` != null) RETURN `aggregate`.`summarization`.`bar`))}
    AQL
  end

  context 'sum' do
    let(:relation) { base.summarize([:foo]) { |r| r.add(:count, r.bar.sum) } }

    expect_aql <<-AQL
      FOR `summarization` IN
        (FOR `base` IN `name` RETURN {\"foo\": `base`.`foo`, \"bar\": `base`.`bar`})
        COLLECT `foo` = `summarization`.`foo` INTO `collect`
        RETURN {"foo": `foo`, "count": SUM((FOR `aggregate` IN `collect` FILTER (`aggregate`.`summarization`.`bar` != null) RETURN `aggregate`.`summarization`.`bar`))}
    AQL
  end

  context 'count' do
    let(:relation) { base.summarize([:bar]) { |r| r.add(:count, r.foo.count) } }

    expect_aql <<-AQL
      FOR `summarization` IN
        (FOR `base` IN `name` RETURN {\"foo\": `base`.`foo`, \"bar\": `base`.`bar`})
        COLLECT `bar` = `summarization`.`bar` INTO `collect`
        RETURN {"bar": `bar`, "count": LENGTH((FOR `aggregate` IN `collect` FILTER (`aggregate`.`summarization`.`foo` != null) RETURN `aggregate`.`summarization`.`foo`))}
    AQL
  end
end
