require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::For::Binary::Join, '#local_name' do
  let(:object) { described_class.new(node, context) }
  let(:node)   { mock('Node') }
  subject { object.local_name }


  context 'as root' do
    let(:context) { nil }
    it { should eql(AQL.name_node(:local_0)) }
    it_should_behave_like 'an idempotent method'
  end

  context 'as non root' do
    let(:context) { mock('Context', :depth => 0) }
    it { should eql(AQL.name_node(:local_1)) }
    it_should_behave_like 'an idempotent method'
  end
end
