# ---
# title: A gentle introduction to for loops
# status: rc
# ---

# Oh no. Oh no no no. This is *not* a fun module. This will not be pleasant. But
# this will, very much, be necessary and incredibly empowering. Sit down, buckle
# up, we're about to see what loops do.

# <!--more-->

# Iteration is one of the most central, most useful, most confusing concepts
# there is. But without it, there is little we can do that is useful or fun. The
# one and only redeeming feature of iteration is that if you understand its most
# basic example, you have actually understood all of the more complicated ways
# to iterate. The point of this module is to introduce the way *Julia* thinks
# about iteration, and to show as many examples as possible.

# Let us start with the simplest possible loop:

for i in [1, 2, 3]
    @info "The value of i is $(i)"
end

# That's it. That's all there is to know about iteration, but in order to move
# forward we need to study it; we need to study it like a kōan.

# Broken down into its most fundamental components, this loop (the structure
# that begins at `for` and ends at `end`) is simple.

# It has an opening statement: `for`. This means that we will repeat an action
# *for* multiple things. These multiple things are given on the first line:

# ~~~
# i in [1, 2, 3]
# ~~~

# But what does it means? This means that `i` will take all of the values in
# `[1, 2, 3]` *in turn*. Let's verbally expand this: `i` will be 1, then `i`
# will be 2, then `i` will be 3. But not everywhere! No, `i` will only have
# these values *inside* the loop. So `i` has no value, unless it takes one
# *inside* the loop.

# And so we need to go deeper: inside the loop. The inside of the loop is
# everything under the first line, and above the last line. If it sounds
# obvious, great. But it is important to emphasize this, as this is the space in
# which `i` *exists*, in the sense that this is the space where it has a value.

# Currently, the inside of our loop has a single instruction: we show a string
# that has the value of `i` using interpolation as we have seen in a previous
# module. But we can have a loop that is arbitratily complex:

for i in [1, 2, 3]
    if i == 2
        @info "The value of i is 2"
    else
        @info "The value of i isn't 2 (it's $(i))"
    end
end

# We have no asked for a full `if`/`else` statement within our loop. This result
# in a more complex output, but also increases what we call the [cyclomatic
# complexity][cyccom] of our program --- there are more "branches" we can
# explore. Think of a program as a "chose your own adventure" type book: we now
# have a lot more possible endings. 

# [cyccom]: https://en.wikipedia.org/wiki/Cyclomatic_complexity

# !!!OPINION A very crude yet surprisingly effective way to check the complexity
# of your code, is to look how far from the left margin your lines are starting.
# If they are very far away, it is time to take things out of loops or
# `if`/`else` statements and to write functions. We will explore how to write
# functions in the next section.

# We can put *whatever* we want in a loop. Even, of course, another loop!

for i in [1, 2, 3]
    @info "i = $(i)"
    for j in [1, 2, 3]
        @info "  j = $(j)  →  i×j = $(i*j)"
    end
end

# Notice that the value of `i` exists within its own loop, but also within the
# loop on `j`, because `j`'s loop exists within `i`'s. Where variables are
# usable is called scoping, and understanding scoping is something done through
# avid reading of the documentation. For now, it is safer to assume that the
# variables are not accessible outside their loop.

# !!!INFO Sometimes it pays to be able to access variables outside of their
# loop, or to modify variables external to the loop in the loop itself. In one
# of the next modules, we will show an example of how to do it, using the
# `global` annotation.

# Not only are the variables not accessibles, they are not *defined*. Using a
# `try` statement (it captures error, and we will take a deep dive into it very
# soon), we can verify this:

try
    j
catch error
    @info error
end

# The existence of `j` (and of `i`, as well) is limited to the inside of its
# loop.

# But what are loops good for? Now that we have established what loops are, the
# next module will deal with very powerful ways to iterate over objects, which
# is one of the most important things to do.