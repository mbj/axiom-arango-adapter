require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::For::Unary::Order, '#root' do
  subject { object.root }

  let(:relation) { base.sort_by { |r| [r.foo.asc, r.bar.asc] } }

  expect_aql <<-AQL
    FOR `order` IN
      (FOR `base` IN `name` RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`})
      SORT `order`.`foo` ASC, `order`.`bar` ASC
      RETURN {"foo": `order`.`foo`, "bar": `order`.`bar`}
  AQL
end
