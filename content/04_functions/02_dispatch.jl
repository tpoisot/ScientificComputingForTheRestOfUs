# ---
# title: Understanding dispatch
# status: release
# ---

# The point of this module is to understand *dispatch*, which is to say, the way
# the correct method is called based on the arguments; we will also see how to
# use it to write the least possible amount of code!

# In order to illustrate some fundamental mechanisms, we will build a
# rock/paper/scissors game, with a twist: it will rely *entirely* on types and
# dispatch -- there will be no `if`, and most of the functions will very likely
# be one-liners with almost no code at all.

# TK

abstract type Strategy end

# Based on this, we can define a series of possible moves, which are *sub-types*
# of `Strategy`:

struct Rock <: Strategy end
struct Paper <: Strategy end
struct Scissors <: Strategy end

# Let's have a look at these types. First, what is the type of `Rock`?

typeof(Rock)

# This shows that `Rock` is indeed a type (a `DataType`, specifically). We can
# further check that it is a sub-type of `Strategy`:

Rock <: Strategy

# The `<:` operator is an interesting one -- it reads as "is a subtype of", and
# is going to be very helpful to limit which methods are called. Finally, we can
# check that we are able to *create* objects of the type `Rock`, using the
# `Rock()` method (or constructor):

typeof(Rock())

# Let's finally check that an instance of `Rock` is indeed a `Rock`, but is also
# a `Strategy`:

isa(Rock(), Rock)

#-

isa(Rock(), Strategy)

# Surprisingly, this is enough to build our rock/papers/scissors game. We will
# build the most basic components: a function called `move`, which is going to
# take two arguments (the `Strategy` for each player), and returning the score
# of each player in a tuple.

# To keep things simple, we will start with the situation in which both players
# use the same strategy. We can think about this situation as the following
# question: "what are the types of the arguments corresponding to two identical
# strategies?". The two arguments will have the same type (`T`), and this type
# is a `Strategy` (`T <: Strategy`).

# We can write the function this way:

move(::T, ::T) where {T<:Strategy} = (0, 0)

# **Wait**! Where are the arguments names? Well, they are not here because we do
# not *need* them. All the information is given by the types, and so instead of
# writing `p1::T, p2::T`, we can omit the names of the arguments. It's nice,
# because it is very concise.

# But let's scroll back a little bit: when we declared the function, the output
# we got from *Julia* was 

# ~~~
# move (generic function with 1 method)
# ~~~

# Understanding the difference between a *function* and a *method* is going to
# be crucial moving forward. A *function* is the *name* of a family of methods.
# For example, the `sin` function has many methods:

sin

# You may list them with `methods(sin)` and see for yourself why there are many
# different ones. If you don't want to do this, the summarized version is: each
# *method* is the most optimized code given the *type* of the arguments given to
# the *function*. **This is dispatch**.

# Now that we have established what dispatch is, let's run a little bit of code:

move(Rock(), Rock())

# Note that we use `Rock()`, not `Rock`, and calling `typeof()` on both versions
# should clear up why. 

move(Paper(), Paper())

# At this point, it is time to try something that will not work, because we have
# not written a method for it. As we are about to (potentially) fail, we might
# as so do it *gracefully*, and use a `try`/`catch` block. What we are going to
# attempt is to play a move of paper against rock. First, let's ensure it does
# not work:

try
    move(Paper(), Rock())
catch error
    msg = """There was a $(typeof(error)):
    $(error)
    """
    print(msg)
end

# Succes! We had a `MethodError` (note that in *Julia*, even errors have types,
# so you can handle different errors differently). Why didn't it work? Well, we
# do not have a method that would be dispatched to when the arguments are of
# types, respectively, `Paper` and `Rock`. Thankfully, writing one is easy:

move(::Paper, ::Rock) = (1,0)

# Note that `move` is *still* a `generic function`, but it has two *methods*. We
# can try the move again:

move(Paper(), Rock())

# In order to complete the game, we will add two other moves:

move(::Scissors, ::Paper) = (1, 0)
move(::Rock, ::Scissors) = (1, 0)

# This will take care of the cases where *player 1* wins. Note that we are still
# not using any argument name, as we care only about the types. But what if
# *player 2* were to win? We could define a method for `move(::Rock, ::Paper)`,
# and then two additional methods for the other combinations, but there is a
# more efficient way!

# Dispatch (in *Julia*) goes from most specific to least specific. In fact, if
# you use the `methods` function on a function, it will list the methods in
# order of specificity:

methods(move)

# The problem we want to solve becomes, in plain English, "the move has two
# types for which we do not have a specialized method, but who are not the same
# type, and then return the result in the correct order". In plain *Julia*, this
# becomes:

move(p1::S1, p2::S2) where {S1 <: Strategy, S2 <: Strategy} = reverse(move(p2, p1))

# Why will it work? If you look at the updated output of `methods`, you will see
# that this method has a *lower* specificity than the specialized methods, or
# the method with the same types: it will only be dispatched to as a last
# resort!

# Let's now check that our program works:

valid_moves = [Rock(), Paper(), Scissors()]

for player1 in valid_moves
    for player2 in valid_moves
        println("$(player1) \t $(player2)\t→\t$(move(player1, player2))")
    end
end

# This is, in a nutshell, why understanding dispatch is very useful. Our
# rock/paper/scissors game fits in nine lines of code: four for the types
# definitions, and five for the methods to dispatch correctly. A useful thought
# experiment would be to think about the code it would take to write code with
# the same output, but using only `if` statements: it would be longer, and
# arguably harder to maintain.