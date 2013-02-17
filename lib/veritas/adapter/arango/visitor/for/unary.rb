module Veritas
  module Adapter
    module Arango
      class Visitor
        class For 
          # Base class for visitors that emit from unary veritas relations
          class Unary < self

          private

            # Return body
            #
            # @return [AQL::Node]
            #
            # @api private
            #
            def body
              AQL::Node::Block.new([
                operation,
                return_operation
              ])
            end

          end
        end
      end
    end
  end
end
