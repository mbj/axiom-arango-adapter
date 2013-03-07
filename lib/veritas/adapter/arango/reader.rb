module Veritas
  module Adapter
    module Arango
      # A reader to read tuples from the database
      class Reader
        include Adamantium::Flat, Enumerable, Concord.new(:adapter, :relation)

        # Enumerate tuples
        #
        # @return [self]
        #   if block given
        #
        # @return [Enumerable<Tuple>]
        #   otherwise
        #
        # @api private
        #
        def each
          return to_enum unless block_given?

          cursor.each do |document|
            yield tuple(document)
          end

          self
        end

      private

        # Coerce document to tuple
        #
        # @param [Ashikawa::Core::Document] document
        #
        # @return [Tuple]
        #
        # @api private
        #
        def tuple(document)
          Tuple.new(header, document.to_hash.values_at(*document_keys))
        end

        # Return header
        #
        # @return [Relation::Header]
        #
        # @api private
        #
        def header
          relation.header
        end

        # Return attribute names
        #
        # @return [Enumerable<Symbol>]
        #
        # @api private
        #
        def attribute_names
          header.map(&:name)
        end

        # Return document keys
        #
        # @return [Enumerable<String>]
        #
        # @api private
        #
        def document_keys
          attribute_names.map(&:to_s)
        end
        memoize :document_keys

        # Return cursor
        #
        # @return [Ashikawa::Core::Cursor]
        #
        # @api private
        #
        def cursor
          adapter.database.query.execute(aql)
        end

        # Return AQL to query with
        #
        # @return [String]
        #
        # @api private
        #
        def aql
          aql = Visitor.run(relation).aql
          adapter.logger.debug { "AQL: #{aql}" }
          aql
        end

      end
    end
  end
end
