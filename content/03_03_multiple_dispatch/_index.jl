# ---
# title: Understanding multiple dispatch
# url: multiple-dispatch
# weight: 3
# category: 03-functions
# ---

# In this module, we will expand on the previous content (understanding
# *dispatch*) to get familiar with a central design paradigm of *Julia*:
# multiple dispatch. We will do so by writing code to simulate the outcome of
# encounters between different types of organisms.

abstract type Organism end

#-

struct Predator <: Organism
    name::String
end

#-

struct Prey <: Organism
    name::String
end

#- 

🦊, 🐭 = Predator("Vulpes vulpes"), Prey("Mus musculus")

# Yes, emojis are, indeed, acceptable for variable names, function names, etc.
# This is not the best idea, but this is a direct consequence of *Julia*'s
# excellent unicode support. More interesting is the fact that we define two
# variables in one line.

# Let's try again, this time with words:

fox, mouse = Predator("Vulpes vulpes"), Prey("Mus musculus")

# Better. What we want to do now is functionnaly very similar to the
# rock/paper/scissors example we used to introduce dispatch: depending on who is
# involved in the interaction, we want to output different outcomes.

# Before we start thinking about the biology too much, let's make sure our
# function never really fails. In order to do so, we will write a "catch-all"
# method that will return something when called with two organisms:

function encounter(sp1::T1, sp2::T2) where {T1 <: Organism, T2 <: Organism}
    return "I don't know what $(sp1.name) and $(sp2.name) are up to"
end

#-

encounter(fox, mouse)

#-

function encounter(prey::Prey, predator::Predator)
    return "$(prey.name) is eaten by $(predator.name)"
end

#- 

encounter(mouse, fox)

#-

function encounter(predator::Predator, prey::Prey)
    return encounter(prey, predator)
end

#-

encounter(fox, mouse)

#-

encounter(fox, fox)

#-

function encounter(sp1::T, sp2::T) where {T <: Organism}
    return "$(sp1.name) and $(sp2.name) ignore one another"
end

#-

encounter(fox, fox)

#- 

encounter(mouse, mouse)

#-

function encounter(sp1::Prey, sp2::Prey)
    return "$(sp1.name) and $(sp2.name) just vibe"
end

#-

encounter(mouse, mouse)

#- 

vole = Prey("Microtus arvalis")
encounter(mouse, vole)

#-

encounter(fox, vole)