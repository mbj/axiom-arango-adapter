require 'spec_helper'

describe Axiom::Adapter::Arango::Adapter, '.new' do
  subject { object.new(*arguments) }

  let(:object) { described_class }

  let(:database) { mock('Database') }
  let(:logger)   { mock('Logger')   }

  context 'with single argument' do
    let(:arguments) { [database] }

    its(:database) { should be(database) }
    its(:logger)   { should be(NullLogger.instance) }
  end

  context 'with two arguments' do
    let(:arguments) { [database, logger] }

    its(:database) { should be(database) }
    its(:logger)   { should be(logger)   }
  end
end
