module Veritas
  module Adapter
    module Arango
      class Visitor
        class For
          class Unary
            # Visitor for emitting AQL SORT statements from veritas order operations
            class Order < self

              handle(Veritas::Relation::Operation::Order)

              LOCAL_NAME = AQL.name_node('order')

            private

              # Return operation
              #
              # @return [AQL::Node]
              #
              # @api private
              #
              def operation
                Node::Operation::Nary::Sort.new(directions)
              end
              memoize :operation

              # Return restriction expression
              #
              # @return [Enumerable<AQL::Node>]
              #
              # @api private
              #
              def directions
                input.directions.map do |direction|
                  direction(direction)
                end
              end

              TABLE = {
                Veritas::Relation::Operation::Order::Ascending  => Node::Operation::Unary::Direction::Ascending,
                Veritas::Relation::Operation::Order::Descending => Node::Operation::Unary::Direction::Descending
              }.freeze

              # Return direction AQL for veritas direction
              #
              # @param [Relation::Operation::Order::Direction] direction
              #
              # @return [AQL::Node]
              #
              # @api private
              #
              def direction(direction)
                klass = TABLE.fetch(direction.class)
                klass.new(visit(direction.attribute))
              end

            end
          end
        end
      end
    end
  end
end
