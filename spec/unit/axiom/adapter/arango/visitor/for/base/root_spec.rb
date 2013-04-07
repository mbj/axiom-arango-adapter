require 'spec_helper'

describe Axiom::Adapter::Arango::Visitor::For::Base, '#root' do
  subject { object.root }

  let(:relation) { base                                   }
  let(:object)   { described_class.new(relation, context) }

  expect_aql <<-AQL
    FOR `base` IN `name`
      RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`}
  AQL
end
