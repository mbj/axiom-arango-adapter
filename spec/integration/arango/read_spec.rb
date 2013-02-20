require 'spec_helper'
require 'logger'

describe Veritas::Adapter::Arango, 'read' do
  let(:logger) do
    Logger.new($stderr, :debug)
  end

  let(:projects) do
    header = Veritas::Relation::Header.coerce(
      [
        [ :id, Integer ],
        [ :name, String ]
      ]
    )

    Veritas::Relation.new(header, 
      [
        [ 1, 'dm-mapper' ],
        [ 2, 'veritas'   ],
        [ 3, 'dm-session'],
      ]
    )
  end

  let(:people) do
    header = Veritas::Relation::Header.coerce(
      [
        [ :id, Integer ],
        [ :name, String ]
      ]
    )

    Veritas::Relation.new(header, 
      [
        [ 1, 'Dan Kubb'          ],
        [ 2, 'Piotr Solnica'     ],
        [ 3, 'Martin Gamsjaeger' ],
        [ 4, 'Markus Schirp'     ]
      ]
    )
  end

  let(:tasks) do
    header = Veritas::Relation::Header.coerce(
      [
        [ :id, Integer ],
        [ :name, String ],
        [ :project_id, Integer ]
      ]
    )

    Veritas::Relation::new(header, 
      [
        [ 1, 'Add full mutation coverage',    1],
        [ 2, 'Finish dm-session integration', 1],
        [ 3, 'Rename to axiom',               2],
        [ 4, 'Add UoW Interface',             3]
      ]
    )
  end

  let(:relations) do
    {
      :tasks    => tasks,
      :people   => people,
      :projects => projects
    }
  end

  let(:database) do
    Ashikawa::Core::Database.new('http://localhost:8529')
  end

  let(:adapter) do
    Veritas::Adapter::Arango::Adapter.new(database, logger)
  end

  before :all do
    relations.each do |name, relation|
      database[name].delete
      collection = database[name]
      relation.each do |tuple|
        document = relation.header.each_with_object({}) do |attribute, document|
          document[attribute.name.to_s]=tuple[attribute]
        end
        collection.create(document)
      end
    end
  end

  def assert_eql_tuples_order(example, expected)
    expected.to_a.map(&:to_ary).should eql(example.to_a.map(&:to_ary))
  end

  def assert_eql_tuples(expected, example)
    expected_tuples = expected.to_a.map(&:to_ary).to_set
    example_tuples  = example.to_a.map(&:to_ary).to_set
    example_tuples.should eql(expected_tuples)
  end

  def gateway(name)
    adapter.gateway(Veritas::Relation::Base.new(name, relations.fetch(name).header))
  end

  specify 'projecting relation' do
    assert_eql_tuples(gateway(:tasks).project([:id, :name]), tasks.project([:id, :name]))
  end

  specify 'restricting relation' do
    assert_eql_tuples(gateway(:tasks).restrict { |r| r.project_id.eq(1) }, tasks.restrict { |r| r.project_id.eq(1) })
  end

  specify 'joining relations' do
    expected = projects.rename(:id => :project_id).join(tasks)

    assert_eql_tuples(
      projects.rename(:id => :project_id, :name => :project_name).join(tasks),
      gateway(:projects).rename(:id => :project_id, :name => :project_name).join(tasks)
    )
  end

  specify 'sorting relations' do
    assert_eql_tuples_order(
      projects.sort_by { |r| [r.id.asc, r.name.asc] },
      gateway(:projects).sort_by { |r| [r.id.asc, r.name.asc] }
    )
  end

  specify 'limiting relations' do
    assert_eql_tuples_order(
      projects.sort_by { |r| [r.id.asc, r.name.asc] }.take(1),
      gateway(:projects).sort_by { |r| [r.id.asc, r.name.asc] }.take(1)
    )
  end

  specify 'offseting relations' do
    assert_eql_tuples_order(
      projects.sort_by { |r| [r.id.asc, r.name.asc] }.drop(1),
      gateway(:projects).sort_by { |r| [r.id.asc, r.name.asc] }.drop(1)
    )
  end

  specify 'summarizing relations' do
    assert_eql_tuples(
      tasks.summarize([:project_id]) { |r| r.add(:count, r.name.count) },
      gateway(:tasks).summarize([:project_id]) { |r| [r.add(:count, r.name.count)] }
    )
  end
end
