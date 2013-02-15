require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::For, '#root' do
  subject { object.root.aql }

  let(:object) { class_under_test.new(node, context) }

  let(:context) { mock('Context') }

  let(:class_under_test) do
    local = self.local
    Class.new(described_class) do
      define_method :local_name do
        local
      end
    end
  end

  let(:header)   { Veritas::Relation::Header.coerce([[:id, Integer]]) }
  let(:operand)  { Veritas::Relation::Base.new(:name_a, header)       }
  let(:node)     { operand.restrict { |r| r.id.eq(1) }                }
  let(:local)    { AQL.name_node('local')                             }
  let(:source)   { Veritas::Adapter::Arango::Visitor.run(operand)     }
  let(:body)     { AQL.name_node('foo')  }

  it { should eql('FOR `local` IN (FOR `local_name_a` IN `name_a` RETURN {"id": `local_name_a`.`id`}) RETURN {"id": `local`.`id`}') }

  it_should_behave_like 'an idempotent method'
end
