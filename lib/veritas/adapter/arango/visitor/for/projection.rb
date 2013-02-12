module Veritas
  module Adapter
    module Arango
      class Visitor
        class For
          # Visitor for emitting projections
          class Projection < self

            handle(Algebra::Projection)

            # Return local name
            #
            # @return [AQL::Name]
            #
            # @api private
            #
            def local_name
              AQL.name_node('projection')
            end
            memoize :local_name

          end
        end
      end
    end
  end
end
