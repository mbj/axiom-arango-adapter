module Axiom
  module Adapter
    module Arango
      class Visitor
        class For
          class Unary
            # Visitor for emitting projections
            class Projection < self

              handle(Algebra::Projection)

              LOCAL_NAME = AQL.name_node('projection')

            private

              # Return for body
              #
              # @return [AQL::Node]
              #
              # @api private
              #
              def body
                return_operation
              end

            end
          end
        end
      end
    end
  end
end
