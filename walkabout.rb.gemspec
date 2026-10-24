require_relative './lib/Walkabout/VERSION'

class Gem::Specification
  def development_dependencies=(gems)
    gems.each{|gem| add_development_dependency(*gem)}
  end
end

Gem::Specification.new do |spec|
  spec.name = 'walkabout.rb'
  spec.version = Walkabout::VERSION

  spec.summary = "Walk a directed acyclic graph in dependency order."
  spec.description = "Walk a directed acyclic graph in dependency order. A DAG built from edges, or from sequences, hands out the nodes whose predecessors are complete, singly or in batches, and refuses a graph with a cycle."

  spec.author = 'thoran'
  spec.email = 'code@thoran.com'
  spec.homepage = 'https://github.com/thoran/walkabout'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 3'
  spec.require_paths = ['lib']

  spec.files = [
    'walkabout.rb.gemspec',
    Dir['lib/**/*.rb'],
    Dir['test/**/*.rb'],
    'CHANGELOG',
    'LICENSE',
    'Rakefile',
    'README.md',
  ].flatten

  spec.development_dependencies = %w{
    rake
    minitest
  }
end
