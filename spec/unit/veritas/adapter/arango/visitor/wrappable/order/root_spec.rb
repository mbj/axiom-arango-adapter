require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Wrappable::Order, '#root' do
  subject { object.root }

  let(:node)    { base.sort_by { |r| [r.foo.asc, r.bar.asc] } }

  expect_aql <<-AQL
    FOR `local_name` IN `name`
      SORT `local_name`.`foo` ASC, `local_name`.`bar` ASC
      RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
  AQL
end
