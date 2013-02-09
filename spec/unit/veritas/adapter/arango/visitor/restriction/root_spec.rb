require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Restriction, '#root' do
  let(:node)    { base.restrict { |r| r.foo.eq('bar') }              }
  let(:context) { mock('Visitor Context', :root? => true)            }
  let(:object)  { described_class.new(node, context)                 }

  subject { object.root }

  expect_aql <<-AQL
    FOR `local_name` IN `name`
      FILTER (`local_name`.`foo` == "bar")
      RETURN {"foo": `local_name`.`foo`}
  AQL

end
