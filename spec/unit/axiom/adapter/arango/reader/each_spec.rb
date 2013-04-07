require 'spec_helper'

describe Axiom::Adapter::Arango::Reader, '#each' do
  let(:object)     { described_class.new(adapter, relation)                                 }
  let(:adapter)    { mock('Adapter', :database => database, :logger => logger)              }
  let(:aql_node)   { mock('AQL Node', :aql => aql)                                          }
  let(:aql)        { mock('AQL')                                                            }
  let(:logger)     { mock('Logger')                                                         }
  let(:header)     { Axiom::Relation::Header.coerce([[:id, Integer], [:name, String]])    }
  let(:relation)   { mock('Relation', :header => header)                                    }
  let(:database)   { mock('Database', :query => query)                                      }
  let(:query)      { mock('Query')                                                          }
  let(:yields)     { []                                                                     }
  let(:cursor)     { [document_a, document_b]                                               }
  let(:document_a) { mock('Document A', :to_hash => hash_a)                                 }
  let(:document_b) { mock('Document B', :to_hash => hash_b)                                 }
  let(:hash_a)     { { 'id' => 1, 'name' => 'Markus Schirp' }                               }
  let(:hash_b)     { { 'id' => 2, 'name' => 'John Doe' }                                    }
  let(:tuple_a)    { Axiom::Tuple.new(header, document_a.to_hash.values_at('id', 'name')) }
  let(:tuple_b)    { Axiom::Tuple.new(header, document_b.to_hash.values_at('id', 'name')) }

  subject { object.each { |item| yields << item } }

  before do
    logger.stub(:debug)
    Axiom::Adapter::Arango::Visitor.stub(:run).with(relation).and_return(aql_node) 
    query.stub(:execute).with(aql).and_return(cursor)
  end

  it_should_behave_like 'an #each method'

  it 'should yield expected tuples' do
    expect { subject }.to change { yields }.from([]).to([tuple_a, tuple_b])
  end

  it 'should log aql' do
    logger.should_receive(:debug) do |&block|
      block.call.should eql("AQL: #{aql}")
    end
    subject
  end

end
