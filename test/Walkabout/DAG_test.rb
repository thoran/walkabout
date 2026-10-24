# test/Walkabout/DAG_test.rb

require 'minitest/autorun'

require_relative '../../lib/Walkabout/DAG'

describe Walkabout::DAG do
  def names(nodes)
    nodes.map(&:name)
  end

  describe '.parse' do
    it 'turns each sequence into edges between consecutive members' do
      dag = Walkabout::DAG.parse([[:a, :b, :c], [:d, :b, :e]])
      _(names(dag.take(5))).must_equal [:a, :d]
    end

    it 'joins sequences at the members they share' do
      dag = Walkabout::DAG.parse([[:a, :b], [:c, :b]])
      dag.take.complete!
      _(names(dag.take(5))).must_equal [:c]
      dag.take.complete!
      _(names(dag.take(5))).must_equal [:b]
    end
  end

  describe '#take' do
    it 'returns the first ready node when given no count' do
      dag = Walkabout::DAG.new([[:a, :b]])
      _(dag.take.name).must_equal :a
    end

    it 'returns up to n ready nodes when given a count' do
      dag = Walkabout::DAG.parse([[:a, :d], [:b, :d], [:c, :d]])
      _(names(dag.take(2))).must_equal [:a, :b]
    end

    it 'returns a node only once its predecessors are complete' do
      dag = Walkabout::DAG.parse([[:a, :b, :c]])
      _(names(dag.take(5))).must_equal [:a]
      dag.take.complete!
      _(names(dag.take(5))).must_equal [:b]
    end

    it 'returns nil, or an empty array, when nothing is ready' do
      dag = Walkabout::DAG.new([])
      _(dag.take).must_be_nil
      _(dag.take(2)).must_equal []
    end
  end

  describe '#complete?' do
    it 'is false while any node is incomplete' do
      dag = Walkabout::DAG.new([[:a, :b]])
      dag.take.complete!
      _(dag.complete?).must_equal false
    end

    it 'is true once every node is complete' do
      dag = Walkabout::DAG.parse([[:a, :b, :c], [:d, :b]])
      while (node = dag.take)
        node.complete!
      end
      _(dag.complete?).must_equal true
    end
  end

  describe 'cycles' do
    it 'raises CycleError for a cycle' do
      _{Walkabout::DAG.new([[:a, :b], [:b, :a]])}.must_raise Walkabout::CycleError
    end

    it 'raises CycleError for a node which is its own predecessor' do
      _{Walkabout::DAG.new([[:a, :a]])}.must_raise Walkabout::CycleError
    end

    it 'names only the nodes on the cycle, and not those before or after it' do
      error = _{Walkabout::DAG.parse([[:x, :a, :b, :c, :a], [:c, :y]])}.must_raise Walkabout::CycleError
      _(names(error.nodes).sort).must_equal [:a, :b, :c]
      _(error.message).must_equal 'cycle among: a, b, c'
    end

    it 'does not raise where paths diverge and rejoin' do
      _(Walkabout::DAG.parse([[:a, :b, :d], [:a, :c, :d]]).take.name).must_equal :a
    end
  end
end
