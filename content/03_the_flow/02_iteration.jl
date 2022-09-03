# ---
# title: Advanced iteration
# status: rc
# ---

# In this module, we will see how we *actually* iterate over objects in *Julia*.
# Although the content of the previous module is very important, as it forms the
# basis of all ways to iterate, there are a number of functions that greatly
# facilitate our task. We finish this module by simulating a simple
# host-parasitoid model.

# <!--more-->

# What are the numbers between 12 and 17? We can represent this as a `UnitRange`
# (a memory efficient way to store sequences):

our_seq = 12:17

# After reading the module on indexing, we could get the second entry in this
# sequence with

our_seq[2]

# But of course, performing any operation on *all* numbers in the sequence would
# be a little time-consuming. Therefore, we will iterate.

# It would be very tempting to iterate from the first index (`1`) to the last
# index of the sequence (its `length`). *Julia* discourages this, because
# `length` is not really meant to help with iteration. And luckily, there is a
# much, much better

for i in eachindex(our_seq)
    @info our_seq[i]
end

# What is this mysterious `eachindex`?

eachindex(our_seq)

# In short, it is an object that *Julia* prepares for us, that makes iteration
# safe. But there is an even better way to iterate. Let's assume that we have a
# sequence of evenly spaced numbers:

our_other_seq = LinRange(0.0, 1.0, 6)

# We can iterate on these values to take, for example, their square, this way:

for i in eachindex(our_other_seq)
    @info "i = $(i)   (xᵢ)² = $(our_other_seq[i]^2.0)"
end

# !!!WARNING Ah, yes. About this. `0.2^2.0` is *not* `0.04`. There is a reason for
# this, and it is: [computers are not very good with
# numbers](https://en.wikipedia.org/wiki/Round-off_error). It's OK, neither are
# we; hopefully it'll sort itself out ([it
# won't](https://slate.com/technology/2019/10/round-floor-software-errors-stock-market-battlefield.html)).

# But there is a more efficient way to iterate:

for (i, x) in enumerate(our_other_seq)
    @info "i = $(i)   (xᵢ)² = $(x^2.0)"
end

# The `enumerate` function is making things a little more complex because our
# mental model of `for`, `variable`, `values` is a little bit invalidated now.
# This is because it returns not one value but two: the position in the object
# we are iterating over, and the *value* at this position. This is a little
# confusing, so let's open-up the `enumerate` function:

collect(enumerate(our_other_seq))

# This is something we know! It's a tuple! It's tuples in a vector! And we know
# from the module on tuples that they can be used to store values until we are
# ready to use them, and so this is what `enumerate` does: it stores together
# the position and the value.

# But what about arrays with higher dimensions? The same logic applies. Let's
# create a little matrix, and see how we can iterate over it:

A = reshape(Array(7:12), 2, 3)

# Let's start to get a sense of the output of `eachindex`:

collect(enumerate(A))

# This is very similar to the output we got for a vector, with the exception
# that the shape of the enumerated elements matches the shape of the matrix.
# Will it be an issue? Is there something we need to do? No.

# Recall from the module on indexing that we can index a matrix linearly, so we
# don't need to change the way we work:

for (pos, val) in enumerate(A)
    @info "A[$(pos)] = $(val)"
end

# But what if we wanted to use the fact that matrices have rows and columns? In
# this case, we can use the `axes` function:

axes(A)

# When called on an array, it will return a tuple of iterators (`OneTo` is a
# weird object, but essentially, `OneTo(3)` will return the numbers from 1 to
# 3), one for each dimension. The `axes` function has additional methods where
# we specify the arguments, so we can write, for example:

for row in axes(A, 1)
    for col in axes(A, 2)
        @info "A[$(row),$(col)] = $(A[row,col])"
    end
end

# But wait! This is two loops, one nested in the other. There has got to be an
# easier way to write this. When we are are dealing with nested loops, we can
# declare all of them on the same line:

for row in axes(A, 1), col in axes(A, 2)
    @info row, col
end
