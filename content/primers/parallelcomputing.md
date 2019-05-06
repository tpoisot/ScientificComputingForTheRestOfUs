Sometimes, we really need more than one CPU to get things done in a reasonable
amount of time.

````julia
using Distributed
````



````julia
addprocs(2)
````


````
2-element Array{Int64,1}:
 4
 5
````


