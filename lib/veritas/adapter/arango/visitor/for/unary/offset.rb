module Veritas
  module Adapter
    module Arango
      class Visitor
        class For
          class Unary
            # Visitor for emitting currently defunct LIMIT statements from veritas offset operations
            class Offset < self

              handle(Veritas::Relation::Operation::Offset)

              SIGNED_INT_32_MAX = 2 ** 31 - 1
              LOCAL_NAME = AQL.name_node('offset')
              MAXIMUM = Node::Literal::Primitive::Number.new(SIGNED_INT_32_MAX)

            private

              # Return offset operation
              #
              # @return [AQL::Node]
              #
              # @api private
              #
              def operation
                Node::Operation::Nary::Limit.new(MAXIMUM, Node::Literal::Primitive::Number.new(input.offset))
              end

            end
          end
        end
      end
    end
  end
end
