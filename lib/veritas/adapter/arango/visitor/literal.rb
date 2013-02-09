module Veritas
  module Adapter
    module Arango
      class Visitor
        # Visitor for literal nodes
        class Literal < self

          handle(String)

          # Return root aql node
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def root
            Node::Literal.build(input)
          end
          memoize :root

        end
      end
    end
  end
end
