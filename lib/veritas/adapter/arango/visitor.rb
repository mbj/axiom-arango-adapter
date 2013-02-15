module Veritas
  module Adapter
    module Arango
      # Base class for relation specific visitors
      class Visitor
        include AbstractType, Adamantium::Flat, Composition.new(:input, :context), AQL

        abstract_method :root

        # Return AQL node from relation 
        #
        # @param [Relation] relation
        #
        # @return [AQL::Node]
        #
        # @api private
        #
        def self.run(relation)
          build(relation).root
        end

        REGISTRY = {}

        # Register handler for veritas relation
        #
        # @param [Class] klass
        #
        # @return [undefined]
        #
        # @api private
        #
        def self.handle(klass)
          REGISTRY[klass]=self
        end

        private_class_method :handle

        # Test if relation can be wrapped within AQL FOR statement
        #
        # @return [true]
        #   if relation supports beeing consumed inside base
        #
        # @return [false]
        #   otherwise
        #
        # @api private
        #
        def wrappable?
          kind_of?(Wrappable)
        end

        # Return visitor for relation and context
        #
        # @param [Relation] relation
        # @param [Visitor] context
        #
        # @return [Visitor]
        #
        # @api private
        #
        def self.build(relation, context = nil)
          REGISTRY.fetch(relation.class).new(relation, context)
        end

      private

        # Return visitor for relation
        #
        # @param [Relation] relation
        # @param [Visitor] context
        #
        # @return [Visitor]
        #
        # @api private
        #
        def visitor(relation, context = self)
          self.class.build(relation, context)
        end

        # Return AQL node from visiting veritas relation
        #
        # @param [Relation] relation
        # @param [Visitor] context
        #
        # @return [AQL::Node]
        #
        # @api private
        #
        def visit(relation, context = self)
          visitor(relation, context).root
        end

      end
    end
  end
end
