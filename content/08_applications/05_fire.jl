# ---
# title: The forest-fire model
# status: alpha
# ---

# In this module, we will have a look at indexing in order to simulate the
# behavior of a forest when trees can catch on fire, be planted, and regrow.

# <!--more-->

# INTRO

# We will rely on {{CairoMakie}} for plotting, and {{StatsBase}} for random
# sampling.

using CairoMakie
using StatsBase

#-

grid_size = (100, 100)

# We will use the following convention: an empty cell is 0, a burning cell is 1,
# and a planted cell is 2. The reason we are using numbers here is that they
# take less memory footprint than strings or symbols would (and also allow some
# nifty tricks with the color palette as we will see later).

forest = zeros(Int64, grid_size)

# probabilities

p, f = 1e-3, 1e-5

# initial seeding

locations_to_plant = filter(i -> rand()<=p, eachindex(forest))
forest[locations_to_plant] .+= 2

#-

heatmap(forest)