# Walkabout/CycleError.rb
# Walkabout::CycleError

module Walkabout
  class CycleError < StandardError
    attr_reader :nodes

    private

    def initialize(nodes)
      @nodes = nodes
      super("cycle among: #{nodes.map(&:name).join(', ')}")
    end
  end
end
