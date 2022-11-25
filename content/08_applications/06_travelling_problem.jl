# ---
# title: The travelling salespserson problem
# status: beta
# ---

# In this module

# <!--more-->

# The travelling salesperson problem is a rather famous problem in optimisation, which is
# often stated as follows: "given a list of cities represented by their coordinates, what is
# the shortest possible route that visits all of these cities exactly once, and returns to
# its origin?".

using CairoMakie
CairoMakie.activate!(; px_per_unit = 2) # This ensures high-res figures

# There is a *lot* of information in this statement, and we will need to translate it into
# code. But we can work on these elements one at a time. First, there is a list of cities,
# and these cities are represented by their coordinates. We can set a few limits here: first
# the world exists in two dimensions; second, there are 50 cities to visit. We will arrange
# these cities on a circle, with some small perturbations;

angles = rand(50) .* 2π
radii = sqrt.(8.0 .+ rand(length(angles)) .* 2.0)
x = cos.(angles) .* radii
y = sin.(angles) .* radii

cities = permutedims(hcat(x, y))

cities[:, 1:5]

# !!!DOMAIN We use the square root transform of the radius to have points defined uniformly
# within a ribbon. This is a small detail, but it's worth keeping in mind if you want to
# generate points that are uniformly distributed within a circle.

scatter(
    cities;
    color = :black,
    axis = (; aspect = AxisAspect(1.0)),
    figure = (; backgroundcolor = :transparent),
)

# The next information given by the statement of the problem is that we care about the
# distances between these cities, and so we can pre-calculate these distances, assuming that
# the Euclidean distance is suitable here.

D = zeros(Float16, size(cities, 2), size(cities, 2));

# !!!OPINION We are using `Float16` here because it takes us less space in memory, and we do
# not care so much about the precision.

# We need to fill our matrix - this is going to be made easier by the fact that the distance
# is symmetric, but this is not a requirement here.

for i in axes(cities, 2)[1:(end - 1)], j in axes(cities, 2)[(i + 1):end]
    D[i, j] = D[j, i] = sqrt(sum((cities[:, i] .- cities[:, j]) .^ 2.0))
end

# The third element of the problem is that we have a "route", which is the order in which we
# visit cities. Each city is visited only once (so we know how many stops there are), and
# the salesperson returns to the origin city.

# !!!DOMAIN We do not really care about which city is the origin city, since by the end, we
# will have a loop. We can simply pick whichever arbitrary city we want as the point of
# origin after the fact.

# The easiest way to represent a route is therefore to have a series of indices,
# representing the order in which we visit the cities. In the absence of a know initial
# solution, we will simply visit the cities in order:

route = collect(axes(cities, 2));

# We can plot this route to see what it would look like:

scatter(
    cities;
    color = :black,
    axis = (; aspect = AxisAspect(1.0)),
    figure = (; backgroundcolor = :transparent),
)
lines!(cities[:, route]; color = :black)
current_figure()

# What is the total travel distance of this route? In order to know this, we only need to
# read the pairwise distances between adjacent cities in the route, and add the return step
# at the end.

global distance =
    sum([D[route[i], route[i + 1]] for i in axes(route, 1)[1:(end - 1)]]) +
    D[route[end], route[begin]]

# Problem solved! Now what we need to do is find a way to decrease this distance, which
# would represent a shortest path. We can (sort of) brute force our way to a solution.

for i in 1:10000
    switches = rand(eachindex(route), 2)
    route[reverse(switches)] .= route[switches]
    new_distance =
        sum([D[route[i], route[i + 1]] for i in axes(route, 1)[1:(end - 1)]]) +
        D[route[end], route[begin]]
    if new_distance < distance
        global distance = new_distance
    else
        route[reverse(switches)] .= route[switches]
    end
end

# !!!DOMAIN This is not the best way to approach this problem. In practice, we would use
# something like a genetic algorithm. This would be a lot more work, but give much better
# results.

# After 10000 iterations, we can have a look at the new solution:

scatter(
    cities;
    color = :black,
    axis = (; aspect = AxisAspect(1.0)),
    figure = (; backgroundcolor = :transparent),
)
lines!(cities[:, route]; color = :black)
current_figure()

#-

distance
