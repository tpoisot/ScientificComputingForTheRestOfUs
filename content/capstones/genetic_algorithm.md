---
title: Genetic algorithm
weight: 1
status: draft
packages:
  - StatsPlots
  - StatsKit
  - Statistics
concepts:
  - data frames
  - generic code
  - type system
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

Specifically, we will use the `DataFrames` and `CSV` package (installed in
`StatsKit`) to read a table containing metabolic rates of species, and then use
genetic algorithm to try and find out the scaling exponent linking mass to the
field metabolic rate. The data come from a meta-analysis by [Lawrence N. Hudson
and colleagues](hudson), and can be downloaded as follows:

[hudson]: https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/1365-2656.12086

````julia
using StatsKit
using StatsPlots
url = "http://sciencecomputing.io/data/metabolicrates.csv"
tmp = download(url)
rates = CSV.read(tmp)
rates[1:5,:]
````



<table class="data-frame"><thead><tr><th></th><th>Class</th><th>Order</th><th>Family</th><th>Genus</th><th>Species</th><th>Study</th><th>M (kg)</th><th>FMR (kJ / day)</th></tr><tr><th></th><th>String</th><th>String</th><th>String</th><th>String</th><th>String</th><th>String</th><th>Float64</th><th>Float64</th></tr></thead><tbody><p>5 rows × 8 columns</p><tr><th>1</th><td>Mammalia</td><td>Carnivora</td><td>Odobenidae</td><td>Odobenus</td><td>rosmarus</td><td>Acquarone et al 2006</td><td>1370.0</td><td>345000.0</td></tr><tr><th>2</th><td>Mammalia</td><td>Carnivora</td><td>Odobenidae</td><td>Odobenus</td><td>rosmarus</td><td>Acquarone et al 2006</td><td>1250.0</td><td>417400.0</td></tr><tr><th>3</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>7.4</td><td>3100.0</td></tr><tr><th>4</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>6.95</td><td>2898.0</td></tr><tr><th>5</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>8.9</td><td>3528.0</td></tr></tbody></table>



Let's have a look at the names of the columns:

````julia
names(rates)
````


````
8-element Array{Symbol,1}:
 :Class                  
 :Order                  
 :Family                 
 :Genus                  
 :Species                
 :Study                  
 Symbol("M (kg)")        
 Symbol("FMR (kJ / day)")
````





We will replace the last two names, as they are not easy to work with:

````julia
rename!(rates, names(rates)[end-1] => :mass)
````


<pre class="julia-error">
ERROR: UndefVarError: rename&#33; not defined
</pre>


````julia
rename!(rates, names(rates)[end] => :fmr)
````


<pre class="julia-error">
ERROR: UndefVarError: rename&#33; not defined
</pre>


````julia
rates = rates[rates[:mass].<1e3,:]
````


<pre class="julia-error">
ERROR: ArgumentError: column name :mass not found in the data frame; existing most similar names are: :Class
</pre>


````julia
rates[1:5,:]
````



<table class="data-frame"><thead><tr><th></th><th>Class</th><th>Order</th><th>Family</th><th>Genus</th><th>Species</th><th>Study</th><th>M (kg)</th><th>FMR (kJ / day)</th></tr><tr><th></th><th>String</th><th>String</th><th>String</th><th>String</th><th>String</th><th>String</th><th>Float64</th><th>Float64</th></tr></thead><tbody><p>5 rows × 8 columns</p><tr><th>1</th><td>Mammalia</td><td>Carnivora</td><td>Odobenidae</td><td>Odobenus</td><td>rosmarus</td><td>Acquarone et al 2006</td><td>1370.0</td><td>345000.0</td></tr><tr><th>2</th><td>Mammalia</td><td>Carnivora</td><td>Odobenidae</td><td>Odobenus</td><td>rosmarus</td><td>Acquarone et al 2006</td><td>1250.0</td><td>417400.0</td></tr><tr><th>3</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>7.4</td><td>3100.0</td></tr><tr><th>4</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>6.95</td><td>2898.0</td></tr><tr><th>5</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>8.9</td><td>3528.0</td></tr></tbody></table>



