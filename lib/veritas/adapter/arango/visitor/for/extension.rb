module Veritas
  module Adapter
    module Arango
      class Visitor
        class For
          # Visitor for emitting extensions
          class Extension < self

            handle(Algebra::Extension)

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
