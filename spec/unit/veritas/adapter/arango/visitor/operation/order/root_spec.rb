require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Operation::Order, '#root' do
  let(:node)    { base.sort_by { |r| [r.foo.asc, r.bar.asc] } }
  let(:context) { nil }

  subject { object.root }

  expect_aql <<-AQL
    FOR `local_name` IN `name`
      SORT `local_name`.`foo` ASC, `local_name`.`bar` ASC
      RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
  AQL

end
