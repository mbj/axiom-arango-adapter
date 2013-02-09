require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Restriction, '#root' do
  let(:node)    { base.restrict { |r| r.foo.eq('bar') }              }
  let(:context) { mock('Visitor Context', :root? => true)            }

  subject { object.leaf }

  expect_aql <<-AQL
    FILTER (`local_name`.`foo` == "bar")
  AQL

end
