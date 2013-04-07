require 'spec_helper'

describe Axiom::Adapter::Arango::Visitor::For::Binary, '#local_name' do
  subject { object.local_name }

  let(:object) { described_class.new(relation, context) }

  let(:relation) { mock('Relation') }
  let(:context)  { mock('Context')  }

  it { should eql(AQL.name_node('left')) }

  it_should_behave_like 'an idempotent method'
end
