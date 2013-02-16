require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Wrappable::Restriction, '#root' do
  subject { object.root }

  let(:relation) { base.restrict { |r| r.foo.eq('bar') } }

  expect_aql <<-AQL
    FOR `base` IN `name`
      FILTER (`base`.`foo` == "bar")
      RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`}
  AQL
end
