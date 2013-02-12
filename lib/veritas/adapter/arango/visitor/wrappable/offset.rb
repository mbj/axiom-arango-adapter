module Veritas
  module Adapter
    module Arango
      class Visitor
        class Wrappable
          # Visitor for emitting currently definct LIMIT statements from veritas offset operations
          class Offset < self

            handle(Veritas::Relation::Operation::Offset)

            # Magic offset from https://github.com/triAGENS/ArangoDB/issues/398#issuecomment-13445098
            MAGIC = 2147483647

            # Return leaf aql ast
            #
            # @return [AQL::Node]
            #
            # @api private
            #
            def leaf
              Node::Operation::Nary::Limit.new(Node::Literal::Primitive::Number.new(MAGIC), Node::Literal::Primitive::Number.new(input.offset))
            end
            memoize :leaf

          end
        end
      end
    end
  end
end
