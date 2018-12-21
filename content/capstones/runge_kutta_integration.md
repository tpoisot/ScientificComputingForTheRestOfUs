---
title: Runge-Kutta integration
slug: runge_kutta_integration
weight: 1
packages:
  - Plots.jl
topics:
  - writing functions
  - numerical precision
  - arrays
  - varargs
---

Numerical integration, the search for solutions of differential equations, is a
hallmark of scientific computing. In this lesson, we will see how we can apply
multipe concepts to write our own routine for the second-order Runge-Kutta
method. In practice, it is *never* recommended to write one's own routine for
numerical integration, as there are specific packages to handle this task. In
Julia, this is
[`DifferentialEquations.jl`](http://docs.juliadiffeq.org/latest/). This being
said, writing a Runge-Kutta method is an interesting exercise.

Glossing over a few details, numerical integration requires a function $f$,
giving the derivative at time $t$, a timestep $h$ at which to evaluate $f$, and
an initial quantity $y$. There are multiple notations, but for this lesson we
will adopt $y(t)$ for the value of $y$ at time $t$. The second-order Runge-Kutta
method (RK2) works by evaluating the derivative at time $t+h/2$, and using this
information to correct the initial assessment. This helps (very moderately) in
problems where $y$ varies a lot over short periods of time.

In practice, RK2 is described by the following system of equations:

$$y(t+\frac{h}{2}) = y(t)+\frac{h}{2}f\left(t, y(t)\right)$$

$$y'(t+\frac{h}{2}) = f\left(t+\frac{h}{2}, y(t+\frac{h}{2})\right)$$

$$y(t+h) = y(t) + h y'(t+\frac{h}{2})$$

But before we start writing this in code, let's think about the function we want
to integrate for a minute or two. In this example, we will use the situation of
two or more species competing for space or any other resource. The general
equation of this system is:

$$\frac{1}{N_i}\frac{d}{dt}N_i = r_i - \sum_j\alpha(ij)N_j$$

Every species grows at rate $r_i$, and species $j$ prevents the growth of
species $i$ at a *per capita* rate of $\alpha(ij)$. There are a number of
parameters we may want to change: the number of species, the matrix giving
competition strengths, and the initial populations sizes. We may also want to
substitute another problem later, instead of working on the competition model.
For this reason, it is better to write a fonction which is as general as
possible.

We know that all of our problems (*i.e.* all of our models) will have two things
in common: they will require the time $t$, and the value $y$; the rest can go in
keyword arguments. This gives us a template to write the function for the
competitive model:

````julia
function competitive_model(t::Float64, y::Vector{Float64}; r=1.0, α=1.0)
  return vec(r.*y .- sum(α .* (y .* y'); dims=2))
end
````


````
competitive_model (generic function with 1 method)
````





There are *many* things that can go wrong with this function -- so we may want
to add a few checks before we call it. This is an interesting exercise to do,
and you can re-read through the lesson on [avoiding mistakes]({{< ref
"lessons/03_avoiding_mistakes.md" >}}) to refresh your memory. For now, we will
use this basic (but unsafe) version.

Let's try! If we have a single species, and we give it an initial population
lower than $r/\alpha$, then it should grow:

````julia
competitive_model(0.0, [0.1]; r=0.5, α=1.0)
````


````
1-element Array{Float64,1}:
 0.04
````





Nothing stops us from running this function a few times, to figure out if it
gives the correct dynamics:

````julia
population = zeros(Float64, 50)
population[1] = 1e-2
for i in 2:length(population)
  population[i] = population[i-1] + competitive_model(0.0, [population[i-1]]; r=0.5, α=0.3)[1]
end
population
````


````
50-element Array{Float64,1}:
 0.01               
 0.01497            
 0.02238776973      
 0.03343129092495495
 0.04981164102355973
 0.0739731016609016 
 0.10931804656055216
 0.16039193924968373
 0.23287023662164333
 0.33303679080119897
 ⋮                  
 1.6666666609274734 
 1.66666666379707   
 1.6666666652318685 
 1.6666666659492675 
 1.6666666663079672 
 1.666666666487317  
 1.666666666576992  
 1.6666666666218295 
 1.666666666644248
````





We can plot this:

````julia
using Plots
plot(population,
  c=:orange, lw=2, leg=false, xlab="Time", ylab="Population size",
  xlim=(0,50), ylim=(0,2), frame=:origin
  )
````


{{< figure src="../figures/runge_kutta_integration_4_1.svg" title="Results of the simulation with a naive approach, where we simply add the output of the function to the original value. In this situation, because the problem is simple, it gives reasonable results."  >}}


So far, so good! Our simple functions works Well Enough &trade;, so we can start
thinking about the RK2 integrator. We want our RK2 integrator (a function named
`rk2`) to return two values: an array of times, going from $t_0$ to $t_f$ by
steps of $h$, and an array of population sizes at every point. This means that
we can start thinking about the arguments: `t=(t0,tf)` is a tuple with the
beginning and end time; `h` is the integration step. None of these have obvious
defaults, but we will still put them as default, keyword arguments, to make sure
that we can run our function with a minimum number of keystrokes. If this seems
contradictory to the best practices we mentionned in some lessons, it's because
it really is! But best practices are not laws, and sometimes it is worth
applying critical judgement.

Our function will therefore look something like

```raw
function rk2(;t=0.0=>100.0, h=0.1)
  # something
  # something else
  T = collect(t.first:h:t.second)
  return something, T
end
```

The notation we use for `t` is called a `Pair` (and is covered in the Julia
documentation). The next step is to think about the "meat" of the function: for
every timestep, we want to apply the RK2 equations that are given early in this
lesson. Assuming that the current population is stored at position `i` of an
object called `U`, this would look like:

```raw
y_th2 = U[i] .+ 0.5*h .* f(ti, U[i]; p...)
yprime_th2 = f(ti+0.5*h, y_th2; p...)
y_th = U[i] .+ h*yprime_th2
U[i+1] = y_th
```

There are a few things worth looking at here. First, note that we use the `.`
notation, to make sure that operations are vectorized. Second, we call the `f`
function (which here would be our `competitive_model` function) using an
argument called `p...`. This syntax allows a function to *capture keyword
arguments, and pass them to another function. Let's have a look:

````julia
function a(x; y=2.0, z=3.0)
  return x + y + z
end
function b(x; k...)
  return a(x; k...)
end

b(1.0) # Should be 6
````


````
6.0
````



````julia
b(1.0; y=0.0) # Should be 4
````


````
4.0
````





In short, this allows passing "all the keyword arguments" from a function to
another. This is really useful in our context, because although we currently use
the competition model, we may want to change it later, possibly to something
that accepts different keyword arguments! This gives us the two extra parameters
we need to add to `rk2`: the function `f`, and the term to catch arguments `p...`.

```raw
function rk2(f; t=0.0=>100.0, h=0.1, p...)
  # something
  for some things
    y_th2 = U[i] .+ 0.5*h .* f(ti, U[i]; p...)
    yprime_th2 = f(ti+0.5*h, y_th2; p...)
    y_th = U[i] .+ h*yprime_th2
    U[i+1] = y_th
  end
  # something else
  T = collect(t.first:h:t.second)
  return U T
end
```

Believe it or not, this is almost finished! All we need is to set a value for
`U`, and to iterate over all values of `T`:

````julia
function rk2(u0, f; t=0.0=>100.0, h=0.1, p...)
  T = collect(t.first:h:t.second)
  U = typeof(u0)[]
  push!(U, u0)
  for (i,ti) in enumerate(T[2:end])
    y_th2 = U[i] + 0.5*h * f(ti, U[i]; p...)
    yprime_th2 = f(ti+0.5*h, y_th2; p...)
    y_th = U[i] + h*yprime_th2
    push!(U, y_th)
  end
  return (T, hcat(U...)')
end
````


````
rk2 (generic function with 1 method)
````





Let's try to run the same example as before:

````julia
t, u = rk2([0.01], competitive_model; t=1.0=>50.0, r=0.5, α=0.3)
plot(population,
  c=:orange, lw=2, lab="Naive method", xlab="Time", ylab="Population size",
  xlim=(0,50), ylim=(0,2), frame=:origin
  )
plot!(t, u, c=:teal, lab="RK2")
````


{{< figure src="../figures/runge_kutta_integration_8_1.svg" title="Using a second-order Runge-Kutta method is changing the result quite a lot. Although the naive method is finding the correct endpoint, it is underestimating the growth at first."  >}}


And now, we can use this function to

````julia
N = 200
α = rand(Float64, (N, N))
u0 = rand(Float64, N).*0.01
r = rand(Float64, N)
rk2(u0, competitive_model; r=r, α=α, h=0.01, t=1.0=>50.0) |> x -> plot(x, c=:grey, leg=false)
````


{{< figure src="../figures/runge_kutta_integration_9_1.svg"  >}}


**TODO** with r varying over time
