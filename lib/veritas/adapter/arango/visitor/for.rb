module Veritas
  module Adapter
    module Arango
      class Visitor
        # Base class for visitors that emit for statements
        class For < self

          # Return root aql ast
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def root
            Node::Operation::For.new(local_name, source, body)
          end
          memoize :root

          abstract_method :local_name

        private

          # Return source
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def source
            visit(input.operand)
          end

          # Return body
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def body
            return_operation
          end

          # Return return operation
          #
          # @return [AQL::Node::Operation::Return]
          #
          # @api private
          #
          def return_operation
            Node::Operation::Unary::Return.new(visit(input.header))
          end

        end
      end
    end
  end
end
