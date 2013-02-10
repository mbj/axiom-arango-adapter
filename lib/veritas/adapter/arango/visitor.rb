module Veritas
  module Adapter
    module Arango
      # Base class for node specific visitors
      class Visitor
        include AbstractType, Adamantium::Flat, Composition.new(:input, :context), AQL

        abstract_method :root
        abstract_method :leaf

        # Return AQL node from relation 
        #
        # @param [Relation] node
        #
        # @return [AQL::Node]
        #
        # @api private
        #
        def self.run(node)
          build(node).root
        end

        REGISTRY = {}

        # Register handler for veritas node
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

        # Return visitor for node and context
        #
        # @param [Node] node
        # @param [Visitor] context
        #
        # @return [Visitor]
        #
        # @api private
        #
        def self.build(node, context = nil)
          REGISTRY.fetch(node.class).new(node, context)
        end

      private

        # Return visitor for relation
        #
        # @param [Node] node
        #
        # @return [Visitor]
        #
        # @api private
        #
        def visitor(node)
          self.class.build(node, self)
        end

        # Return aql node from visiting veritas node
        #
        # @param [Node] node
        #
        # @return [AQL::Node]
        #
        # @api private
        #
        def visit(node)
          visitor(node).root
        end

      end
    end
  end
end
