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

# Better.