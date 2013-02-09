require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor, '.run' do
  let(:object) { described_class }

  let(:node)         { mock('Veritas Node')               }
  let(:root_context) { described_class::Root.new(node)    }
  let(:aql_node)     { mock('AQL Node')                   }
  let(:visitor)      { mock('Visitor', :root => aql_node) }

  subject { object.run(node) }

  before do
    object.should_receive(:visitor).with(node, root_context).and_return(visitor)
  end

  it { should be(aql_node) }
end
