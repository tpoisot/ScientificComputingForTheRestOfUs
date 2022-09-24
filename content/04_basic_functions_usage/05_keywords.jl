# ---
# title: Keyword arguments and splatting
# status: beta
# ---

# In the previous modules, we have defined functions that used *positional*
# arguments, some with default values, some without. In this module, we will
# look at keyword arguments and splatting, to build functions that we can
# control a bit more.

# <!--more-->

# A common activation function in neural networks is the parametric leaky ReLU,
# where the gradient is the input if the input is positive, and a small fraction
# of the input if not. The weight of how small the gradient is can be an
# hyper-parameter, or a parameter that is learned alongside the model itself.

# Commonly, the leaky ReLU uses a weight of $10^{-3}$, so this makes sense as a
# *default* value. Or would $0$ be a better value, so that our default leaky
# ReLU is the original ReLU? Who knows?

# !!!OPINION Eh, whatever, just document it. To give you an idea of how this is
# done, we will add a *docstring* to the function just below.

"""
    relu(x; a=0)

Parameteric leaky ReLU for a given activation `x`, where the gradient is `x` if
`x` is positive, and `a*x` if not. The rate of the gradient for negative values
of `x` is given by the keyword argument `a`, which has a default value of
`zero(typeof(x))` -- **without changing the value of `a`, this function is the
"standard" ReLU**.
"""
function relu(x::T; a::T = zero(T))::T where {T <: Real}
    return x <= zero(T) ? a * x : x
end

# You can now type `?relu` in your REPL to see the documentation of this
# function. Note that the function docstring is written in mardkown, so you can
# use bold, italic, lists, code, etc..

# We can also use the `@doc relu` macro (in the REPL), or call the
# `Base.Docs.doc` function:

Base.Docs.doc(relu)

# How do we use our function?

for activation in [-0.2, 0.0, 0.2]
    @info "∇($(activation))\t →    $(relu(activation))"
end

# As we have specified, the *default* behavior is to use the standard ReLU
# function. We can change this behavior when calling the function:

relu(-0.4; a = 1e-3)

#-

relu(0.4; a = 1e-3)

# This works! We can tweak the parameter values using their name, and not only
# their position.

# !!!OPINION We are **big fans** of using `;` to indicate the separation between
# positional and keyword arguments. This is actually required for some cases,
# and so it makes sense to use it everywhere.

# We can define another version of `relu` that has no position argument. Before
# we do so, let's justify this. Let's say we want to keep the weight of negative
# activations the same, so we want to (as in the previous modules) return a
# function. The issue is that our `relu` function has keyword arguments in its
# signature (just one, but in some cases we can have dozens). And so, it would
# be far better for us not to have to type all of this.

# Here is what we will do: we can create a new method of `relu` where the
# signature is *no positional arguments, followed by a bunch of keyword
# arguments*: the syntax of this is `relu(; kwargs...)`.

# !!!INFO The `kwargs` name is not *required*, but it is shared across many
# languages as a signifier for "the kewyord arguments". You can name this in
# anyway you want.

"""
    relu(;kwargs...)

Curried version of `relu` that will return a function to be called on an
activation value.
"""
function relu(; kwargs...)
    @info kwargs # Show the keyword arguments
    prelu(x) = relu(x; kwargs...) # Create a function
    return prelu # Return the function
end

# Let's call this function, and see what happens:

relu(; a = 0.3)

# Interestingly, the `kwargs` variable contains a series of `Pair`s, mapping a
# keyword to its value. But let's take a moment to talk about `...`. This
# operator does something called *splatting*, which is essentially "capturing or
# expanding multiple arguments". It is restricted to being used within function
# calls.

# When we call `kwargs...` in the `prelu` function, it will *simply* (well...)
# unpack the keywords and their values. We can check that our function actually
# works:

relu(; a = 1e-2)(-0.2)

#-

relu(; a = 1e-2)(0.2)

# !!!WARNING This use-case is the one situation where `;` is mandatory. It tells
# *Julia* where the keyword arguments start. Using `;` to signify that there are
# no positional arguments is good practice.

# There is a nice little trick we can play with splatting: storing arguments in
# `NamedTuple`s:

function linear(x; m = 1.0, b = 0.0)
    return m * x + b
end

# Now, we can have a specific series of parameters:

p = (m=2.1, b=-0.3)

# And call the function by *unpacking* (with splatting) these keyworks:

linear(0.0; p...)

#-

linear(1.0; p...)

# Note that we are not restricted to `NamedTuple`s! We can use an array of
# `Pair`s:

q = [:m => 2.1, :b => -0.3]

# This will give the same result, and shows how much flexibility we have when
# passing arguments to functions:

linear(1.0; q...)

# As a conclusion: in addition to positional arguments, we can use *keyword*
# arguments, and store the value of these keyword arguments in structures that
# are then unpacked. This, in conjunction with `kwargs...` makes it easy to
# expand our function, or write multiple methods to make the code easier to
# maintain.