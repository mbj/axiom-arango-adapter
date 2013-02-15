require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Wrappable::Limit, '#root' do
  subject { object.root }

  let(:relation)    { base.sort_by { |r| [r.foo.asc, r.bar.asc] }.take(5) }

  expect_aql <<-AQL
    FOR `local_name` IN `name`
      SORT `local_name`.`foo` ASC, `local_name`.`bar` ASC
      LIMIT 0, 5
      RETURN {\"foo\": `local_name`.`foo`, \"bar\": `local_name`.`bar`}
  AQL
end
