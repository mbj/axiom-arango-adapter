shared_examples_for 'Node#aql' do
  subject { object.aql }

  it { should eql(expected_aql) }
  its(:frozen?) { should be(true) }
  it_should_behave_like 'an idempotent method'
end
