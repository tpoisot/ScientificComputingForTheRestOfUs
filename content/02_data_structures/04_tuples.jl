# ---
# title: Tuples, named tuples, and sets
# status: beta
# ---

# In this module, we will explore data structures that look a lot like arrays,
# but have subtly different use cases: tuples, named tuples, and sets. Knowing
# when to use arrays and when to use others data structure can really make a
# difference in your programming!s

# <!--more-->

# One important feature of arrays is that they are *mutable*. For example, if we write

x = [1, 2, 3]
x[2] = 3
x

# we have modified the value of `x``. In some cases, we care a lot about data
# integrity in a collection. This is, for example, the case with model
# hyper-parameters, for which we do not want to see a change.

# In a nutshell, this is what tuples do (they do a little more than that, and it
# is, as you have guessed, written down in the documentation).

# A tuple is declared using parentheses instead of square brackets:s

a = (1, 2, 3)

# By contrast to the array, we cannot modify values in a tuple:

try
    a[2] = 3
catch error
    @info typeof(error)
end

# Note that this is a `MethodError`: there is no instruction in *Julia* to let
# the user modify a tuple!

# In short, values in a tuple are *safe*, because they can be read (`a[2]` would
# return the second element), but not written to. But tuple can do something
# absolutely fantastic:

x, y, z = (1, 2, 3)
y

# They can store values, and this allows us to *unpack* these tuples into
# arguments. This is a great way to safely store values (tuples are impossible
# to alter) until we are ready to use them with more explicit names.

# Although we have written the tuple using the position of arguments, it is
# possible to use a structure called a *named* tuple, in which the fields of the
# tuple have names.

parameters = (r = 0.8, K = 1.0, A = 0.2)

# We can access these fields using the dot notation:

parameters.r

# or with the `getfield` function:

getfield(parameters, :K)

# Note that tuples have a fairly intricate type:

typeof(parameters)

# This goes far beyond the scope of this material, but the type of this tuple
# actually account for the *name* of its fields!

# !!!INFO One exteremely powerful use of named tuples is to splat them when
# calling functions. We will get to this point later on, when spending quite a
# lot of time exploring how functions work.

# An addition way to store a collection of data is to use a `Set`. Sets are
# exactly that, a translation of the mathematical object of a set, from set
# theory.

s1 = Set([1, 2, 3])

# Notice that the order or the elements is not maintained! Operations on sets
# follow the mathematical convention:s

s2 = Set([2, 3, 4, 5])

# For example, the `\cap` operator will perform an intersection (see also
# `intersect`):

s1 ∩ s2

# The union is done with `\cup` (see also `union`):

s1 ∪ s2

# There is also a `setdiff` function for set differences:

setdiff(s1, s2)

# Note that `setdiff` is sensitive to the order of its arguments:

setdiff(s2, s1)

# A big difference with the tuples is that sets cannot be indexed (because the
# elements are *not* sorted), but it is possible to *add* elements to a set:

push!(s2, 6)

# A second difference is that sets only store *unique* values, so pushing the
# value `6` a second time will not be an issue:

push!(s2, 6)

# Sets are very useful at representing a group of entities for which the order
# is unimportant, but the entries must be unique. Tuples are very good at
# storing data that you may want to name, but that you certainly do not want to
# modify.