module Veritas
  module Adapter
    module Arango
      class Visitor
        class Aggregate < self

          LOCAL_NAME = AQL.name_node('aggregate')

          def root
            Node::Call.new(self.class::FUNCTION, [mapped])
          end

        private

          def map_attribute_name
            Node::Name.new(input.operand.name.to_s)
          end
          memoize :map_attribute_name

          def map_attribute
            Node::Attribute.new(LOCAL_NAME, map_attribute_name)
          end
          memoize :map_attribute

          def mapped
            Node::Operation::For.new(
              LOCAL_NAME, 
              context, 
              map_body
            )
          end

          def map_filter
            Node::Operation::Unary::Filter.new(
              Node::Operator::Binary::Inequality.new(map_attribute_name, Node::Literal::Singleton::NULL)
            )
          end

          def map_return
            Node::Operation::Unary::Return.new(
              map_attribute
            )
          end

          def map_body
            Node::Block.new([
              map_filter,
              map_return
            ])
          end

          class Count < self
            FUNCTION = 'LENGTH'.freeze
            handle(Veritas::Aggregate::Count)
          end

          class Sum < self
            FUNCTION = 'SUM'.freeze
            handle(Veritas::Aggregate::Sum)
          end

          class Maxiumum < self
            FUNCTION = 'MAX'.freeze
            handle(Veritas::Aggregate::Maximum)
          end

          class Minimum < self
            FUNCTION = 'MIN'.freeze
            handle(Veritas::Aggregate::Minimum)
          end

        end
      end
    end
  end
end
