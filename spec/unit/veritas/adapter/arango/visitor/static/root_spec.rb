require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Static, '#root' do
  subject { object.root }

  let(:object) { class_under_test.new(mock, mock) }
  let(:root)   { mock('Root')                     }

  let(:class_under_test) do
    root = self.root
    Class.new(described_class) do
      const_set(:ROOT, root)
    end
  end

  it_should_behave_like 'an idempotent method'

  it { should be(root) }
end
