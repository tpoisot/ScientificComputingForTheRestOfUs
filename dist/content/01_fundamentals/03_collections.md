---
title: Iteration and indexing
weight: 3
---

## Introducing iteration

The `for` operation is one of the most common, but also one of the most
confusing, ways to tell a computer what to do. This is because it requires to
understand a lot of concepts at once; we will walk through each of them, get
confused a little bit, then get confused a lot, then get it.

But first! We will make sure that running this code multiple times will give
us the same result, by setting a seed for our random number generator:

````julia
using Random
Random.seed!(123456)
````

````
Random.TaskLocalRNG()
````

When talking about `for`, we usually talk about *for loops* or *iteration*.
This is because `for` lets you express the fact that you will perform an
operation on a (finite) set of elements. Let's start with a perfectly boring
yet somewhat instructive example. We can draw five random numbers between 0
and 1, using

````julia
rand(5)
````

````
5-element Vector{Float64}:
 0.3859098947362972
 0.1467242159945591
 0.9887363297442582
 0.06641191524107182
 0.8914839126552594
````

We might want to print *smol* when a number is lower or equal to 0.5, and
*chonky* in the rest of the situations. In a lot of programming examples, you
will see *foo* and *bar*. Why on Earth would we need to print *foo* and *bar*?
These are nonsense words used as placeholders by programmers. Of course, what
with us being all fancy, the term you should use instead of nonsense is
"metasyntactic variables". But polysyllabic nonsense is nonsense still, and so
we will use the far more dignified *smol* and *chonky*:

````julia
random_numbers = rand(5)

for random_number in random_numbers
  if random_number ≤ 0.5
    println("smol")
  else
    println("chonky")
  end
end
````

````
chonky
chonky
smol
smol
chonky

````

There is quite a lot happening here, so we will go line by line.

````julia
random_numbers = rand(5)
````

````
5-element Vector{Float64}:
 0.7646006338932442
 0.26348724853556216
 0.4049769471766548
 0.4000708410427055
 0.22652223432706042
````

First, we generate 5 random numbers, and put them in a variable called
`random_numbers`. It is always a good idea to give very explicit names to
variables. To begin with, most code editors will be very good at
autocompletion: type a few letters, then hit the *Tab* key, and you will see
the possible values.

Giving plural names to things that have multiple elements is also useful: it
helps to have code that reads like plain english. By contrast, variables whose
name is singular have a single value in them.

Now we can start the loop itself:

~~~
for random_number in random_numbers
    # Content of the loop
end
~~~

This line gives a simple instruction to your computer. Actually, no. It gives
a bunch of complex instructions to your computer, but it is an easy enough
instruction for us to *write*, and this is all that matters.

It goes something like this:

1. look at what is inside `random_numbers`
1. take the first value, and name it `random_number`
1. do whatever we tell you to do with this variable until you hit `end`
1. move on to the next value of `random_numbers`, and start again
1. when you have exhausted the values in `random_numbers`, continue to
   whatever is *after* the end of the loop

The *for* loop is one of the most difficult construct to understand, because
of this "change the content of the variable" trickery. We will have a few more
examples in this lesson.

The final lines we need to look at are in the *inside* of the loop -- we call
this inside thing *the body* for no particular reason.

```
if random_number ≤ 0.5
    println("smol")
else
    println("chonky")
end
```

These lines should be familiar to you now -- your computer will evaluate the
statement "`random_number` is lower than or equal to 0.5", and depending on
the truthiness of it, will print either *foo* or *bar*.

## Navigating arrays

Before we move on to a more interesting use of iteration, it is worth
understanding what exactly is in the `random_numbers` object. Let's display it
again:

````julia
random_numbers
````

````
5-element Vector{Float64}:
 0.7646006338932442
 0.26348724853556216
 0.4049769471766548
 0.4000708410427055
 0.22652223432706042
````

This type of object is an *array*; it may help to think of an array as a
shelf, in which every compartment can store one thing. You can have shelves
with a single row, a single column, or both rows and columns. In *Julia*,
arrays are by default columns, and this is important for applications like
linear algebra (they behave as vectors). Arrays have all sorts of properties,
the most important being their *length*:

````julia
length(random_numbers)
````

````
5
````

This tells us that our "shelf" has five compartments, so we can store five
things in it. We can also ask what its *size* is:

````julia
size(random_numbers)
````

````
(5,)
````

The output is `(5,)` - this is the computer way of telling us that this array
has 5 positions in its first *dimension*, and no positions in its second
dimension: this is a column with five rows. We can also access any *position*
we like; this is akin to asking "computer, give me the content of the 1st
compartment":

````julia
random_numbers[1]
````

````
0.7646006338932442
````

Some languages, like *Julia*, *R*, and *MatLab*, start counting from 1, but
*python* and *C* start counting from 0. These are conventions that each
language adopted. Everyone thinks the other camp is wrong, and it's one of
these surprisingly bitter (considering how utterly unimportant they are)
divides in the computer science world.

We can also ask what the *last* position contains:

````julia
random_numbers[length(random_numbers)]
````

````
0.22652223432706042
````

The way to read this instruction is as follows: get me the element at position
`length(random_numbers)`. We know that the length of `random_numbers` is `5`,
so this will return the 5th position. *Julia* has a quite pretty way of
getting the last element of most collections:

