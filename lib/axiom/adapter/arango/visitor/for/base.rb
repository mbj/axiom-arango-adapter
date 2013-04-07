module Axiom
  module Adapter
    module Arango
      class Visitor
        class For
          # Visitor handling axiom base relations
          class Base < self

            handle(Axiom::Relation::Base)

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

            # Return body of for statement
            #
            # @return [AQL::Node::Body]
            #
            # @api private
            #
            def body
              Node::Block.new([return_operation])
            end

          end
        end
      end
    end
  end
end
