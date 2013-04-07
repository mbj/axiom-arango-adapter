require 'spec_helper'

describe Axiom::Adapter::Arango::Visitor::For::Unary::Rename, '#root' do
  subject { object.root }

  let(:relation) { base.rename(:bar => :baz) }

  expect_aql <<-AQL
    FOR `rename` IN
      (FOR `base` IN `name` RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`})
      RETURN {"foo": `rename`.`foo`, "baz": `rename`.`bar`}
  AQL
end
