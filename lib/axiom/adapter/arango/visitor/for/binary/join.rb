module Axiom
  module Adapter
    module Arango
      class Visitor
        class For
          class Binary
            # Visitor for emitting joins
            class Join < self

              handle(Axiom::Algebra::Join)

              # Return local name
              #
              # @return [AQL::Node::Name]
              #
              # @api private
              #
              def local_name
                AQL::Node::Name.new("local_#{depth}")
              end
              memoize :local_name

            private

              # Visitor for right of join
              class Right < Binary::Right

              private

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
                  right_header - left_header
                end

              end
            end
          end
        end
      end
    end
  end
end
