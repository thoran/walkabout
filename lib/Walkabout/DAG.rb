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
        if sequence.size == 1
          [sequence]
        else
          sequence.each_cons(2).to_a
        end
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
      edges.uniq.each do |edge|
        a, b = edge
        predecessor = (nodes[a] ||= Node.new(a))
        next if edge.size == 1
        successor = (nodes[b] ||= Node.new(b))
        successor.predecessors << predecessor
      end
      nodes.values
    end

    def check_for_cycles
      nodes = cyclic_nodes
      raise CycleError.new(nodes) unless nodes.empty?
    end

    # Trims forward from the nodes with no predecessor, then back from those
    # left with no successor. Only nodes on a cycle, or on a path between two,
    # survive.
    def cyclic_nodes
      predecessors = @nodes.to_h{|node| [node, node.predecessors]}
      successors = @nodes.to_h{|node| [node, []]}
      @nodes.each{|node| node.predecessors.each{|p| successors[p] << node}}
      trim(trim(@nodes, predecessors, successors), successors, predecessors)
    end

    # Removes each node with nothing inward of it among those remaining, until
    # none is left to remove.
    def trim(nodes, inward, outward)
      remaining = nodes.to_h{|node| [node, true]}
      counts = nodes.to_h{|node| [node, inward[node].count{|n| remaining[n]}]}
      queue = nodes.select{|node| counts[node].zero?}
      until queue.empty?
        node = queue.shift
        remaining.delete(node)
        outward[node].each do |n|
          next unless remaining[n]
          counts[n] -= 1
          queue << n if counts[n].zero?
        end
      end
      nodes.select{|node| remaining[node]}
    end

    def ready
      @nodes.select do |n|
        !n.complete? && n.predecessors.all?(&:complete?)
      end
    end
  end
end
