require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor, '#visit' do
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
      public :visit
    end
  end

  let!(:test_visitor) do
    aql_node = self.aql_node
    Class.new(described_class) do
      handle(Dummy)
      define_method :root do
        aql_node
      end
    end
  end

  subject { object.visit(dummy) }

  it { should be(aql_node) }
end
