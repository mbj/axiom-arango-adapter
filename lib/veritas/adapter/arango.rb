require 'veritas'
require 'aql'
require 'concord'
require 'ashikawa-core'
require 'null_logger'

module Veritas
  # Namespace for veritas adapters
  module Adapter
    # Namespace for ArangoDB adapter
    module Arango
    end
  end
end

require 'veritas/adapter/arango/adapter'
require 'veritas/adapter/arango/gateway'
require 'veritas/adapter/arango/reader'
require 'veritas/adapter/arango/visitor'
require 'veritas/adapter/arango/visitor/function'
require 'veritas/adapter/arango/visitor/literal'
require 'veritas/adapter/arango/visitor/binary'
require 'veritas/adapter/arango/visitor/header'
require 'veritas/adapter/arango/visitor/attribute'
require 'veritas/adapter/arango/visitor/reverse'
require 'veritas/adapter/arango/visitor/aggregate'
require 'veritas/adapter/arango/visitor/for'
require 'veritas/adapter/arango/visitor/for/base'
require 'veritas/adapter/arango/visitor/for/summarization'
require 'veritas/adapter/arango/visitor/for/unary'
require 'veritas/adapter/arango/visitor/for/unary/extension'
require 'veritas/adapter/arango/visitor/for/unary/projection'
require 'veritas/adapter/arango/visitor/for/unary/rename'
require 'veritas/adapter/arango/visitor/for/unary/restriction'
require 'veritas/adapter/arango/visitor/for/unary/order'
require 'veritas/adapter/arango/visitor/for/unary/limit'
require 'veritas/adapter/arango/visitor/for/unary/offset'
require 'veritas/adapter/arango/visitor/for/binary'
require 'veritas/adapter/arango/visitor/for/binary/join'
require 'veritas/adapter/arango/visitor/for/binary/product'
