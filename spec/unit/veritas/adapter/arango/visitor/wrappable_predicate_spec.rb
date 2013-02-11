require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor, '#wrappable?' do
  subject { object.wrappable? }

  let(:object) { described_class.allocate }

  context 'for instances of class within Veritas::Adapter::Arango::Visitor::Wrappable namespace' do
    let(:described_class) { Veritas::Adapter::Arango::Visitor::Wrappable::Restriction }

    it { should be(true) }

    it_should_behave_like 'an idempotent method'
  end

  context 'for instances of class outside Veritas::Adapter::Arango::Visitor namespace' do
    let(:described_class) { Veritas::Adapter::Arango::Visitor::Reverse }

    it { should be(false) }

    it_should_behave_like 'an idempotent method'
  end
end
