module Veritas
  module Adapter
    module Arango
      class Visitor
        class For
          # Visitor handling veritas base relations
          class Base < self

            handle(Veritas::Relation::Base)

            LOCAL_NAME = AQL.name_node('base')

          private

            # Return source of iteration
            #
            # @return [AQL::Node::Name]
            #
            # @api private
            #
            def source
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
              while current and current.wrappable?
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

          end 
        end
      end
    end
  end
end
