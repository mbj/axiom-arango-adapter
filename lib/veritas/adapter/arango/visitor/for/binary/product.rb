module Veritas
  module Adapter
    module Arango
      class Visitor
        class For
          class Binary
            # Visitor for emitting products
            class Product < self

              handle(Veritas::Algebra::Product)


            private

              # Vistior for right of projection
              class Right < Binary::Right

              private

                # Return left document attributes
                #
                # @return [Enumerable<AQL::Node::Literal::Composed::Document::Attribute>]
                #
                # @api private
                #
                def left_document_attributes
                  visitor = visitor(left_header, context)
                  visitor.document_attributes
                end

                # Return right document attributes
                #
                # @return [Enumerable<AQL::Node::Literal::Composed::Document::Attribute>]
                #
                # @api private
                #
                def right_document_attributes
                  visitor(right_header).document_attributes
                end

              end
            end
          end
        end
      end
    end
  end
end
