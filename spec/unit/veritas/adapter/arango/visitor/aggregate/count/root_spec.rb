require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Aggregate::Count, '#root' do

  let(:object)  { described_class.new(relation, context) }
  let(:context) { AQL.name_node('collect') }

  subject { object.root }

  let(:relation) { base.summarize([:bar]) { |r| r.add(:count, r.foo.count) }.summarizers.values.first }

  expect_aql <<-AQL
    LENGTH((FOR `aggregate` IN `collect` FILTER (`foo` != null) RETURN `aggregate`.`foo`))
  AQL
end
