require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor, '.visitor' do

  let(:object)  { described_class }
  let(:header)  { Veritas::Relation::Header.coerce([[:id, Integer]]) }
  let(:node)    { Veritas::Relation::Base.new(:foo, header)          }
  let(:context) { mock('Context')                                    }

  subject { object.visitor(node, context) }

  it { should eql(Veritas::Adapter::Arango::Visitor::Base.new(node, context)) }
end
