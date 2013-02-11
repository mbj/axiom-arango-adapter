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
            operand.root
          end
          memoize :root

          abstract_method :leaf

          # Return local name
          #
          # @return [AQL::Node::Name]
          #
          # @api private
          #
          def local_name
            operand.local_name
          end
          memoize :local_name

        private

          # Return operand visitor
          #
          # @return [Visitor]
          #
          # @api private
          #
          def operand
            visitor(input.operand)
          end
          memoize :operand

        end
      end
    end
  end
end
