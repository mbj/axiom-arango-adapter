# encoding: utf-8

require 'spec_helper'

describe Axiom::Adapter::Arango::Gateway, '#each' do
  subject { object.each { |tuple| yields << tuple } }

  let(:header)   { mock('Header')                         }
  let(:reader)   { mock('Reader')                         }
  let(:tuple)    { mock('Tuple')                          }
  let(:adapter)  { mock('Adapter')                        }
  let(:relation) { mock('Relation')                       }
  let!(:object)  { described_class.new(adapter, relation) }
  let(:reader)   { [tuple]                                }
  let(:yields)   { []                                     }

  before do
    adapter.stub(:reader => reader)
  end

  context 'with an unmaterialized relation' do
    let(:wrapper) { stub }

    before do
      relation.stub!(:header).and_return(header)
      relation.stub!(:materialized?).and_return(false)
      relation.stub!(:each).and_return(relation)
    end

    it_should_behave_like 'an #each method'

    it 'yields each tuple' do
      expect { subject }.to change { yields.dup }.
        from([]).
        to([ tuple ])
    end

    it 'passes in the relation to the adapter reader' do
      adapter.should_receive(:reader).with(relation).and_return(reader)
      subject
    end
  end

  context 'with a materialized relation' do
    before do
      relation.stub!(:materialized?).and_return(true)

      # I do not know a better way to mock this behaviour out and
      # I'm pretty sure that rspec does not provide Enumerator helpers
      relation.stub(:each) do |&block|
        unless block
          relation.to_enum
        else
          block.call(tuple)
          relation
        end
      end
    end

    it_should_behave_like 'an #each method'

    it 'yields each tuple' do
      expect { subject }.to change { yields.dup }.
        from([]).
        to([ tuple ])
    end

    it 'does not create a reader' do
      adapter.should_not_receive(:read)
      subject
    end

    it 'does not create a wrapper' do
      Axiom::Relation.should_not_receive(:new)
      subject
    end
  end
end
