require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Literal, '#root' do
  subject { object.root }

  let(:node) { 'foo' }
  let(:context) { mock }

  expect_aql('"foo"')
end
