module Veritas
  module Adapter
    module Arango
      class Visitor
        include AbstractType, Adamantium::Flat, Composition.new(:input, :context), AQL

        class Root < self
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

        abstract_method :root
        abstract_method :leaf

        def self.run(relation)
          visitor(relation, Root.new(relation)).root.aql
        end

        def self.table
          @table ||= {
            String                                     => Literal,
            Veritas::Attribute::String                 => Attribute,
            Veritas::Function::Connective::Disjunction => Binary,
            Veritas::Function::Predicate::Equality     => Binary,
            Veritas::Algebra::Restriction              => Restriction,
            Veritas::Relation::Base                    => BaseRelation
          }
        end

        def self.visitor(relation, context)
          table.fetch(relation.class).new(relation, context)
        end

        def visitor(relation)
          self.class.visitor(relation, self)
        end

        def visit(relation)
          visitor(relation).root
        end

        def self.process(*args)
          new(*args).root
        end

        class Literal < self
          def root
            Node::Literal.build(input)
          end
        end

        class Binary < self
          TABLE = {
            Veritas::Function::Connective::Disjunction => AQL::Node::Operator::Binary::Or,
            Veritas::Function::Predicate::Equality     => AQL::Node::Operator::Binary::Equality
          }

          def local_name
            context.local_name
          end

          def root
            klass = TABLE.fetch(input.class)
            klass.new(left, right)
          end

          def left
            visit(input.left)
          end

          def right
            visit(input.right)
          end
        end

        class Attribute < self

          def root
            Node::Attribute.new(context.local_name, Node::Name.new(input.name))
          end
        end

        class Restriction < self

          def root
            visit(input.operand)
          end

          def leaf
            Node::Operation::Unary::Filter.new(expression)
          end

          def local_name
            visitor(input.operand).local_name
          end

          def expression
            visit(input.predicate)
          end
        end

        class BaseRelation < self

          def root
            Node::Operation::For.new(local_name, collection_name, body)
          end

          def local_name
            Node::Name.new("local_#{input.name}")
          end
          memoize :local_name

        private

          def collection_name
            Node::Name.new(input.name)
          end

          def leafes
            leafes = []
            current = context
            until current.kind_of?(Root)
              leafes << current.leaf
              current = current.context
            end
            leafes

          end

          def body
            body = []
            body.concat(leafes)
            body << return_operation
            Node::Block.new(body)
          end

          def return_operation
            Node::Operation::Unary::Return.new(document)
          end

          def document
            attributes = input.header.map do |attribute|
              DocumentAttribute.process(attribute, self)
            end
            Node::Literal::Composed::Document.new(attributes)
          end
        end

        class DocumentAttribute < self

          def root
            Node::Literal::Composed::Document::Attribute.new(key, value) 
          end

        private

          def key
            Node::Literal::Primitive::String.new(input.name.to_s)
          end

          def value
            Node::Attribute.new(context.local_name, Node::Name.new(input.name))
          end

        end

      end
    end
  end
end
