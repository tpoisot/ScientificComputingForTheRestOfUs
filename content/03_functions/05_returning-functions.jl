# ---
# title: Returning functions
# weight: 5
# ---

# *Julia* has a very interesting function called `isequal`. Let's see how it
# works (don't forget to look at `?isequal` for more):

is_two = isequal(2.0)

# When we call this function, we get back *another function*. We can apply this
# new function to a few arguments:

is_two(π)

#-

is_two(2)

#-

# This is actually rather helpful! In this module, we will illustrate how
# returning functions works, and see a simple example from population dynamics.

