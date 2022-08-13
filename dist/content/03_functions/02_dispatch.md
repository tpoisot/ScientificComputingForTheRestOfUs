---
title: Understanding dispatch
weight: 2
---

The point of this module is to understand *dispatch*, which is to say, the way
the correct method is called based on the arguments; we will also see how to
use it to write the least possible amount of code!

In order to illustrate some fundamental mechanisms, we will build a
rock/paper/scissors game, with a twist: it will rely *entirely* on types and
dispatch -- there will be no `if`, and most of the functions will very likely
be one-liners with almost no code at all.

TK

````julia
abstract type Strategy end
````

Based on this, we can define a series of possible moves, which are *sub-types*
of `Strategy`:

````julia
struct Rock <: Strategy end
struct Paper <: Strategy end
struct Scissors <: Strategy end
````

Let's have a look at these types. First, what is the type of `Rock`?

````julia
typeof(Rock)
````

````
DataType
````

This shows that `Rock` is indeed a type (a `DataType`, specifically). We can
further check that it is a sub-type of `Strategy`:

````julia
Rock <: Strategy
````

````
true
````

The `<:` operator is an interesting one -- it reads as "is a subtype of", and
is going to be very helpful to limit which methods are called. Finally, we can
check that we are able to *create* objects of the type `Rock`, using the
`Rock()` method (or constructor):

````julia
typeof(Rock())
````

````
Main.##375.Rock
````

Let's finally check that an instance of `Rock` is indeed a `Rock`, but is also
a `Strategy`:

````julia
isa(Rock(), Rock)
````

````
true
````

````julia
isa(Rock(), Strategy)
````

````
true
````

Surprisingly, this is enough to build our rock/papers/scissors game. We will
build the most basic components: a function called `move`, which is going to
take two arguments (the `Strategy` for each player), and returning the score
of each player in a tuple.

To keep things simple, we will start with the situation in which both players
use the same strategy. We can think about this situation as the following
question: "what are the types of the arguments corresponding to two identical
strategies?". The two arguments will have the same type (`T`), and this type
is a `Strategy` (`T <: Strategy`).

We can write the function this way:

````julia
move(::T, ::T) where {T<:Strategy} = (0, 0)
````

````
move (generic function with 1 method)
````

**Wait**! Where are the arguments names? Well, they are not here because we do
not *need* them. All the information is given by the types, and so instead of
writing `p1::T, p2::T`, we can omit the names of the arguments. It's nice,
because it is very concise.

But let's scroll back a little bit: when we declared the function, the output
we got from *Julia* was

~~~
move (generic function with 1 method)
~~~

Understanding the difference between a *function* and a *method* is going to
be crucial moving forward. A *function* is the *name* of a family of methods.
For example, the `sin` function has many methods:

````julia
sin
````

````
sin (generic function with 13 methods)
````

You may list them with `methods(sin)` and see for yourself why there are many
different ones. If you don't want to do this, the summarized version is: each
*method* is the most optimized code given the *type* of the arguments given to
the *function*. **This is dispatch**.

Now that we have established what dispatch is, let's run a little bit of code:

````julia
move(Rock(), Rock())
````

````
(0, 0)
````

Note that we use `Rock()`, not `Rock`, and calling `typeof()` on both versions
should clear up why.

````julia
move(Paper(), Paper())
````

````
(0, 0)
````

At this point, it is time to try something that will not work, because we have
not written a method for it. As we are about to (potentially) fail, we might
as so do it *gracefully*, and use a `try`/`catch` block. What we are going to
attempt is to play a move of paper against rock. First, let's ensure it does
not work:

````julia
try
    move(Paper(), Rock())
catch error
    msg = """There was a $(typeof(error)):
    $(error)
    """
    print(msg)
end
````

