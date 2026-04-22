# Walkabout/DAG.rb
# Walkabout::DAG

module Walkabout
  class DAG
    class Node
      @nodes = []

      class << self
        def from_edges(edges)
          builder_nodes = {}
          edges.each do |a, b|
            predecessor = (builder_nodes[a] ||= self.new(a))
            (builder_nodes[b] ||= self.new(b)).predecessors << predecessor
          end
          @nodes = builder_nodes.values
        end

        def complete
          @nodes.select{|n| n.complete?}
        end

        def ready
          @nodes.select do |n|
            !n.complete? && n.predecessors.all?{|p| p.complete?}
          end
        end
      end # class << self

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

    def ready
      Node.ready
    end

    def next
      ready.first
    end

    def complete?
      Node.ready.empty?
    end

    private

    def initialize(edges)
      Node.from_edges(edges)
    end
  end
end

sequences = [
  [:a, :b, :c],
  [:d, :b, :e],
  [:f, :g]
]

dag = Walkabout::DAG.parse(sequences)
node = dag.next
node.complete!
