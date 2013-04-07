require 'spec_helper'

describe Axiom::Adapter::Arango::Visitor::For::Unary::Restriction, '#root' do
  subject { object.root }

  let(:relation) { base.restrict { |r| r.foo.eq('bar') } }

  expect_aql <<-AQL
    FOR `restriction` IN
      (FOR `base` IN `name` RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`})
      FILTER (`restriction`.`foo` == "bar")
      RETURN {"foo": `restriction`.`foo`, "bar": `restriction`.`bar`}
  AQL
end
