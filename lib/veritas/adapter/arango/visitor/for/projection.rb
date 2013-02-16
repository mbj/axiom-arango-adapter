module Veritas
  module Adapter
    module Arango
      class Visitor
        class For
          # Visitor for emitting projections
          class Projection < self

            handle(Algebra::Projection)

            LOCAL_NAME = AQL.name_node('projection')

          end
        end
      end
    end
  end
end
