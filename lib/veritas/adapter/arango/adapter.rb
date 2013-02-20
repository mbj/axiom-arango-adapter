module Veritas
  module Adapter
    module Arango

      # Adapter to read tuples from remote elasticsearch database
      class Adapter
        include Adamantium::Flat, Composition.new(:database, :logger)

        # Return new adapter
        #
        # @param [Ashikawa::Core::Database] database
        # @param [NullLogger] logger
        #
        # @return [undefined]
        #
        # @api private
        #
        def self.new(database, logger = NullLogger.instance)
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

        # Read tuples from relation 
        #
        # @param [Relation::Base] base_relation
        #
        # @return [self]
        #   if block given
        #
        # @return [Enumerable<Tuple>]
        #   otherwise
        #
        # @api private
        #
        def read(base_relation, &block)
          return to_enum(__method__, base_relation) unless block_given?
          reader(base_relation).each(&block)
          self
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
