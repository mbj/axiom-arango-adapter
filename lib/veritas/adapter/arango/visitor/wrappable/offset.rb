module Veritas
  module Adapter
    module Arango
      class Visitor
        class Wrappable
          # Visitor for emitting currently definct LIMIT statements from veritas offset operations
          class Offset < self

            handle(Veritas::Relation::Operation::Offset)


            SIGNED_INT_32_MAX = 31 ** 2 - 1

            MAXIMUM = Node::Literal::Primitive::Number.new(SIGNED_INT_32_MAX)

            # Return leaf aql ast
            #
            # @return [AQL::Node]
            #
            # @api private
            #
            def leaf
              Node::Operation::Nary::Limit.new(MAXIMUM, Node::Literal::Primitive::Number.new(input.offset))
            end
            memoize :leaf

          end
        end
      end
    end
  end
end
