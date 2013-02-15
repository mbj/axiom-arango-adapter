require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::For::Binary::Join, '#root' do
  subject { object.root }

  let(:relation) { base.join(base_c) }

  expect_aql <<-AQL
    FOR `left` IN (FOR `local_name` IN `name` RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`})
      FOR `right` IN (FOR `local_name_c` IN `name_c` RETURN {"baz": `local_name_c`.`baz`, "bar": `local_name_c`.`bar`})
        FILTER (`left`.`bar` == `right`.`bar`)
        RETURN {"foo": `left`.`foo`, "bar": `left`.`bar`, "baz": `right`.`baz`}
  AQL
end
