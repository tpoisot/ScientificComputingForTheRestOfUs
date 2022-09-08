# ---
# title: Types
# status: beta
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
# integers), but there's an infinite number of things between `2.0` and `3.0`.

# !!!WARNING The last point is not actually quite true. Because bits are finite
# resource, there is a finite number of steps between `2.0` and `3.0`, but we
# assume that it is large enough that we can cross our fingers and hope for the
# best.

# Why do types matter so much? In a sense, it is because they give the compiler
# (or the interpreter) some valuable information as to what it should expect. A
# feature of *Julia* is that we can annotate every variable (even non `const`)
# with a type, which will ensure that this variable will *never* store data from
# a different type.

two::Float64 = 2.0

#-

typeof(two)

# !!!OPINION The best practice is still to have be variables declared outside of
# functions be constants (*i.e.* `const a = 2.0`), because it gives more
# guarantees to the compiler and produces more efficient code. In a learning
# context, it does make things easier to not write everything within functions,
# and in this case annotating variables with a type provides some degree of
# protection as well as (modest) performance improvements.

# Why does this matter? The answer is simple -- as much as we like to think of
# 2.0+1 and 2.0+1.0 as the same operation, they are very different *to a
# computer*. Specifically, although they write almost the same, they turn out to
# be transformed to different code. In *Julia*, we can use the `@code_llvm`
# macro, from {{InteractiveUtils}}, to look at the way the code we write is
# transformed into compiler instructions. This sounds like a lot of information
# (and it is, although when optimizing code it is often required to use these
# macros), but this will nicely illustrate the possible issue.

# Let's start with the naive 2.0+1:

import InteractiveUtils
InteractiveUtils.@code_llvm two + 1

# As you see, there are a lot of lines about *promotion*, which is to say, about
# representing a variable as another type. What happens if we use 2.0+1.0 (note
# that we can generate a one of the correct type using the `one` function):

InteractiveUtils.@code_llvm two + one(two)

# The code is much smaller, and notably has *no promotion*. We have gained some
# valuable execution time by using two variables with correct types. Another
# useful macro is `@code_warntype`. For example, this will show the promotion
# step:

InteractiveUtils.@code_warntype 2 + 1.0

# But the correctly typed version will simply show the addition:

InteractiveUtils.@code_warntype 2.0 + 1.0

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
# the type annotation (`two` must be a `Float64`) is still satisfied.
# Transforming a variable into another type is something we can do manually (and
# in fact, have to do fairly frequently). For example, we might want to be very
# cheap (efficient) with memory, and represent `2.0` as an unsigned integer on 8
# bits:

convert(UInt8, two)

# But what if instead of 2, we try to store $2i+0$ (a complex number) in our
# original variable?

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

# Understanding types, which comes through a lot of practice, is key to
# accessing some of *Julia*'s most interesting features, notably the dispatch
# system. In the following modules, we will introduce a lot more types, and see
# how they are organized in types hierarchies, and how we can use this
# information to refine the behavior of our functions.