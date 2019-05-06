---
title: Genetic algorithm
weight: 1
status: construction
packages:
  - StatsPlots
  - StatsBase
  - Statistics
concepts:
  - arrays
  - control flow
---

Genetic algorithm is a heuristic that takes heavy inspiration from evolutionary
biology, to explore a space of parameters rapidly and converge to an optimum.
Every solution is a "genome", and the combinations can undergo mutation and
recombination. By simulating a process of reproduction, over sufficiently many
generation, this heuristic usually gives very good results. It is also simple to
implement, and this is what we will do!

A genetic algorithm works by measuring the fitness of a solution (*i.e.* its fit
to a problem we have defined). We can then pick solution for "reproduction",
which involves recombination at various points in the "genome", and finally a
step for the mutation of offspring. There are an almost infinite number of
variations at each of these steps, but we will limit ourselves to a simple case
here.

To illustrate how genetic algorithms work, we will attempt to reproduce
this wonderful line from Shakespeare's Macbeth: *What, you egg?*.

````julia
const problem = lowercase("What, you egg?")
````


````
"what, you egg?"
````





The first thing we need to decide is the initial state of our population; in
this case, we will draw a random string of characters. To simplify our task, we
will use a reduced subset of all possible characters). We could make our

````julia
using StatsBase
search_space = split("abcdefghijklmnopqrstuvwxyz !?,.-", "")
initial_guess = reduce(*, sample(search_space, length(problem), replace=true))
println(initial_guess)
````


````
mxgel!eoseaskd
````





This first solution is one *genome*, and every position on the string is a
*gene*. This is, quite obviously, a bit far from the string we want to
reproduce. How far? We can calculate a *fitness* for this genome, which in this
situation is the average number of correct letters.

````julia
using Statistics

function ω(guess, solution)
  return mean(split(guess, "") .== split(solution, ""))
end

ω(initial_guess, problem)
````


````
0.07142857142857142
````





The fitness of this genome is 0.07142857142857142. We can increase the
number of individuals in our population, by generating a *lot* of initial
guesses:

````julia
initial_guesses = [reduce(*, sample(search_space, length(problem), replace=true)) for i in 1:500];
````





Once this is done, we can view their fitness distribution:

````julia
using StatsPlots
scatter(sort(ω.(initial_guesses, problem)), leg=false, c=:grey, msw=0.0)
````


{{< figure src="../figures/genetic_algorithm_5_1.png" title="Fitness of the initial solutions. Although quite a lot of the genomes have a very low fitness, recombination and mutation will improve this over time."  >}}


Picking the next generation -- pair of parents, recombination at random point,
then mutation:

````julia
Ω = ω.(initial_guesses, problem)
parents = sample(initial_guesses, StatsBase.weights(Ω), 2; replace=false)
cutoff = rand(1:length(problem))
offspring = first(parents)[1:cutoff] * last(parents)[cutoff+1:end]
````


````
"kxnl,gbb!uc-mp"
````





Now, we want to automate the process a bit, so function

````julia
function reproduction(pool, Ω)
  offspring = copy(pool)
  for i in eachindex(offspring)
    parents = sample(pool, weights(Ω), 2; replace=false)
    cutoff = rand(1:length(first(parents)))
    offspring[i] = first(parents)[1:cutoff] * last(parents)[cutoff+1:end]
  end
  return offspring
end

reproduction(initial_guesses, ω.(initial_guesses, problem))
````


````
500-element Array{String,1}:
 "omaf,jkxmgvxj!"
 "ngdluvr.mex,gk"
 "don,qj?quu, va"
 "yjowmpolu-ggd."
 "ngdluvr.mex.fc"
 "era!t-yqipiqu."
 "donwmpolu-iqus"
 "dszoimyg f.q-o"
 "w,tdd.?qpyyrsm"
 " !qd uuonhbisi"
 ⋮               
 "mildbysishhvnt"
 "riacpuyawy.u,c"
 "szek trm.dagja"
 "ipapsi ubxgghn"
 "y!jnhi ubxgghn"
 "a?hscetgauekgr"
 "eocm,h?owvqlmz"
 "lwc !trm. xzvn"
 "whx!mbc.i sxr?"
````





Next step is to have mutations

````julia
function mutation(genome, μ, search_space)
  splitted = split(genome, "")
  for i in 1:length(splitted)
    if rand() ≤ μ
      splitted[i] = rand(search_space)
    end
  end
  return reduce(*, splitted)
end
````


````
mutation (generic function with 1 method)
````





We can start wrapping it up:

````julia
problem = lowercase("What, you egg?")
search_space = split("abcdefghijklmnopqrstuvwxyz ?,!", "")
population = [reduce(*, sample(search_space, length(problem), replace=true)) for i in 1:300]

fit = []

for generation in 1:500
  global population
  population = reproduction(population, ω.(population, problem))
  for i in eachindex(population)
    population[i] = mutation(population[i], 0.01, search_space)
  end
  maxfit = findmax(ω.(population, problem))
  push!(fit, maxfit[1])
  maxfit[1] == 1.0 && break
end
````





The `break` syntax (and short-circuit operators) is covered in the [Advanced
control flow primer]({{> ref "/primers/advanced_control_flow.md" <}}). In short,
whenever the population has a mutant whose fitness is 1, we don't need to keep
running, and so the code will stop.

````julia
final_fit = ω.(population, problem)
println(population[last(findmax(final_fit))])
````


````
what, you egg?
````



````julia

plot(fit,
  leg=false, xlab="Step", ylab="Maximal fitness",
  frame=:origin, c=:purple, lw=2
  )
yaxis!((0,1))
````


{{< figure src="../figures/genetic_algorithm_10_1.png"  >}}