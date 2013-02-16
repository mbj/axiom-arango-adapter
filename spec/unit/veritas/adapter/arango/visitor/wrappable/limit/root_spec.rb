require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Wrappable::Limit, '#root' do
  subject { object.root }

  let(:relation)    { base.sort_by { |r| [r.foo.asc, r.bar.asc] }.take(5) }

  expect_aql <<-AQL
    FOR `base` IN `name`
      SORT `base`.`foo` ASC, `base`.`bar` ASC
      LIMIT 0, 5
      RETURN {\"foo\": `base`.`foo`, \"bar\": `base`.`bar`}
  AQL
end
