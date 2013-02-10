module Veritas
  module Adapter
    module Arango
      class Visitor
        # Base class for visitors of nodes in the Veritas::Relation::Operation namespace
        class Operation < self

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
