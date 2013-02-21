module Veritas
  module Adapter
    module Arango
      class Visitor
        class Static < self

          # Return root node
          #
          # @return [AQL::Node]
          #
          # @api private
          #
          def root
            self.class::ROOT
          end

          class Tautology < self
            ROOT = AQL::Node::Literal::Singleton::TRUE
            handle(Veritas::Function::Proposition::Tautology)
          end

          class Contradiction < self
            ROOT = AQL::Node::Literal::Singleton::FALSE
            handle(Veritas::Function::Proposition::Contradiction)
          end
        end
      end
    end
  end
end
