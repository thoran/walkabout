# Walkabout/DAG.rb
# Walkabout::DAG

module Walkabout
  class DAG
    class << self
      def parse(sequences)
        result = []
        sequences.map{|s| result += parse_sequence(s)}
        result
      end

      private

      def parse_sequence(sequence)
        result = []
        sequence.each_cons(2){|c| result << c}
        result
      end
    end # class << self
  end
end

sequences = [
  [:a, :b, :c],
  [:d, :b, :e],
  [:f, :g]
]

Walkabout::DAG.parse(sequences)
