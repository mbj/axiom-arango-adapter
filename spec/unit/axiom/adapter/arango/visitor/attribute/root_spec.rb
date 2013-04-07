require 'spec_helper'

describe Axiom::Adapter::Arango::Visitor::Attribute, '#root' do
  let(:relation) { base.header[:foo] }
  let(:context)  { mock('Visitor Context', :local_name => AQL::Node::Name.new('local_name')) }

  subject { object.root }

  it_should_behave_like 'an idempotent method'

  expect_aql('`local_name`.`foo`')
end
