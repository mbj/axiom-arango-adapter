module Veritas
  module Adapter
    module Arango
      class Visitor
        include AbstractType, Adamantium::Flat, Composition.new(:input, :context), AQL

        def self.run(relation)
          visitor(relation, nil).output.aql
        end

        def self.table
          @table ||= {
            String                                     => Literal,
            Veritas::Attribute::String                 => Attribute,
            Veritas::Function::Connective::Disjunction => Binary,
            Veritas::Function::Predicate::Equality     => Binary,
            Veritas::Algebra::Restriction              => Restriction,
            Veritas::Relation::Base                    => BaseRelation,
          }
        end

        def self.visitor(relation, context)
          table.fetch(relation.class).new(relation, context)
        end

        def visitor(relation)
          self.class.visitor(relation, self)
        end

        def visit(relation)
          visitor(relation).output
        end

        abstract_method :output

        def self.process(*args)
          new(*args).output
        end

        class Literal < self
          def output
            Node::Literal.build(input)
          end
        end

        class Binary < self
          TABLE = {
            Veritas::Function::Connective::Disjunction => AQL::Node::Operator::Binary::Or,
            Veritas::Function::Predicate::Equality => AQL::Node::Operator::Binary::Equality
          }

          def local_name
            context.local_name
          end

          def output
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

          def output
            Node::Attribute.new(context.local_name, Node::Name.new(input.name))
          end
        end

        class Restriction < self
          def output
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

          def output
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

          def body
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

          def output
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
