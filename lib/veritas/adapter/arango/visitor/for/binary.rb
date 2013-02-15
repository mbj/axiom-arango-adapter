module Veritas
  module Adapter
    module Arango
      class Visitor
        class For
          # Base class for binary relation visitors
          class Binary < self

            # Return local name
            #
            # @return [AQL::Node::Name]
            #
            # @api private
            #
            def local_name
              AQL.name_node(:left)
            end
            memoize :local_name

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
              self.class::Right.new(input.right, self).root
            end

            # Visitor for right of join
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
              memoize :local_name

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

              # Return right header
              #
              # @return [Relation::Header]
              #
              # @api private
              #
              def right_header
                input.header
              end

              # Return left header
              #
              # @return [Relation::Header]
              #
              # @api private
              #
              def left_header
                context_input.left.header
              end

              abstract_method :left_document_attributes
              abstract_method :right_document_attributes

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
