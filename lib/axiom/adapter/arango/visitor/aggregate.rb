module Axiom
  module Adapter
    module Arango
      class Visitor
        # Base class for aggregate visitors
        class Aggregate < self

          LOCAL_NAME = AQL.name_node('aggregate')

          # Return root AQL node
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def root
            Node::Call.new(self.class::FUNCTION, [mapped])
          end
          memoize :root

        private

          # Return attribute name used for mapping
          #
          # @return [AQL::Node::Name]
          #
          # @api private
          #
          def map_attribute_name
            Node::Name.new(input.operand.name.to_s)
          end
          memoize :map_attribute_name

          # Return summarization attribute
          #
          # @return [AQL::Node::Attribute]
          #
          # @api private
          #
          def summarization_attribute
            Node::Attribute.new(For::Summarization::LOCAL_NAME, map_attribute_name)
          end

          # Return attribute used for mapping
          #
          # @return [AQL::Node::Attribute]
          #
          # @api private
          #
          def map_attribute
            Node::Attribute.new(LOCAL_NAME, summarization_attribute)
          end
          memoize :map_attribute

          # Return mapped collection
          #
          # @return [AQL::Node::Operation::For]
          #
          # @api private
          #
          def mapped
            Node::Operation::For.new(
              LOCAL_NAME,
              For::Summarization::COLLECT_NAME,
              map_body
            )
          end

          # Return map filter operation
          #
          # @return [AQL::Node::Operation::Unary::Filter]
          #
          # @api private
          #
          def map_filter
            Node::Operation::Unary::Filter.new(
              Node::Operator::Binary::Inequality.new(map_attribute, Node::Literal::Singleton::NULL)
            )
          end

          # Return map return operation
          #
          # @return [AQL::Node::Operation::Unary::Return]
          #
          # @api private
          #
          def map_return
            Node::Operation::Unary::Return.new(map_attribute)
          end

          # Return map body
          #
          # @return [AQL::Node::Block]
          #
          # @api private
          #
          def map_body
            Node::Block.new([
              map_filter,
              map_return
            ])
          end

          # Visitor for count aggregate
          class Count < self
            FUNCTION = 'LENGTH'.freeze
            handle(Axiom::Aggregate::Count)
          end

          # Visitor for sum aggregate
          class Sum < self
            FUNCTION = 'SUM'.freeze
            handle(Axiom::Aggregate::Sum)
          end

          # Visitor for maximum aggregate
          class Maximum < self
            FUNCTION = 'MAX'.freeze
            handle(Axiom::Aggregate::Maximum)
          end

          # Visitor for minimum aggregate
          class Minimum < self
            FUNCTION = 'MIN'.freeze
            handle(Axiom::Aggregate::Minimum)
          end

        end
      end
    end
  end
end
