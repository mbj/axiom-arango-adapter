require 'spec_helper'

describe Axiom::Adapter::Arango::Adapter, '#reader' do

  let(:object)   { described_class.new(database) }
  let(:database) { mock('Database')              }
  let(:relation) { mock('Relation')              }

  subject { object.reader(relation)  }

  it { should eql(Axiom::Adapter::Arango::Reader.new(object, relation)) }
end
