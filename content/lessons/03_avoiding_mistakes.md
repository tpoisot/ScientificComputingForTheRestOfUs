---
title: Avoiding mistakes
slug: avoiding_mistakes
weight: 3
meta:
  issue: 19
  label: "lesson:defensive"
---

## We can't avoid mistakes

But we can work as cautiously as possible, to make sure we catch them in time.
It is always better to try and fail to run something, than to have the operation
keep going and accumulating mistakes.

There are four types of mistakes to look out for. Some are caused by the
programmer, and some are caused by the user. But in the context of writing code
for science, the programmer and the user are often the same person. Even if it
were not the case, user mistakes can come from sub-optimal design. It is crucial
to work in a way that protects everyone against mistakes.

Let's start with this function, for example:

````julia
function diversity_test1(a)
  x = [i/sum(a) for i in a]
  return -sum(p.*log.(p))./log(length(a))
end
````


````
diversity_test1 (generic function with 1 method)
````





What is this function doing? Who knows? Well, it takes an array of values, and
them calculates Pielou's diversity index ($J = \left(-\sum
p_i\text{ln}p_i\right)/\left(\text{ln}|p|\right)$) based on this array. But we
would not use this function, because it is particularly badly written. In this
lesson, we will go through a series of steps to make it usable.

In this lesson, you may note that we will switch perspective frequently, from
user to developper. This is because, in our own experience, this is a fair
representation of the way we work. We try to write something (developper), then
apply it to a specific problem (user), then figure out there is an issue and
switch back to developper mode.

## After this lesson, you will be able to ...

- ... use defensive programming
- ... write basic tests to ensure that the program fails when it should
- ... **TODO**

## Confusing interface

The first issue with our function (aside from the fact that it does not work,
but this is actually irrelevant for now!) is that its name is meaningless.
Naming things explicitely is always better: it makes the code easier to read.

Our first order of business should therefore be to rename this function:

````julia
function pielou(a)
  x = [i/sum(a) for i in a]
  return -sum(p.*log.(p))./log(length(a))
end
````


````
pielou (generic function with 1 method)
````





This is not really sufficient, but this is a large improvement. If you come back
to code using this function in a week, or in six months, you will be able to
understand what this function does simply by reading its name.

{: .opinion}

Most languages have "styleguides" (some have several), that explain how to write
code and name things. [*Julia*'s][jlsg] is short, and makes sense. We will
mostly follow it, except when we won't. These are "guides", not laws.

[jlsg]: https://docs.julialang.org/en/latest/manual/style-guide/

Another issue with this function is the name of its argument. There is *nothing*
in here that will prevent the computer from performing the required task. But a
non-specific argument name will make the user experience worse. Let's compare
`pielou(a)` with `pielou(abundances)`. One is correct but obscure; the other is
correct and self-explanatory. It is easy to forget that well-written code is one
key element of effective documentation!

Our second task will be to re-write this function to use the more explicit name:

````julia
function pielou(abundances)
  x = [i/sum(abundances) for i in abundances]
  return -sum(p.*log.(p))./log(length(abundances))
end
````


````
pielou (generic function with 1 method)
````





## Using the wrong arguments

## Mistakes in the code

## Lack of integration

- calling wrong function
- running with bad arguments
- mistake in functions
- integration issues
