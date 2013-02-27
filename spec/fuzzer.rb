#!/usr/bin/env ruby

require 'veritas-arango-adapter'
require 'veritas-fuzzer'
require 'logger'
require 'yaml'
 
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

Veritas::Fuzzer.run(gateway, relation)

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
