---
title: Map, filter, reduce
slug: map_filter_reduce
layout: page
status: construction
concepts: [map filter reduce]
weight: 2
---

A *lot* of computing tasks involve going through arrays, or collections, of
values, and selecting some of them, applying transformations, and returning
values based on them. After reading the lesson on [Control flow]({{< ref
"/lessons/control_flow.md" >}}), you are equipped to do this using `for`, `if`,
and `while`. But most tasks can actually be adressed using an approach which is
even more simple: map/filter/reduce.

## Map

````julia
map(x -> x * 2, 1:5)
````


````
5-element Array{Int64,1}:
  2
  4
  6
  8
 10
````





## Filter

````julia
filter(isodd, 1:5)
````


````
3-element Array{Int64,1}:
 1
 3
 5
````





## Reduce


````julia
reduce(+, 1:3)
````


````
6
````





## Map on slices
