require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Wrappable::Restriction, '#leaf' do
  subject { object.leaf }
  let(:relation) { base.restrict { |r| r.foo.eq('bar') } }

  expect_aql <<-AQL
    FILTER (`base`.`foo` == "bar")
  AQL
end
