# ---
# title: The ternary operator
# status: alpha
# ---

# In this module

# <!--more-->

# Based on what we have seen in the previous modules, the way to store different
# values in a variable would be to write something like

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

# This is call a ternary operator. The basic syntax is `condition ? if true : if
# false`. A single line, and we can handle both cases. This is obviously very
# efficient to set the value of a variable depending on a condition.

# Another source of efficiency is that both sides of the `:` are *not*
# evaluated, unlike other languages:

true ? print(2) : print(3)

# !!!INFO In fact, using the `Meta.@lower` macro, we can see that this is
# converted to a `goto` statement, but this is a little beyond the scope of an
# introduction module.

# TODO using Bool as index this way
