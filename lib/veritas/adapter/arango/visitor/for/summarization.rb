module Veritas
  module Adapter
    module Arango 
      class Visitor
        class For
          class Summarization < self
            handle(Veritas::Algebra::Summarization)

            LOCAL_NAME = AQL.name_node('summarization')
            COLLECT_NAME = AQL.name_node('collect')

          private

            # Return body of for operation
            #
            # @return [AQL::Node::Block]
            #
            # @api private
            #
            def body
              AQL::Node::Block.new([
                collect_operation,
                return_operation
              ])
            end

            def assignments
              projected_document_attributes.map do |document_attribute|
                attribute = document_attribute.value
                AQL::Node::Operator::Binary::Assignment.new(
                  attribute.name,
                  attribute
                )
              end
            end

            def return_value
              AQL::Node::Literal::Composed::Document.new(projected_document_attributes + extension_document_attributes)
            end

            def extension_document_attributes
              input.summarizers.map do |attribute, summarizer|
                AQL::Node::Literal::Composed::Document::Attribute.new(AQL::Node::Literal::Primitive::String.new(attribute.name.to_s), visit(summarizer, COLLECT_NAME))
              end
            end

            def projected_document_attributes
              visitor(input.summarize_per.header).document_attributes
            end
            memoize :projected_document_attributes

            def collect_operation
              AQL::Node::Operation::Nary::Collect::Into.new(assignments, COLLECT_NAME)
            end


          end
        end
      end
    end
  end
end
