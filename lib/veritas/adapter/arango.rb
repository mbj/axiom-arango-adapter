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
require 'veritas/adapter/arango/visitor/root'
require 'veritas/adapter/arango/visitor/base'
require 'veritas/adapter/arango/visitor/literal'
require 'veritas/adapter/arango/visitor/binary'
require 'veritas/adapter/arango/visitor/restriction'
require 'veritas/adapter/arango/visitor/attribute'
