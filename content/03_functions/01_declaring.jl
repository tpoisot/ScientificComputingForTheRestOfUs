# ---
# title: Declaring functions
# weight: 1
# ---

# Everything should be a function. Everything. Especially in *Julia*, for
# performance related reasons that are far beyond the scope of this material. So
# one of the first, most significant piece of knowledge to acquire is: how do I
# declare a function?

# Let us start with a function that says (or rather, `print`) `"Hello"`:

function hello()
    print("Hello")
end

# This is a `generic function` with `1 method`, and for now we will ignore this
# information (and get back to it only when discussing dispatch). We can call
# our function by using its name:

hello()

# Fantastic. Let's get something out of the way. We do not need to write
# `function` and `end`, as we can simply get the same effect with a one-liner
# function:

hello() = print("Hello")
hello()

# This is, at times, a little more convenient. For example, we can define the
# logit and logistic functions on one line (each!):

logistic(x) = 1.0 / (1.0 + exp(-x))

#-

logit(p) = log(p / (1.0 - p))

# Hey there's something new! We have added `x` (and `p`) in the declaration of
# the function.