module Axiom
  module Adapter
    module Arango
      class Visitor
        # Visitor for creating projected documents from axiom header
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
          memoize :document_attributes

        private

          # Return document attribute node
          #
          # @return [Axiom::Attribute] attribute
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def document_attribute(attribute)
            Node::Literal::Composed::Document::Attribute.new(
              Node::Literal::Primitive::String.new(attribute.name.to_s),
              visit(attribute, context)
            )
          end

        end
      end
    end
  end
end
