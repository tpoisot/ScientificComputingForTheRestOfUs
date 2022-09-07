# ---
# title: Working with delimited files
# status: beta
# ---

# A lot of files we use in scientific computing are very simple, and organized
# as tables. There are a lot of packages in *Julia* to handle these files,
# including the full-featured {{DataFrames}} and {{DataFramesMeta}}. But in this
# module, we will focus on the standard library package {{DelimitedFiles}},
# which allows to store files where fields are separated by a specified
# character.

# <!--more-->

# In order to demonstrate how {{DelimitedFiles}} works, we will come up with a
# simple example of something we might want to save: the Singular Value
# Decomposition of a matrix. In order to have access to SVD, we will load the
# {{LinearAlgebra}} package.

import LinearAlgebra

A = round.(rand(5, 5); digits = 2)
U, Σ, V = LinearAlgebra.svd(A);

# We have three pieces of data here: the $\mathbf{U}$ and $\mathbf{V}^\intercal$
# matrices, and the vector of eigenvalues $\mathbf{\Sigma}$. If we save these
# three pieces of information, we can reproduce our matrix $\mathbf{A}$.

# In order to start saving the data, we need access to functionalities within
# {{DelimitedFiles}}:

using DelimitedFiles

# Specifically, we need to use the `writedlm` function. Before we continue,
# let's make sure we put our matrices in the same place:

destination = tempname()
mkdir(destination)

# We can save, for example, the matrix `U`:

writedlm(joinpath(destination, "U.mat"), U)

# Checking that it has been written is easy, as we can can simply read the
# content of the `destination` directory:

readdir(destination)

# Perfect! One thing that we *can* tweak with `writedlm` is the separator, which
# is `\t` (a tabulation) by default. We can change this to turn `U.mat` into a
# `csv` file:

writedlm(joinpath(destination, "U.mat"), U, ';')

# Note that the separator is given as a *character*, not as a string! That's
# right, no one can stop you from writing the following line:

writedlm(joinpath(destination, "U.mat"), U, '🙂')

# !!!WARNING Someone, preferably yourself, *should definitely* stop you from
# writing this line.

# Let's reset the `U.mat` file to something sensible (tab-separated):

writedlm(joinpath(destination, "U.mat"), U)

# We can now write the `V` matrix. In addition to the form we have seen here,
# there is another way to call `writedlm`, from within an `open`/`end`
# statement:

open(joinpath(destination, "V.mat"), "w") do io
    return writedlm(io, V)
end

# Why would we *ever* pick the more verbose, more complex way? Well, it's
# because of the `"w"` character. It stands for *write*, and is a way to specify
# what *Julia* is allowed to do with the file. For now, it can *only* write in
# it. Alternative permissions are `"r"` (read only), `"r+"` (read and write),
# `"w+"` (write and read), "`"a"` (append to the file), and `"a+"` (essentially
# all of the above).

# !!!INFO This is *very* useful when you couple this with a *lock*, as is
# detailed in the documentation for `open`, as it can prevent multiple threads
# or parallel processes from inadvertently over-writing one another. Although we
# will not go into this topic for this material, this is an important piece of
# information to keep in mind when you start dealing with distributed computing.

# We can similarly check that the file has been correctly written:

readdir(destination)

# Let's write the array of eigenvalues now:

writedlm(joinpath(destination, "eigenvalues.vec"), Σ)

# All done. And now, we are going to run things in reverse, and read these files
# to re-assemble our original matrix. But we will apply a little twist! The
# `readdlm` function (like `writedlm`) allows specifying the type of the data to
# read. This is a good idea if you want to save on memory and load, for example,
# data as `Float16`:

u = readdlm(joinpath(destination, "U.mat"), Float16)
v = readdlm(joinpath(destination, "V.mat"), Float16)
σ = readdlm(joinpath(destination, "eigenvalues.vec"), Float16)
typeof(σ)

# Notice that the type of `σ` is `Matrix{Float16}`, whereas the type of `Σ` was
# `Vector{Float64}`. This is because, by default, `readdlm` assumes that things
# are matrices, and therefore will return matrices. Thankfully this is easy to
# correct:

σ = reshape(σ, length(σ))

# !!!WARNING This assumption that things are a matrix is likely to cause issues
# depending on how you dispatch on arguments, or on the type of operations you
# apply. As always, check the output of functions and ensure that the computer
# representation and the mathematical representation match!

# And there we go. We have used {{DelimitedFiles}} to store tabular data using a
# custom separator, loaded these data back with a floating point precision, and
# corrected a little reshape incident. We can finally check that the
# decomposition/recomposition worked:

B = u * LinearAlgebra.Diagonal(σ) * v'
B ≈ A

# This concludes the module on {{DelimitedFiles}}. At a later point in this
# material, we will use {{CSV}} to read more structured data, but in a broad
# variety of situations, having access to simple features will get you a long
# way.