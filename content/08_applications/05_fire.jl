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

grid_size = (200, 200)

# We will use the following convention: an empty cell is 0, a burning cell is 1,
# and a planted cell is 2. The reason we are using numbers here is that they
# take less memory footprint than strings or symbols would (and also allow some
# nifty tricks with the color palette as we will see later).

forest = zeros(Int64, grid_size)
changeto = zeros(Int64, grid_size)

# probabilities

p, f = 1e-2, 0.5e-4

# !!!DOMAIN The model starts to have interesting behaviors when the $p/f$ ratio
# reaches 100. Keeping $p$ as is, and decreasing the value of $f$ leads to more
# spiral, and longer oscillations in the number of patches.

# how do we spread the fire

stencil = CartesianIndices((-1:1, -1:1))

# color mapping

fire_state_palette = cgrad([:white, :orange, :green], 3; categorical = true)

# initial seeding

locations_to_plant = filter(i -> rand() <= p, eachindex(forest))
forest[locations_to_plant] .+= 2

#-

figure = Figure(; resolution = (600, 300), fontsize = 20, backgroundcolor = :transparent)
forest_plot = Axis(figure[1:3, 1]; xlabel = "", ylabel = "")
B_plot = Axis(figure[1, 2]; xlabel = "Time", ylabel = "Burning")
P_plot = Axis(figure[2, 2]; xlabel = "Time", ylabel = "Planted")
V_plot = Axis(figure[3, 2]; xlabel = "Time", ylabel = "Empty")
hidedecorations!(forest_plot)
hidedecorations!(B_plot)
hidedecorations!(P_plot)
hidedecorations!(V_plot)
heatmap!(forest_plot, forest; colormap = fire_state_palette)
current_figure()

# steps

epochs = 1:1000

# states

V = zeros(Int64, length(epochs))
P = zeros(Int64, length(epochs))
B = zeros(Int64, length(epochs))

# stochastic processes without the need for iteration 

# this is very slow rn

function _deal_empty!(changeto, forest, position, p)
    if forest[position] == 0
        if rand() <= p
            changeto[position] = 2
        end
    end
end

function _deal_planted!(changeto, forest, position, f)
    if forest[position] == 2
        if rand() <= f
            changeto[position] = 1
        end
    end
end

function _deal_fire!(changeto, forest, position, stencil)
    if forest[position] == 1
        changeto[position] = 0
        arounds = CartesianIndices(forest)[position] .+ stencil
        for around in arounds
            if around in CartesianIndices(forest)
                if forest[around] == 2
                    changeto[around] = 1
                end
            end
        end
    end
end

@profview for epoch in epochs
    for (position,state) in enumerate(forest)
        _deal_empty!(changeto, forest, position, p)
        _deal_planted!(changeto, forest, position, f)
        _deal_fire!(changeto, forest, position, stencil)
    end
    
    for i in eachindex(forest)
        forest[i] = changeto[i]
    end
    
    V[epoch] = count(iszero, forest)
    B[epoch] = count(isone, forest)
    P[epoch] = prod(size(forest)) - (V[epoch] + B[epoch])
end

# plot

heatmap!(forest_plot, forest; colormap = fire_state_palette)
lines!(P_plot, P; color = :green)
lines!(B_plot, B; color = :orange)
lines!(V_plot, V; color = :black, linestyle=:dot)
current_figure()