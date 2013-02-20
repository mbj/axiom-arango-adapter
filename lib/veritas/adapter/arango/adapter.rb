module Veritas
  module Adapter
    module Arango

      # Adapter to read tuples from remote elasticsearch database
      class Adapter
        include Adamantium::Flat, Composition.new(:database, :logger)

        # Return new adapter
        #
        # @param [Ashikawa::Core::Database] _database
        # @param [NullLogger] _logger
        #
        # @return [undefined]
        #
        # @api private
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

        # Return gateway for arango adapter
        #
        # @param [Relation::Base] base_relation
        #
        # @return [Gateway]
        #
        # @api private
        #
        def gateway(base_relation)
          Gateway.new(self, base_relation)
        end

      end
    end
  end
end
