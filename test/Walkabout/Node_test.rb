# test/Walkabout/Node_test.rb

require 'minitest/autorun'

require_relative '../../lib/Walkabout/Node'

describe Walkabout::Node do
  describe '.new' do
    it 'has a name' do
      _(Walkabout::Node.new(:a).name).must_equal :a
    end

    it 'has no predecessors by default' do
      _(Walkabout::Node.new(:a).predecessors).must_equal []
    end

    it 'is not complete' do
      _(Walkabout::Node.new(:a).complete?).must_equal false
    end
  end

  describe '#complete!' do
    it 'makes the node complete' do
      node = Walkabout::Node.new(:a)
      node.complete!
      _(node.complete?).must_equal true
    end
  end
end
