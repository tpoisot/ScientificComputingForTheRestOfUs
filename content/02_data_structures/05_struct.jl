# ---
# title: Building your own types
# status: alpha
# ---

# intro

# <!--more-->

struct Graph{N,E}
    edges::Vector{Tuple{N,N}}
    weights::Vector{E}
end

# Let's make a simple graph

edges = [(:a, :b), (:a, :d)]
weights = [1, 2]
𝒢 = Graph(edges, weights)

#-

typeof(𝒢s)