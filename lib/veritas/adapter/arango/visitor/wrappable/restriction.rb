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

            # Return local name
            #
            # @return [AQL::Node::Name]
            #
            # @api private
            #
            def local_name
              visitor(input.operand).local_name
            end
            memoize :local_name

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
