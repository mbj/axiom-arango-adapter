module Veritas
  module Adapter
    module Arango
      class Visitor
        class Wrappable
          # Visitor for emitting AQL FILTER statements from veritas restrictions
          class Restriction < self

            handle(Veritas::Algebra::Restriction)

            # Return leaf aql ast
            #
            # @return [AQL::Node]
            #
            # @api private
            #
            def leaf
              Node::Operation::Unary::Filter.new(expression)
            end
            memoize :leaf

          private

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