Much better! Now let's try to figure out the relationship between the last two
variables:

````julia
scatter(rates[:mass], rates[:fmr], c=:teal, leg=false, msc=:transparent)
````


<pre class="julia-error">
ERROR: ArgumentError: column name :mass not found in the data frame; existing most similar names are: :Class
</pre>


````julia
xaxis!(:log10, "Mass (kg)")
yaxis!(:log10, "Field Metabolic Rate (kj per day)")
````


<pre class="julia-error">
ERROR: ArgumentError: At least one finite value must be provided to formatter.
</pre>




Neat! This is a log-log relationship, so we can represent this problem as:

$$\text{log}{10}(\text{FMR}) \propto m\times\text{log}_{10}(\text{M})+b$$

To simplify the problem a little bit, we will average the values within species;
because the relation is log-log, we will average the log of the value (as
opposed to taking the log of the averages).

````julia
rates = by(
  rates,
  [:Genus, :Species],
  [:mass, :fmr] =>
    x -> (
    mass=mean(log10.(x.mass)),
    fmr=mean(log10.(x.fmr))
    )
  )
````


<pre class="julia-error">
ERROR: ArgumentError: column name :mass not found in the data frame; existing most similar names are: :Class
</pre>


````julia
rates[1:5,:]
````



<table class="data-frame"><thead><tr><th></th><th>Class</th><th>Order</th><th>Family</th><th>Genus</th><th>Species</th><th>Study</th><th>M (kg)</th><th>FMR (kJ / day)</th></tr><tr><th></th><th>String</th><th>String</th><th>String</th><th>String</th><th>String</th><th>String</th><th>Float64</th><th>Float64</th></tr></thead><tbody><p>5 rows × 8 columns</p><tr><th>1</th><td>Mammalia</td><td>Carnivora</td><td>Odobenidae</td><td>Odobenus</td><td>rosmarus</td><td>Acquarone et al 2006</td><td>1370.0</td><td>345000.0</td></tr><tr><th>2</th><td>Mammalia</td><td>Carnivora</td><td>Odobenidae</td><td>Odobenus</td><td>rosmarus</td><td>Acquarone et al 2006</td><td>1250.0</td><td>417400.0</td></tr><tr><th>3</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>7.4</td><td>3100.0</td></tr><tr><th>4</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>6.95</td><td>2898.0</td></tr><tr><th>5</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>8.9</td><td>3528.0</td></tr></tbody></table>



We can look at the simplified data:

````julia
scatter(10.0.^rates[:mass], 10.0.^rates[:fmr], c=:teal, leg=false, msc=:transparent)
````


<pre class="julia-error">
ERROR: ArgumentError: column name :mass not found in the data frame; existing most similar names are: :Class
</pre>


````julia
xaxis!(:log10, "Mass (kg)")
yaxis!(:log10, "Field Metabolic Rate (kj per day)")
````


<pre class="julia-error">
ERROR: ArgumentError: At least one finite value must be provided to formatter.
</pre>




{{< callout information >}}
In this capstone, we will try to write a very general code for genetic
algorithms. It is possible to come up with a more specific code, but spending
time to think about making code general is almost always wise, since it means we
can seamlessly re-use already written code.
{{< /callout >}}

Genetic algorithms represent the state of the problem as "genomes", which here
will be composed of two genes: $m$ and $b$. There are a few decisions we need to
take already: how large is our initial population, and how much standing
variation do we have?

Just to be a little fancier than usual, we will define a *type* for our genomes:

````julia
mutable struct Genome
  m::Float64
  b::Float64
end
````





{{< callout information >}}
Defining a new type is *absolutely not* necessary. We are only doing it to show
some interesting features of Julia.
{{< /callout >}}

