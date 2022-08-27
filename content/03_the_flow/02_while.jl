# ---
# title: The while statement
# status: alpha
# ---

# In this module, we will see how we can use the `while` construct to make a
# series of instruction repeat until a condition is met, and how to deal with
# common caveats that can arise when using a `while` loop.

# <!-- more -->

# By opposition to a `for` loop, as we have seen in the previous module, the
# number of times a `while` loop will happen is not limited by the length of a
# collection. It is, instead, decided by an "exit condition", *i.e.* a condition
# that when met will stop the loop.

# Let's start with an example - because we will generate randon numbers, we will
# set the seed for this simulation:

import Random
Random.seed!(123456)

# The problem we want to solve is as follows: we need to generate two vectors of
# random numbers, `x` and `y`, that have a correlation between 0.6 and 0.8. This
# is, for example, a way to generate a small benchmark data point. The
# correlation function (`cor`) is in `Statistics`, which we can import:

import Statistics

# We can generate an initial pair of vectors:

x, y = rand(10), rand(10)

# Their correlation is

Statistics.cor(x, y)

# What we now need to do is keep generating vectors `x` and `y` *until* the
# condition is met. In *Julia*, this is expressed as

while !(0.6 ≤ Statistics.cor(x, y) ≤ 0.8)
    global x, y
    x, y = rand(10), rand(10)
end

# !!! DANGER Note that `while` loops only terminate when some condition is met.
# If the condition cannot be met, the loop can run on forever. One common
# strategy is to implement a counter with a maximum number of iterations, for
# example, and to use it to `break` out of the loop.

Statistics.cor(x, y)

# Note that we use `global x,y` because `x` and `y` are defined outside of the
# loop, and we are working outside of a function. If we removed this line, this
# code will never stop running! This is a very important poi
