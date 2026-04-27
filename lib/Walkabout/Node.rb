# Walkabout/Node.rb
# Walkabout::Node

module Walkabout
  class Node
    attr_accessor :name
    attr_accessor :predecessors

    def complete!
      @complete = true
    end

    def complete?
      @complete
    end

    private

    def initialize(name, predecessors = [])
      @name = name
      @predecessors = predecessors
      @complete = false
    end
  end
end
