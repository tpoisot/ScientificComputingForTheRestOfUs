# ---
# title: Broadcasting and the dot notation
# status: beta
# ---

# In some of the previous modules, we have used a notation that looked like
# `function.(arguments)`, or `x .+ y`. In this module, we will talk about what
# the `.` notation does, and more broadly, what *broadcasting* is.

# <!--more-->

# Let's generate two arrays:

x, y = [1, 2, 0], [4, 2, 1]

# We think of them as arrays, but in practice, they are *column vectors*, and
# therefore have their own arithmetic. For example, we can add them
# (element-wise):

x + y

# But the multiplication is not defined. If we want to do an element-wise
# multiplication, we need to specify that we are applying an operation to each
# elements:

x .* y

# We can also take the difference between these vectors (element-wise):

x - y

# But diving one by the other can give an unexpected result:

x / y

# What is going on? In simple terms, `/` is defined as the multiplication of its
# first argument by the inverse of its second, and because *Julia* will adhere
# very strictly to what symbols means mathematically, this operation works.

# This behavior can be surprising when coming from other languages, but this is
# a fact of life. If we want to *ensure* we work in an element-wise way, we need
# to use the `.` notation:

x ./ y

# This (using `.` to work on the elements instead of the entire object) is a
# nice little bit of syntactic sugar around what the operation actually is:

broadcast(*, x, y)

# In fact, we can call the `.*` version with the `@lower` macro from {{Meta}},
# and see that it is indeed performing broadcasting:

Meta.@lower x .* y

# Using element-wise notation can be extremely important when dealing with
# higher dimensional objects. For example, if we have two matrices:

U = [1 0; 0 1]
V = [1 2; 1 3]

# Calling `*` will perform *matrix multiplication*, because the `*` operator has
# a well accepted behavior when its arguments are matrices:

U * V

# In order to perform the Hadamard product, we need to call `.*` instead:

U .* V

# Again, this is equivalent to

broadcast(*, U, V)

# The `.` can also be used *betwen* a function and its arguments. For example,
# we can check for the odd elements in a matrix:

isodd.(V)

# Which is again identical to

broadcast(isodd, V)

# There is an interesting bit of notation we can use, which is to prefix a line
# where we *only* do element-wise operations with `@.`:

@. (x - y) / (x + y)

# This is equivalent to the more lengthy form using a `.` before each operator:

(x .- y) ./ (x .+ y)

# Using this notation will often be a good way to avoid writing a loop, and to
# apply a function rapidly to any collection. Named tuples and dictionaries are
# still going to resist this syntax, for reasons that are not necessarilly worth
# explaining here; but we have seen in previous modules how we can iterate over
# them regardless.