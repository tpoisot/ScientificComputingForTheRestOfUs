# ---
# title: Types
# status: alpha
# ---

# In this module, we will look at one of the most important concept in *Julia*:
# types. Types are, to be really imprecise, the way a programming language
# thinks about a value. A lot of problems arise from the fact that programming
# languages are very opinionated.

# <!--more-->

# Let's think about $2$, a real number that exists somewhere on the numbers
# line, roughly two steps to the right of 0:

x = 2.0

# We can also think about $2$, a real number that exists somewhere on the
# numbers line, roughly two steps to the right of 0:

y = 2

# These are different numbers. Well, not really. Not mathematically anyways,
# since as we expect:

x == y

# So `x` and `y` are equal, but they're actually not equal-equal. They're
# equal-ish:

x === y

# In the previous modules, we have discussed `==` as an equality comparison
# operator. This new operator, `===` is a "distinguishability" operator. What
# does this means? It lets us know that there exists a program that is able to
# make a difference between `2` and `2.0`. The reason is types.

typeof(x)

#-

typeof(y)

# The variable `x` is a floating point number using 64 bits of memory; the
# variable `y` is an integer using 64 bits of memory. These are very different
# objects: there is nothing existing between `2` and `3` (the two nearest
# integers)

two::Float64 = 2.0

#-

typeof(two)

# Why does this matter? The answer is simple -- as much as we like to think of
# 2.0+1 and 2.0+1.0 as the same operation, they are very different *to a
# computer*. Specifically, although they write almost the same, they turn out to
# be transformed to different code. In *Julia*, we can use the `@code_llvm`
# macro to look at the way the code we write is transformed into compiler
# instructions. This sounds like a lot of information (and it is, although when
# optimizing code it is often required to use these macros), but this will
# nicely illustrate the possible issue.

# Let's start with the naive 2.0+1:

import InteractiveUtils
InteractiveUtils.@code_llvm two + 1

# As you see, there are a lot of lines about *promotion*, which is to say, about
# representing a variable as another type. What happens if we use 2.0+1.0 (note
# that we can generate a one of the correct type using the `one` function):

InteractiveUtils.@code_llvm two + one(two)

# The code is much smaller, and notably has *no promotion*. We have gained some
# valuable execution time by using two variables with correct types.

# Recall that when we created the variable `two`, we *annotated* it with the
# type `Float64`. This is, in a way, a good protection against over-writing this
# variable with a value that has a different type.

# We can experiment with over-writing `two` -- in order to do so safely, we will
# use a `try` block, which we will look at in a few more modules. For now, just
# trust us.

try
    two = 2
catch err
    @warn "I cannot perform this operation"
else
    @info "The variable two is now $(two)"
end

# Why is this working? Well, let's have a look at the type of `two` now:

typeof(two)

# Because it is possible to turn `2` into `2.0`, *Julia* will do it here, and
# the type annotation (`two` must be a `Float64`) is still satisfied. What if
# instead of 2, we try to store $2i+0$ (a complex number)?

try
    two = 2im + 0
catch err
    @warn "I cannot perform this operation"
else
    @info "The variable two is now $(two)"
end

# This time, the assignment is failing because there is no automatic way to turn
# a complex number into a floating point number. Therefore, storing $2i+0$ in
# `two` would break the requirement that `two` is of the `Float64` type!

