require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Header, '#root' do
  subject { object.root }

  let(:relation) { base.header }
  let(:context)  { mock('Context', :local_name => AQL.name_node(:local_name)) }

  expect_aql <<-AQL
    {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
  AQL
end