This means that our population will be of the type `Vector{Genome}`. Now, we
will *add methods* to some of Julia's existing function, so we can write code
that will read exactly like native code would:

````julia
import Base: zero
zero(::Type{Genome}) = Genome(0.0, 0.0)
````


````
zero (generic function with 36 methods)
````





Because we have created a `zero` method for the `Genome` type, we can create our
population:

````julia
population_size = 1_000
population = zeros(Genome, population_size)
population[1:5]
````


````
5-element Array{Main.WeaveSandBox3.Genome,1}:
 Main.WeaveSandBox3.Genome(0.0, 0.0)
 Main.WeaveSandBox3.Genome(0.0, 0.0)
 Main.WeaveSandBox3.Genome(0.0, 0.0)
 Main.WeaveSandBox3.Genome(0.0, 0.0)
 Main.WeaveSandBox3.Genome(0.0, 0.0)
````





To have a slightly more pleasing display, we can also overload the `show`
function:

````julia
import Base: show
show(io::IO, g::Genome) = print(io, "ŷ = $(round(g.m; digits=3))×x + $(round(g.b; digits=3))")
population[1:5]
````


````
5-element Array{Main.WeaveSandBox3.Genome,1}:
 ŷ = 0.0×x + 0.0
 ŷ = 0.0×x + 0.0
 ŷ = 0.0×x + 0.0
 ŷ = 0.0×x + 0.0
 ŷ = 0.0×x + 0.0
````





And we are now ready to start. At this point, it is useful to outline the
general structure of the genetic algorithm:

````julia
function GA!(p::Vector{T}, fitness::Function, mutation!::Function; generations=1_000) where {T}
  for generation in 1:generations
    fitnesses = fitness.(p)
    p = sample(p, weights(fitnesses), length(p), replace=true)
    mutation!.(p)
  end
  return nothing
end
````


````
GA! (generic function with 1 method)
````





Wouldn't it be cool if the real code was actually that simple?

What if I told you this *is* the real code? To make it work, we need to do two
things. First, we need to define a `fitness` function, which, given an input
(here, a `Genome`), will return its "score". Second, we need to define a
`mutation!` function, which will *modify* a genome.

The fitness function can be defined as follows (note that we have already taken
the log10 of the mass and FMR earlier):

````julia
const log10fmr = rates[:fmr]
````


<pre class="julia-error">
ERROR: ArgumentError: column name :fmr not found in the data frame
</pre>


````julia
const log10M = rates[:mass]
````


<pre class="julia-error">
ERROR: ArgumentError: column name :mass not found in the data frame; existing most similar names are: :Class
</pre>


````julia

ŷ(g::Genome, x::Vector{Float64})=  g.m .* x .+ g.b

function fmr_fitness(g::Genome)
  errors = log10fmr .- ŷ(g, log10M)
  sum_of_errors_sq = sum(errors.^2.0)/length(log10fmr)
  return 1.0/sum_of_errors_sq
end
````


````
fmr_fitness (generic function with 1 method)
````





The first thing we do is "extract" the $\text{log}_{10}$ of the FMR and mass,
and turn them into vectors. Then we define a function which uses these vectors,
and does the linear prediction. You may notice that this function uses elements
from "the outside", which have not been passed as arguments, and this may not be
ideal - this is why the `log10...` variables have been declared as `const`: they
will raise a warning if they are changed.

We can check the score of an "empty" genome ($\hat y = 0$):

````julia
fmr_fitness(zero(Genome))
````


<pre class="julia-error">
ERROR: UndefVarError: log10M not defined
</pre>




Now, let's define a function for mutations. Because we might want to change the
rate at which parameters evolve, it would be useful to be able to generate
multiple such functions. And so, our first task is to write a function that will
return another function, which will itself modify the `Genome` object. Note that
we `return nothing` at the end, because all of this function does is change an
existing object.

