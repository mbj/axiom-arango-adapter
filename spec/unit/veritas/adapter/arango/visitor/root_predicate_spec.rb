require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor, '#root?' do
  subject { object.root? }

  let(:object)  { class_under_test.new(node, context) }
  let(:node)    { mock('Node')                        }

  context 'when not instance of root visitor' do
    let(:object) { Class.new(described_class).new(node, mock) }

    it { should be(false) }
  end

  context 'when instance of root visitor' do
    let(:object) { described_class::Root.new(node) }

    it { should be(true) }
  end
end
