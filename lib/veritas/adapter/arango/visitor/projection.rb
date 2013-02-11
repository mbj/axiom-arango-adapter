module Veritas
  module Adapter
    module Arango
      class Visitor
        # Visitor limits
        class Projection < self

          handle(Algebra::Projection)

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

          # Return local name
          #
          # @return [AQL::Name]
          #
          # @api private
          #
          def local_name
            AQL.name_node('projection')
          end
          memoize :local_name

        end
      end
    end
  end
end
