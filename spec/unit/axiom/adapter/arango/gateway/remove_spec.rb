# encoding: utf-8

require 'spec_helper'

describe Axiom::Adapter::Arango::Gateway, '#remove' do
  subject { object.remove(args) }

  let(:adapter)  { mock('Adapter')                         }
  let(:relation) { mock('Relation', :remove => response)   }
  let(:response) { mock('New Relation', :kind_of? => true) }
  let!(:object)  { described_class.new(adapter, relation)  }
  let(:args)     { stub                                    }

  it_should_behave_like 'a unary relation method'

  it 'forwards the arguments to relation#remove' do
    relation.should_receive(:remove).with(args)
    subject
  end
end
