module Veritas
  module Adapter
    module Arango
      class Visitor
        class For
          # Visitor for emitting products
          class Product < self

            handle(Veritas::Algebra::Product)

            # Return local name
            #
            # @return [AQL::Node::Name]
            #
            # @api private
            #
            def local_name
              AQL.name_node(:left)
            end

          private

            # Return iteration source
            #
            # @return [AQL::Node]
            #
            # @api private
            # 
            def source
              visit(input.left)
            end

            # Return body of for statement
            #
            # @return [AQL::Node]
            #
            # @api private
            #
            def body
              Right.new(input.right, self).root
            end

            # Vistior for right of projection
            class Right < For

              # Return local name
              #
              # @return [AQL::Node::Name]
              #
              # @api private
              #
              def local_name
                AQL.name_node(:right)
              end

            private

              # Return source of iteration 
              #
              # @return [AQL::Node]
              #
              # @api private
              #
              def source
                visit(input)
              end

              # Return return value
              #
              # @return [AQL::Node::Literal::Compised::Document]
              #
              # @api private
              #
              def return_value
                AQL::Node::Literal::Composed::Document.new(left_document_attributes + right_document_attributes)
              end

              # Return left document attributes
              #
              # @return [Enumerable<AQL::Node::Literal::Composed::Document::Attribute>]
              #
              # @api private
              #
              def left_document_attributes
                visitor = visitor(context_input.left.header, context)
                visitor.document_attributes
              end

              # Return right document attributes
              #
              # @return [Enumerable<AQL::Node::Literal::Composed::Document::Attribute>]
              #
              # @api private
              #
              def right_document_attributes
                visitor(context_input.right.header).document_attributes
              end

              # Return context input
              #
              # @return [Veritas::Relation] 
              #
              # @api private
              #
              def context_input
                context.input
              end

            end
          end
        end
      end
    end
  end
end
