require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Wrappable::Offset, '#root' do
  subject { object.root }

  let(:relation) { base.sort_by { |r| [r.foo.asc, r.bar.asc] }.drop(5) }

  expect_aql <<-AQL
    FOR `base` IN `name`
      SORT `base`.`foo` ASC, `base`.`bar` ASC
      LIMIT 5, 2147483647
      RETURN {\"foo\": `base`.`foo`, \"bar\": `base`.`bar`}
  AQL
end
