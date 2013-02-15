require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Binary, '#root' do

  let(:relation) { base.restrict { |r| r.foo.eq('bar') }.predicate }
  let(:context)  { mock('Visitor Context', :local_name => AQL::Node::Name.new('local_name')) }

  subject { object.root }

  expect_aql <<-AQL
    (`local_name`.`foo` == "bar")
  AQL

end

