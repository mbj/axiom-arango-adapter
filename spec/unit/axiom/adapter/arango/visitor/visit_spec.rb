require 'spec_helper'

describe Axiom::Adapter::Arango::Visitor, '#visit' do
  let(:object) { class_under_test.new(relation, context) }
  let(:relation) { mock('Axiom Node')               }
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

  context 'with one argument' do
    subject { object.visit(dummy) }

    it { should be(aql_node) }

    it 'should use receiver as context' do
      test_visitor.should_receive(:new).with(dummy, object).and_return(mock(:root => aql_node))
      subject
    end
  end

  context 'with two arguments' do
    subject { object.visit(dummy, context) }

    it { should be(aql_node) }

    it 'should explicit context' do
      test_visitor.should_receive(:new).with(dummy, context).and_return(mock(:root => aql_node))
      subject
    end
  end
end
