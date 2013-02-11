require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Operation::Restriction, '#root' do
  let(:node)    { base.restrict { |r| r.foo.eq('bar') } }
  let(:context) { nil                                   }

  subject { object.root }

  expect_aql <<-AQL
    FOR `local_name` IN `name`
      FILTER (`local_name`.`foo` == "bar")
      RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
  AQL
end
