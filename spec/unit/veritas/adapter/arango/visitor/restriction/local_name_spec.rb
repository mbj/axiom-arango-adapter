require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Restriction, '#root' do
  let(:header)  { Veritas::Relation::Header.coerce([[:foo, String]]) }
  let(:base)    { Veritas::Relation::Base.new(:name, header)         }
  let(:node)    { base.restrict { |r| r.foo.eq('bar') }              }
  let(:context) { mock('Visitor Context', :root? => true)            }

  let(:object) { described_class.new(node, context) }

  subject { object.local_name }

  it_should_behave_like 'an idempotent method'

  expect_aql('`local_name`')
end
