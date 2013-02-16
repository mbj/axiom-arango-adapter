require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Wrappable::Order, '#root' do
  subject { object.root }

  let(:relation) { base.sort_by { |r| [r.foo.asc, r.bar.asc] } }

  expect_aql <<-AQL
    FOR `base` IN `name`
      SORT `base`.`foo` ASC, `base`.`bar` ASC
      RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`}
  AQL
end
