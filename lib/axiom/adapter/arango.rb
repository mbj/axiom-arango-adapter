require 'axiom'
require 'aql'
require 'concord'
require 'ashikawa-core'
require 'null_logger'

module Axiom
  # Namespace for axiom adapters
  module Adapter
    # Namespace for ArangoDB adapter
    module Arango
    end
  end
end

require 'axiom/adapter/arango/adapter'
require 'axiom/adapter/arango/gateway'
require 'axiom/adapter/arango/reader'
require 'axiom/adapter/arango/visitor'
require 'axiom/adapter/arango/visitor/function'
require 'axiom/adapter/arango/visitor/literal'
require 'axiom/adapter/arango/visitor/binary'
require 'axiom/adapter/arango/visitor/header'
require 'axiom/adapter/arango/visitor/attribute'
require 'axiom/adapter/arango/visitor/reverse'
require 'axiom/adapter/arango/visitor/aggregate'
require 'axiom/adapter/arango/visitor/for'
require 'axiom/adapter/arango/visitor/for/base'
require 'axiom/adapter/arango/visitor/for/summarization'
require 'axiom/adapter/arango/visitor/for/unary'
require 'axiom/adapter/arango/visitor/for/unary/extension'
require 'axiom/adapter/arango/visitor/for/unary/projection'
require 'axiom/adapter/arango/visitor/for/unary/rename'
require 'axiom/adapter/arango/visitor/for/unary/restriction'
require 'axiom/adapter/arango/visitor/for/unary/order'
require 'axiom/adapter/arango/visitor/for/unary/limit'
require 'axiom/adapter/arango/visitor/for/unary/offset'
require 'axiom/adapter/arango/visitor/for/binary'
require 'axiom/adapter/arango/visitor/for/binary/join'
require 'axiom/adapter/arango/visitor/for/binary/product'
