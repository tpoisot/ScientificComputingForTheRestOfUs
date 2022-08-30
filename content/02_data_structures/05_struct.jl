# ---
# title: Building your own types
# status: alpha
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
# a very simple system to store the values of model parameters.

#-

abstract type ModelParameter end

#-

struct ExponentialDecay{T} <: ModelParameter where {T <: Number}
    λ::T
end

# We can use this new type with

ExponentialDecay(1.2)

# the @kwdef macro

Base.@kwdef struct LogisticModel{T} <: ModelParameter where {T <: Number}
    r::T = 0.1
    K::T = 1.0
end

#-

LogisticModel(0.2, 1.2)

#-

LogisticModel(; K = 2.0)

# const field in mutable struct

Base.@kwdef mutable struct StochasticModel{T, M} <:
                           ModelParameter where {T <: Number, M <: ModelParameter}
    noise::T = 0.01
    model::M = LogisticModel()
end

# mutable struct

mutable struct ProtectedStochasticModel{T, M} <:
               ModelParameter where {T <: Number, M <: ModelParameter}
    noise::T
    const model::M
end

#-

psm = ProtectedStochasticModel(0.001, LogisticModel())

#-

setfield!(psm, :noise, 0.1)

#-

getfield(psm, :noise)

#-

try
    setfield!(psm, :model, ExponentialDecay(0.2))
catch error 
    @warn "It is impossible to change the model field of a $(typeof(psm))"
end

# abstract type

# union types