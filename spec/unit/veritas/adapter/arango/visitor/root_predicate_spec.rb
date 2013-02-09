require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor, '#root?' do
  subject { object.root? }

  let(:object)  { class_under_test.new(node, context) }
  let(:node)    { mock('Node')                        }

  let(:class_under_test) do
    Class.new(described_class)
  end

  context 'when context equals input' do
    let(:object) { class_under_test.new(node, node) }

    it { should be(true) }
  end

  context 'when context not equals input' do
    let(:object) { class_under_test.new(node, mock) }

    it { should be(false) }
  end
end
