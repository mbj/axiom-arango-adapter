require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::For, '#local_name' do
  subject { object.local_name }
  let(:object) { class_under_test.new(relation, context) }
  let(:relation) { mock('Relation') }
  let(:context)  { mock('Context') }

  let(:local_name) { mock('Local Name') }

  let(:class_under_test) do
    local_name = self.local_name
    Class.new(described_class) do
      const_set('LOCAL_NAME', local_name)
    end
  end

  it_should_behave_like 'an idempotent method'

  it { should be(local_name) }
end
