# ---
# title: Returning functions
# status: rc
# ---

# In this module, we will learn how we can write functions that return other
# functions. Because this seems a little weird at first, we will also discuss
# situations in which this is a useful design pattern, and see how this approach
# can be used together with Julia's powerful dispatch system.

# <!--more-->

# *Julia* has a very interesting function called `isequal`. Let's see how it
# works (don't forget to look at `?isequal` for more):

is_two = isequal(2.0)

# When we call this function, we get back *another function*. We can apply this
# new function to a few arguments:

is_two(π)

#-

is_two(2)

#-

# This is actually rather helpful! In this module, we will illustrate how
# returning functions works, and see a simple example from population dynamics.
# But first, why should we want to return functions? A common example is when we
# want to run multiple parameterizations of a model. We *could* write the model
# function in such a way that we would give it all of the parameters, but it
# might lead to long function calls. What if we could have a function that only
# depends on the variables? To do this, we can write a fist function to generate
# the function we will actually call.

# An illustration is probably more useful here. Let's assume that we are
# interesting in the logistic growth of a population in discrete time, which is
# a simple process we can represent with the following model:

# $$ n(t+1) = n(t)\times(1 + r (1 - n(t)/K)) $$

# A way to simulate this could rely on a function that would be called with
# something like `f(n, r, K)` -- but within a simulation, we do not expect $r$
# or $K$ to change. So let's define a function that would *only* be a function
# of $n$:

foo(n::Float64)::Float64 = n * (1.0 + r * (1 - n / K))

# Now, this function will *not work* because we do not have defined `r` or `K`.
# We can do that by having a function taking values of `r` and `K` as arguments,
# and return a version of our function with these values "replaced":

function discrete_logistic_growth(r::T, K::T)::Function where {T <: AbstractFloat}
    return model(n::T)::T = n * (one(T) + r * (one(T) - n / K))
end

# Note that we are using a number of tricks from the previous modules: we ensure
# that `r` and `K` have the same type (a floating point value), we let *Julia*
# know that `discrete_logistic_growth` returns a function, *and* we re-use the
# type of the parameters to constrain the type of the variables.

# What does it looks like in practice? We will use `Float32` values to get a
# sense that all of the annotations on our function were not in vain:

discrete_logistic_growth(1.0f0, 2.0f0)

# Excellent, this is a generic function with a single method! We can double
# check that it is, indeed, a `Function`, by using the `isa` operator (it also
# works as a function!):

discrete_logistic_growth(1.0f0, 2.0f0) isa Function

# Excellent! Let's take a step back. That we are able to return functions should
# not be very surprising, because functions are just another category of things.
# There's not really a lot of conceptual difference between returning a number
# and returning a function. But some of the difficulty comes from the fact that
# the parameters of `discrete_logistic_growth` are now baked in the function we
# return.

# So how do we *use* this function? We can simply add a set of parentheses at
# the end. For example, if our population has a growth rate of 1, a carrying
# capacity of 2, and a current population size of 2.2, we should get a value
# lower than 2:

discrete_logistic_growth(1.0f0, 2.0f0)(2.2f0)

# Now, we can of course assign the first part of this expression to a variable:

parameterized_model = discrete_logistic_growth(1.0f0, 2.0f0)

# We now have a fully usable function: 

parameterized_model(2.2f0)

# But *why*? Think of our function this way: as soon as it is created, using
# `discrete_logistic_growth`, we know the parameters (because we specified
# them), and we know that they will not change.

# Can we make this approach intersect nicely with Julia's dispatch system? Of
# course! Let's assume we want to run the model sometimes on a single point (one
# population), and sometimes on a series of populations (a vector of
# abundances). We can do this by having, for example, one function taking a
# number as input, and another function taking a vector of number as inputs. But
# can we create both these functions when we create our model?

# Yes!

function better_discrete_logistic_growth(r::T, K::T)::Function where {T <: AbstractFloat}
    model(n::T)::T = n * (one(T) + r * (one(T) - n / K))
    model(n::Vector{T})::Vector{T} =
        n .* (one(eltype(T)) .+ r .* (one(eltype(T)) .- n ./ K))
    return model
end

# Remember from the [module on dispatch][fn_disp] that a function is "just" a
# name, a big ol' bag of methods. We can declare as many methods as we want, and
# the output is still going to be a function.

# [fn_disp]: {{< ref "04_basic_functions_usage/02_dispatch.md" >}}

# Let's verify this!

parameterized_better_model = better_discrete_logistic_growth(0.2, 1.0)

# This is indeed a generic function with two methods. We can see it in action:

parameterized_better_model(0.5)

#-

parameterized_better_model([0.0, 0.2, 1.0, 1.4])

# This is another reason why the dispatch system is so important in Julia -- we
# can use it to write a lot of different things that make the syntax of our code
# much more pleasant to read!