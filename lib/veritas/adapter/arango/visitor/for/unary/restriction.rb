module Veritas
  module Adapter
    module Arango
      class Visitor
        class For
          class Unary
            # Visitor for emitting AQL FILTER statements from veritas restrictions
            class Restriction < self

              handle(Veritas::Algebra::Restriction)

              LOCAL_NAME = AQL.name_node('restriction')

            private

              # Return filter operation
              #
              # @return [AQL::Node]
              #
              # @api private
              #
              def operation
                Node::Operation::Unary::Filter.new(expression)
              end

              # Return restriction expression
              #
              # @return [AQL::Node]
              #
              # @api private
              #
              def expression
                visit(input.predicate)
              end

            end
          end
        end
      end
    end
  end
end
