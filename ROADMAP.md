# walkabout/ROADMAP.md

The discrete jobs are in TODO. What is here is the direction: themes larger than any
one change, each with whatever about it is still undecided.

## A scheduler, not a graph

Walkabout schedules the nodes of a directed acyclic graph in dependency order: take
hands out nodes which are incomplete and whose predecessors are all complete, and each
is marked done with Node#complete!. It is not a store of graphs. There is no reader for
a DAG's nodes or edges, so it can be read back only by walking it to completion; an
edge is no more than an entry in a node's predecessors; a base Node holds no data
beyond its name; and nothing is asked of the graph as a whole but whether it is
complete and whether it has a cycle, with no degree, subgraphs or connected
components. What TODO holds, the readers, add_node and add_edge, successors, are what
a scheduler itself wants, and stop short of that.

## A graph which may have cycles, and grows as it is walked

Whether Walkabout should also walk a directed graph which may have cycles and is
extended as it is walked: nodes and edges added mid-walk, a walk from a start node,
breadth-first or depth-first, visiting each node once, and edges carrying a kind.
Dependency order means nothing where there are cycles, so this is a different walk over
a different graph, and whether it belongs in Walkabout or beside it is open. Either way
it wants add_node and add_edge, the readers and successors first. Attributes on nodes
and edges, and the queries over the whole graph, would be reconsidered with it.
