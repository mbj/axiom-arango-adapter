#!/usr/bin/ruby -Ku
 
# encoding: utf-8
 
# gem install backports veritas veritas-optimizer 
 
require 'logger'
require 'rubygems'
require 'backports'
require 'veritas'
require 'veritas-arango-adapter'
require 'uri'
require 'diffy'
require 'terminal-table'
 
srand(Time.now.to_i)
 
def next_operation(relation)
  # TODO: break this up into separate classes for each mutation
  #       and then randomly select the mutator class.
 
  # TODO: add more operations
  method = [ :none, :project, :remove, :join, :product, :union, :intersect, :difference, :restrict ].sample

  header      = relation.header
  header_size = header.to_a.size
  attributes  = header.to_a.sample(rand(header_size))
 
  case method
  when nil
    nil  # do nothing
  when :none
    [ :restrict , [], proc { Veritas::Function::Proposition::Tautology.new }]
  when :project, :remove
    [ method, [ attributes ] ] if attributes.any?
  when :restrict
    predicate = attributes.reduce(Veritas::Function::Proposition::Tautology.new) do |predicate, attribute|
      function = [ :eq, :ne, :gt, :gte, :lt, :lte ].sample
      value    = relation.map { |tuple| tuple[attribute] }.sample
 
      predicate.and(attribute.send(function, value))
    end
 
    [ :restrict, [], proc { predicate } ]
  when :join, :product, :union, :intersect, :difference
    other_method, other_args, other_block = next_operation(relation)
    return unless other_method
    [ :join, [ relation.send(other_method, *other_args, &other_block) ] ]
  else
    raise "unhandled operation: #{method}"
  end
end
 
def table(relation)
  Terminal::Table.new do |table|
    table.headings = relation.header.map(&:name)
    table.rows     = relation.map(&:to_ary)
  end
end
 
database = Ashikawa::Core::Database.new('http://localhost:8529')
collection = database['people']
collection.delete
collection = database['people']
 
YAML.load(DATA).each do |document|
  collection.create(document)
end
 
header   = [ [ :id, Integer ], [ :name, String, { :length => 1..50 } ] ]

base     = Veritas::Relation::Base.new('people', header)
adapter  = Veritas::Adapter::Arango::Adapter.new(database, Logger.new($stderr, :debug))
gateway  = adapter.gateway(base)
relation = gateway.materialize
 

stack = [ [ gateway, relation ] ]
 
while element = stack.last
  gateway, relation = element

  relations = {
    :gateway_materialized            => gateway.materialize,
    :relation_materialized           => relation.materialize,
  }
 
  relations.keys.permutation(2) do |(left_key, right_key)|
    next if left_key < right_key
    left, right = relations.values_at(left_key, right_key)

    p left == right

    next if left == right
 
    left_table  = table(left.sort_by  { left.header  })
    right_table = table(right.sort_by { right.header })
 
    raise <<-OUTPUT.gsub(/^\s+/, '')
      #{left_key} and #{right_key} are different:
      #{Diffy::Diff.new(left_table, right_table)}
    OUTPUT
  end

  method, args, block = next_operation(relation) if relation.any?

  if method.nil?
    stack.pop
  else
    stack << [
      gateway.send(method, *args, &block),
      relation.send(method, *args, &block),
    ]
  end

end
 
__END__
---
- id: 1
  name: Macie Deckow
- id: 2
  name: Desmond Gleichner
- id: 3
  name: Phil Krajcik
- id: 4
  name: Adolph McClure
- id: 5
  name: Trudy Torphy
- id: 6
  name: Vance Hegmann
- id: 7
  name: Lincoln Morissette
- id: 8
  name: Dexter Doyle
- id: 9
  name: Edgar Sanford
- id: 10
  name: Jasper Batz
