#!/usr/bin/env ruby

require 'axiom-arango-adapter'
require 'axiom-fuzzer'
require 'logger'
require 'yaml'

# This will go away with the shared gateway
Axiom::Sexp::Generator::REGISTRY[Veritas::Adapter::Arango::Gateway] = [ :unary, :gateway, :relation ]
 
database = Ashikawa::Core::Database.new do |config|
  config.url = 'http://localhost:8529'
end

collection = database['people']
collection.delete
collection = database['people']
 
YAML.load(DATA).each do |document|
  collection.create_document(document)
end

header   = [ [ :id, Integer ], [ :name, String, { :length => 1..50 } ] ]

base     = Axiom::Relation::Base.new('people', header)
adapter  = Axiom::Adapter::Arango::Adapter.new(database, Logger.new($stderr, :debug))
gateway  = adapter.gateway(base)
relation = gateway.materialize

Axiom::Fuzzer.run(gateway, relation)

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