````
There was a MethodError:
MethodError(Main.##375.move, (Main.##375.Paper(), Main.##375.Rock()), 0x0000000000007bf2)

````

Succes! We had a `MethodError` (note that in *Julia*, even errors have types,
so you can handle different errors differently). Why didn't it work? Well, we
do not have a method that would be dispatched to when the arguments are of
types, respectively, `Paper` and `Rock`. Thankfully, writing one is easy:

````julia
move(::Paper, ::Rock) = (1,0)
````

````
move (generic function with 2 methods)
````

Note that `move` is *still* a `generic function`, but it has two *methods*. We
can try the move again:

````julia
move(Paper(), Rock())
````

````
(1, 0)
````

In order to complete the game, we will add two other moves:

````julia
move(::Scissors, ::Paper) = (1, 0)
move(::Rock, ::Scissors) = (1, 0)
````

````
move (generic function with 4 methods)
````

This will take care of the cases where *player 1* wins. Note that we are still
not using any argument name, as we care only about the types. But what if
*player 2* were to win? We could define a method for `move(::Rock, ::Paper)`,
and then two additional methods for the other combinations, but there is a
more efficient way!

Dispatch (in *Julia*) goes from most specific to least specific. In fact, if
you use the `methods` function on a function, it will list the methods in
order of specificity:

````julia
methods(move)
````

````
# 4 methods for generic function "move":
[1] move(::Main.##375.Paper, ::Main.##375.Rock) in Main.##375 at /home/tpoisot/Teaching/ScientificComputingForTheRestOfUs/dist/content/03_functions/02_dispatch.md:1
[2] move(::Main.##375.Scissors, ::Main.##375.Paper) in Main.##375 at /home/tpoisot/Teaching/ScientificComputingForTheRestOfUs/dist/content/03_functions/02_dispatch.md:1
[3] move(::Main.##375.Rock, ::Main.##375.Scissors) in Main.##375 at /home/tpoisot/Teaching/ScientificComputingForTheRestOfUs/dist/content/03_functions/02_dispatch.md:2
[4] move(::T, ::T) where T<:Main.##375.Strategy in Main.##375 at /home/tpoisot/Teaching/ScientificComputingForTheRestOfUs/dist/content/03_functions/02_dispatch.md:1
````

The problem we want to solve becomes, in plain English, "the move has two
types for which we do not have a specialized method, but who are not the same
type, and then return the result in the correct order". In plain *Julia*, this
becomes:

````julia
move(p1::S1, p2::S2) where {S1 <: Strategy, S2 <: Strategy} = reverse(move(p2, p1))
````

````
move (generic function with 5 methods)
````

Why will it work? If you look at the updated output of `methods`, you will see
that this method has a *lower* specificity than the specialized methods, or
the method with the same types: it will only be dispatched to as a last
resort!

Let's now check that our program works:

````julia
valid_moves = [Rock(), Paper(), Scissors()]

for player1 in valid_moves
    for player2 in valid_moves
        println("$(player1) \t $(player2)\t→\t$(move(player1, player2))")
    end
end
````

````
Main.##375.Rock() 	 Main.##375.Rock()	→	(0, 0)
Main.##375.Rock() 	 Main.##375.Paper()	→	(0, 1)
Main.##375.Rock() 	 Main.##375.Scissors()	→	(1, 0)
Main.##375.Paper() 	 Main.##375.Rock()	→	(1, 0)
Main.##375.Paper() 	 Main.##375.Paper()	→	(0, 0)
Main.##375.Paper() 	 Main.##375.Scissors()	→	(0, 1)
Main.##375.Scissors() 	 Main.##375.Rock()	→	(0, 1)
Main.##375.Scissors() 	 Main.##375.Paper()	→	(1, 0)
Main.##375.Scissors() 	 Main.##375.Scissors()	→	(0, 0)

````

This is, in a nutshell, why understanding dispatch is very useful. Our
rock/paper/scissors game fits in nine lines of code: four for the types
definitions, and five for the methods to dispatch correctly. A useful thought
experiment would be to think about the code it would take to write code with
the same output, but using only `if` statements: it would be longer, and
arguably harder to maintain.
