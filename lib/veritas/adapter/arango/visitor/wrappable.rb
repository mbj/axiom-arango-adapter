module Veritas
  module Adapter
    module Arango
      class Visitor
        # Base class for vistitors that support to be wrapped in a AQL FOR statement
        class Wrappable < self

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

          abstract_method :leaf

        end
      end
    end
  end
end
