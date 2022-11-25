# ---
# title: Dispatch on element types
# status: rc
# ---

# In this lesson, we will see how we can dispatch on parametric types, in order
# to have a fine-grained control on what method is used for different
# types of data collections. This is a core design pattern in *Julia*, and we will
# illustrate it by building some functions related to measuring the distances between
# points.

# <!--more-->

# In the previous modules, we have learned that (i) collections have a type, that is often
# a parameter of the type of the elements they contain, and (ii) methods are dispatched
# based on the type of their arguments. From this, we can build functions that are
# specialized to the content of a collection:

function whatsinthebox(x::Array{T, N}) where {T, N}
    return "This collection has $(N) dimension$(N>1 ? "s" : "") and stores $(T) elements"
end

# Let us first see whether this function works, and then we will take a bit of time to
# explain what is going on.

whatsinthebox(rand(Float64, 4))

#-

whatsinthebox(rand(Float64, 4, 3))

#- 

whatsinthebox(rand(Float64, 4, 3, 5))

# The part of this function signature that makes all of this happens is the `where`
# statement: it states that the type of the argument is `Array{T, N}`, but that we care
# about `T` and `N` (essentially). But we can do something more interesting with this,
# because we can add *conditions* to the types of `T` and `N`.

# There is a simple example we can build here, related to pairwise distances. Assuming we
# have a number of points, represented by a vector of numbers giving their position in some
# space, we might want to calculate the distance between each consecutive points. This is,
# in fact, the basis for the travelling salesperson problem!

# But the nature of how the information is represented should give use some type of clue as
# to what the proper distance function is. For example, integer positions might represent
# intersections between streets (and so we care about the taxicab, Manhattan, snake,
# city-block, ... distance); floating point positions are likely to represent the position
# on a plane, and the Euclidean distance is enough.

# Let us generate a matrix giving the series of successive positions in a 3d space:

M = rand(Float64, (3, 8))

# And let us also generate a matrix giving the positions in a 3d space made of street
# intersections:

P = rand(1:10, (3, 8))

# Perfect! Now, what would a distance function for such data look like? It would take two
# arrays of numbers as arguments, and return a number of the same type.

function distance(p1::Vector{T}, p2::Vector{T})::T where {T <: Real}
    return sqrt(sum((p1 .- p2).^(2.0)))
end

# We can try this on the matrix of continuous positions:

distance(M[:,1], M[:,2])

# This would *not* work on the matrix of discrete positions. The first reason is that this
# is not the distance measure we care about (but the code has no way to know about that),
# and the second reason is that the return point would *not* be an integer! And so, we need
# to define a method for distance that would specifically return the taxicab distance:

function distance(p1::Vector{T}, p2::Vector{T})::T where {T <: Integer}
    return sum(abs.(p1 .- p2))
end

# If we call this function on vectors from the matrix with discrete positions:

distance(P[:,1], P[:,2])

# Now that we have defined this function, we can wrap everything up to return the total
# travel length corresponding to an array of successive positions:

function travel(m::Array{T, N})::T where {T <: Number, N}
    travel_length = zero(T)
    for i in axes(m, 2)[2:end]
        travel_length += distance(m[:,(i-1)], m[:,i])
    end
    return travel_length
end

#-

travel(M)

#-

travel(P)

# And there we have it! This module is scratching the surface of what is possible when
# dispatching on parametric types. We will make use of these capacities in the later
# modules.
