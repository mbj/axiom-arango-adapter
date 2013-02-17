require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::For::Unary::Projection, '#root' do
  let(:relation) { base.project([:bar]) }

  subject { object.root }

  expect_aql <<-AQL
    FOR `projection` IN
      (FOR `base` IN `name` RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`})
      RETURN {"bar": `projection`.`bar`}
  AQL
end
