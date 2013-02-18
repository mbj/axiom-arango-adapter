require 'spec_helper'

describe Veritas::Adapter::Arango::Reader, '#each' do
  let(:object)     { described_class.new(database, relation)                             }
  let(:aql)        { mock('AQL')                                                         }
  let(:header)     { Veritas::Relation::Header.coerce([[:id, Integer], [:name, String]]) }
  let(:relation)   { mock('Relation', :header => header)                                 }
  let(:database)   { mock('Database')                                                    }
  let(:yields)     { []                                                                  }
  let(:cursor)     { [document_a, document_b]                                            }
  let(:document_a) { { 'id' => 1, 'name' => 'Markus Schirp' }                            }
  let(:document_b) { { 'id' => 2, 'name' => 'John Doe' }                                 }

  let(:tuple_a)   { Veritas::Tuple.new(header, document_a.values_at('id', 'name')) }
  let(:tuple_b)   { Veritas::Tuple.new(header, document_b.values_at('id', 'name')) }

  subject { object.each { |item| yields << item } }

  before do
    Veritas::Adapter::Arango::Visitor.stub!(:run).with(relation).and_return(aql) 
    database.should_receive(:execute).with(aql).and_return(cursor)
  end

  #it_should_behave_like 'an #each method'

  it 'should yield expected tuples' do
    expect { subject }.to change { yields }.from([]).to([tuple_a, tuple_b])
  end


end
