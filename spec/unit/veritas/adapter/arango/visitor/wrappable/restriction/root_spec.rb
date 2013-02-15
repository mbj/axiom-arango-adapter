require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Wrappable::Restriction, '#root' do
  subject { object.root }

  let(:relation) { base.restrict { |r| r.foo.eq('bar') } }

  expect_aql <<-AQL
    FOR `local_name` IN `name`
      FILTER (`local_name`.`foo` == "bar")
      RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
  AQL
end
