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
    let(:context) { mock('Context', :root? => false, :context => nil, :leaf => AQL::Node::Literal.build('baz')) }


    # Senseless but proves parent context is taken into account
    expect_aql <<-AQL
      FOR `local_name` IN `name`
        "baz"
        RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
    AQL
  end

  context 'many levels deep' do
    let(:middle)  { mock('Middle', :root? => false, :context => nil, :leaf => AQL::Node::Literal.build('bog')) }
    let(:context) { mock('Context', :root? => false, :context => middle, :leaf => AQL::Node::Literal.build('baz')) }


    # Senseless but proves nested contexts are taken into account
    expect_aql <<-AQL
      FOR `local_name` IN `name`
        "baz"
        "bog"
        RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`}
    AQL
  end

end

