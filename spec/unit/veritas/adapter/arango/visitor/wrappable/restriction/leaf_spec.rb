require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Wrappable::Restriction, '#root' do
  subject { object.leaf }
  let(:node)    { base.restrict { |r| r.foo.eq('bar') } }

  expect_aql <<-AQL
    FILTER (`local_name`.`foo` == "bar")
  AQL
end
