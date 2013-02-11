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
            Node::Operation::For.new(local_name, visit(input.operand), return_operation)
          end
          memoize :root

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

        private

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
