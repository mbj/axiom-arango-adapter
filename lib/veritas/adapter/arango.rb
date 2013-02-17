require 'veritas'
require 'aql'

module Veritas
  # Namespace for veritas adapters
  module Adapter
    # Namespace for arango adapter
    module Arango
    end
  end
end

require 'veritas/adapter/arango/visitor'
require 'veritas/adapter/arango/visitor/literal'
require 'veritas/adapter/arango/visitor/binary'
require 'veritas/adapter/arango/visitor/header'
require 'veritas/adapter/arango/visitor/attribute'
require 'veritas/adapter/arango/visitor/reverse'
require 'veritas/adapter/arango/visitor/for'
require 'veritas/adapter/arango/visitor/for/base'
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
