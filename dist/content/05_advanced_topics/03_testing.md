---
title: Testing functions
status: alpha
---

````julia
using Test
````

````julia
@test isequal(4)(2+2)
````

````
Test Passed
````

````julia
@test 2+2 isa typeof(2)
````

````
Test Passed
````

