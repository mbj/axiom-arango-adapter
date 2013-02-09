module Veritas
  module Adapter
    module Arango
      class Visitor
        # Visitor for restriction nodes
        class Restriction < self

          handle(Veritas::Algebra::Restriction)

          # Return root aql ast
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def root
            visit(input.operand)
          end

          # Return leaf aql ast
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def leaf
            Node::Operation::Unary::Filter.new(expression)
          end

          # Return local name
          #
          # @return [AQL::Node::Name]
          #
          # @api private
          #
          def local_name
            visitor(input.operand).local_name
          end

          # Return restriction expression
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def expression
            visit(input.predicate)
          end

        end
      end
    end
  end
end
