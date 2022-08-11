---
title: Returning functions
weight: 5
---

*Julia* has a very interesting function called `isequal`. Let's see how it
works (don't forget to look at `?isequal` for more):

````julia
is_two = isequal(2.0)
````

````
(::Base.Fix2{typeof(isequal), Float64}) (generic function with 1 method)
````

When we call this function, we get back *another function*. We can apply this
new function to a few arguments:

````julia
is_two(π)
````

````
false
````

````julia
is_two(2)
````

````
true
````

This is actually rather helpful! In this module, we will illustrate how
returning functions works, and see a simple example from population dynamics.

