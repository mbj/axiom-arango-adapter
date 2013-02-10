module Veritas
  module Adapter
    module Arango
      class Visitor
        class Operation
          # Visitor for restriction nodes
          class Restriction < self

            handle(Veritas::Algebra::Restriction)

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
