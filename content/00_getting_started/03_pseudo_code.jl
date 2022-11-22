# ---
# title: Pseudo-code
# status: rc
# ---

# To facilitate the transition between diagram and code, one important step is
# to write *pseudo-code*, *i.e.* text that looks reasonably like code, but is
# not. This pseudo-code will not help the computer think about our problem,
# but it might help *us* think about the problem in ways that will make the
# actual programming easier.

# <!--more-->

# !!! OPINION Pseudo-code is mostly useful when it comes to working on a single
# function. The overall structure of the project can be done as a flowchart, and
# then each function can be written as pseudo-code. This is, in fact, a really
# good exercise to try with your own projects.

# Let us try with an example - we want to sort numbers. We will write
# pseudo-code for a very, *very* inefficient algorithm:

# ~~~
# let X be a list of numbers
# let Y be an empty list of numbers
# 
# as long as X still has elements in it
#     let x be the minimum of X
#     add x to Y
#     remove x from X
# 
# return Y
# ~~~

# This is, essentially, what *pseudo-code* is: a way to explain in your own words
# what the function should do. This can be translated line-by-line into code, but
# this is rarely a good idea. The best way to represent an idea with code is rarely
# the same as the best way to represent it as pseudo-code.

# Yet there are important lessons in this piece of pseudo-code. First, we know that we will
# need two *variables* (`X` and `Y`), a way to find `x` which is going to be the smallest
# value in `X`, and ways to add and remove elements from lists. Although this is not a 
# full program yet, this is helpful to guide our search for information in, *e.g.*,
# *Julia*'s documentation! We will also need to perform a series of steps `as long as`
# some condition is satisfied, which means that we will have to think about iteration and
# conditionals and all that.

# The purpose of this material is to give you the basic bits of information to write this
# function, and much more!

# To give you a little taste, we can write the *Julia* code:

X = rand(1:5, 12)
Y = empty(X)

while !(isempty(X))
    x, i = findmin(X)
    push!(Y, x)
    deleteat!(X, i)
end

Y'

# !!!INFO At this point, it is *absolutely* normal to not understand the code. Especially if
# you have little programming experience! After completing the first two or three sections
# of this material, you should be able to revisit it and understand what is going on, and
# even suggest an improvement to it! This will take time, and we will go through all the
# steps.

# Pseudo-code is also useful to reason about the structure of the program you
# are about to start writing. A good example is when you do not know which functions
# to use (or write!) yet, or whether your functions are appropriately sized; if the
# pseudo-code is getting too long, it is a good sign that you may start thinking
# about smaller functions, and break down your problem into further (smaller) pieces.
