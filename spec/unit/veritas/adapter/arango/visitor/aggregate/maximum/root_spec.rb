require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Aggregate::Maximum, '#root' do

  let(:object)  { described_class.new(relation, context) }
  let(:context) { AQL.name_node('collect') }

  subject { object.root }

  let(:relation) { base.summarize([:bar]) { |r| r.add(:max, r.foo.max) }.summarizers.values.first }

  expect_aql <<-AQL
    MAX((FOR `aggregate` IN `collect` FILTER (`aggregate`.`summarization`.`foo` != null) RETURN `aggregate`.`summarization`.`foo`))
  AQL
end
