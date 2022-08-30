# ---
# title: Building your own types
# status: beta
# ---

# In this module, we will *briefly* see how we can define our own types (*aka*
# `struct`), and give them a hierarchy. We will barely scratch the surface of
# what can be done with custom types, as the real fun will take place in the
# modules on [dispatch][dispatch], [element dispatch][elemdispatch], and
# [overloading][overloading] (don't read them yet!).

# <!--more-->

# [dispatch]: {{< ref "04_functions/02_dispatch.md" >}}
# [elemdispatch]: {{< ref "04_functions/04_element_dispatch.md" >}}
# [overloading]: {{< ref "05_advanced_topics/04_overloading.md" >}}

# In order to demonstrate how useful it is to build our own types, we will build
# a very simple system to store the values of model parameters. This is actually
# a fairly common design pattern: we express models as their own types, with
# parameter values stored as *fields*, and then write the correct methods to
# handle these types.

# In order to give some consistency to our own types, we will create an
# *abstract* type; an abstract type is not something that we represent an object
# directly, but it can collect other types. For example, `Real` is the abstract
# supertype for all real numbers; it is nested within `Number`, which is the
# abstract supertype for all numbers. We can use this to specificy a hierarchy
# between types:

Float64 <: AbstractFloat <: Real <: Number

# !!!INFO The `<:` operator means "is a subtype of, and we will use it *a lot*.

# We can define an `AbstractModelParameter` supertype in the following way:

abstract type AbstractModelParameter end

# Note that it has no content, as it only exists as a sort of placeholder to
# which various concrete types will be added.

# We can start building a type to represent, for example, the exponent in an
# exponential decay process, $x_t = x_0\text{exp}\left(-\lambda t\right)$:

struct ExponentialDecay{T} <: AbstractModelParameter where {T <: Real}
    λ::T
end

# Note that our type is defined as `ExponentialDecay{T}`, for which we specify
# that `T` must be a `Real` number (so no complex exponents!). Within the
# definition of the type fields, we further say that `λ` is a single scalar of
# the type `T`.

# !!!INFO This is called a *parametric* types, and parametric types are equally
# powerful and tricky; in other words, at the end of this module, have a look at
# the section on types in the *Julia* manual.

# We can use this new type with, for example:

expmodel = ExponentialDecay(1.2)

# Note that because the type of `1.2` is `Float64`, the type we have created is
# `ExponentialDecay{Float64}`. The `fieldnames` function is very helpful to
# investigate the names of the fields:

fieldnames(typeof(expmodel))

# Similarly, `fieldtypes` will give us the type of each field:

fieldtypes(typeof(expmodel))

# In order to define our `expmodel` variable, we had to pass the arguments in
# order; this is fine with a single (or a few) arguments, but for more complex
# types, it may be a good thing to have the option to use keywords. Thankfully,
# the `Base.@kwdef` macro can allow this:

# We can for example define the parameters of a logistic model, where we want to
# set a default value:

Base.@kwdef struct LogisticModel{T} <: AbstractModelParameter where {T <: Real}
    r::T = 0.1
    K::T = 1.0
end

# If we call this constructor (a constructor is the function that creates a
# variable of a given type, this is superbly documented in *Julia*'s manual), we
# get the default values:

LogisticModel()

# We can still use the usual interface of passing arguments in the order where
# they exist in the `struct`:

LogisticModel(0.2, 1.2)

# But now, we can also change the values we need, by using them as keywords:

LogisticModel(; K = 2.0)

# If we want to inspect the values of a specific field, there are a few options.
# We can access them directly:

expmodel.λ

# Or, we can access them in a much safer way:

getfield(expmodel, :λ)

# !!!OPINION The two approaches are roughly equivalent, and we usually go for
# `type.field` for user-facing code, although `getfield(type, :field)` is
# probably cleaner for low-level code.

# The types we have defined so far are *immutable*, which is to say they do not
# allow users to change their values. In order to make field mutable, we can
# annotate the declaration with `mutable`, like so:

Base.@kwdef mutable struct StochasticModel{T, M} <:
                           AbstractModelParameter where {T <: Number, M <: AbstractModelParameter}
    noise::T = 0.01
    model::M = LogisticModel()
end

# The `StochasticModel` can have its values changed! Let's create one without
# giving any values:

smod = StochasticModel()

# This is a fairly dense output, but it is worth nothing that the types and
# default values for `LogisticModel` have been correctly identified.

# With this mutable type, we can change the amount of noise we apply to our
# model. There are, again, two ways to do this.

smod.noise = 2.0

# The alternative way is to use `setfield!`

setfield!(smod, :noise, 3.0)

# !!!INFO The same disclaimer as with `getfield` applies. Note that `setfield!`
# follows the convention of ending with a `!` because it modifies its first
# argument.

# But what if we do *not* want all of the fields to be modified? For example, we
# can change the amount of noise over time, but keep the model the same. In
# order to do so, we can annotate some fields with `const`, meaning that they
# will not be mutable:

mutable struct ProtectedStochasticModel{T, M} <:
               AbstractModelParameter where {T <: Number, M <: AbstractModelParameter}
    noise::T
    const model::M
end

# We can create such a type:

psm = ProtectedStochasticModel(0.001, LogisticModel())

# Note that we can change the value of the `:noise` field:

setfield!(psm, :noise, 0.1)

# But if we try to change the model, we do expect an error -- this is because we
# have specified that this part of the `struct` is constant, and therefore
# *Julia* will not modify it:

try
    setfield!(psm, :model, ExponentialDecay(0.2))
catch error 
    @warn "It is impossible to change the model field of a protected model!"
end

# Building your own types, parametric or not, unlocks some of *Julia*'s most
# advanced features. We will revisit the importance of the type system in
# subsequent modules