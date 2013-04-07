require 'spec_helper'

describe Axiom::Adapter::Arango::Visitor::For::Unary::Extension, '#root' do
  let(:relation) { base.extend { |r| r.add(:baz, r.bar * 2) }                  }

  subject { object.root }

  expect_aql <<-AQL
    FOR `extension` IN
      (FOR `base` IN `name` RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`})
      RETURN MERGE(`extension`, {"baz": (`extension`.`bar` * 2)})
  AQL
end
