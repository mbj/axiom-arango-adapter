module Axiom
  module Adapter
    module Arango
      class Visitor
        # Visitor for reverse operation
        class Reverse < self

          handle(Axiom::Relation::Operation::Reverse)

          FUNCTION_NAME = 'REVERSE'.freeze

          # Return root AQL AST
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def root
            Node::Call::new(FUNCTION_NAME, [visit(input.operand)])
          end
          memoize :root

        end
      end
    end
  end
end
