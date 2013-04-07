module Axiom
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

          # Visitor for Axiom::Function::Proposition::Tautology
          class Tautology < self
            ROOT = AQL::Node::Literal::Singleton::TRUE
            handle(Axiom::Function::Proposition::Tautology)
          end

          # Visitor for Axiom::Function::Proposition::Contradiction
          class Contradiction < self
            ROOT = AQL::Node::Literal::Singleton::FALSE
            handle(Axiom::Function::Proposition::Contradiction)
          end
        end
      end
    end
  end
end
