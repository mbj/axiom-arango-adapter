module Veritas
  module Adapter
    module Arango
      class Visitor
        class For
          class Unary
            # Visitor for emitting extensions
            class Extension < self

              handle(Algebra::Extension)

              LOCAL_NAME = AQL.name_node('extension')

            private

              # Return for body
              #
              # @return [AQL::Node]
              #
              # @api private
              #
              def body
                return_operation
              end

              # Return return value
              #
              # @return [AQL::Node::Call]
              #
              # @api private
              #
              def return_value
                Node::Call.new('MERGE', [local_name, Node::Literal::Composed::Document.new(extended_attributes)])
              end

              # Return document attribute node
              #
              # @return [Veritas::Attribute] attribute
              #
              # @return [AQL::Node]
              #
              # @api private
              #
              def extended_attributes
                input.extensions.map do |attribute, function|
                  document_attribute(attribute, function)
                end
              end

              # Return document attribute
              #
              # @param [Veritas::Attribute] attribute
              # @param [Veritas::Function] function
              #
              # @return [AQL::Node::Literal::Composed::Document::Attribute>]
              #
              # @api private
              #
              def document_attribute(attribute, function)
                Node::Literal::Composed::Document::Attribute.new(
                  Node::Literal::Primitive::String.new(attribute.name.to_s),
                  visit(function)
                )
              end

            end
          end
        end
      end
    end
  end
end
