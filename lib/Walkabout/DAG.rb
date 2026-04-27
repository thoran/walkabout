# Walkabout/DAG.rb
# Walkabout::DAG

require_relative 'Node'

module Walkabout
  class DAG
    class << self
      def parse(sequences)
        result = []
        sequences.map{|s| result += parse_sequence(s)}
        self.new(result)
      end

      private

      def parse_sequence(sequence)
        result = []
        sequence.each_cons(2){|c| result << c}
        result
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

    def ready
      @nodes.select do |n|
        !n.complete? && n.predecessors.all?(&:complete?)
      end
    end
  end
end
