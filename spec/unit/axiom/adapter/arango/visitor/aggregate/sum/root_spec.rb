require 'spec_helper'

describe Axiom::Adapter::Arango::Visitor::Aggregate::Sum, '#sum' do

  let(:object)  { described_class.new(relation, context) }
  let(:context) { AQL.name_node('collect') }

  subject { object.root }

  let(:relation) { base.summarize([:foo]) { |r| r.add(:count, r.bar.sum) }.summarizers.values.first }

  expect_aql <<-AQL
    SUM((FOR `aggregate` IN `collect` FILTER (`aggregate`.`summarization`.`bar` != null) RETURN `aggregate`.`summarization`.`bar`))
  AQL
end
