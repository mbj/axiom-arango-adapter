require 'spec_helper'

describe Axiom::Adapter::Arango::Visitor::For::Unary::Offset, '#root' do
  subject { object.root }

  let(:relation) { base.sort_by { |r| [r.foo.asc, r.bar.asc] }.drop(5) }

  expect_aql <<-AQL
    FOR `offset` IN
      (FOR `order` IN
        (FOR `base` IN `name` RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`})
        SORT `order`.`foo` ASC, `order`.`bar` ASC
        RETURN {"foo": `order`.`foo`, "bar": `order`.`bar`})
      LIMIT 5, 2147483647
      RETURN {"foo": `offset`.`foo`, "bar": `offset`.`bar`}
  AQL
end
