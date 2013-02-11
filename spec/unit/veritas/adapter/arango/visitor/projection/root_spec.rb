require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Projection, '#root' do
  let(:node) { base.project([:bar]) }

  subject { object.root }

  expect_aql <<-AQL
    FOR `projection` IN
      (FOR `local_name` IN `name`
      RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`})
      RETURN {"bar": `projection`.`bar`}
  AQL
end
