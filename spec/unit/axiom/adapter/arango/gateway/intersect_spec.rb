# encoding: utf-8

require 'spec_helper'

describe Axiom::Adapter::Arango::Gateway, '#intersect' do
  subject { object.intersect(other) }

  let(:adapter)         { mock('Adapter')                        }
  let(:relation)        { mock('Relation')                       }
  let(:object)          { described_class.new(adapter, relation) }
  let(:operation)       { :intersect                             }
  let(:factory)         { Axiom::Algebra::Intersection         }
  let(:binary_relation) { mock(factory)                          }

  it_should_behave_like 'a binary relation method'
end
