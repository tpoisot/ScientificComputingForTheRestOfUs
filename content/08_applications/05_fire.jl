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
CairoMakie.activate!(; px_per_unit = 2)

#-

grid_size = (600, 600)

# We will use the following convention: an empty cell is 0, a burning cell is 1,
# and a planted cell is 2. The reason we are using numbers here is that they
# take less memory footprint than strings or symbols would (and also allow some
# nifty tricks with the color palette as we will see later).

forest = zeros(Int64, grid_size)

# probabilities

p, f = 1e-2, 1e-5

# !!!DOMAIN The model starts to have interesting behaviors when the $p/f$ ratio
# reaches 100. Keeping $p$ as is, and decreasing the value of $f$ leads to more
# spiral, and longer oscillations in the number of patches.

# how do we spread the fire

stencil = permutedims(vec(CartesianIndices((-1:1, -1:1))))

# color mapping

fire_state_palette = cgrad([:white, :orange, :green], 3; categorical = true)

# initial seeding

locations_to_plant = filter(i -> rand() <= p, eachindex(forest))
forest[locations_to_plant] .+= 2

#-

figure = Figure(; resolution = (900, 300), fontsize = 20, backgroundcolor = :transparent)
forest_plot = Axis(figure[1, 1]; xlabel = "", ylabel = "")
time_plot = Axis(figure[1, 2:3]; xlabel = "Time", ylabel = "Pixels")
hidedecorations!(forest_plot)
heatmap!(forest_plot, forest; colormap = fire_state_palette)
current_figure()

# steps

epochs = 1000

# states

V = zeros(Int64, epochs)
P = zeros(Int64, epochs)
B = zeros(Int64, epochs)

# stochastic processes without the need for iteration 

# this is very slow rn

for i in 1:epochs
    new_trees = filter(i -> rand() <= p, findall(isequal(0), forest))
    new_fires = filter(i -> rand() <= f, findall(isequal(2), forest))
    burned_trees = findall(isequal(1), forest)

    active_fires_position = findall(isone, forest)
    around =
        unique(filter(p -> p in CartesianIndices(forest), active_fires_position .+ stencil))
    on_fire = findall(isequal(2), forest[around])
    fire_spread = around[on_fire]

    forest[new_trees] .= 2
    forest[new_fires] .= 1
    forest[burned_trees] .= 0
    forest[fire_spread] .= 1

    V[i] = count(iszero, forest)
    B[i] = count(isone, forest)
    P[i] = prod(size(forest)) - (V[i] + B[i])
end

# plot

heatmap!(forest_plot, forest; colormap = fire_state_palette)
lines!(time_plot, P; color = :green, label="Planted")
lines!(time_plot, B; color = :orange, label="On fire")
axislegend(time_plot, position=:lb)
current_figure()