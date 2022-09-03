# ---
# title: Error handling with try
# status: beta
# ---

# In previous modules, we have used a `try`/`catch` statement. In this module,
# we will go into some detail about what it means, and how to use them to write
# code that handles errors gracefully.

# <!--more-->

# !!!OPINION A very important design principle of this course is that we write
# and demonstrate code that will *not* fail. In practice, mistakes happen, and
# there are errors we cannot fully anticipate. But we are convinced that anytime
# we think an error can happen, it must be handled.

# Let us start with a good example - we can try to get the natural log of
# negative two, which is quite obviously not going to work. A really nice thing
# with *Julia* errors is that they all have a type:

try
    log(-2)
catch error
    @info "I caught a $(typeof(error))"
end

# Not only do they have a type, they have a type hierarchy!

DomainError <: Exception

# Errors are nested under `Exception`s, which is a very nice way to think about
# them -- it's not that something went wrong (it did!), but something went wrong
# that we did not anticipate in our code. It sounds trivial, but the point of
# code is to have it run without erroring: first by ensuring that we run things
# that make sense, and second by handling exceptions appropriately.

# We can use the type system to dispatch on exceptions. To illustrate this, we
# can write a function whose sole purpose is to generate exceptions.

function oops()
    rand() < 0.5 && (DimensionMismatch("oh noes") |> throw)
    rand() < 0.5 && (DomainError("lol wut?") |> throw)
    rand() < 0.5 && (MethodError("sike you thought") |> throw)
    return ErrorException("oopsie") |> throw
end

# !!!WARNING This is actually terrible practice. Just awful. The worst. All of
# these exception types are not just ways to halt the execution of your program,
# but ways to communicate what went wrong to your user. Do not throw a random
# exception, and remember that you can define your own!

# This has 50% chance of returning a `DimensionMismatch`, then a 50% chance of a
# `DomainError`, then a 50% chance of of `MethodError`, then in anycase an
# `ExceptionError`. Note that exceptions are not passed throught the `return`
# keyword, but throught the `throw` function -- this is probably a good idea to
# have a look at the documentation for `throw` when you are done reading this
# module.

# Because our function will throw an exception, we will wrap it in a
# `try`/`catch` block:

try
    oops()
catch err
    @info "I caught a $(typeof(err))"
end

# It's all well and good, but we want to handle each type of error separately!
# We can write a function call `oops_handler`, and have it do different things
# for different error messages:

oops_handler(::E) where {E <: Exception} = "I caught an error of the type $(E)"

# !!!INFO In practice, the `oops_handler` would do much more interesting signs.
# For example, it can try to fix the issue in the original function, or exit a
# loop, or an infinite number of variations of things

try
    oops()
catch err
    oops_handler(err)
end

# Because this is all dispatch, we can refine the behavior of the `oops_handler`
# based on different types of errors:

oops_handler(::DimensionMismatch) = "The dimensions of your input arguments are wrong"
oops_handler(::MethodError) = "There is no available method here"
oops_handler(::DomainError) = "The input value is outside the correct domain"

# Let's now do a simple loop, and see what we get!

for i in 1:10
    try
        oops()
    catch err
        @info oops_handler(err)
    end
end

# Notice that our code is able to handle different types of exceptions, thanks
# to the magic of dispatch and the use of `try`/`catch`.

# But what if the code worked? This might seem like a stretch of the
# imagination, but it happens! And `try`/`catch` blocks can very easily be
# extended to accomodate this uncommon situation. Enter the `finally` keyword,
# and the `else` keyword we already encountered when talking about Booleans
# values.

# Let's try with something that is going to throw an exception, because we make
# it:

try
    throw(ErrorException("This is not going to work"))
catch error
    @info "I got a $(typeof(error))"
else
    @info "This part runs because there is no exception!"
finally
    @info "This part will always run no matter what!"
end

# And now, compare with something that is not throwing an exception:

try
    true
catch error
    @info "I got a $(typeof(error))"
else
    @info "This part runs because there is no exception!"
finally
    @info "This part will always run no matter what!"
end

# The `else` and `finally` keywords are very important! The content of the
# `else` block will *only* run if no exception was thrown, and the content of
# the `finally` block will run no matter what happens. Here is a good use-case:

# ~~~
# try
#   run_my_model()
# catch err
#   handle_my_errors(err)
# else
#   plot_my_results()
# finally
#   remove_temporary_files()
# end
# ~~~

# In a lot of cases, we do not want the analysis to progress until the previous
# steps are done well -- this is a situation where `try` works perfectly, with
# the added benefit of easily letting us specify what we want to do for each
# type of exception, in case of a success, in case of a failure, and regardless
# of the outcome. The `try`/`catch` construct is very powerful (and very
# under-used by novice programmers!).