````julia
random_numbers[end]
````

````
0.22652223432706042
````

There is a similar trick for the beginning of a collection:

````julia
random_numbers[begin]
````

````
0.7646006338932442
````

These two are mostly useful to write things like

````julia
random_numbers[(begin+1):(end-1)]
````

````
3-element Vector{Float64}:
 0.26348724853556216
 0.4049769471766548
 0.4000708410427055
````

An extra bit of [syntactic sugar][sugar] in *Julia* are the two following
functions:

[sugar]: https://en.wikipedia.org/wiki/Syntactic_sugar

````julia
first(random_numbers)
````

````
0.7646006338932442
````

````julia
last(random_numbers)
````

````
0.22652223432706042
````

Being able to access elements by their position can be very useful. Our
`random_numbers` array has five elements, and we only want to print the
odd-numbered ones. One way to do this would be to call then individually:

````julia
println(random_numbers[1])
println(random_numbers[3])
println(random_numbers[5])
````

````
0.7646006338932442
0.4049769471766548
0.22652223432706042

````

Of course, this is only reasonable if we have a very small number of things to
do. But what if we want to iterate over hundreds, or thousands of values? We
need a more efficient strategy.

## Iterating over values

We know that a number is even if the statement `x % 2 == 0`, where `%` is
integer division. We can also say that a number is even if the remainder of
its integer division by two is *not* 0: `x % 2 != 0`.

Let's go:

````julia
for i in eachindex(random_numbers)
  if i % 2 != 0
    println("Position $i:\t", random_numbers[i])
  end
end
````

````
Position 1:	0.7646006338932442
Position 3:	0.4049769471766548
Position 5:	0.22652223432706042

````

We can "read" this snippet (a *snippet* is the affectionate name given to a
litle chunk of code; a *chunk* is a much uglier name for "a piece") as

~~~
there is a variable i
it will take every value between 1 and the length of the ranom_numbers array
for every value
look if it is odd
if it is, print the random number at this position
~~~

The `eachindex` function is a very powerful way to get, well, every position
in an array; it is the same thing as writing `for i in
1:length(random_numbers)`, but in a more expressive way.

All `for` loops will share the following structure:

~~~ julia
for element in collection
    # this bit can be as complex as we like -- but not too complex!
    do_things(element)
end
~~~

There is an important notion to mention: the *scope*. The scope is the parts of
your program in which a variable exists. Let's look at this hypothetical code:

~~~ julia
for i in 1:3
    println(i)
end

It will take the values 1, 2, and 3, and put them in the variable `i`, one at
a time. This is like writing

~~~ julia
i = 1
i = 2
i = 3
~~~

Right? So let's try. What do you think will happen if you run the cell below?

```julia
for i in 1:3
    println(i)
end

println(i)
```

What happens is that the variable `i` only exists within the `for` loop! This
might seem problematic at first, but it is actually much cleaner: this avoid
polluting your workspace with a lot of variables that are not really relevant.

This is true for all variables created within a loop. In the following code,
`a` is not defined outside of the loop:

~~~ julia
for i in 1:3
    a = i
end
~~~

If you want a variable to be accessible *outside* a loop, you can simply
create it before *and* declare it as a `global` variable (this is not required
within functions, and this is the point where reading the section of the Julia
manual on scope will help you):

````julia
a = 0
for i in 1:3
    global a
    a = i
end
println(a)
````

````
3

````

## Doing something until something happens

Before moving on, there is an additional construct we can use: `while`. This
one is *dangerous* (or at the very least *possibly inconvenient*), because it
will keep on running *until* something happens. Why is not called `until`?
Because most programming languages have been designed with little regard for
the way humans think...

A good example of `while` in action is to keep on generating random numbers
*until* their mean is within a certain range of a desired value. The `rand()`
function will generate numbers uniformly distributed between 0 and 1, so we
can run it for a while (*GET IT?*) to get a sample with an average of about
0.5.

We can for example write it this way:

````julia
using Statistics

my_collection = rand(5)
````

````
5-element Vector{Float64}:
 0.7765683713932601
 0.37082255393396135
 0.49595368421740216
 0.4454848647458809
 0.9929855033045603
````

````julia
while !(0.499 ≤ mean(my_collection) ≤ 0.501)
  append!(my_collection, rand(5))
end
````

````julia
println("μ: $(round(mean(my_collection); digits=4))")
````

````
μ: 0.5003

````

The instruction just after `while`, *i.e.*

~~~
!(0.499 ≤ mean(my_collection) ≤ 0.501)
~~~

is worth thinking about. It is a very compact way of running multiple tests at
once: the mean needs to be larger than 0.499, yet smaller than 0.501, and we
need to continue *until* this is true (but there is not *until* statement, so we
use the awkward "while not").

{{% callout danger %}} If we are particularly unlucky, we would never get a
sequence of random numbers that would match this condition! In this case, our
computer would stubbornly keep running until the heat death of the universe
(or until it breaks, which in all likelihood will happen earlier). Writing
`while` loops can be a complex exercice, and it is always good to think about
"exit strategies". {{% /callout %}}

This concludes the lesson on the flow of execution. These concepts are very
important to understand in depth, as everything else we do is built on them. Now
would be a good time to get back to the questions, or to try and change the
examples, to make sure you are familiar with the material.

