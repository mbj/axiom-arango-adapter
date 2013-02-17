require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::For::Unary::Limit, '#root' do
  subject { object.root }

  let(:relation)    { base.sort_by { |r| [r.foo.asc, r.bar.asc] }.take(5) }

  expect_aql <<-AQL
    FOR `limit` IN
      (FOR `order` IN
        (FOR `base` IN `name` RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`})
        SORT `order`.`foo` ASC, `order`.`bar` ASC
        RETURN {"foo": `order`.`foo`, "bar": `order`.`bar`})
      LIMIT 0, 5
      RETURN {"foo": `limit`.`foo`, "bar": `limit`.`bar`}
  AQL
end
