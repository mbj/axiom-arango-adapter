require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Extension, '#root' do
  let(:node)    { base.extend { |r| r.add(:baz, r.bar * 2) } }
  let(:context) { mock('Context', :local_name => AQL.name_node('local_name')) }

  subject { object.root }

  expect_aql <<-AQL
    FOR `extension` IN
      (FOR `local_name` IN `name` RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`})
      RETURN {"foo": `extension`.`foo`, "bar": `extension`.`bar`, "baz": (`extension`.`bar` * 2)}
  AQL
end
