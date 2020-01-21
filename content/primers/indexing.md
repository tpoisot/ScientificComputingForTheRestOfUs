---
title: Indexing and arrays dimensions
slug: indexing
layout: page
concepts: [arrays, indexing, slices]
weight: 1
---

The overwhelming majority of data we will need to manipulate will be stored in
vectors, or matrices, or other types of multi-dimensional structures.

````julia
for r in rand(10)
  r ≥ 1/3 || continue
  println(round(r; digits=2))
end
````


````
0.47
0.45
0.8
0.73
0.58
0.69
0.57
````





In short, `continue` will *skip ahead* to the next element in the iteration.
This can be very important to avoid performing operations on objects that are
not relevant.
