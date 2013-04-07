require 'spec_helper'

describe Axiom::Adapter::Arango::Visitor::Literal, '#root' do
  subject { object.root }

  let(:relation) { 'foo' }
  let(:context)  { mock }

  expect_aql('"foo"')
end
