---
title: Approximate Bayesian Computation
weight: 1
status: draft
packages:
  - StatsPlots
  - StatsBase
  - Statistics
  - Distributions
concepts:
  - arrays
  - control flow
---


[Approximate Bayesian
computation](https://en.wikipedia.org/wiki/Approximate_Bayesian_computation), or
ABC for short, is a very useful heuristic to estimate the posterior distribution
of model parameters, specifically when the analytical expression of the
likelihood function is unavailable (or when we can't be bothered to figure it
out). We will rely on a few packages for this example:

````julia
using StatsPlots
using Statistics
using StatsBase
using Distributions
````





Let us now imagine an island. It is a small island, no more than a few meters in
diameter, in the Florida keys. Every year, for 20 years, a few biologists comb
through the island, to figure out whether or not *Eurycotis floridana* is
present or absent. This results in a timeseries, like this:

````
Year 1	present
Year 2	present
Year 3	absent
Year 4	absent
Year 5	present
Year 6	absent
Year 7	absent
Year 8	absent
Year 9	absent
Year 10	absent
````





To begin with, let us see how we can model the presence/absence of this species.
We will make two assumptions. First, the biological process here can be
represented by modeling the probabilities of *transition*, *i.e.* the chance of
changing from one state to another. Second, there is a small chance of *error*
when measuring the state of the system. Specifically, while detecting at least
one individual means that there is no chance that the species is absent, *not*
detecting any individual can also mean that there were present in low density,
and have not been detected.

We can represent this system using the following figure:

{{< mermaid >}}
graph LR

subgraph True state
present -- e --> absent
absent -- c --> present
absent -- 1-c --> absent
present -- 1-e --> present
end

subgraph Measured state
absent --> InsectAbsent[absent]
present -- 1-m --> InsectPresent[present]
present -- m --> InsectAbsent[absent]
end
{{< /mermaid >}}

In the *true state* box, the rates represent the probabilities of state change.
The rates between *true state* and *measured state* represent the probabilities
of making the wrong measurement. We now have enough to write a simple function
to simulate this model:

````julia
function island(e::T, c::T, m::T; n=200) where {T <: AbstractFloat}
  @assert 0.0 ≤ e ≤ 1.0
  @assert 0.0 ≤ c ≤ 1.0
  @assert 0.0 ≤ m ≤ 1.0
  true_state = zeros(Bool, n)
  measured_state = zeros(Bool, n)
  measured_state[1] = true_state[1]
  for year in 2:n
    true_state[year] = true_state[year-1] ? rand() ≥ e : rand() < c
    measured_state[year] = true_state[year] ? rand() ≥ m : false
  end
  return measured_state
end
````


````
island (generic function with 1 method)
````





In ABC, one key notion is the idea of "summary statistics", *i.e.* the act of
compressing the empirical data and model output to something that can be
meaningfully compared. Here, we will work with two informations, namely the rate
of transition, and the temporal occupancy.

````julia
function summary(t::Vector{Bool})
  transitions = 0.0
  for i in 2:length(t)
    if t[i] ≠ t[i-1]
      transitions = transitions+1.0
    end
  end
  occupancy = sum(t)/length(t)
  return [occupancy, transitions/(length(t)-1)]
end
````


````
summary (generic function with 1 method)
````





We can apply this function to a simulation with parameters $(e=0.2, c=0.6,
m=0.1)$, and get the summary statistics:

````julia
summary(island(0.2, 0.6, 0.1))
````


````
2-element Array{Float64,1}:
 0.725              
 0.32663316582914576
````





At this point, we need empirical data to feed the model. Let's say that over
twenty years, the species has been observed from year 4 to 12, then 14 to 15,
and finally from year 17 to 20. We can write this as:

````julia
empirical_data = zeros(Bool, 20)
empirical_data[4:12] .= true
empirical_data[14:15] .= true
empirical_data[17:20] .= true
````





Your biologist colleague has tasked you with estimating the parameters that
govern the presence of this insect on the island. This is an easy enough task to
do with ABC.

We can measure the statistics of this timeseries:

````julia
summary(empirical_data)
````


````
2-element Array{Float64,1}:
 0.75              
 0.2631578947368421
````





And just like this, we are ready to start the ABC process. We will start by
deciding on priors for all three parameters. We could model them in a variety of
ways, including β laws, and truncated distributions. Let's go with the later, as
it is a neat illustration of the `Distributions` package.

````julia
Dc = Truncated(Normal(0.6, 0.1), 0.0, 1.0)
De = Truncated(Normal(0.3, 0.1), 0.0, 1.0)
Dm = Truncated(Normal(0.1, 0.3), 0.0, 1.0)
````





We will generate 10⁶ samples using our simulation model, and get the summary
statistics for all of them:

````julia
N = 1_000_000
Sc = rand(Dc, N)
Se = rand(De, N)
Sm = rand(Dm, N)
simulated_results = summary.(map(i -> island(Se[i], Sc[i], Sm[i]), 1:N))
````





{{< callout opinion >}}ABC is an excellent exercice for parallel computing!
Because the model runs are independant, this is an "embarassingly parallel"
problem. After reading the [parallel computing](/primers/parallelcomputing/)
primer, you may want to try it out on this problem.{{< /callout >}}

We can now measure the distance between these simulated results and the
empirical results:

````julia
function euclidean_distance(x1::Vector{T}, x2::Vector{T}) where {T <: AbstractFloat}
  return sum(sqrt.((x1.-x2).^2.0))
end
distances = map(s -> euclidean_distance(s, summary(empirical_data)), simulated_results)
````



````julia
density(distances, leg=false, fill=(0, :orange, 0.4), c=:orange)
xaxis!("Distance", (0,1))
yaxis!("Density", (0, 4))
````


{{< figure src="../figures/abc_11_1.png" title="Distance between the summaries of empirical and actual data."  >}}


The actual ABC step is to *reject* some of the samples from them prior
distribution, to only select the parameters combinations that produce results
*close* to the empirical data. This is done by setting a threshold, and
distances above this threshold will be rejected.

````julia
θ = 0.02
posterior = findall(distances.<θ)
````





{{<  callout information >}}Another approach to rejection sampling would be to
keep generating samples until the sample size of the posterior has reached a
certain threshold. Both solutions are valid, but for the sake of illustration,
we went with the one that was simpler to implement.{{< /callout >}}

````julia
density(Sc, c=:teal, ls=:dash, lab="")
density!(Se, c=:purple, ls=:dash, lab="")
density!(Sm, c=:grey, ls=:dash, lab="")

density!(Sc[posterior], c=:teal, fill=(0, :teal, 0.3), lab="Colonization")
density!(Se[posterior], c=:purple, fill=(0, :purple, 0.3), lab="Extinction")
density!(Sm[posterior], c=:grey, fill=(0, :grey, 0.3), lab="Error")

xaxis!("Parameter value", (0,1))
yaxis!("Density", (0, 14))
````


{{< figure src="../figures/abc_13_1.png" title="Posterior distributions (shaded) and the corresponding priors (dashed) for the three parameters in the model."  >}}


To summarize, we can now extract the values of the different parameters:

|     | meaning                |                                     mean |                      standard deviation |
|:---:|:-----------------------|-----------------------------------------:|----------------------------------------:|
| $c$ | Colonization rate      | 0.553 | 0.066 |
| $e$ | Extinction rate        | 0.152 | 0.042 |
| $m$ | Measurement error rate | 0.054 | 0.042 |
