module Veritas
  module Adapter
    module Arango
      class Visitor
        class Wrappable
          # Vistor for emitting AQL SORT statments from veritas order operations
          class Order < self

            handle(Veritas::Relation::Operation::Order)

            # Return leaf aql ast
            #
            # @return [AQL::Node]
            #
            # @api private
            #
            def leaf
              Node::Operation::Nary::Sort.new(directions)
            end
            memoize :leaf

          private

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

            # Return direction aql for veritas direction
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
