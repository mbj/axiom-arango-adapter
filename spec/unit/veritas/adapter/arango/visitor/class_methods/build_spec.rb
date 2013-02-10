require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor, '.build' do
  let(:object) { described_class }

  let(:node)     { mock('Veritas Node')               }
  let(:aql_node) { mock('AQL Node')                   }
  let(:context)  { mock('Context')                    }
  let(:build)  { mock('Visitor', :root => aql_node) }

  class Dummy
  end

  let(:dummy) { Dummy.new }

  let!(:test_visitor) do
    aql_node = self.aql_node
    Class.new(described_class) do
      handle(Dummy)
      define_method :root do
        aql_node
      end
    end
  end

  context 'with explicit context' do
    subject { object.build(dummy, context) }

    it { should eql(test_visitor.new(dummy, context)) }
  end

  context 'with implicit context' do
    subject { object.build(dummy) }

    it { should eql(test_visitor.new(dummy, nil)) }
  end
end
