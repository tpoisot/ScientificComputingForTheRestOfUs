# ---
# title: Multiple dispatch in practice
# status: beta
# ---

# In this module, we will expand on the previous content (understanding
# *dispatch*) to get familiar with a central design paradigm of *Julia*:
# multiple dispatch. We will do so by writing code to simulate the growth of a
# population in space.

# <!--more-->

# !!!INFO The difference between dispatch and multiple dispatch is, essentially,
# that under multiple dispatch (what *Julia* does), the methods that gets called
# is a function of all of the types of the arguments in the signature. The
# practical consequence is that in *Julia*, types matter. A lot.

# To start our simulations, we will create an abstract type to store organisms:

abstract type Organism end

# We will specifically focus on two types of organisms: `Rabbits` and `Foxes`.
# These will be defined by a population size, which is an integer.

Base.@kwdef mutable struct Rabbit <: Organism
    population::Integer = 1
end

# Note that we have prefaced the declaration of our `struct` with `Base.@kwdef`.
# This is a strange little macro, which is very useful, and also very
# undocumented. What it does is let us put default values in the fields, and
# call them by their names:

🐰 = Rabbit(; population = 4)

# We can do the same work for foxes:

Base.@kwdef mutable struct Fox <: Organism
    population::Integer = 1
end

# !!!OPINION Notice how the types are almost the same? We could solve this
# problem in a dozen different ways, including making `Organism` a concrete
# parametric type, or using metaprogramming to write the `struct` definitions
# for us. Do not hesitate to look for these keywords in the *Julia* manual when
# you have mastered the content of this module; for now, explicit and verbose is
# better than fancy and concise.

🦊 = Fox()

# Even if we do not specify a value for `population`, it will take the default
# value. Also, yes, emojis are valid variable names. And function names. And
# it's a curse and a blessing.

# What we will do is write a function called `sight`, which will establish a set
# of rules for what happens when an organism sees another organism.

function sight!(fox::Fox, rabbit::Rabbit)
    if iszero(rabbit.population)
        fox.population -= 1
    else
        fox.population += 1
        rabbit.population -= 1
    end
end

# !!!INFO The `!` at the end of the `sight` function means nothing in terms of
# the language, but is part of the social contract of using *Julia*, and
# signifies that the function will *mutate* (this means "change") its arguments.
# It is an exclamation mark because mutation is a side-effect, and there are
# situations where we care about side-effects and so-called *pure* functions a
# lot, and we will revisit mutating functions in the next section.

# We can try to apply this function now:

sight!(🦊, 🐰)

# Because the fox has sighted the rabbit first, the rabbit population loses one
# individual, and the fox population grows by one.

# !!!DOMAIN This is, and we cannot emphasize this enough, not how *any* of this
# works.

# Let's check the status of our populations:

🦊, 🐰

# So far, so good. How do we add more complexity to this? Well, let's add a
# version of `sight!` that accounts for the fact that foxes are hunting during
# sunset, at night, and very early in the morning. Let's say that they hunt from
# 9pm to 5am. To represent this, we will load the {{Dates}} package from the
# standard library:

using Dates

# It is going to let us do a little bit of interesting date arithmetic, and its
# documentation is worth reading a couple times over if you have the misfortune
# of needing to manipulate dates and times. Specifically, the thing we want to
# express is that foxes are hunting between 9pm yesterday and 5am today, which
# are respectively

Hour(21) - Day(1)

# and 

Hour(5)

# We can check that this is covering the correct timespan of 8 hours:

Hour(5) - (Hour(21) - Day(1))

# Now, to add this to a method for `sight!`

function sight!(fox::Fox, rabbit::Rabbit, time::DateTime)
    if (Hour(21) - Day(1)) <= Hour(time) <= Hour(5)
        sight!(fox, rabbit)
    else
        @info "Foxes are currently closed for business"
    end
end

# Let's try this at different moments -- for example, at 4:58pm on the first day
# of August, 2018:

sight!(🦊, 🐰, DateTime(2018, 8, 1, 16, 58, 00))

# We can check that the population size has not changed:

🦊, 🐰

# Alternatively, if the same encounter happens a bit later:

sight!(🦊, 🐰, DateTime(2018, 8, 2, 01, 35, 21))
🦊, 🐰

# This is an illustration of the things we can do when dispatching on the types
# of multiple arguments. In the next modules, this will become standard
# practice, and so it is worth spending a bit of time trying to experiment with
# the concepts here. For example, we have not defined a situation in which the
# rabbit is the one sighting the fox first -- this is a good example to
# implement yourself!