````julia
function normal_error(σm::Float64, σb::Float64)
  function f(g)
    g.m = rand(Normal(g.m, σm))
    g.b = rand(Normal(g.b, σb))
    return nothing
  end
  return f
end
````


````
normal_error (generic function with 1 method)
````





We can test that this all works as expected:

````julia
change_both! = normal_error(0.01, 0.01)
initial_genome = Genome(0.2, 0.5)
change_both!(initial_genome)
initial_genome
````


````
ŷ = 0.2×x + 0.511
````





Let's now define a function to work on the actual problem:

````julia
very_gradual_change! = normal_error(1e-3, 1e-3)
````


````
(::getfield(Main.WeaveSandBox3, Symbol("#f#4")){Float64,Float64}) (generic 
function with 1 method)
````





We have all of the pieces to apply our genetic algorithm. Before starting, it is
always a good idea to try and eyeball the parameters. Judging from the plot we
made early in the lesson, the intercept is probably just around 3, so we can
probably draw it from $\mathcal{N}(\mu=3, \sigma=1)$; the slope seems to be
close to one but a little bit lower, so we can get it from
$\mathcal{N}(\mu=0.75, \sigma=0.2)$:

````julia
population = [Genome(rand(Normal(0.75,0.2)), rand(Normal(3,1))) for i in 1:500]
````


````
500-element Array{Main.WeaveSandBox3.Genome,1}:
 ŷ = 0.958×x + 2.879
 ŷ = 0.674×x + 3.908
 ŷ = 0.734×x + 2.403
 ŷ = 0.818×x + 4.346
 ŷ = 1.031×x + 4.9  
 ŷ = 0.475×x + 2.027
 ŷ = 0.456×x + 2.679
 ŷ = 0.843×x + 2.243
 ŷ = 0.794×x + 4.469
 ŷ = 1.08×x + 3.123 
 ⋮                   
 ŷ = 0.81×x + 3.605 
 ŷ = 0.71×x + 3.998 
 ŷ = 0.75×x + 2.936 
 ŷ = 0.974×x + 3.078
 ŷ = 0.881×x + 3.915
 ŷ = 0.39×x + 1.924 
 ŷ = 0.594×x + 3.176
 ŷ = 0.838×x + 4.527
 ŷ = 0.928×x + 2.184
````



````julia
GA!(population, fmr_fitness, very_gradual_change!; generations=10000)
````


<pre class="julia-error">
ERROR: UndefVarError: log10M not defined
</pre>




**_TODO_**

````julia
scatter(10.0.^rates[:mass], 10.0.^rates[:fmr], c=:teal, leg=false, msc=:transparent)
````


<pre class="julia-error">
ERROR: ArgumentError: column name :mass not found in the data frame; existing most similar names are: :Class
</pre>


````julia
pred = collect(LinRange(10.0.^minimum(rates[:mass]), 10.0.^maximum(rates[:mass]), 100))
````


<pre class="julia-error">
ERROR: ArgumentError: column name :mass not found in the data frame; existing most similar names are: :Class
</pre>


````julia
mostfit = fmr_fitness.(population) |> findmax |> last
````


<pre class="julia-error">
ERROR: UndefVarError: log10M not defined
</pre>


````julia
plot!(pred, 10.0.^ŷ(population[mostfit], log10.(pred)), c=:orange, lw=2, ls=:dash)
````


<pre class="julia-error">
ERROR: UndefVarError: mostfit not defined
</pre>


````julia
xaxis!(:log10, "Mass (kg)")
yaxis!(:log10, "Field Metabolic Rate (kj per day)")
````


<pre class="julia-error">
ERROR: ArgumentError: At least one finite value must be provided to formatter.
</pre>




We can also look at the equation for the most fit genome: <pre class="julia-error">
ERROR: UndefVarError: mostfit not defined
</pre>
.
