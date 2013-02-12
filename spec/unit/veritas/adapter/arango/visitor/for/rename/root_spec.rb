require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::For::Rename, '#root' do
  subject { object.root }

  let(:node) { base.rename(:bar => :baz) }

  expect_aql <<-AQL
    FOR `rename` IN
      (FOR `local_name` IN `name` RETURN {"foo": `local_name`.`foo`, "bar": `local_name`.`bar`})
      RETURN {"foo": `rename`.`foo`, "baz": `rename`.`bar`}
  AQL
end
