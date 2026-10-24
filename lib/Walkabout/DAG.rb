# Walkabout/DAG.rb
# Walkabout::DAG

require_relative 'CycleError'
require_relative 'Node'

module Walkabout
  class DAG
    class << self
      def parse(sequences)
        self.new(sequences.flat_map{|s| parse_sequence(s)})
      end

      private

      def parse_sequence(sequence)
        sequence.each_cons(2).to_a
      end
    end # class << self

    def take(n = nil)
      if n
        ready.first(n)
      else
        ready.first
      end
    end

    def complete?
      ready.empty?
    end

    private

    def initialize(edges)
      @nodes = build_nodes(edges)
      check_for_cycles
    end

    def build_nodes(edges)
      nodes = {}
      edges.each do |a, b|
        predecessor = (nodes[a] ||= Node.new(a))
        successor = (nodes[b] ||= Node.new(b))
        successor.predecessors << predecessor
      end
      nodes.values
    end

    def check_for_cycles
      nodes = cyclic_nodes
      raise CycleError.new(nodes) unless nodes.empty?
    end

    # Trims, until nothing more goes, every node with no predecessor or no
    # successor left among those remaining. Only nodes on a cycle, or on a path
    # between two, survive.
    def cyclic_nodes
      nodes = @nodes
      while (trimmed = nodes_with_predecessor_and_successor_among(nodes)) != nodes
        nodes = trimmed
      end
      nodes
    end

    def nodes_with_predecessor_and_successor_among(nodes)
      nodes.select do |node|
        node.predecessors.any?{|p| nodes.include?(p)} && nodes.any?{|n| n.predecessors.include?(node)}
      end
    end

    def ready
      @nodes.select do |n|
        !n.complete? && n.predecessors.all?(&:complete?)
      end
    end
  end
end
