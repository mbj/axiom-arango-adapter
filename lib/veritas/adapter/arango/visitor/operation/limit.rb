module Veritas
  module Adapter
    module Arango
      class Visitor
        class Operation
          # Visitor limits
          class Limit < self

            handle(Veritas::Relation::Operation::Limit)

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

            # Return leaf aql ast
            #
            # @return [AQL::Node]
            #
            # @api private
            #
            def leaf
              Node::Operation::Nary::Limit.new(Node::Literal::Primitive::Number.new(input.limit), Node::Literal::Primitive::Number.new(0))
            end
            memoize :leaf

          end
        end
      end
    end
  end
end
