require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Wrappable, '#local_name' do
  subject { object.local_name }

  let(:node)    { base.restrict { |r| r.foo.eq('bar') } }
  # This is stupid I know, will be improved later ;)
  expect_aql('`local_name`')
end
