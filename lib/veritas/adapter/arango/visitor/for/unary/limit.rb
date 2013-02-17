module Veritas
  module Adapter
    module Arango
      class Visitor
        class For
          class Unary
            # Vistor for emitting AQL LIMIT statements from veritas limit operations
            class Limit < self

              handle(Veritas::Relation::Operation::Limit)
              LOCAL_NAME = AQL.name_node('limit')

            private

              # Return limit operation
              #
              # @return [AQL::Node]
              #
              # @api private
              #
              def operation
                Node::Operation::Nary::Limit.new(Node::Literal::Primitive::Number.new(input.limit), Node::Literal::Primitive::Number.new(0))
              end

            end
          end
        end
      end
    end
  end
end
