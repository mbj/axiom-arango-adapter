module Veritas
  module Adapter
    module Arango
      class Visitor
        # Visitor for attribute accesses
        class Attribute < self

          handle(Veritas::Attribute::String)

          # Return root aql node 
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def root
            Node::Attribute.new(context.local_name, Node::Name.new(input.name))
          end
          memoize :root

        end
      end
    end
  end
end
