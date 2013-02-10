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
require 'veritas/adapter/arango/visitor/base'
require 'veritas/adapter/arango/visitor/literal'
require 'veritas/adapter/arango/visitor/binary'
require 'veritas/adapter/arango/visitor/attribute'
require 'veritas/adapter/arango/visitor/operation'
require 'veritas/adapter/arango/visitor/operation/restriction'
require 'veritas/adapter/arango/visitor/operation/reverse'
require 'veritas/adapter/arango/visitor/operation/order'
require 'veritas/adapter/arango/visitor/operation/limit'
require 'veritas/adapter/arango/visitor/operation/offset'
