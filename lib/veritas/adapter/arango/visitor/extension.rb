module Veritas
  module Adapter
    module Arango
      class Visitor
        # Visitor limits
        class Extension < self

          handle(Algebra::Extension)

          # Return root aql ast
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def root
            Node::Operation::For.new(local_name, visit(input.operand), return_operation)
          end
          memoize :root

          # Return local name
          #
          # @return [AQL::Name]
          #
          # @api private
          #
          def local_name
            AQL.name_node('extension')
          end
          memoize :local_name

        private

          # Return return operation
          #
          # @return [AQL::Node::Operation::Return]
          #
          # @api private
          #
          def return_operation
            Node::Operation::Unary::Return.new(extended_document)
          end

          # Return extended document
          #
          # @return [AQL::Node::Literal::Composed::Document]
          #
          # @api private
          #
          def extended_document
            Node::Literal::Composed::Document.new(document_attributes)
          end

          # Return document attributes
          #
          # @return [Enumerable<AQL::Node>]
          #
          # @api private
          #
          def document_attributes
            input.header.map do |attribute|
              document_attribute(attribute)
            end
          end

          # Test if attribute is extended
          #
          # @param [Attribute] attribute
          #
          # @return [true]
          #   if attribute is extended
          #
          # @return [false]
          #   otherwise
          #
          # @api private
          #
          def extended?(attribute)
            input.extensions.key?(attribute)
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
              document_attribute_value(attribute)
            ) 
          end

          # Return document attribute value
          #
          # @param [Attribute] attribute
          #
          # @return [AQL::Node::Attribute]
          #
          # @api private
          #
          def document_attribute_value(attribute)
            extension = input.extensions.fetch(attribute) do
              return Node::Attribute.new(local_name, AQL.name_node(attribute.name))
            end
            visit(extension)
          end

        end
      end
    end
  end
end
