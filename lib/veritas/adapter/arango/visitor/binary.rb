module Veritas
  module Adapter
    module Arango
      class Visitor
        # Visitor for binary aql nodes
        class Binary < self

          handle(Function::Connective::Disjunction)
          handle(Function::Predicate::Equality)
  
          MAPPING = {
            Veritas::Function::Connective::Disjunction => AQL::Node::Operator::Binary::Or,
            Veritas::Function::Predicate::Equality     => AQL::Node::Operator::Binary::Equality
          }.freeze

          # Return local name
          #
          # @return [Node::Name]
          #
          # @api private
          #
          def local_name
            context.local_name
          end

          # Return root aql node
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def root
            klass = MAPPING.fetch(input.class)
            klass.new(left, right)
          end

        private

          # Return left aql node
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def left
            visit(input.left)
          end

          # Return right aql node
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def right
            visit(input.right)
          end

        end
      end
    end
  end
end
