require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Base, '#root' do
  subject { object.root }

  let(:node)    { base                               }
  let(:object)  { described_class.new(node, context) }

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
        :consume_in_base? => consume_in_base?,
        :leaf => AQL.literal_node('baz')
      )
    end

    context 'when context is consumed' do
      let(:consume_in_base?) { true }

      # Senseless AQL but proves parent context is taken into account
      expect_aql <<-AQL
        FOR `local_name` IN `name`
          "baz"
          RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
      AQL
    end

    context 'when parent is NOT consumed' do
      let(:consume_in_base?) { false }

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
        :consume_in_base? => parent_consume?,
        :context => nil,
        :leaf => AQL.literal_node('parent')
      )
    end

    let(:context) do 
      mock(
        'Context',
        :root? => false,
        :consume_in_base? => context_consume?,
        :context => parent, 
        :leaf => AQL.literal_node('context')
      )
    end

    context 'when context and parent are consumed' do
      let(:parent_consume?)  { true }
      let(:context_consume?) { true }

      # Senseless AQL but proves nested contexts are taken into account
      expect_aql <<-AQL
        FOR `local_name` IN `name`
          "context"
          "parent"
          RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
      AQL
    end

    context 'when context but NOT parent is consumed' do

      let(:parent_consume?)  { false }
      let(:context_consume?) { true }

      # Senseless AQL but proves nested contexts are taken into account
      expect_aql <<-AQL
        FOR `local_name` IN `name`
          "context"
          RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
      AQL
    end

    context 'when context is NOT consumed' do
      let(:parent_consume?)  { mock }
      let(:context_consume?) { false }

      expect_aql <<-AQL
        FOR `local_name` IN `name`
          RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
      AQL
    end
  end
end
