---
title: Dispatch on element types
---

In this module,

<!-- more -->

A good case study to look at element-wise dispatch is the measurement of
species diversity, a task of which ecologists are very fond. In a lot of
cases, information about species richness is presented in a "community data
matrix", which has species as rows and locations as columns (or the other way
around, it doesn't matter). These data are very easy to simulate, if we are
willing to assume that (i) species abundances are log-normally distributed,
and (ii) a species cannot have a negative abundance at one site. The
*Distributions* package does this task really well:

````julia
using Distributions
𝒟 = LogNormal(0.2, 3.0)
n_species, n_sites = 12, 17
𝐘 = round.(Int64, rand(𝒟, n_species, n_sites))
````

````
12×17 Matrix{Int64}:
   0   0   19  82   1    0    4    0   827  573   8   3    1  851  21    0  1003
   0   4    8   8   4    0   16    4     3    0   0   3    6  490  86    1    21
   0   2    0   0  21   60    0  122     0    7   0   0    2   39   2    1     0
   1   3    0   0  30   46    1  888     0    0   2  64   18    0  15    1    31
   2   0    3   1   0    0    0    0    21   44  16   0    0    3  37    2     3
  17   1    7   1  36    1    0   68    72    0   8   0    0    2   5    4     0
   0   2    0  45   0  136  110    6     2    0   0   5    1    0  44    0     4
  12   0    1   8   0    0    2    0    10    0   1  12    0    0   0    0     0
 279   0    0   0  21   14    7    2  1528    2   4  11    0    0   0    0     3
  44  84    2   7   0  594    3    0     2    0   0   0  821    1   1    2    11
   8   5  117   0  20   10    2    0     7  683   0   1   21    5   1    1     1
   7   5  583   1   0    0  144    0     4    2   0   0  183    2   1  232     0
````

{{< callout information >}}
We use the `𝒟` and `𝐘` symbols because they look really nice, but
`D` and `Y` are equally valid choices. In order to produce the math notation,
you can use the LaTeX syntax: `\scrD` and `\bfY` and press tab.
{{< /callout >}}

Measuring species diversity is a task that can be accomplished in many ways,
but generally depends on the type of data available. In this example, we have
*abundance* data, *i.e.* we know how many individuals (for example) have been
sighted at each location.

To work on such a matrix, it is tempting to write a function that would check
for an argument of the type `Matrix{Int64}` (for example).

{{< callout opinion >}}
Both `Matrix{Int64}` and `Vector{Int64}` are actually aliases for
`Array{2, Int64}` and `Array{2, Int64}`. We prefer the more compact notation,
that is also explicit about what type of mathematical object we will be
handling, but in some situations, expressing the number of dimensions
explicitely is helpful.
{{< /callout >}}

But let's try for a more general approach. Specifically, when looking at
abundance data, we will often want to express diversity as the eveness, which
for a vector of $S$ species with relative abundances $\mathbf{p}$ is

$$
J'(\mathbf{p}) = \frac{1}{\text{ln} S}\times\left(-\sum_{i=1}^Sp_i\text{ln} p_i\right)
$$

This is a function we can easily write:

````julia
function J(p::Vector{T}) where {T <: Number}
    S = length(p)
    p ./= sum(p)
    H = -sum(p .* log.(p))
    return H / log(S)
end
````

````
J (generic function with 1 method)
````

Note the way we dispatch -- rather than saying "`T` is a vector of number", we
say "this is a vector containing `T`s". This is a very interesting approach
when we know what the type of the elements must be.

