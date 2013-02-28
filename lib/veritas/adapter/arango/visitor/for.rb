module Veritas
  module Adapter
    module Arango
      class Visitor
        # Base class for visitors that emit for statements
        class For < self

          # Return root AQL AST
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def root
            Node::Operation::For.new(local_name, source, body)
          end
          memoize :root

          # Return local name
          #
          # @return [AQL::Node::Name]
          #
          # @api private
          #
          def local_name
            self.class::LOCAL_NAME
          end

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
            Node::Operation::Unary::Return.new(return_value)
          end

          # Return return value
          #
          # @return [AQL::Node::Literal::Composed::Document]
          #
          # @api private
          #
          def return_value
            visit(input.header)
          end

        end
      end
    end
  end
end
