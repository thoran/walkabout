# walkabout

Walk a directed acyclic graph in dependency order.

## Installation

```
gem install walkabout
```

Or add to your Gemfile:

```ruby
gem 'walkabout'
```

## Usage

```ruby
require 'walkabout'
```

### Building a DAG

From edges, each a pair of predecessor and successor:

```ruby
dag = Walkabout::DAG.new([[:a, :b], [:b, :c], [:d, :b]])
```

Or from sequences, each of which is read as edges between its consecutive
members, and which join at the members they share:

```ruby
dag = Walkabout::DAG.parse([
  [:a, :b, :c],
  [:d, :b, :e],
  [:f, :g]
])
```

Nodes are made from the names in the edges, and so a node appears only where it
is in at least one edge.

### Walking it

A node is ready once it is incomplete and each of its predecessors is complete.
`take` hands out the first ready node, or `nil`; `take(n)` up to n of them, as
an array:

```ruby
while (node = dag.take)
  puts node.name
  node.complete!
end
dag.complete?  # => true
```

`take` does not record that a node has been handed out, so a node taken and not
yet completed is handed out again. A batch from `take(n)` is therefore to be
completed before the next is taken.

### Cycles

A DAG with a cycle raises `Walkabout::CycleError` when it is built, rather than
leaving the nodes on the cycle never ready. Its `nodes` are the nodes on the
cycle, or on a path between two cycles:

```ruby
Walkabout::DAG.new([[:x, :a], [:a, :b], [:b, :a]])
# => Walkabout::CycleError: cycle among: a, b
```

### Subclassing

`Walkabout::Node` and `Walkabout::DAG` are meant to be subclassed, a node
carrying whatever the walk is to do:

```ruby
class Step < Walkabout::Node
  def run
    puts "running #{name}"
    complete!
  end
end
```

## Contributing

1. Fork it [https://github.com/thoran/walkabout/fork](https://github.com/thoran/walkabout/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request

## License

MIT
