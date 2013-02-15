require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::For::Binary, '#local_name' do
  subject { object.local_name }

  let(:object) { described_class.new(node, context) }

  let(:node)    { mock('Node') }
  let(:context) { mock('Context') }

  it { should eql(AQL.name_node('left')) }

  it_should_behave_like 'an idempotent method'
end
