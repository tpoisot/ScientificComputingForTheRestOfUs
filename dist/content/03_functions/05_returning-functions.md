---
title: Returning functions
weight: 5
---

*Julia* has a very interesting function called `isequal`. Let's see how it
works (don't forget to look at `?isequal` for more):

````julia
is_two = isequal(2.0)
````

````
(::Base.Fix2{typeof(isequal), Float64}) (generic function with 1 method)
````

When we call this function, we get back *another function*. We can apply this
new function to a few arguments:

````julia
is_two(π)
````

````
false
````

````julia
is_two(2)
````

````
true
````

This is actually rather helpful! In this module, we will illustrate how
returning functions works, and see a simple example from population dynamics.
But first, why should we want to return functions? A common example is when we
want to run multiple parameterizations of a model. We *could* write the model
function in such a way that we would give it all of the parameters, but it
might lead to long function calls. What if we could have a function that only
depends on the variables? To do this, we can write a fist function to generate
the function we will actually call.

An illustration is probably more useful here. Let's assume that we are
interesting in the logistic growth of a population in discrete time, which is
a simple process we can represent with the following model:

$$ n(t+1) = n(t)\times(1 + r (1 - n(t)/K)) $$

A way to simulate this could rely on a function that would be called with
something like `f(n, r, K)` -- but within a simulation, we do not expect $r$
or $K$ to change. So let's define a function that would *only* be a function
of $n$:

````julia
foo(n::Float64)::Float64 = n*(1.0+r*(1-n/K))
````

````
foo (generic function with 1 method)
````

Now, this function will *not work* because we do not have defined `r` or `K`.
We can do that by having a function taking values of `r` and `K` as arguments,
and return a version of our function with these values "replaced":

````julia
function discrete_logistic_growth(r::T, K::T)::Function where {T <: AbstractFloat}
    return model(n::T)::T = n*(one(T)+r*(one(T)-n/K))
end
````

````
discrete_logistic_growth (generic function with 1 method)
````

Note that we are using a number of tricks from the previous modules: we ensure
that `r` and `K` have the same type (a floating point value), we let *Julia*
know that `discrete_logistic_growth` returns a function, *and* we re-use the
type of the parameters to constrain the type of the variables.

What does it looks like in practice? We will use `Float32` values to get a
sense that all of the annotations on our function were not in vain:

````julia
discrete_logistic_growth(1.0f0, 2.0f0)
````

````
(::Main.##318.var"#model#1"{Float32, Float32, Float32}) (generic function with 1 method)
````

Excellent, this is a generic function with a single method! We can double
check that it is, indeed, a `Function`, by using the `isa` operator (it also
works as a function!):

````julia
discrete_logistic_growth(1.0f0, 2.0f0) isa Function
````

````
true
````

Excellent! Let's take a step back. That we are able to return functions should
not be very surprising, because functions are just another category of things.
There's not really a lot of conceptual difference between returning a number
and returning a function. But some of the difficulty comes from the fact that
the parameters of `discrete_logistic_growth` are now baked in the function we
return.

So how do we *use* this function? We can simply add a set of parentheses at
the end. For example, if our population has a growth rate of 1, a carrying
capacity of 2, and a current population size of 2.2, we should get a value
lower than 2:

````julia
discrete_logistic_growth(1.0f0, 2.0f0)(2.2f0)
````

````
1.98f0
````

Now, we can of course assign the first part of this expression to a variable:

````julia
parameterized_model = discrete_logistic_growth(1.0f0, 2.0f0)
````

````
(::Main.##318.var"#model#1"{Float32, Float32, Float32}) (generic function with 1 method)
````

We now have a fully usable function:

````julia
parameterized_model(2.2f0)
````

````
1.98f0
````

But *why*? Think of our function this way: as soon as it is created, using
`discrete_logistic_growth`, we know the parameters (because we specified
them), and we know that they will not change.

