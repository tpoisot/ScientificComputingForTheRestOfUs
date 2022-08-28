# ---
# title: Linear regression using gradient descent
# status: alpha
# ---

using Random
using Distributions
using CairoMakie

#-

n_samples = 150
b, m, x = 1.05, -2.6, rand(Normal(0.0, 1.7), n_samples)
noise = rand(Normal(0.0, 2.0), n_samples)
y = b .* (x .+ noise) .+ m;

#-

figure = Figure(resolution=(600, 600))
scplot = Axis(figure[2, 1]; xlabel = "Variable", ylabel = "Response")
scatter!(scplot, x, y)
figure

#-