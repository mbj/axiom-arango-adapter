require 'spec_helper'

describe Axiom::Adapter::Arango::Adapter, '#gateway' do
  subject { object.gateway(relation) }

  let(:object) { described_class.new(database) }
  let(:relation) { mock('Relation') }
  let(:database) { mock('Database') }

  it { should eql(Axiom::Adapter::Arango::Gateway.new(object, relation)) }
end
