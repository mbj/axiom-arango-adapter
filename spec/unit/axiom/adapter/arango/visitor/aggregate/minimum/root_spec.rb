require 'spec_helper'

describe Axiom::Adapter::Arango::Visitor::Aggregate::Minimum, '#root' do

  let(:object)  { described_class.new(relation, context) }
  let(:context) { AQL.name_node('collect') }

  subject { object.root }

  let(:relation) { base.summarize([:bar]) { |r| r.add(:min, r.foo.min) }.summarizers.values.first }

  expect_aql <<-AQL
    MIN((FOR `aggregate` IN `collect` FILTER (`aggregate`.`summarization`.`foo` != null) RETURN `aggregate`.`summarization`.`foo`))
  AQL
end
