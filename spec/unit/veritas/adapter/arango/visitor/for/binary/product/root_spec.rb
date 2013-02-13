require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::For::Binary::Product, '#root' do
  subject { object.root }

  let(:node) { base.product(base_b) }

  expect_aql <<-AQL
    FOR `left` IN (FOR `local_name` IN `name` RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`})
      FOR `right` IN (FOR `local_name_b` IN `name_b` RETURN {"baz": `local_name_b`.`baz`})
        RETURN {"foo": `left`.`foo`, "bar": `left`.`bar`, "baz": `right`.`baz`}
  AQL
end
