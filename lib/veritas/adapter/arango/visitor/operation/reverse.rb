module Veritas
  module Adapter
    module Arango
      class Visitor
        class Operation
          # Visitor for reverse operation
          class Reverse < self

            handle(Veritas::Relation::Operation::Reverse)

            FUNCTION_NAME = 'REVERSE'.freeze
            
            # Return root aql ast
            #
            # @return [AQL::Node]
            #
            # @api private
            #
            def root
              Node::Call::new(FUNCTION_NAME, [visit(input.operand)])
            end
            memoize :root

            # Return leaf
            #
            # @return [AQL::Node]
            #
            # @api private
            #
            def leaf
              Node::NULL
            end

          end
        end
      end
    end
  end
end
