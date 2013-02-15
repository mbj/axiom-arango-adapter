module Veritas
  module Adapter
    module Arango
      class Visitor
        # Visitor for binary AQL nodes
        class Binary < self

          MAPPING = {
            Function::Numeric::Multiplication => AQL::Node::Operator::Binary::Multiplication,
            Function::Numeric::Addition       => AQL::Node::Operator::Binary::Addition,
            Function::Numeric::Division       => AQL::Node::Operator::Binary::Division,
            Function::Numeric::Modulo         => AQL::Node::Operator::Binary::Modulo,
            Function::Numeric::Subtraction    => AQL::Node::Operator::Binary::Subtraction,
            Function::Connective::Disjunction => AQL::Node::Operator::Binary::Or,
            Function::Connective::Disjunction => AQL::Node::Operator::Binary::Or,
            Function::Predicate::Equality     => AQL::Node::Operator::Binary::Equality
          }.freeze

          MAPPING.each_key do |klass|
            handle(klass)
          end

          # Return local name
          #
          # @return [Node::Name]
          #
          # @api private
          #
          def local_name
            context.local_name
          end
          memoize :local_name

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
          memoize :root

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
