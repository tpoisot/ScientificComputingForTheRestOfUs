# ---
# title: An introduction to arrays
# status: rc
# ---

# A *lot* of scientific computing eventually boils down to accessing things in
# structures that look like vectors or matrices. In this module, we will examine
# the basic syntax to create, interact with, and transpose these structures. This is
# one of the most foundational module in the class, as we will be using an
# absurd quantity of vectors and matrices moving forward.

# <!--more-->

# We can start with a simple vector, *i.e.* a series of numbers (for example)
# organized in a structure:

[1, 2, 3]

# The way in which this `Vector{Int64}` is presented to you hides two extremely
# valuable pieces of information. First, it is a `Vector`, and the type of the
# elements in this vector are `Int64`. Paying attention to the type of things
# will rapidly become second nature, because it really opens up the full
# capacities of *Julia* as an expressive language for research.

# The second, and possibly more important piece of information, is that this is
# a *column* vector. In other words, when we type `[1, 2, 3]`, *Julia*
# understands that we really mean $[1\quad 2\quad 3]^\intercal$. Vectors are
# represented as columns, the way things should be.

# We can of course transpose this vector to make it into a *row* vector:

[1, 2, 3]'

# Yes! If you want to transpose a vector, you can add `'` at the end of it (or
# use the `transpose` function), which is a really nice bit of notation.

# But why do we care that the vectors are by default laid out as columns? There
# are two reasons. First, *Julia* is "column-major", meaning that things are
# stored alongside columns. This will be important to keep in mind when dealing
# with iteration a little later one (but you can forget it for now).

# Second, when it will be the time to multiply things together, it will be
# important to know if our vectors are represented as columns or rows. For
# example, the $\mathbf{u}\mathbf{v}'$ operation can be written as:

𝐮 = [1, 2, 3]
𝐯 = [2, 1, 0, 1]

𝐮 * 𝐯'

# This is nice! We have a code notation that looks like the way we would write
# this on paper.

# !!!OPINION *Julia* has extensive unicode support, documented at
# <https://docs.julialang.org/en/v1/manual/unicode-input/>. It is very possible
# to overuse this feature. Do not forget that not all fonts will have a version
# of these characters. The selections presented in the installation section
# should have most of them.

# But wait! This operation created a new beast we hadn't seen yet: a
# `Matrix{Int64}`. A `Matrix` and a `Vector` are actually very close cousins:
# both are examples of `Array`s. An array with a single dimension is a column
# vector, an array with two dimensions is a matrix, an array with three
# dimensions is a cube, etc.

Vector{Int64} == Array{Int64, 1}

#-

Matrix{Int64} == Array{Int64, 2}

# There is no alias for arrays in higher dimensions than 2, but it does not
# really matter, as we do not need them anyways.

# !!!INFO Note that the type of `Array{Int64, 2}` is parametric, but one of the
# parameters is a *value* (giving the number of dimensions). This is interesting
# if you want to perform some operations based on the dimensionality of the
# objects, although we won't be talking about ways to extract this information
# quite yet.

# In order to better understand vectors and matrices, let's get back to our
# example:

𝐀 = 𝐮 * 𝐯'

# We can have a look at the *size* of these structures:

size(𝐮)

# In the case of `𝐮`, the size is `(3,)`, which means that it has a single
# dimension, with three elements in it. If we apply the same function to `𝐀`,
# we get:

size(𝐀)

# This matrix has, indeed, three rows and four columns. We can query the number
# of elements alongside a dimension directly:

size(𝐀, 1)

# This gives the number of rows (using `size(𝐀, 2)` would give the number of
# columns, etc.).

# The size (or shape) of an array is something we can manipulate. Let's say that
# we have a vector:

𝐰 = [true, false, false, true]

# We can reshape it into an identity matrix, using

reshape(𝐰, (2, 2))

# !!!WARNING We would not generate an identity matrix this way in practice! The
# `LinearAlgebra`, from the standard library, has everything you will ever need
# to create one.

# Note that much like we can transpose vectors, we can transpose matrices:

𝐀'

# But pay attention to the type of `𝐀'` compared to the following:

transpose(𝐀)

# By looking into the *Julia* documentation, it shall be revealed that these
# operations are meant for linear algebra use only. If you want to pivot a
# matrix, there is a function to do that:

permutedims(𝐀)

# These three operations give you the same numbers in the same order, but they
# have different types, because *Julia* is so very particular about its type
# system (for good reasons). Note that if you *really* want to use the `'`
# operator because it looks nice, but you *really* want a matrix, you can:

Matrix(𝐀')

# In the next module, we will see how we can get values *out* of arrays, use
# different indexing systems to access values, and how we can take slices of
# these objects.