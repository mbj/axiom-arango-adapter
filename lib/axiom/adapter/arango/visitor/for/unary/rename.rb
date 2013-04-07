module Axiom
  module Adapter
    module Arango
      class Visitor
        class For
          class Unary
            # Visitor for emitting renames
            class Rename < self

              handle(Algebra::Rename)

              LOCAL_NAME = AQL.name_node('rename')

            private

              # Return return value
              #
              # @return [AQL::Node::Literal::Composed::Document]
              #
              # @api private
              #
              def return_value
                Node::Literal::Composed::Document.new(renamed_attributes)
              end

              # Return for body
              #
              # @return [AQL::Node]
              #
              # @api private
              #
              def body
                return_operation
              end

              # Return renamed attributes
              #
              # @return [Enumerable<AQL::Node::Literal::Composed::Document::Attribute>]
              #
              # @api private
              #
              def renamed_attributes
                input.header.map do |attribute|
                  document_attribute(attribute)
                end
              end

              # Return document attribute
              #
              # @param [Attribute] attribute
              #
              # @return [Node::Literal::Composed::Document::Attribute]
              #
              # @api private
              #
              def document_attribute(attribute)
                key = Node::Literal::Primitive::String.new(attribute.name.to_s)
                Node::Literal::Composed::Document::Attribute.new(key, document_attribute_value(attribute))
              end

              # Return inverse of aliases
              #
              # @return [Algebra::Rename::Aliases]
              #
              # @api private
              #
              def inverse
                input.aliases.inverse
              end
              memoize :inverse

              # Return document attribute value
              #
              # @return [AQL::Node]
              #
              # @api private
              #
              def document_attribute_value(attribute)
                visit(inverse[attribute])
              end

            end
          end
        end
      end
    end
  end
end
