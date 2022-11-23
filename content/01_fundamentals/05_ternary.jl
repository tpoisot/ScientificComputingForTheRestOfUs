# ---
# title: The ternary operator
# status: rc
# ---

# In this module, we will look at the "ternary operator", a very efficient
# shortcut to perform a logical test in a single line. This is a construct we
# will use quite a lot to express both possible outcomes of a conditional expression using
# a single line!

# <!--more-->

# Based on what we have seen in the previous modules, the way to store different
# values in a variable according to some condition we set would be to write
# something like:

x::Float64 = 0.0
if rand() < 0.5
    x = 0.25
else
    x = 0.75
end

# In the words of Stephen King, "it goes somewhere, but it ain't, you know,
# *boss*". Thankfully there is a way to simplify this expression greatly, and it
# does of course involve learning some more operators.

# But before we start doing this, as a little bit of recall from the previous module, note
# that we can do the same thing with short-circuit operators:

x = 0.75
rand() < 0.5 && (x = 0.25)

# But there is a reason why we don't do everything we technically can, and in this instance,
# the reason is that this notation is absolutely vile. So we will address our problem in
# a more elegant way, using the *ternary operator*:

x = rand() < 0.5 ? 0.25 : 0.75

# This little `=`/`?`/`:` sequence is called a ternary operator. The basic syntax is `condition ? if true :
# if false`. It fits in a single line, and we can handle both cases. Note that
# the cases are *returned* as a function of whether the condition is satisfied,
# which is a way to rapidly give a value to a variable.

# Another source of efficiency is that both sides of the `:` are *not*
# evaluated, unlike other languages:

true ? print(2) : print(3)

# We can check this using the `@lower` macro from {{Meta}}: it is translating
# *Julia* code into something of a lower-level, and is an interesting
# opportunity to check what is going on "under the hood":

Meta.@lower true ? cos(4) : sin(3)

# We see in the output above that the *operations* (like `cos(4)`) have *not*
# been expanded yet -- the ternary operator is "pointing" *Julia* towards the
# right branch.

# We can use the ternary operator as the most basic ingredient in a very naive
# function that reproduces the Kronecker $\delta$ function: it returns 1 if the
# two inputs are equal, and 0 if they are not. This function is generally
# applied to non-negative integers.

# !!!INFO Of course, if we wanted to do this properly, we could remember that
# `false` *is* 0 and `true` *is* 1, and our function is not necessary.
# Nevertheless, this is an interesting example to write from scratch:

function δ(i::T, j::T) where {T <: Integer}
    return i == j ? one(T) : zero(T)
end

# !!!WARNING We have not yet covered how to declare functions, and how to handle the types
# of arguments. This will happen later in the material. For now, just trust us when we say
# that all of the bits that aren't the ternary operator are required for a function to run.

# We can see what our function would do when applied to actual numbers:

for i in 1:3, j in 1:3
    @info "δ($(i), $(j)) = $(δ(i, j))"
end
