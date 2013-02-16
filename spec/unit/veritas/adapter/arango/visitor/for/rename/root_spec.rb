require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::For::Rename, '#root' do
  subject { object.root }

  let(:relation) { base.rename(:bar => :baz) }

  expect_aql <<-AQL
    FOR `rename` IN
      (FOR `base` IN `name` RETURN {"foo": `base`.`foo`, "bar": `base`.`bar`})
      RETURN {"foo": `rename`.`foo`, "baz": `rename`.`bar`}
  AQL
end
