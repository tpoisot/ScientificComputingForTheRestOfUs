---
title: Genetic algorithm
weight: 1
status: construction
packages:
  - Plots
  - StatsBase
  - Statistics
concepts:
  - arrays
  - control flow
---

Intro to GA

Definition of the problem: MacBeth line

````julia
problem = lowercase("What, you egg?")
````





Initial solution

````julia
using StatsBase
search_space = split("abcdefghijklmnopqrstuvwxyz !?,.-", "")
initial_guess = reduce(*, sample(search_space, length(problem), replace=true))
````





fitness function

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





Generating a lot of initial guesses

````julia
initial_guesses = [reduce(*, sample(search_space, length(problem), replace=true)) for i in 1:500];
````





We can view the fitness distribution:

````julia
using Plots
scatter(sort(ω.(initial_guesses, problem)), leg=false, c=:grey, msw=0.0)
````


{{< figure src="../figures/genetic_algorithm_5_1.svg" title="TODO"  >}}


Picking the next generation -- pair of parents, recombination at random point,
then mutation:

````julia
Ω = ω.(initial_guesses, problem)
parents = sample(initial_guesses, StatsBase.weights(Ω), 2; replace=false)
cutoff = rand(1:length(problem))
offspring = first(parents)[1:cutoff] * last(parents)[cutoff+1:end]
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
 "doudj?yrkyb ,x"
 "u? tf-,he-?rwn"
 " b!ighflhw ,?h"
 "v xcdnaeuquwps"
 "luav!eigzwedms"
 "yea?,!o-z?lqyi"
 "itgiw!r-a ddzw"
 "mwco.lo!tnitgp"
 "izx?,horzfcumk"
 "yaec,wc-ypuq?n"
 ⋮               
 "hladm, wqy!.ck"
 "wgeeywtyixnbgl"
 "wnff-d.?.,drco"
 "g-ywv a.glemj-"
 "rjwnofyqo?pw?x"
 "ej!f!m,orscv.q"
 "ykwopky?ecocir"
 "luav!eigztfgab"
 " guzxx?i! liz-"
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
control flow primer]({{> "/primers/advanced_control_flow.md" <}}). In short,
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


{{< figure src="../figures/genetic_algorithm_10_1.svg"  >}}