module Veritas
  module Adapter
    module Arango
      class Visitor
        # Visitor limits
        class Projection < self

          handle(Algebra::Projection)

          # Return root aql ast
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def root
            visit(input.operand)
          end
          memoize :root

        end
      end
    end
  end
end
