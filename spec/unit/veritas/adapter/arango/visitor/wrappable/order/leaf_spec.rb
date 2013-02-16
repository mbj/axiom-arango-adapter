require 'spec_helper'

describe Veritas::Adapter::Arango::Visitor::Wrappable::Order, '#leaf' do
  subject { object.leaf }

  let(:relation) { base.sort_by { |r| [r.foo.asc, r.bar.asc] } }

  expect_aql <<-AQL
    SORT `base`.`foo` ASC, `base`.`bar` ASC
  AQL
end
