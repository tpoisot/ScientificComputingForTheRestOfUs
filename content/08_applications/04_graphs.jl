# ---
# title: Building our own graph library
# status: alpha
# ---

# In this module, 

# <!--more-->

# Let's define a simple parametric type for a graph:

mutable struct Graph{V, E <: Real}
    edges::Vector{Tuple{V, V}}
    weights::Vector{E}
end

# In defining a `Graph` type, we have also defined a constructor for this graph:

diamond = Graph([(:a, :b), (:a, :c), (:b, :d), (:c, :d)], [true, true, true, true])

# We may be interested in making it display a little more nicely, by overloading `show`:

function Base.show(io::IO, g::Graph)
    return print(io, "A graph with $(length(g.edges)) $(eltype(g.weights)) edges")
end

# The `show` method is what is called when we type in the name of a variable, and we can
# decide what to print as a return:

diamond

# We can now define a graph generator based on the Erdős–Rényi model -- the
# function to do so is a good encapsulation of concepts from the previous
# modules, notably conditionals, the creation of `struct`, and list
# comprehensions. We will use the {{Combinatorics}} package to iterate over
# nodes combinations.

using Combinatorics

# !!!DOMAIN The Erdős–Rényi model assumes that all edges have the same
# probability of being connected, and has an interesting critical transition at
# $p = 1/(n-1)$ where $n$ is the number of nodes. Go read some graph theory if
# you feel like it, it's really cool.

# But generating a random graph is, in a sense, using the generator to do what we want. And
# so we will get a little crafty here, and define a type that represents an *algorithm*:

abstract type AbstractGraphGenerator end

struct ErdosRenyi <: AbstractGraphGenerator
    n::Integer
    p::AbstractFloat
end

# We can now create an ER generator by giving  it `n` (the number of nodes) and `p`, the
# probability of a connection between two nodes.

# Are we closer to solving our problem? Yes! We can overload the generator for `Graph` in
# a new way, that accepts a single argument: an instance of `ErdosRenyi`.

function Graph(er::ErdosRenyi)
    vertices = collect(1:(er.n))
    @assert zero(er.p) <= er.p <= one(er.p)
    edges = [tuple(pair...) for pair in combinations(vertices, 2) if rand() <= er.p]
    return Graph(edges, fill(true, length(edges)))
end

# We can now create a graph, and check its type:

G = Graph(ErdosRenyi(10, 0.2))

#-

typeof(G)
