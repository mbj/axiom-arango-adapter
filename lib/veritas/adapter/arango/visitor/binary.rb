module Veritas
  module Adapter
    module Arango
      class Visitor
        # Visitor for binary AQL nodes
        class Binary < self

          MAPPING = {
            Function::Numeric::Multiplication         => AQL::Node::Operator::Binary::Multiplication,
            Function::Numeric::Addition               => AQL::Node::Operator::Binary::Addition,
            Function::Numeric::Division               => AQL::Node::Operator::Binary::Division,
            Function::Numeric::Modulo                 => AQL::Node::Operator::Binary::Modulo,
            Function::Numeric::Subtraction            => AQL::Node::Operator::Binary::Subtraction,
            Function::Predicate::GreaterThanOrEqualTo => AQL::Node::Operator::Binary::GreaterThanOrEqualTo,
            Function::Predicate::GreaterThan          => AQL::Node::Operator::Binary::GreaterThan,
            Function::Predicate::LessThan             => AQL::Node::Operator::Binary::LessThan,
            Function::Predicate::LessThanOrEqualTo    => AQL::Node::Operator::Binary::LessThanOrEqualTo,
            Function::Connective::Disjunction         => AQL::Node::Operator::Binary::Or,
            Function::Connective::Conjunction         => AQL::Node::Operator::Binary::And,
            Function::Predicate::Equality             => AQL::Node::Operator::Binary::Equality,
            Function::Predicate::Inequality           => AQL::Node::Operator::Binary::Inequality
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

          # Return root AQL node
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

          # Return left AQL node
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def left
            visit(input.left)
          end

          # Return right AQL node
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
