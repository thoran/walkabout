# walkabout/ROADMAP.md

The discrete jobs are in TODO. What is here is the direction: themes larger than any
one change, each with whatever about it is still undecided.

## More than a scheduler

Walkabout began as a scheduler: DAG hands out the nodes which are incomplete and whose
predecessors are all complete, and that is nearly all it does. A DAG can be read back
only by walking it to completion, since there is no reader for its nodes or edges; an
edge is no more than an entry in a node's predecessors; a node holds nothing but its
name, and exists only if it is in an edge; the whole graph must be given at once; and
nothing is asked of it but whether it is complete and whether it has a cycle.

A graph library needs to do more, whatever the type of graph. It holds nodes and edges
which carry attributes, a node with no edges among them; it is built in stages, with
add_node and add_edge; it is read back, with nodes and edges; it goes from a node both
to its predecessors and to its successors; and it answers questions of the graph as a
whole, such as degree, subgraphs and components. Walking a graph, or scheduling it as
DAG does, is one use of all that, built on top of it rather than in place of it.

Each new type is written that way. DAG is left as it is for now, its fixes aside, and
may later be rebuilt on what the others share.

## Digraph

The first type written that way: a directed graph in which cycles are allowed, written
from scratch beside DAG rather than taken from it. Nodes and edges are objects carrying attributes as plain hashes,
an edge's kind being one of them, and more than one edge may join the same pair. It is
built with add_node and add_edge, so a node with no edges exists and a graph can grow
in stages; it is read back with nodes, edges, each_node and each_edge; and it gives
each node's predecessors and successors, and its in- and out-degree, and a subgraph
filtered from it. Adjacency is held by the graph rather than by the nodes, so that one
node may be in more than one graph.

It is tried on a real graph before it is published.

Undecided: whether its nodes and edges are Digraph::Node and Digraph::Edge, to be moved
up once there is a Graph, or Walkabout::Node is made a base carrying attributes, with
DAG's node a subclass of it, which touches DAG.

## Walks and components

After that, walks from a start node, breadth-first and depth-first, visiting each node
once and tolerating nodes and edges added mid-walk, and the transitive predecessors and
successors of a node, so that a graph can be walked while it is still being found, and
a walk restricted to the nodes which a change to one affects. Undecided: whether a walk
follows an edge added from a node it has already visited.

Then strongly connected components, which find cycles without forbidding them.

## A family of graph types

Graph, Digraph, DAG, Tree and Network, made from a base Graph and property modules
mixed into it: Directed adds a source and a target to an edge; Acyclic, Rooted and
Simple are constraints; Weighted names the attribute its algorithms read. The
pre-mixed classes add nothing beyond their modules, so a class mixed by hand behaves
the same, and a consumer asks of a graph which modules it has rather than which class
it is. Algorithms are written against a few methods, such as each_node and
each_successor, so that they run on anything which provides them.

That is where the types are headed, not where they start. Each is written on its own
first, whole features coming later, and what they have in common is drawn out once it
shows, rather than designed up front. What is fixed from the start is what would be
costly to change: nodes known by name, adjacency held by the graph, attributes as plain
hashes, and the generic names, nodes, edges, each_node and successors, so that a
common part can be drawn out without renaming.

Undecided: when Graph is drawn out of Digraph and Network; whether DAG comes to be
built on Digraph, its cycle check and Digraph's strongly connected components likely
being the first thing shared; and Tree, which may later be a DAG.
