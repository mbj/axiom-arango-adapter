require 'spec_helper'

describe Axiom::Adapter::Arango::Visitor::Aggregate::Count, '#root' do

  let(:object)  { described_class.new(relation, context) }
  let(:context) { AQL.name_node('collect') }

  subject { object.root }

  let(:relation) { base.summarize([:bar]) { |r| r.add(:count, r.foo.count) }.summarizers.values.first }

  expect_aql <<-AQL
    LENGTH((FOR `aggregate` IN `collect` FILTER (`aggregate`.`summarization`.`foo` != null) RETURN `aggregate`.`summarization`.`foo`))
  AQL
end
