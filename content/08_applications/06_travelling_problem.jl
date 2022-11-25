# ---
# title: The travelling salespserson problem
# status: beta
# ---

# In this module, we will look at a way to start working on the travelling salesperson
# problem. This is mostly an excuse to play around with indexing, as we will not explore the
# many ways to actually optimize this problem.

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
# at the end. This is feasible with a list comprehension, as we need to read the distance
# between step $i$ and step $i-1$ of the route, which are mapped to two different cities:

global distance =
    sum([D[route[i], route[i + 1]] for i in axes(route, 1)[1:(end - 1)]]) +
    D[route[end], route[begin]]

# Problem solved! Now what we need to do is find a way to decrease this distance, which
# would represent a shortest path. We can (sort of) brute force our way to a solution.

# !!!DOMAIN This is not the best way to approach this problem. In practice, we would use
# something like a genetic algorithm. This would be a lot more work, but give much better
# results. The way we use here is almost demonstrably the worst possible way to solve the
# problem.

# Our approach will work as follows: every step, we will pick two random steps along the
# route, and switch them. For example, the route `[1, 2, 3, 4]` can become `[1, 4, 3, 2]`.
# This is something we can do through the fact that `x[[i,j]] = x[[j,i]]` will switch the
# positions of `i` and `j` in `x`. But also, we know that `[j, i]` is `reverse([i, j])`; so
# if we have a vector with two positions on the route, we can switch them very easily!

# This *would* modify our route "in place", which is good, but implies that we need to keep
# track of the positions we switched so we can switch them back if the proposed solution is
# bad. Here, we will define *bad* as "making the distance increase". If a proposed solution
# is *good*, we want to keep the switch (we have nothing to do), and re-write the value of
# `distance` to be the new value to beat.

# We will keep track of the progress of our algorithm in an array of "best distance found so
# far":

best_distance = zeros(Float64, 10_000)
best_distance[1] = distance

# We now have everything we need to run the algorithm:

for i in axes(best_distance, 1)[2:end]
    switches = rand(eachindex(route), 2)
    route[reverse(switches)] = route[switches]
    best_distance[i] =
        sum([D[route[i], route[i + 1]] for i in axes(route, 1)[1:(end - 1)]]) +
        D[route[end], route[begin]]
    if !(best_distance[i] <= best_distance[i - 1])
        route[reverse(switches)] = route[switches]
        best_distance[i] = best_distance[i - 1]
    end
end

# After all the iterations are done, we can have a look at the new solution:

scatter(
    cities;
    color = :black,
    axis = (; aspect = AxisAspect(1.0)),
    figure = (; backgroundcolor = :transparent),
)
lines!(cities[:, route]; color = :black)
current_figure()

# We can also check that the solution has been decreasing over time:

lines(
    best_distance;
    axis = (; xlabel = "Step", ylabel = "Route distance"),
    figure = (; backgroundcolor = :transparent),
)

# This algorithm is *very* prone to getting stuck in local minima, so it is not surprising
# that it is not generating a *good* solution. A formative excercise to do is to (i) add the
# possibility to shuffle larger sections of the route, like for example `1:5` and `30:34`,
# and (ii) come up with a way to accept a move that is just a "little bit" bad, which is the
# basis for *e.g.* simulated annealling.
