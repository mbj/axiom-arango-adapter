require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::For::Base, '#root' do
  subject { object.root }

  let(:relation) { base                                   }
  let(:object)   { described_class.new(relation, context) }

  context 'purse base relation' do
    let(:context) { nil }

    subject { object.root }

    expect_aql <<-AQL
      FOR `local_name` IN `name`
        RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
    AQL
  end

  context 'one level deep' do
    let(:context) do 
      mock(
        'Context', 
        :context => nil, 
        :wrappable? => wrappable?,
        :leaf => AQL.literal_node('baz')
      )
    end

    context 'when context is consumed' do
      let(:wrappable?) { true }

      # Senseless AQL but proves parent context is taken into account
      expect_aql <<-AQL
        FOR `local_name` IN `name`
          "baz"
          RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
      AQL
    end

    context 'when parent is NOT consumed' do
      let(:wrappable?) { false }

      expect_aql <<-AQL
        FOR `local_name` IN `name`
          RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
      AQL
    end
  end

  context 'many levels deep' do
    let(:parent) do 
      mock(
        'Parent',
        :root? => false, 
        :wrappable? => parent_wrap?,
        :context => nil,
        :leaf => AQL.literal_node('parent')
      )
    end

    let(:context) do 
      mock(
        'Context',
        :root? => false,
        :wrappable? => context_wrap?,
        :context => parent, 
        :leaf => AQL.literal_node('context')
      )
    end

    context 'when context and parent are consumed' do
      let(:parent_wrap?)  { true }
      let(:context_wrap?) { true }

      # Senseless AQL but proves nested contexts are taken into account
      expect_aql <<-AQL
        FOR `local_name` IN `name`
          "context"
          "parent"
          RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
      AQL
    end

    context 'when context but NOT parent is consumed' do

      let(:parent_wrap?)  { false }
      let(:context_wrap?) { true }

      # Senseless AQL but proves nested contexts are taken into account
      expect_aql <<-AQL
        FOR `local_name` IN `name`
          "context"
          RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
      AQL
    end

    context 'when context is NOT consumed' do
      let(:parent_wrap?)  { mock }
      let(:context_wrap?) { false }

      expect_aql <<-AQL
        FOR `local_name` IN `name`
          RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
      AQL
    end
  end
end
