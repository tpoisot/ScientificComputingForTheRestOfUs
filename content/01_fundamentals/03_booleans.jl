# ---
# title: Introduction to Boolean values
# status: beta
# ---

# In this module, we will get acquainted with one of the most important type of
# variables: Boolean values. They represent values that are either `true` or
# `false`, which is a key element in a number of problems.

# <!--more-->

# Computer are *really* good at handling true/false statements. In fact, deep
# down, this is pretty much everything they know how to do. And so, getting
# familiar with the logic of Boolean values is extremely important. The good
# thing is that there are only two such values:

# The first is `true`:

true

# The second is `false`:

false

# Why are they so important? The main reason is that we can use them to build
# "branching paths" in our code, for example to perform different actions based
# on whether a condition is satisfied or not. This is usually done with an `if`
# block, like so:

if (true)
    @info "true"
end

# The part of the code in parenthesis is *set* to `true` here, but in practice,
# this would be the outcome of some sort of test or comparison. For example:

2 < 3

# Indeed, many functions return `true` or `false` when they perform a
# comparison, or look for a match, or generally bring a categorical answer to a
# question.

# The `if` blocks can have an `else` statement, which is executed only if the
# condition for the block is `false`. We can see it in action this way:

if (false)
    @info "true"
else
    @info "false"
end

# Because the test we do in the `if` block gives a result of `false`, *Julia*
# will run the content of the `else` block. This is useful to decide what to do
# based on a condition! For example, we may want to do something different based
# on whether a random number is smaller than a threshold:

if rand() < 0.5
    @info "x < .5"
else
    @info "x ≤ .5"
end

# The beauty of Boolean values is that they can be combined, because they obey
# some arithmetic rules, for example:

true + true

# Why? In brief, because `true` is given a value of `1`, and `false` a value of
# `0`. This is a good thing (we can build some semi-clever shortcuts around this
# property), but in practice we use specific operators for Boolean values: `!`,
# `|` and `&`.

# The *not* operation (`!`) is the easiest to grasp: in front of a Boolean
# value, it returns the other:

!true

# !!! OPINION The *not* operation can, *in some contexts only*, be noted with
# `~`. One of the ways we use `~` is to differentiate between the result of some
# mathematical operation (`!`), or some condition on *e.g.* the existence of a
# path (`~`). This is purely a notation convention, and it is entirely
# appropriate to forget about the existence of `~`.

# The next operation is *or* (`|`), which is `true` if at least one of the values is
# true:

true | false

# !!! INFO We encourage you to experiment with other combinations of values for
# each operator, and to notably change the order (*i.e.* `true | false` *v.*
# `false | true`).

# The last operation is *and* (`&`), which is `true` if *both* of the values are
# true:

true & false

# Compare to:

true & true

# We can nest these operations within parentheses. For example, the following
# statement is valid:

true & !(true | false)

# This evaluates as `false` because the *interior* of the parenthesis is `true`,
# so the *not* operation returns `false`, and then `true & false` is `false`.

# There is a lot more we can achieve with Boolean values, which we will cover in
# part in the next modules.s