---
title: Understanding dispatch
weight: 2
category: 03-functions
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
Main.##406.Rock
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
function move(::T, ::T) where {T<:Strategy}
    return (0, 0)
end
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

