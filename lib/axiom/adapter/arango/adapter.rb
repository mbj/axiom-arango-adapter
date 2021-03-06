module Axiom
  module Adapter
    module Arango

      # Adapter to read tuples from remote ArangoDB
      class Adapter
        include Adamantium::Flat, Concord.new(:database, :logger)

        # Return logger
        #
        # @return [Logger]
        #
        # @api private
        #
        attr_reader :logger

        # Return database
        #
        # @return [ArangoDB::Database]
        #
        # @api private
        #
        attr_reader :database

        # Return new adapter
        #
        # @param [Ashikawa::Core::Database] _database
        # @param [NullLogger] _logger
        #
        # @return [undefined]
        #
        # @example
        #
        #   database = Ashikawa::Core::Database.new('http://localhost:8529')
        #   adapter = Axiom::Adapter::Arango::Adapter.new(database, Logger.new($stderr, :debug))
        #
        # @api public
        #
        def self.new(_database, _logger = NullLogger.instance)
          super
        end

        # Return reader for base relation
        #
        # @param [Relation::Base] base_relation
        #   the relation to read from
        #
        # @return [Reader]
        #   the reader
        #
        # @api private
        #
        def reader(base_relation)
          Reader.new(self, base_relation)
        end

        # Return gateway for the ArangoDB adapter
        #
        # @param [Relation::Base] base_relation
        #
        # @return [Gateway]
        #
        # @example 
        #   
        #   gateway = adapter.gateway(base_relation)
        #
        #   # Perform restriction on gateway
        #   relation = gateway.restrict { |r| r.foo.eql('bar') }
        #
        #   # Enumerate tuples
        #   relation.each do |tuple|
        #     p tuple.to_ary
        #   end
        #
        # @api public
        #
        def gateway(base_relation)
          Gateway.new(self, base_relation)
        end

      end
    end
  end
end
