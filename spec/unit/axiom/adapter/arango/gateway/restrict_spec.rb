# encoding: utf-8

require 'spec_helper'

describe Axiom::Adapter::Arango::Gateway, '#restrict' do
  subject { object.restrict(args, &block) }

  let(:adapter)  { mock('Adapter')                         }
  let(:relation) { mock('Relation', :restrict => response) }
  let(:response) { mock('New Relation', :kind_of? => true) }
  let!(:object)  { described_class.new(adapter, relation)  }
  let(:args)     { stub                                    }
  let(:block)    { lambda { |context| }                    }

  it_should_behave_like 'a unary relation method'

  it 'forwards the arguments to relation#restrict' do
    relation.should_receive(:restrict).with(args)
    subject
  end

  it 'forwards the block to relation#restrict' do
    relation.stub!(:restrict) { |_args, &proc| proc.should equal(block) }
    subject
  end
end
