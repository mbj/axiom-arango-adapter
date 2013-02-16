require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::For::Binary::Product, '#root' do
  subject { object.root }

  let(:relation) { base.product(base_b) }

  expect_aql <<-AQL
    FOR `left` IN (FOR `base` IN `name` RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`})
      FOR `right` IN (FOR `base` IN `name_b` RETURN {"baz": `base`.`baz`})
        RETURN {"foo": `left`.`foo`, "bar": `left`.`bar`, "baz": `right`.`baz`}
  AQL
end
