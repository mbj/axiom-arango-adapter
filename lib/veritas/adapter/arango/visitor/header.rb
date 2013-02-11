module Veritas
  module Adapter
    module Arango
      class Visitor
        # Visitor for creating projected documents from veritas header
        class Header < self

          handle(Relation::Header)

          # Return document node
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def root
            Node::Literal::Composed::Document.new(document_attributes)
          end
          memoize :root

        private

          # Return document attributes
          #
          # @return [Enumerable<AQL::Node>]
          #
          # @api private
          #
          def document_attributes
            input.map do |attribute|
              document_attribute(attribute)
            end
          end

          # Return document attribute node
          #
          # @return [Veritas::Attribute] attribute
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def document_attribute(attribute)
            Node::Literal::Composed::Document::Attribute.new(
              Node::Literal::Primitive::String.new(attribute.name.to_s),
              document_value(attribute)
            ) 
          end

          # Return document value
          #
          # @param [Attribute] attribute
          #
          # @return [AQL::Node::Attribute]
          #
          # @api private
          #
          def document_value(attribute)
            Node::Attribute.new(context.local_name, AQL.name_node(attribute.name))
          end

        end
      end
    end
  end
end
