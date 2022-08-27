# ---
# title: Dispatch on element types
# ---

# In this module, 

# <!-- more -->

# A good case study to look at element-wise dispatch is the measurement of
# species diversity, a task of which ecologists are very fond. In a lot of
# cases, information about species richness is presented in a "community data
# matrix", which has species as rows and locations as columns (or the other way
# around, it doesn't matter). These data are very easy to simulate, if we are
# willing to assume that (i) species abundances are log-normally distributed,
# and (ii) a species cannot have a negative abundance at one site. The
# *Distributions* package does this task really well:

using Distributions
𝒟 = LogNormal(0.2, 3.0)
n_species, n_sites = 12, 17
𝐘 = round.(Int64, rand(𝒟, n_species, n_sites))

# !!! INFO We use the `𝒟` and `𝐘` symbols because they look really nice, but
# `D` and `Y` are equally valid choices. In order to produce the math notation,
# you can use the LaTeX syntax: `\scrD` and `\bfY` and press tab.

# Measuring species diversity is a task that can be accomplished in many ways,
# but generally depends on the type of data available. In this example, we have
# *abundance* data, *i.e.* we know how many individuals (for example) have been
# sighted at each location.

# To work on such a matrix, it is tempting to write a function that would check
# for an argument of the type `Matrix{Int64}` (for example).

# !!! OPINION Both `Matrix{Int64}` and `Vector{Int64}` are actually aliases for
# `Array{2, Int64}` and `Array{2, Int64}`. We prefer the more compact notation,
# that is also explicit about what type of mathematical object we will be
# handling, but in some situations, expressing the number of dimensions
# explicitely is helpful.

# But let's try for a more general approach. Specifically, when looking at
# abundance data, we will often want to express diversity as the eveness, which
# for a vector of $S$ species with relative abundances $\mathbf{p}$ is

# $$
# J'(\mathbf{p}) = \frac{1}{\text{ln} S}\times\left(-\sum_{i=1}^Sp_i\text{ln} p_i\right)
# $$

# This is a function we can easily write:

function J(p::Vector{T}) where {T <: Number}
    S = length(p)
    p ./= sum(p)
    H = -sum(p .* log.(p))
    return H / log(S)
end

# Note the way we dispatch -- rather than saying "`T` is a vector of number", we
# say "this is a vector containing `T`s". This is a very interesting approach
# when we know what the type of the elements must be.