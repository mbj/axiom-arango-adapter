require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::For::Binary::Join, '#root' do
  subject { object.root }

  let(:relation) { base.join(base_c) }

  expect_aql <<-AQL
    FOR `local_0` IN (FOR `base` IN `name` RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`})
      FOR `right` IN (FOR `base` IN `name_c` RETURN {"baz": `base`.`baz`, "bar": `base`.`bar`})
        FILTER (`local_0`.`bar` == `right`.`bar`)
        RETURN {"foo": `local_0`.`foo`, "bar": `local_0`.`bar`, "baz": `right`.`baz`}
  AQL
end
