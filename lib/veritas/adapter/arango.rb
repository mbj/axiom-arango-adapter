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
require 'veritas/adapter/arango/visitor/for/projection'
require 'veritas/adapter/arango/visitor/for/rename'
require 'veritas/adapter/arango/visitor/for/extension'
require 'veritas/adapter/arango/visitor/for/summarization'
require 'veritas/adapter/arango/visitor/for/binary'
require 'veritas/adapter/arango/visitor/for/binary/join'
require 'veritas/adapter/arango/visitor/for/binary/product'
require 'veritas/adapter/arango/visitor/wrappable'
require 'veritas/adapter/arango/visitor/wrappable/restriction'
require 'veritas/adapter/arango/visitor/wrappable/order'
require 'veritas/adapter/arango/visitor/wrappable/limit'
require 'veritas/adapter/arango/visitor/wrappable/offset'
