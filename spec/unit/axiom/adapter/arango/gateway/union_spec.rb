# encoding: utf-8

require 'spec_helper'

describe Axiom::Adapter::Arango::Gateway, '#union' do
  subject { object.union(other) }

  let(:adapter)         { mock('Adapter')                        }
  let(:relation)        { mock('Relation')                       }
  let(:object)          { described_class.new(adapter, relation) }
  let(:operation)       { :union                                 }
  let(:factory)         { Axiom::Algebra::Union                }
  let(:binary_relation) { mock(factory)                          }

  it_should_behave_like 'a binary relation method'
end
