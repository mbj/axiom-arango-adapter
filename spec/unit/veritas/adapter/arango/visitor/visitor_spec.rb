require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor, '#visitor' do
  let(:object) { class_under_test.new(node, context) }

  let(:node)     { mock('Veritas Node')               }
  let(:aql_node) { mock('AQL Node')                   }
  let(:context)  { mock('Context')                    }
  let(:visitor)  { mock('Visitor', :root => aql_node) }

  class Dummy
  end

  let(:dummy) { Dummy.new }

  let(:class_under_test) do
    Class.new(described_class) do
      public :visitor
    end
  end

  let!(:test_visitor) do
    Class.new(described_class) do
      handle(Dummy)
    end
  end

  subject { object.visitor(dummy) }

  it { should eql(test_visitor.new(dummy, object)) }
end
