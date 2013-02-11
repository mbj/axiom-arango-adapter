require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Wrappable::Restriction, '#root' do
  let(:node)    { base.restrict { |r| r.foo.eq('bar') }   }

  subject { object.local_name }

  expect_aql('`local_name`')
end
