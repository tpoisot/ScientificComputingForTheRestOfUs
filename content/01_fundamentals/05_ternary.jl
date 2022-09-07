# ---
# title: The ternary operator
# status: alpha
# ---

# In this module, we will look at the "ternary operator", a very efficient
# shortcut to perform a logical test in a single line. This is a construct we
# will use quite a lot to express a conditional expression in a single line.

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

x = rand() < 0.5 ? 0.25 : 0.75

# This is called a ternary operator. The basic syntax is `condition ? if true :
# if false`. It fits in a single line, and we can handle both cases. Note that
# the cases are *returned* as a function of whether the condition is satisfied,
# which is a way to rapidly fill a variable.

# Another source of efficiency is that both sides of the `:` are *not*
# evaluated, unlike other languages:

true ? print(2) : print(3)

# !!!INFO In fact, using the `Meta.@lower` macro, we can see that this is
# converted to a `goto` statement, but this is a little beyond the scope of an
# introduction module.

# In fact, we can use this to build a very naive function that reproduces the
# Kronecker $\delta$ function: it returns 1 if the two inputs are equal, and 0
# if they are not.

# !!!INFO Of course, if we wanted to do this properly, we could remember that
# `false` *is* 0 and `true` *is* 1, and our function is not necessary.
# Nevertheless, this is an interesting example.

