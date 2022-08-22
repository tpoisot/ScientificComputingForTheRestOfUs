---
title: The while statement
---

In this module, we will see how we can use the `while` construct to make a
series of instruction repeat until a condition is met, and how to deal with
common caveats that can arise when using a `while` loop.

<!-- more -->

By opposition to a `for` loop, as we have seen in the previous module, the
number of times a `while` loop will happen is not limited by the length of a
collection. It is, instead, decided by an "exit condition", *i.e.* a condition
that when met will stop the loop.

Let's start with an example - because we will generate randon numbers, we will
set the seed for this simulation:

````julia
import Random
Random.seed!(123456)
````

````
Random.TaskLocalRNG()
````

The problem we want to solve is as follows: we need to generate two vectors of
random numbers, `x` and `y`, that have a correlation between 0.6 and 0.8. This
is, for example, a way to generate a small benchmark data point. The
correlation function (`cor`) is in `Statistics`, which we can import:

````julia
import Statistics
````

We can generate an initial pair of vectors:

````julia
x, y = rand(10), rand(10)
````

````
([0.818848036562839, 0.7569411211154605, 0.411988190027885, 0.7311410378692782, 0.7058500642518956, 0.2601665001465642, 0.49949519818145727, 0.814418633506866, 0.8244361286587295, 0.3285196755147558], [0.62403405150908, 0.9536642053285284, 0.9097066946836926, 0.22190067739742647, 0.3099769213040334, 0.06946766908635915, 0.1811435621082308, 0.34647299403713616, 0.8340072221968884, 0.5016414526444922])
````

Their correlation is

````julia
Statistics.cor(x,y)
````

````
0.29421466052888634
````

What we now need to do is keep generating vectors `x` and `y` *until* the
condition is met. In *Julia*, this is expressed as

````julia
while !(0.6 ≤ Statistics.cor(x,y) ≤ 0.8)
    global x, y
    x, y = rand(10), rand(10)
end
````

````julia
Statistics.cor(x,y)
````

````
0.6100870666348821
````

Note that we use `global x,y` because `x` and `y` are defined outside of the
loop, and we are working outside of a function. If we removed this line, this
code will never stop running! This is a very important poi

