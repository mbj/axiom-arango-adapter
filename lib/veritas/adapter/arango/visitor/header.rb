module Veritas
  module Adapter
    module Arango
      class Visitor
        class Header < self

          handle(Relation::Header)

          # Return document node
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def root
            attributes = input.map do |attribute|
              document_attribute(attribute)
            end
            Node::Literal::Composed::Document.new(attributes)
          end
          memoize :root

        private

          # Return document attribute node
          #
          # @return [Veritas::Attribute] attribute
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def document_attribute(attribute)
            name  = attribute.name
            key   = Node::Literal::Primitive::String.new(name.to_s)
            value = Node::Attribute.new(context.local_name, AQL.name_node(name))
            Node::Literal::Composed::Document::Attribute.new(key, value) 
          end

        end
      end
    end
  end
end
