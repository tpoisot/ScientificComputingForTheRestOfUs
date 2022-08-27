---
title: The while statement
status: beta
---

In this module, we will see how we can use the `while` construct to make a
series of instructions repeat until a condition is met, and how to deal with
common caveats that can arise when using a `while` loop.

<!-- more -->

By opposition to a `for` loop, as we have seen in the previous module, the
number of times a `while` loop will happen is not limited by the length of a
collection. It is, instead, decided by an "exit condition", *i.e.* a condition
that when met will stop the loop.

{{< callout danger >}}
Note that `while` loops only terminate when some condition is met.
If the condition cannot be met, the loop can run on forever. One common
strategy is to implement a counter with a maximum number of iterations, for
example, and to use it to `break` out of the loop.
{{< /callout >}}

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

{{< callout information >}}
This notation is a shortcut, in which Julia will match the first
variable on the left hand side (`x`) with the first expression on the right
hand side (`rand(10)`). This is the same thing as writing `x = rand(10)` and
`y = rand(10)` on two separate lines, but is a little more concise, and also
maintains both variables on the same line.
{{< /callout >}}

Their correlation can be calculated using the `cor` function from
`Statistics`:

````julia
Statistics.cor(x, y)
````

````
0.29421466052888634
````

What we now need to do is, in plain English, keep generating vectors `x` and
`y` *until* the condition is met. We can also decide to maintain `x` and only
change `y`, or to replace elements of `x` or `y` one by one, and many other
alternatives, but for now we will use a brute-force approach to this problem.

In *Julia*, this is expressed as

````julia
while !(0.6 ≤ Statistics.cor(x, y) ≤ 0.8)
    global x, y
    x, y = rand(10), rand(10)
end
````

There are a few things to unpack here.

First, we use the `while not condition` notation, which allows us to write the
comparison in a way that is consistent with the way we would write it down on
paper. Recall from the module on Boolean operations that `!true` is `false`,
and the other way around.

Second, we use `global x,y` because `x` and `y` are defined outside of the
loop, and we are working outside of a function. If we removed this line, this
code will never stop running! This is a very important point, due to the way
Julia handles *scoping* (which is explained at length in the manual!).

We can now check that the correlation is within our interval:

````julia
Statistics.cor(x, y)
````

````
0.6100870666348821
````

There are a number of ways we can make this loop better. First, we can
implement a counter. If we are particularly unlucky, we might never get a pair
of vectors that satisfy our condition, and so we would like to return before
the heat death of the universe.

````julia
number_of_attempts, maximum_attempts = 0, 100
x, y = rand(10), rand(10)
````

````
([0.36850897354521706, 0.6586750244395302, 0.9349083496911273, 0.8201161126583437, 0.6037240677016869, 0.10908496089321651, 0.6560953753740482, 0.21528666443303623, 0.5490543075166564, 0.9058123803649349], [0.4813500034560717, 0.5517201159119057, 0.7637497598284502, 0.09763678764867922, 0.12093972916243012, 0.3850911924551602, 0.0047226757508409545, 0.2481914009302686, 0.8058781549711377, 0.5561236670383914])
````

We can now tweak our loop so that it has a second part to its return
condition: we need to have done fewer attempts than the allowed maximum.

````julia
while (!(0.6 ≤ Statistics.cor(x, y) ≤ 0.8)) & (number_of_attempts < maximum_attempts)
    global x, y, number_of_attempts
    x, y = rand(10), rand(10)
    number_of_attempts += 1
end
````

{{< callout information >}}
There is a much nicer notation to exit a loop than simply adding
elements to the return condition. It is covered in a later module.
{{< /callout >}}

We can now write down the number of attempts it took, and the score we got:

````julia
"""
Pair (x,y) found in $(number_of_attempts) attempts
Correlation: $(round(Statistics.cor(x, y); digits=3))
""" |> println
````

````
Pair (x,y) found in 31 attempts
Correlation: 0.631


````

