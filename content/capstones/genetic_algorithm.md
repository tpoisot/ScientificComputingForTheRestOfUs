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
````


<pre class="julia-error">
ERROR: On worker 2:
ArgumentError: Package StatsBase &#91;2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91&#93; is required but does not seem to be installed:
 - Run &#96;Pkg.instantiate&#40;&#41;&#96; to install all recorded dependencies.

_require at ./loading.jl:929
require at ./loading.jl:858
#2 at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.1/Distributed/src/Distributed.jl:77
#116 at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.1/Distributed/src/process_messages.jl:276
run_work_thunk at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.1/Distributed/src/process_messages.jl:56
run_work_thunk at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.1/Distributed/src/process_messages.jl:65
#102 at ./task.jl:259
#remotecall_wait#154&#40;::Base.Iterators.Pairs&#123;Union&#123;&#125;,Union&#123;&#125;,Tuple&#123;&#125;,NamedTuple&#123;&#40;&#41;,Tuple&#123;&#125;&#125;&#125;, ::Function, ::Function, ::Distributed.Worker&#41; at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.1/Distributed/src/remotecall.jl:421
remotecall_wait&#40;::Function, ::Distributed.Worker&#41; at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.1/Distributed/src/remotecall.jl:412
#remotecall_wait#157&#40;::Base.Iterators.Pairs&#123;Union&#123;&#125;,Union&#123;&#125;,Tuple&#123;&#125;,NamedTuple&#123;&#40;&#41;,Tuple&#123;&#125;&#125;&#125;, ::Function, ::Function, ::Int64&#41; at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.1/Distributed/src/remotecall.jl:433
remotecall_wait&#40;::Function, ::Int64&#41; at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.1/Distributed/src/remotecall.jl:433
&#40;::getfield&#40;Distributed, Symbol&#40;&quot;##1#3&quot;&#41;&#41;&#123;Base.PkgId&#125;&#41;&#40;&#41; at ./task.jl:259

...and 1 more exception&#40;s&#41;.

</pre>


````julia
search_space = split("abcdefghijklmnopqrstuvwxyz !?,.-", "")
initial_guess = reduce(*, sample(search_space, length(problem), replace=true))
````


<pre class="julia-error">
ERROR: UndefVarError: sample not defined
</pre>


````julia
println(initial_guess)
````


<pre class="julia-error">
ERROR: UndefVarError: initial_guess not defined
</pre>




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


<pre class="julia-error">
ERROR: UndefVarError: initial_guess not defined
</pre>




The fitness of this genome is <pre class="julia-error">
ERROR: UndefVarError: initial_guess not defined
</pre>
. We can increase the
number of individuals in our population, by generating a *lot* of initial
guesses:

````julia
initial_guesses = [reduce(*, sample(search_space, length(problem), replace=true)) for i in 1:500];
````


<pre class="julia-error">
ERROR: UndefVarError: sample not defined
</pre>




Once this is done, we can view their fitness distribution:

````julia
using StatsPlots
````


<pre class="julia-error">
ERROR: On worker 2:
ArgumentError: Package StatsPlots &#91;f3b207a7-027a-5e70-b257-86293d7955fd&#93; is required but does not seem to be installed:
 - Run &#96;Pkg.instantiate&#40;&#41;&#96; to install all recorded dependencies.

_require at ./loading.jl:929
require at ./loading.jl:858
#2 at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.1/Distributed/src/Distributed.jl:77
#116 at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.1/Distributed/src/process_messages.jl:276
run_work_thunk at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.1/Distributed/src/process_messages.jl:56
run_work_thunk at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.1/Distributed/src/process_messages.jl:65
#102 at ./task.jl:259
#remotecall_wait#154&#40;::Base.Iterators.Pairs&#123;Union&#123;&#125;,Union&#123;&#125;,Tuple&#123;&#125;,NamedTuple&#123;&#40;&#41;,Tuple&#123;&#125;&#125;&#125;, ::Function, ::Function, ::Distributed.Worker&#41; at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.1/Distributed/src/remotecall.jl:421
remotecall_wait&#40;::Function, ::Distributed.Worker&#41; at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.1/Distributed/src/remotecall.jl:412
#remotecall_wait#157&#40;::Base.Iterators.Pairs&#123;Union&#123;&#125;,Union&#123;&#125;,Tuple&#123;&#125;,NamedTuple&#123;&#40;&#41;,Tuple&#123;&#125;&#125;&#125;, ::Function, ::Function, ::Int64&#41; at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.1/Distributed/src/remotecall.jl:433
remotecall_wait&#40;::Function, ::Int64&#41; at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.1/Distributed/src/remotecall.jl:433
&#40;::getfield&#40;Distributed, Symbol&#40;&quot;##1#3&quot;&#41;&#41;&#123;Base.PkgId&#125;&#41;&#40;&#41; at ./task.jl:259

...and 1 more exception&#40;s&#41;.

</pre>


````julia
scatter(sort(ω.(initial_guesses, problem)), leg=false, c=:grey, msw=0.0)
````


<pre class="julia-error">
ERROR: UndefVarError: initial_guesses not defined
</pre>




Picking the next generation -- pair of parents, recombination at random point,
then mutation:

````julia
Ω = ω.(initial_guesses, problem)
````


<pre class="julia-error">
ERROR: UndefVarError: initial_guesses not defined
</pre>


````julia
parents = sample(initial_guesses, StatsBase.weights(Ω), 2; replace=false)
````


<pre class="julia-error">
ERROR: UndefVarError: StatsBase not defined
</pre>


````julia
cutoff = rand(1:length(problem))
offspring = first(parents)[1:cutoff] * last(parents)[cutoff+1:end]
````


<pre class="julia-error">
ERROR: UndefVarError: parents not defined
</pre>




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


<pre class="julia-error">
ERROR: UndefVarError: initial_guesses not defined
</pre>




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
````


<pre class="julia-error">
ERROR: UndefVarError: sample not defined
</pre>


````julia

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


<pre class="julia-error">
ERROR: UndefVarError: population not defined
</pre>




The `break` syntax (and short-circuit operators) is covered in the [Advanced
control flow primer]({{> ref "/primers/advanced_control_flow.md" <}}). In short,
whenever the population has a mutant whose fitness is 1, we don't need to keep
running, and so the code will stop.

````julia
final_fit = ω.(population, problem)
````


<pre class="julia-error">
ERROR: UndefVarError: population not defined
</pre>


````julia
println(population[last(findmax(final_fit))])
````


<pre class="julia-error">
ERROR: UndefVarError: final_fit not defined
</pre>


````julia

plot(fit,
  leg=false, xlab="Step", ylab="Maximal fitness",
  frame=:origin, c=:purple, lw=2
  )
````


<pre class="julia-error">
ERROR: UndefVarError: plot not defined
</pre>


````julia
yaxis!((0,1))
````


<pre class="julia-error">
ERROR: UndefVarError: yaxis&#33; not defined
</pre>

