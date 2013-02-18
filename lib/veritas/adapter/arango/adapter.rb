module Veritas
  module Adapter
    module Arango

      # Adapter to read tuples from remote elasticsearch database
      class Adapter
        include Adamantium::Flat, Composition.new(:database)

        # Return reader for relation
        #
        # @param [Relation] relation
        #   the relation to read from
        #
        # @return [Reader]
        #   the reader
        #
        # @api private
        #
        def reader(relation)
          Reader.new(database, relation)
        end

      end
    end
  end
end
