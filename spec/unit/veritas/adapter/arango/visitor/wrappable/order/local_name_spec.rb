require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Wrappable::Restriction, '#local_name' do
  subject { object.local_name }

  let(:node)    { base.restrict { |r| r.foo.eq('bar') } }

  expect_aql('`local_name`')
end
