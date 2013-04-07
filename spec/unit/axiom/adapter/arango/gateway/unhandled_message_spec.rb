# encoding: utf-8

require 'spec_helper'

describe Axiom::Adapter::Arango::Gateway, '#unhandled_message' do
  subject { object.unhandled_message }

  let(:adapter)  { mock('Adapter')                         }
  let(:relation) { mock('Relation', :drop => response)     }
  let(:response) { mock('New Relation', :kind_of? => true) }
  let(:object)   { described_class.new(adapter, relation)  }
  let(:args)     { stub                                    }

  it 'raises no method error' do
    expect { subject }.to raise_error(NoMethodError)
  end
end
