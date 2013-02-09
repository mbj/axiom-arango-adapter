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
            until context.root?
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
              DocumentAttribute.process(attribute, self)
            end
            Node::Literal::Composed::Document.new(attributes)
          end

        end # Base

        # Visitor creating document attributes
        class DocumentAttribute < self

          # Return root aql node
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def root
            Node::Literal::Composed::Document::Attribute.new(key, value) 
          end

        private
         
          # Return aql node representing document key
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def key
            Node::Literal::Primitive::String.new(input.name.to_s)
          end
         
          # Return aql node representing document value
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def value
            Node::Attribute.new(context.local_name, Node::Name.new(input.name))
          end

        end
      end
    end
  end
end
