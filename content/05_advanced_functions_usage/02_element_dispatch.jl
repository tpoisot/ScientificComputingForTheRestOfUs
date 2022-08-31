# ---
# title: Dispatch on element types
# status: alpha
# ---

# In this lesson, we will see how we can dispatch on parametric types, in order
# to have a fine-grained control on what method is deployed against different
# types of data.

# <!--more-->

# A common task in community ecology is to measure the β-diversity of two
# samples, *i.e.* the amount to which they resemble one another. We can do this
# based on an almost infinite type of data, but for now let us assume that we
# have measurements of species abundances at different locations.

# !!!DOMAIN We will assume that species abundances follow a log-Normal
# distribution, which is going to make some community ecologists deeply unhappy;
# there is no assumption that makes all ecologist happy.

using Distributions
number_of_sites = 120
species_richness = 41
abundance_distribution = Truncated(LogNormal(0.2, 3.0), 0.0, 100.0)
Y = round.(Int64, rand(abundance_distribution, number_of_sites, species_richness))
S = convert(Matrix{Bool}, (!iszero).(Y));

# !!!INFO We are forcing `S` to be a `Matrix{Bool}` using `convert` *only* for
# the purpose of this example. Without the conversion, the type of `S` would be
# `BitMatrix`, which is a slightly different object. In real-life applications,
# this conversion is entirely superfluous.

# We have two matrices: $\mathbf{Y}$ is a matrix with continuous values (*e.g.*
# biomass), whereas $\mathbf{S}$ has Boolean values (*e.g.* the species is
# present or absent).

# These two data require different approaches to measure their β-diversity. In
# the case of boolean data, we can apply *e.g.* Whittaker's β-diversity measure,
# which is 

# $$\beta = 2\frac{|S_1 \cup S_2|}{|S_1|+|S_2|}$$

# or in other words, the total number of species divided by the average number
# of species, where $S_i$ is the set of species at location $i$.

# What will a function to generate the pairwise β-diversity of our sites
# dispatch on? A first idea could be `Y::Matrix{Bool}`, which works. But we can
# do something a little trickier. We don't really care that `Y` is a matrix. We
# care that it stores `Bool`-like values.

# We can decompose this problem further -- we care about pairwise comparison, so
# we want to work on vectors. So what we will do is write a dispatch that
# reflects this:

function β(S1::Vector{T}, S2::Vector{T}) where {T <: Bool}
    γ = sum(S1 .| S2)
    α = (1 / 2) * (sum(S1) + sum(S2))
    return γ / α
end

# !!!INFO We do not really use the `∪` instruction for sets here, even though we
# could -- it's simply that using Boolean operators achieves the same result,
# and is likely much faster.

# In the case of quantitative values, rather than using the Whittaker formula as
# above, we can measure one minus the Tanimoto distance:

function β(S1::Vector{T}, S2::Vector{T}) where {T <: Real}
    num = abs.(S1 .- S2)
    den = [max(S1[i], S2[i]) for i in eachindex(S1)]
    return 1-num/den
end

# !!!DOMAIN This is actually more likely to make community ecologists angry,
# because this looks suspiciously like Jaccard's similarity. It's true.

#-

function β(Y::Matrix{T}) where {T <: Bool}
end

#-