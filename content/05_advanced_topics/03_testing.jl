# ---
# title: Testing functions
# status: alpha
# ---

#-

using Test

#-

@test isequal(4)(2+2)

#-

@test 2+2 isa typeof(2)
