module Veritas
  module Adapter
    module Arango
      class Visitor
        class Operation
          # Visitor offsets 
          class Offset < self

            handle(Veritas::Relation::Operation::Offset)

            # Return leaf aql ast
            #
            # @return [AQL::Node]
            #
            # @api private
            #
            def leaf
              Node::Operation::Nary::Limit.new(Node::Literal::Primitive::Number.new(0), Node::Literal::Primitive::Number.new(input.offset))
            end
            memoize :leaf

          end
        end
      end
    end
  end
end
