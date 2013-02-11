module Veritas
  module Adapter
    module Arango
      class Visitor
        # Visitor handling veritas base relations
        class Base < self

          handle(Veritas::Relation::Base)

          # Return root aql node
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def root
            Node::Operation::For.new(local_name, collection_name, body)
          end
          memoize :root

          # Return local name
          #
          # @return [AQL::Node::Name]
          # 
          # @api private
          #
          def local_name
            AQL.name_node("local_#{input.name}")
          end
          memoize :local_name

        private

          # List of nodes that are emitted within Base visitor
          CONSUME = [
            Algebra::Restriction,
            Relation::Operation::Order,
            Relation::Operation::Offset,
            Relation::Operation::Limit,
          ].to_set

          # Return collection name
          #
          # @return [AQL::Node::Name]
          #
          # @api private
          #
          def collection_name
            AQL.name_node(input.name)
          end

          # Return leaves
          #
          # @return [Enumerable<AQL::Node>]
          #
          # @api private
          #
          def leaves
            leaves = []
            current = context
            while current and current.consume_in_base?
              leaves << current.leaf
              current = current.context
            end
            leaves
          end

          # Return body of for statement
          #
          # @return [AQL::Node::Body]
          #
          # @api private
          #
          def body
            body = leaves
            body << return_operation
            Node::Block.new(body)
          end

          # Return return operation
          #
          # @return [AQL::Node::Operation::Unary::Return]
          #
          # @api private
          #
          def return_operation
            Node::Operation::Unary::Return.new(visit(input.header))
          end

        end 
      end
    end
  end
end
