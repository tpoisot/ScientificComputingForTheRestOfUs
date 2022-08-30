# ---
# title: Dispatch on element types
# status: alpha
# ---

# In this module, 

# <!--more-->

# Let's define a simple parametric type for a graph:

mutable struct Graph{V, E <: Real}
    edges::Vector{Tuple{V, V}}
    weights::Vector{E}
end

# We can now define a graph generator based on the Erdős–Rényi model -- the
# function to do so is a good encapsulation of concepts from the previous
# modules, notably conditionals, the creation of `struct`, and list
# comprehensions:

using Combinatorics
function ER(vertices; p::T = 0.2) where {T <: AbstractFloat}
    @assert zero(p) <= p <= one(p)
    edges = [tuple(pair...) for pair in combinations(vertices, 2) if rand() <= p]
    return Graph(edges, fill(true, length(edges)))
end

# !!!DOMAIN The Erdős–Rényi model assumes that all edges have the same
# probability of being connected, and has an interesting critical transition at
# $p = 1/(n-1)$ where $n$ is the number of nodes. Go read some graph theory if
# you feel like it, it's really cool.

# We can now create a graph, and check its type:

G = ER(1:100; p = 0.2)

typeof(G)
