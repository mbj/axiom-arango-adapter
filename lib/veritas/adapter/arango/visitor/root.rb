module Veritas
  module Adapter
    module Arango 
      class Visitor
        # Root visitor context
        class Root < self

          # Initialize object
          #
          # @param [node] input
          #
          # @return [undefined]
          #
          # @api private
          #
          def initialize(input)
            super(input, self)
          end

          # Return inspected object
          #
          # Must be overriden to fight stack overflow on inspecting
          #
          # @return [String]
          #
          # @api private
          #
          def inspect
            "#<#{self.class.name} input=#{input.inspect}>"
          end
          memoize :inspect

        end
      end
    end
  end
end
