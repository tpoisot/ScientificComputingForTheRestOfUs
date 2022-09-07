# ---
# title: Map, Filter, Accumulate, Reduce
# status: beta
# ---

# In a lot of applications, we want to apply some operation to all elements in a
# collection, and then aggregate these elements together in a grand unified
# answer. In this module, we will have a look at the map-filter-reduce strategy,
# as well as the accumulate operation.

# <!--more-->

# Calculating an average. Easy, right? We load {{Statistics}}, and call `mean`.
# What if we made it fun? What if we made it way, way more complicated than it
# has any right to be?

# Let's take a vector $\mathbf{x}$. The average value of $\mathbf{x}$ is its sum
# divided by its length:

# $$
# \frac{x_1}{n} + \frac{x_2}{n} + ... + \frac{x_n}{n}
# $$

# In other words, for every element $x_i$, we want to divide it by $n$, and then
# we want to reduce all of these using the sum operation. This is a task for
# `map` and `reduce`.

# The `map` function will take a function as argument, and apply it to every
# element of a collection. For example, this is a way to use `map` to double
# every entry in an array:

x = [1, 2, 3, 4]
map(e -> 2e, x)

# On the other hand, `reduce` accepts a binary operator (something requiring two
# arguments), and applies it sequentially alongside an array until a single
# value remains. For example, the sum of an array expressed as `reduce` is:

y = [1, 2, 4, 5]
reduce(+, y)

# And so, we have enough to build a very crude function to get the average of an
# array of values:

x = [1, 2, 3, 4, 5, 6, 7]
n = length(x)
reduce(+, map(e -> e / n, x))

# !!!WARNING The `reduce` operation has no well defined behavior when using an
# operator without associativity, like a substraction. This is because
# `reduce(-, [a,b,c])` can be `a-(b-c)` or `(a-b)-c`; the documentation for
# `reduce` has a number of alternatives to suggest.

# Another function that is often used together with `map` and `reduce` is
# `filter`. The `filter` function evaluates a condition on every element of a
# collection:

filter(isodd, 1:10)

# Using `filter` can be done *before* `map` (we want to apply on operation, but
# only on some elements), or *after* `map` (we want to apply the operation and
# see where we stand). This sequence of operations is commonly known as
# map-filter-reduce, and is a very expressive way of chaining together
# operations.

# Another related function is `accumulate`, which works much like `reduce` but
# without collapsing the vector to a single element. For example the sequence of
# $n!$ is

accumulate(*, 1:5)

# and the cumulative sum of an array is

accumulate(+, 1:5)

# Chained together, these four functions can get *really* powerful. For example,
# we can use `accumulate` to write a logistic growth model in a single line. We
# can define some parameters:

r, K, n₀ = 2.3, 1.0, 0.01

# We can now define a model that takes two arguments, as per the documentation
# of `accumulate` (which you should definitely read):

model = (n, _) -> n + n * r * (1 - n / K)

# And run it for a number of steps defined by the array; note that we use the
# `init` keyword to "seed" the process with a value of our choice, here the
# initial population size:

nt = accumulate(model, zeros(Float64, 10); init = n₀)

# This is a time-discrete model with no loop!

# !!!INFO The `map` function has a variant for arrays with more than one
# dimension called `mapslices`, which works on slices of high-dimensional
# arrays. It's useful to perform, *e.g.*, row-wise or column-wise operations on
# matrices.
