# ---
# title: Indexing, slicing, and all that
# status: beta
# ---

# In the previous module, we have introduced the notion of `Array`s, and
# experimented with the shape of vectors and matrices. In this module, we will
# continue our exploration of these objects, and see how we can modify and
# access the information they store.

# <!--more-->

# In order to facilitate our work, we will create a simple matrix, which will be
# full of ones:

A = ones(Float64, 4, 7)

# !!!INFO The `ones` and `zeros` functions are extremely useful to initialize
# objects of a given size and type, and we strongly recommend you check out
# their documentation.

# One fairly important question is, in what order are these elements stored in
# the matrix? We can start looking at the first indexing approach, also known as
# *linear* indexing:

LinearIndices(A)

# The first element is at the top-left of the matrix, elements are stored
# alongside columns, and the final element is at the bottom-right.

# This may seem a little awkward as we think of matrices as having two
# dimensions, but it is perfectly appropriate to ask for "the ninth value in
# `A`":

A[9]

# It's one. Of course it's one, because we generated a matrix that is filled
# with ones. So let's change this value:

A[9] = 9.0

# What is going one behind the scenes is in fact a call to two different
# methods. We can get values out of a structure with `getindex`:

getindex(A, 9)

# We can write values in a structure with `setindex!`:

setindex!(A, 2.0, 9)

# !!!INFO The `setindex!` function ends with an exclamation mark to let you know
# that it will mutate its first argument. This is not a feature of the language
# (adding `!` to a function name does not change anything), but a very strongly
# adhered to social contract. Much later, we will see how we use this design
# pattern in practice.

# There is a second way to access the coordinates of an array:

collect(CartesianIndices(A))

# This is a type of indexing we are more familiar with, as each entry is
# specified by a (row,column) pair of values. Notice that this is a matrix with
# the same shape as the `A` matrix, so we can check what the coordinates of the
# ninth position are:

CartesianIndices(A)[9]

# Line 1, row 3 -- what can we do with a `CartesianIndex`? Well, we can get
# information out of matrix:

A[CartesianIndex(1, 3)]

# Wait a minute, you say, this sounds very complicated. Why can't I write
# `A[1,3]`?

A[1, 3]

# You can. You can also use it to modify a value!

A[1, 3] = 4.0
A

# !!!OPINION These different ways to access/write information in an array all
# have their uses. For now, it is enough that you remember that it is possible
# to access information using the position you want by increasing dimension
# (rows, then columns, then ...). But at some point, we will have to leverage
# some unique functions of Cartesian indexing, so you can put a mental pin in
# this.

# Let's now come up with a slightly more interesting matrix:

B = reshape(1:30, (5, 6))

# We can extract the third row of this matrix with:

B[3, :]

# We can get the fourth column with:

B[:, 4]

# We can even get the entire matrix with:

B[:, :]

# This seems useless, but not really. What we have just introduced is a
# mechanism called *slicing*, in which we give a range of values that we want.
# It just so happens that `:` in this context is a shortcut for `begin:end`.

B[begin:end, 3]

# As our `B[:,:]` example shows, we can actually use two ranges:

B[1:2, 1:2]

# We can also use ranges that are defined *relative* to the start or the end of
# the array alongside this dimension:

B[(begin + 1):(end - 1), begin:(end - 2)]

# This is a very interesting way to access elements, and it also works with
# vectors:

u = [1, 2, 3, 4, 5, 6]
u[(begin + 2):(end - 2)]

# !!!INFO In fact, it works with arrays of *any* dimensions, as you need to
# specificy one range for each dimension. You can try with an array `X =
# reshape(Array(1:27), (3,3,3))`, to get `X[1:2,:,2:3]`.

# A final piece of information to know before moving forward is that we can use
# slices to rapidly change a lot of values in an array. Let's imagine a
# stochastic block matrix where we have two blocks of 5×5 with probability
# values, and the rest of the matrix is 0:

SBM = round.(rand(Float64, 10, 10); digits = 1);

# We can slice our way through this matrix to replace the parts that we want to
# set to 0:

SBM[6:end, begin:5] .= 0.0;
SBM[begin:5, 6:end] .= 0.0;

# !!!INFO We use `.=` to replace multiple values at once. This is a specific bit
# of *Julia* notation that we will take a deep dive into in a later module. For
# now, keep in mind that `.=` will replace more than one thing.

SBM

# At the end of this module, we have covered the ways we can index positions in
# an array, and how we can use slices to access multiple rows/columns at once,
# and if need be over-write them. This is a strong foundation to start building
# more ambitious code, as we will start to do in the next section!