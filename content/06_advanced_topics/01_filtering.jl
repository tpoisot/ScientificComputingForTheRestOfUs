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

