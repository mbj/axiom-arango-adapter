require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor, '.run' do
  let(:object) { described_class }

  let(:relation) { mock('Veritas Node')               }
  let(:aql_node) { mock('AQL Node')                   }
  let(:visitor)  { mock('Visitor', :root => aql_node) }

  class Dummy
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

  subject { object.run(Dummy.new) }

  it { should be(aql_node) }
end
