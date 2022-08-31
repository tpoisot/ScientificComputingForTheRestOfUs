# ---
# title: Testing functions
# status: alpha
# ---

# In this module, we will explore the `Test` package, which allows to
# programmatically test the behavior of a function. We will see how testing can
# bring us closer to being confident in our code.

# <!--more-->

using Test

#-

@test isequal(4)(2+2)

#-

@test 2+2 isa typeof(2)
