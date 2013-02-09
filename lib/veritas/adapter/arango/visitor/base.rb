module Veritas
  module Adapter
    module Arango
      class Visitor
        # Visitor handling veritas base relations
        class Base < self

          handle(Veritas::Relation::Base)

          # Return root aql node
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def root
            Node::Operation::For.new(local_name, collection_name, body)
          end
          memoize :root

          # Return local name
          #
          # @return [AQL::Node::Name]
          # 
          # @api private
          #
          def local_name
            Node::Name.new("local_#{input.name}")
          end
          memoize :local_name

        private

          # Return collection name
          #
          # @return [AQL::Node::Name]
          #
          # @api private
          #
          def collection_name
            Node::Name.new(input.name)
          end

          # Return leaves
          #
          # @return [Enumerable<AQL::Node>]
          #
          # @api private
          #
          def leaves
            leafes = []
            context = self.context
            while !context.root?  # mutant does not know "until" currently ;)
              leafes << context.leaf
              context = context.context
            end
            leafes
          end

          # Return body of for statement
          #
          # @return [AQL::Node::Body]
          #
          # @api private
          #
          def body
            body = []
            body.concat(leaves)
            body << return_operation
            Node::Block.new(body)
          end

          # Return return operation
          #
          # @return [AQL::Node::Operation::Unary::Return]
          #
          # @api private
          #
          def return_operation
            Node::Operation::Unary::Return.new(document)
          end

          # Return document node
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def document
            attributes = input.header.map do |attribute|
              document_attribute(attribute)
            end
            Node::Literal::Composed::Document.new(attributes)
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
            name = attribute.name
            key = Node::Literal::Primitive::String.new(name.to_s)
            value = Node::Attribute.new(local_name, Node::Name.new(name))
            Node::Literal::Composed::Document::Attribute.new(key, value) 
          end

        end 
      end
    end
  end
end
