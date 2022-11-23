# ---
# title: Declaring functions
# status: rc
# ---

# Everything should be a function. Everything. Especially in *Julia*, for
# performance related reasons that are far beyond the scope of this material. So
# one of the first, most significant piece of knowledge to acquire is: how do I
# declare a function?

# <!--more-->

# Let us start with a function that says (or rather, `print`, as we call it)
# `"Hello"`:

function hello()
    return print("Hello")
end

# This is a `generic function` with `1 method`, and for now we will ignore this
# information (and get back to it only when discussing dispatch in the next
# module). We can call our function by using its name:

hello()

# Note that we use the parentheses (`()`) to make a difference between *talking
# about the function* (`hello`) and *executing the function* (`hello()`). There
# is nothing within the parentheses (yet), but without them, this would not
# work.

# Let's get something out of the way immediately. We do not need to write
# `function` and `end`, as we can simply get the same effect with a one-liner
# function:

hello_oneline() = print("Hello")
hello_oneline()

# This is, at times, a little more convenient. For example, we can define the
# logit and logistic functions on one line (each!):

logistic(x) = 1.0 / (1.0 + exp(-x))

#-

logit(p) = log(p / (1.0 - p))

# Hey there's something new! We have added `x` (and `p`) in the declaration of
# the function. What are these?

# They are called *arguments*. The arguments of a function (and their type!) are
# called its *signature* (there is a second part to the signature of a function,
# and we will get to it much, much later). Arguments are used to provide information about
# the outside world to a function.

# We can have many arguments to a function. For example, we can have a function
# called `linear`, with three arguments `x`, `m`, and `b`, which would return
# $mx+b$.

function linear(x, m, b)
    return m * x + b
end

# We can check that it works, maybe by testing different values of `x`, with the
# equation $0.2x+1.4$:

for x in 0.0:0.1:0.5
    @info linear(x, 0.2, 1.4)
end

# But how do we know that `m` is `0.2` and `b` is `1.4`? Well, these arguments
# are what we call *positional arguments*; they are read in the order where they
# are declared in the function signature.

# !!!WARNING The downside of positional arguments is that, of course, you need
# to pass them to the function in the right order, as specified by the
# signature. Thankfully, most decent text editors will provide you with information about
# the signature as you type the name of the function, so you do not need to have a complete
# mental model of your entire code every time you want to write something.

# One thing that the function cannot do yet is deal with us giving it no
# arguments. We can fix this by giving default values to some arguments. Note
# how we also change the name of the arguments to make it far more obvious what
# the function will do:

function linear(x, slope, intercept = 0.0)
    return slope * x + intercept
end

# !!!OPINION Using descriptive variable names is a *Good Thing*. Most text
# editors will auto-complete, but most importantly, it makes the code readable
# by humans. You will spend a lot of time dealing with your code, and it makes sense to have
# names that help you figure out what the *purpose* of the code is.

# One small (or, well, actually, gigantic) caveat with default values for
# positional arguments is that you *cannot* mix and match the order: the
# arguments with default values *must* come last.

# There is another way to declare a function, and we will make ample use of it
# in the next modules -- we can declare an *anonymous* function using a notation
# very close to the standard mathematical notation of declaring a function. For
# example:

f = (x) -> x^2

# The `->` symbol is called a *coding ligature*, and they are all the rage in programming
# fonts. In practice, this is simply the characters `-` `>`, but replaced with a nice little
# arrow. Font ligatures notwisthanding, this notations makes `f` a function returning the square of its argument:

f(2.0)

# !!!INFO Anonymous functions are more difficult to debug, optimize, and
# generally deal with than "proper" functions. That being said, they are very
# useful when you need a function somewhere, but do not feel like writing one
# for a single operation. We will make ample use of the when looking for stuff in things (or
# is it the other way around?).

# In this module, we went through the different ways to declare a function. In
# the following module, we will go in a lot of details into the dispatch
# mechanism, which is central to *Julia*'s philosophy.
