module Veritas
  module Adapter
    module Arango
      class Visitor
        # Base class for visitors with static root 
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

          # Visitor for Veritas::Function::Proposition::Tautology
          class Tautology < self
            ROOT = AQL::Node::Literal::Singleton::TRUE
            handle(Veritas::Function::Proposition::Tautology)
          end

          # Visitor for Veritas::Function::Proposition::Contradiction
          class Contradiction < self
            ROOT = AQL::Node::Literal::Singleton::FALSE
            handle(Veritas::Function::Proposition::Contradiction)
          end
        end
      end
    end
  end
end
