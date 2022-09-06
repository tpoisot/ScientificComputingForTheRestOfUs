# ---
# title: Map, Filter, Reduce
# status: alpha
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

x = [1,2,3,4,5,6,7]
n = length(x)
reduce(+, map(e -> e/n, x))

# !!!WARNING The `reduce` operation has no well defined behavior when using an
# operator without associativity, like a substraction. This is because
# `reduce(-, [a,b,c])` can be `a-(b-c)` or `(a-b)-c`; the documentation for
# `reduce` has a number of alternatives to suggest.