require 'spec_helper'

describe Axiom::Adapter::Arango::Visitor::For, '#root' do
  subject { object.root.aql }

  let(:object) { class_under_test.new(relation, context) }

  let(:context) { mock('Context') }

  let(:class_under_test) do
    local = self.local
    Class.new(described_class) do
      define_method :local_name do
        local
      end
    end
  end

  let(:header)   { Axiom::Relation::Header.coerce([[:id, Integer]]) }
  let(:operand)  { Axiom::Relation::Base.new(:name_a, header)       }
  let(:relation) { operand.restrict { |r| r.id.eq(1) }                }
  let(:local)    { AQL.name_node('local')                             }
  let(:source)   { Axiom::Adapter::Arango::Visitor.run(operand)     }
  let(:body)     { AQL.name_node('foo')  }

  it { should eql('FOR `local` IN (FOR `base` IN `name_a` RETURN {"id": `base`.`id`}) RETURN {"id": `local`.`id`}') }

  it_should_behave_like 'an idempotent method'
end
