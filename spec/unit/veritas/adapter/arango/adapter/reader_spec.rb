require 'spec_helper'

describe Veritas::Adapter::Arango::Adapter, '#reader' do

  let(:object)     { described_class.new(database) }
  let(:relation)   { mock('Relation')              }
  let(:database)   { mock('Database')              }

  subject { object.reader(relation)  }

  it { should eql(Veritas::Adapter::Arango::Reader.new(database, relation)) }
end
