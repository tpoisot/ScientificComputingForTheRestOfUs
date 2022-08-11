---
title: Understanding multiple dispatch
weight: 3
---

In this module, we will expand on the previous content (understanding
*dispatch*) to get familiar with a central design paradigm of *Julia*:
multiple dispatch. We will do so by writing code to simulate the outcome of
encounters between different types of organisms.

````julia
abstract type Organism end
````

````julia
struct Predator <: Organism
    name::String
end
````

````julia
struct Prey <: Organism
    name::String
end
````

````julia
🦊, 🐭 = Predator("Vulpes vulpes"), Prey("Mus musculus")
````

````
(Main.##307.Predator("Vulpes vulpes"), Main.##307.Prey("Mus musculus"))
````

Yes, emojis are, indeed, acceptable for variable names, function names, etc.
This is not the best idea, but this is a direct consequence of *Julia*'s
excellent unicode support. More interesting is the fact that we define two
variables in one line.

Let's try again, this time with words:

````julia
fox, mouse = Predator("Vulpes vulpes"), Prey("Mus musculus")
````

````
(Main.##307.Predator("Vulpes vulpes"), Main.##307.Prey("Mus musculus"))
````

Better. What we want to do now is functionnaly very similar to the
rock/paper/scissors example we used to introduce dispatch: depending on who is
involved in the interaction, we want to output different outcomes.

Before we start thinking about the biology too much, let's make sure our
function never really fails. In order to do so, we will write a "catch-all"
method that will return something when called with two organisms:

````julia
function encounter(sp1::T1, sp2::T2) where {T1 <: Organism, T2 <: Organism}
    return "I don't know what $(sp1.name) and $(sp2.name) are up to"
end
````

````
encounter (generic function with 1 method)
````

````julia
encounter(fox, mouse)
````

````
"I don't know what Vulpes vulpes and Mus musculus are up to"
````

````julia
function encounter(prey::Prey, predator::Predator)
    return "$(prey.name) is eaten by $(predator.name)"
end
````

````
encounter (generic function with 2 methods)
````

````julia
encounter(mouse, fox)
````

````
"Mus musculus is eaten by Vulpes vulpes"
````

````julia
function encounter(predator::Predator, prey::Prey)
    return encounter(prey, predator)
end
````

````
encounter (generic function with 3 methods)
````

````julia
encounter(fox, mouse)
````

````
"Mus musculus is eaten by Vulpes vulpes"
````

````julia
encounter(fox, fox)
````

````
"I don't know what Vulpes vulpes and Vulpes vulpes are up to"
````

````julia
function encounter(sp1::T, sp2::T) where {T <: Organism}
    return "$(sp1.name) and $(sp2.name) ignore one another"
end
````

````
encounter (generic function with 4 methods)
````

````julia
encounter(fox, fox)
````

````
"Vulpes vulpes and Vulpes vulpes ignore one another"
````

````julia
encounter(mouse, mouse)
````

````
"Mus musculus and Mus musculus ignore one another"
````

````julia
function encounter(sp1::Prey, sp2::Prey)
    return "$(sp1.name) and $(sp2.name) just vibe"
end
````

````
encounter (generic function with 5 methods)
````

````julia
encounter(mouse, mouse)
````

````
"Mus musculus and Mus musculus just vibe"
````

````julia
vole = Prey("Microtus arvalis")
encounter(mouse, vole)
````

````
"Mus musculus and Microtus arvalis just vibe"
````

````julia
encounter(fox, vole)
````

````
"Microtus arvalis is eaten by Vulpes vulpes"
````

