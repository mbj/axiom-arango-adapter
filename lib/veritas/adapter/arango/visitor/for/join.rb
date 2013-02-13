module Veritas
  module Adapter
    module Arango
      class Visitor
        class For
          # Visitor for emitting products
          class Join < self

            handle(Veritas::Algebra::Join)

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

              # Return filter
              #
              # @return [AQL::Node::Operation::Filter]
              #
              # @api private
              #
              def filter
                AQL::Node::Operation::Unary::Filter.new(filter_expression)
              end

              # Return filter expression
              #
              # @return [AQL::Node]
              #
              # @api private
              #
              def filter_expression
                AQL::Node::Operator::Nary::And.new(filter_predicates)
              end

              # Return filter predicates
              #
              # @return [Enumerable<AQL::Node::Operator::Binary::Equality>]
              #
              # @api private
              #
              def filter_predicates
                context_input.join_header.map do |attribute|
                  filter_predicate(attribute)
                end
              end

              # Return filter predicate for attribute
              #
              # @param [Attribute] attribute
              #
              # @return [AQL::Node::Operator::Binary::Equality]
              #
              # @api private
              #
              def filter_predicate(attribute)
                AQL::Node::Operator::Binary::Equality.new(visit(attribute, context), visit(attribute))
              end

              # Return body of for statement
              #
              # @return [AQL::Node]
              #
              # @api private
              #
              def body
                AQL::Node::Block.new([filter, return_operation])
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
                visitor(left_header, context).document_attributes
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

              # Return right document attributes
              #
              # @return [Enumerable<AQL::Node::Literal::Composed::Document::Attribute>]
              #
              # @api private
              #
              def right_document_attributes
                visitor(right_document_header).document_attributes
              end

              # Return right document header
              #
              # @return [Relation::Header]
              #
              # @api private
              #
              def right_document_header
                context_input.right.header - left_header
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
