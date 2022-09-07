# ---
# title: Finding things in arrays
# status: beta
# ---

# In this module, we will see how to locate interesting values in collections,
# and how to extract and test the existence of some of these values. This is
# important knowledge in order to build more advanced programs, and we will put
# it in action in the following section.

# <!--more-->

# During the module on indexing, we thought about getting the first and last
# position of an array using `begin` and `end`. *Julia* offers a `first` and a
# `last` function to do just this:

first(1:3)

#-

last(1:3)

# These functions are extremely useful when, for example, we are interesting in
# the starting or ending position of a collection. But what if we want to do
# more advanced, condition-based finding of elements?

# Before we do this, let's ask a very important question: given a test we can
# apply to each element (*i.e.* a function taking an element of the collection
# and returning a Boolean), how many elements satisfy it? This is usually done
# with the `count` function:

count(isodd, 1:5)

# This gives us the number of odd numbers between 1 and 5. This is an important
# information because, when we want to find elements according to a condition,
# there is always a chance that no element will match this condition! For
# example, we can count the number of elements larger than 10 in between 1 and
# 5:

count(x -> x > 10, 1:5)

# We can use `count` to decide whether we should start moving forward with a
# search. But how, exactly, do searches work?

# It's complicated. Or rather, it's very specialized, and there are a number of
# ways *Julia* handles searches, depending on what you are actually after. Let's
# say you have a random matrix, and want to know where the largest value is:

max_value, position_max = findmax(rand(10, 10))

# This similarly works for the smallest value; we can also apply this to a data
# structure with more than two dimensions:

min_value, position_min = findmin(rand(10, 10, 10))

# Note that the `position_min` output is now a `CartesianIndex` with *three*
# dimensions, because we are looking inside a random *cube*. By contrast,
# working on a vector will return the linear index of the matched position:

findmax(rand(10))

# There are more general functions we can use to search for anything in a
# collection. For example, let's create a random data cube:

R = rand(3, 3, 3)

# We might want to know where the numbers between 0.5 and 0.6 are located:

findall(x -> 0.5 <= x <= 0.6, R)

# This is a vector of `CartesianIndex`, with the correct number of dimensions.
# There are two noteworthy variants to `findall`: `findfirst` and `findlast`.
# They return, respectively, the first and last position matching the condition:

findfirst(x -> 0.5 <= x <= 0.6, R)

#-

findlast(x -> 0.5 <= x <= 0.6, R)

# We can fine-tune the behavior of a search a lot more, using the `findnext` and
# `findprev` function. For example, let's say that we have a time series, and
# want to skip the first 10 values:

ts = rand(200)
findnext(x -> 0.5 <= x <= 0.6, ts, 10)

# Or we can look for a matching value immediately *before* this point:

findprev(x -> 0.5 <= x <= 0.6, ts, 10)

# Usng `findprev` and `findnext` can let you be very efficient about iteration
# based on criteria, simply by replacing the index of the match in your next
# call to `findprev`/`findnext`. This is useful when you do not want to collect
# all of the values. For example, we may want to be interested in getting all of
# the values between 0.5 and 0.6 after then tenth position, but have *at least*
# 10 timepoints between each value we collect.

# If there is no more entries left in the collection, `findnext` (and
# `findprev`) will return `nothing`, which makes it easy to break out of the
# loop (as we have seen in a previous module):

position = findnext(x -> 0.5 <= x <= 0.6, ts, 10)
@info position
while ~isnothing(findnext(x -> 0.5 <= x <= 0.6, ts, position + 10))
    global position
    position = findnext(x -> 0.5 <= x <= 0.6, ts, position + 10)
    @info position
end

# But wait... Things have been going a little bit too well so far, and we have
# avoided the situation where we still haven't found what we're looking for. So
# let's create a situation where there is no match:

findall(x -> x >= 10, 1:5)

# This collection is *empty*, and we can test it with `isempty`:

isempty(findall(x -> x >= 10, 1:5))

# This is usually something we can use to decide to break out of a loop, or
# maybe throw an exception. Note that this is equivalent to using:

iszero(count(x -> x >= 10, 1:5))

# There are sometimes more than a single idiomatic way to express an idea.

# Another series of related features is the ability to manipulate the output of
# these functions (or indeed, of any array, but this is most closely related to
# working on the output of searches).

# The first functions are `something` `coalesce` -- in essence, they return the
# first value that is not `nothing` or not `missing`.

# !!!OPINION We think that *Julia*'s insistence of making a difference between
# `nothing`, `missing`, and `NaN` is one of the language's best features,
# especially for data analysis.

# Let's see them in action - we will create a mock function to return `nothing`
# most of the time, and a random number between 1 and 10 some of the time:

nothingator() = rand() < 0.9 ? nothing : rand(1:10)
series = [nothingator() for i in 1:10]
series[rand(3:length(series))] = rand(1:10) # We have at least one non-nothing value

#- 

something(series...)

# !!!WARNING These functions *must* be called on a splatted collection; if not,
# they will simply return the collection, because it isn't `nothing` or
# `missing`.

# In brief, `something` and `coalesce` are extremely useful when you can
# anticipate that your collection may have some `missing` or `nothing` values,
# but still want to get a result out of it.

# Sometimes, we need a little more control, namely when we know that we should
# only get a single result. For example, we can write our own `findmax`
# function:

series = rand(10)
findall(x -> x == maximum(series), series)

# How do we get this value out of the vector?

only(findall(x -> x == maximum(series), series))

# Why use `only` and not `first` here? The answer is: `only` will throw an
# exception if there are not exactly one single element in the collection on
# which it is called!

# Before we take this module to a close, there are two additional functions
# worth knowing about:

any([true false true])

#-

any([false false false])

#- 

all([true false true])

#-

all([true true true])

# The `any` function will return `true` if at least one of the elements is
# `true`, and `all` will check that *all* elements are `true`. By remembering
# our Boolean operations *and* the way `reduce` works, we can think of these
# functions as

(x) -> reduce(|, x)

# for `any`, and 

(x) -> reduce(&, x)

# for `all`.

# The concepts introduced in this module are very helpful to design code that
# look for specific information in a flexible way. This will help be more
# efficient, by writing less code, and combining a few simple ingredients to
# safely get to the information we need.