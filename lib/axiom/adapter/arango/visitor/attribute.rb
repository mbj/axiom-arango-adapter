module Axiom
  module Adapter
    module Arango
      class Visitor
        # Visitor for attribute accesses
        class Attribute < self

          handle(Axiom::Attribute::String)
          handle(Axiom::Attribute::Integer)

          # Return root AQL node
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def root
            Node::Attribute.new(context.local_name, AQL.name_node(input.name))
          end
          memoize :root

        end
      end
    end
  end
end
