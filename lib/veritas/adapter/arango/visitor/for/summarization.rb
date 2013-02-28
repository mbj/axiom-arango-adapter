module Veritas
  module Adapter
    module Arango
      class Visitor
        class For
          # Visitor for veritas summarizations
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

            # Return collection assignments
            #
            # @return [Enumerable<AQL::Node::Operator::Assignment>]
            #
            # @api private
            #
            def assignments
              input.summarize_per.header.map do |attribute|
                name = AQL::Node::Name.new(attribute.name.to_s)
                value = AQL::Node::Attribute.new(LOCAL_NAME, name)
                AQL::Node::Operator::Assignment.new(
                  name,
                  value
                )
              end
            end
            memoize :assignments

            # Return AQL return value
            #
            # @return [AQL::Node::Literal::Composed::Document]
            #
            # @api private
            #
            def return_value
              AQL::Node::Literal::Composed::Document.new(projected_document_attributes + extension_document_attributes)
            end

            # Return extension document attributes
            #
            # @return [Enumerable<AQL::Node::Literal::Composed::Document::Attribute>]
            #
            # @api private
            #
            def extension_document_attributes
              input.summarizers.map do |attribute, summarizer|
                extension_document_attribute(attribute, summarizer)
              end
            end

            # Return extension document attribute
            #
            # @param [Attribute] attribute
            # @param [Aggregate] summarizer
            #
            # @return [AQL::Node::Literal::Composed::Document::Attribute]
            #
            # @api private
            #
            def extension_document_attribute(attribute, summarizer)
              key = AQL::Node::Literal::Primitive::String.new(attribute.name.to_s)
              value = visit(summarizer)
              AQL::Node::Literal::Composed::Document::Attribute.new(key, value)
            end

            # Return projected document attributes
            #
            # @return [Enumerable<AQL::Node::Literal::Composed::Document::Attribute>]
            #
            # @api private
            #
            def projected_document_attributes
              assignments.map do |assignment|
                value = assignment.name
                key   = AQL::Node::Literal::Primitive::String.new(value.name)
                AQL::Node::Literal::Composed::Document::Attribute.new(key, value)
              end
            end
            memoize :projected_document_attributes

            # Return collect operation
            #
            # @return [AQL::Node::Operation::Nary::Collect::Into]
            #
            # @api private
            #
            def collect_operation
              AQL::Node::Operation::Nary::Collect::Into.new(assignments, COLLECT_NAME)
            end

          end
        end
      end
    end
  end
end
