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
plot(population, c=:black, leg=false, size=(900,300))
````


{{< figure src="../figures/runge_kutta_integration_4_1.svg"  >}}


Note that at this time we do not use $t$ (you can try changing the value of $t$,
it has no impact on the result), and note also that this function returns the
*derivative*, *i.e.* the absolute change in population size.

````julia
function rk2(t0, u0, f; h=0.5, t=200.0, p...)
  T = typeof(t0)[]
  U = typeof(u0)[]
  push!(T, t0)
  push!(U, u0)
  for (i,ti) in enumerate(t0+h:h:t)
    y_th2 = U[i] + 0.5*h * f(ti, U[i]; p...)
    yprime_th2 = f(ti+0.5*h, y_th2; p...)
    y_th = U[i] + h*yprime_th2
    push!(T, ti)
    push!(U, y_th)
  end
  return (T, U)
end
````


````
rk2 (generic function with 1 method)
````



````julia
rk2(0.0, 0.0001, logistic; t=15.0)
````


<pre class="julia-error">
ERROR: UndefVarError: logistic not defined
</pre>

