# ---
# title: Short-circuit Boolean operations
# status: beta
# ---

# In the [previous module][bool], we have introduce important notions about
# Boolean values. In this module, we will expand upon this knowledge in ways
# that will enable us to be more expressive with the code we write.

# [bool]: {{< ref "01_fundamentals/03_booleans.md" >}}

# <!--more-->

# As part of the previous module, we introduced `|` and `&` as the *or* and
# *and* operands, respectively. There was a slight omission in this approach, as
# both of them have a closely related variant, `||` and `&&`.

# The difference between `|` and `||` is particularly confusing, and is related
# to the fact that one is a *short-circuit* version of the other. One way to
# figure out what this means is to experiment with a construct where we will put
# a Boolean value first, then a Boolean operator, and finally something
# different, like for example `"Hi!"`.

# If you look at the documentation for `|` and `||`, you will see that `|` is
# the bit-wise operator; in other words, it will need to be surrounded by
# Boolean values on both sides. The `||` is the *short-circuit* version of the
# operator, which has the very nice property that its evaluation stops as soon
# as it can determine the answer with certainty. We can exploit this.s

# Let's try a simple case first:

true || "Hi!"

# This returns `true` because the left side is `true` and the operator is `||`
# (*or*). No matter what the right hand is, there is no need to evaluate it
# because `true |` anything is `true`. The operator serves as a sort of circuit
# breaker.

# But what is the initial element is `false`? In this case, we need to know the
# right side, because `false |` anything is not something we can answer
# directly; therefore, *Julia* will have to evaluate the right hand side.

false || "Hi!"

# Interesting..! In this case, the output is not a Boolean, but a `String`:
# `"Hi!"`. In the process of evaluating our code, we have managed to execute an
# operation.s

# The short-circuit *and* works in the exact same way (well, the exact opposite,
# but still):

false && "Hi!"

# This returns `false` directly because there is no right hand side value that
# could possibly change the result of an operation, and so `&&` serves as a
# circuit breaker. But if we have a `true` statement next:

true && "Hi!"

# In this case, we get the right hand side executed!

# This is the basis of a common (and very expressive) design pattern -- in the
# same line, we can specify a check and an action. One of our favorite ways to
# use it is to check if a path exists, and if not create it:

ispath("foo") || mkdir("foo")

# Let's be clean and remove this path, but only if it exists:s

ispath("foo") && rm("foo")

# Additional uses of this patterns include throwing exceptions, exiting out of
# loops early, returning early, etc., and it will see *a lot* of use in this
# material (because it is concise and elegant).