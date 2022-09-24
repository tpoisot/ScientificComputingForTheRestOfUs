# ---
# title: Mutating functions
# status: beta
# ---

# In this module, we will see how *Julia* deals with collections when they are
# passed as arguments to a function, why this can be terrifying when coming from
# other languages that are less concerned with economy of memory, and how we can
# use this behavior to write more efficient code.

# <!--more-->

# Let's wrap the numbers from one to 25 in a matrix:

A = reshape(collect(1:25), (5, 5))

# And now, let's double them:

2A

# Very well. Now let's do this within a function:

function twice(M)
    for i in eachindex(M)
        M[i] = 2M[i]
    end
    return M
end

# We can call this function on `A`:

twice(A)

# And let's have a look at `A` again:

A

# !!DANGER Yeah. You see how that can be a problem, right? `A` has been changed
# because we passed it through the `twice` function. This is super dangerous.
# But also really useful. With great power, and all that.

# So what is going on?

# When you pass a collection to a *Julia* function, you do not pass a *copy* of
# this object. You pass the *location* of this collection in memory, for the
# function to work with. It might make sense if you know *C*, and no sense if
# you know *R*, but this is what *Julia* does, and the net benefit is:
# regardless of the size of the array you work on, it "costs" the same memory
# footprint to send it to a function.

# *Julia* functions are, by default, performing *mutations* on their arguments.
# By *convention*, this behavior is indicated by a `!` at the end of the
# function name. Think of it as the language going *Hey, listen!*, and asking
# you to pay attention.

# So let's start again, with a collection of values, and we will get a matrix
# with the remainder of their integer division by any other integer:

A = reshape(collect(1:25), (5, 5))

# The mutating function will have a `!` at the end of its name:

function remainder!(X::Matrix{T}, d::T) where {T <: Integer}
    for i in eachindex(X)
        X[i] = X[i] % d
    end
    return X
end

# This function will *overwrite* its argument `X`. How do we avoid this? Well,
# quite simply! We write a function that works on a *copy* of `X`:

function remainder(X::Matrix{T}, d::T) where {T <: Integer}
    Y = copy(X)
    remainder!(Y, d)
    return Y
end

# This function does *not* end with a `!`: this is because it is *not* modifying
# its first argument. Instead, we create a *copy* of this argument. This is when
# we re-use the function that changes its argument, to modify the copy, which we
# then return.

remainder(A, 3)

# We can check that `A` has not been affected:

A

# Success!

# !!!INFO There is a little subtelty here related to dispatch. Our `remainder`
# and `remainder!` are different *functions*, even though they belong to the
# same "family". This may be important if you look at the methods for
# `remainder`, as it will not list the methods for `remainder!`.

# And now, here is how we turn this into a very powerful way to be efficient
# about memory management. We will write another method for `remainder!` that
# over-writes, not its original argument, but an arbitrary array:

Z = similar(A)

# This might be a placeholder array we will use to store results temporarily.
# For example, when we perform thousands of iterations, we might not need to
# re-allocate the memory every time: in this case, it is beneficial to
# over-write the same memory locations over and over again.

function remainder!(x::Matrix{T}, X::Matrix{T}, d::T) where {T <: Integer}
    for i in eachindex(X)
        x[i] = X[i] % d
    end
    return x
end

# The way to call this function is:

remainder!(Z, A, 2)

#-

remainder!(Z, A, 3)

# But wait! The new version of `remainder!` we wrote is *suspiciously* similar
# to the earliest version of `remainder!`. In fact, with the exception of a
# single change, they are the same function. It is therefore time to revisit our
# initial `remainder!` function:

function remainder!(X::Matrix{T}, d::T) where {T <: Integer}
    return remainder!(X, X, d)
end

# See, writing *read from X and write in Z* and *read from X and write in X* is
# essentially the same thing, because we are giving *Julia* memory locations.
# And because `remainder!` is a function with different methods, the dispatch
# system is now working for us.

# !!!WARNING In practice, we would take great care to ensure that the dimensions
# of the various objects are compatible, but this has been omitted for the sake
# of brevity. This can be done with `@assert`, or more explicitly with checks
# and the throwing of exceptions.

# So let's summarize, and write our little remainder "library", from the most
# basal to the most abstract function:

function remainder!(x::Matrix{T}, X::Matrix{T}, d::T) where {T <: Integer}
    for i in eachindex(X)
        x[i] = X[i] % d
    end
    return x
end

function remainder!(X::Matrix{T}, d::T) where {T <: Integer}
    return remainder!(X, X, d)
end

function remainder(X::Matrix{T}, d::T) where {T <: Integer}
    Y = copy(X)
    remainder!(Y, d)
    return Y
end

# What happens when we do the following?

remainder(A, 3)

# We start by calling `remainder`, which makes a copy of the first argument,
# then calls `remainder!` (using a single argument); this then calls
# `remainder!` using the two arguments, and gives us the result *without*
# modifying `A`:

A

# Let's take a step back. Working with this design pattern is very useful when
# we sometimes have to overwrite some memory. In other cases, we only care about
# getting an object returned. Or we *definitely* want to overwrite the object we
# pass as an argument. To accomodate these use-cases, writing functions with and
# without `!`, and that operate on themselves or similar objects, give us the
# flexibility we need, and is a very Julian code design.