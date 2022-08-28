# ---
# title: Linear regression using gradient descent
# status: beta
# ---

# In this module, we will use the gradient descent algorithm to perform a linear
# regression. This will draw on concepts from a number of previous modules,
# while also presenting an example of how core programming skills can be applied
# for research.

# <!--more-->

# In order to make the code reproducible, after loading the packages we need, we
# will set a random generator seed:

using Random
using Distributions
using CairoMakie
Random.seed!(1234)

# Here is a broad overview of the task we want to accomplish. Given a series of
# inputs $X$, and measurements $Y$, we want to infer the value of parameters $m$
# and $b$ so that $mX+b \approx Y$. This is a linear regression, and it is one
# of the most basic techniques in statistics.

# !!!OPINION Machine Learning and Statistics both claim linear regression as
# "theirs". Both are wrong. Methods belong to the people.

# In order to facilitate the process, we will generate a series of random
# measurements, with $X$ drawn in $(-3,3)$, under the known parameters $m =
# -2.6$ and $b = 1.05$. In order to generate some stochasticity in the data, we
# will get our values $Y$ by measuring $m(X+\epsilon)+b$, *i.e.* we add a
# measurement error on $X$ (and assume it is normally distributed with null mean
# and unit variance):

n_samples = 150
b, m, X = 1.05, -2.6, rand(Uniform(-3, 3), n_samples)
noise = rand(Normal(0.0, 1.0), n_samples)
Y = m .* (X .+ noise) .+ b;

# It is *always* a good idea to look at the data before attempting any
# modelling, so we can use the *CairoMakie* package to do so:

figure = Figure(; resolution = (900, 300))
scplot = Axis(figure[1, 1]; xlabel = "Variable", ylabel = "Response")
scatter!(scplot, X, Y; color = :darkgrey)
figure

# !!!INFO There are multiple plotting packages in *Julia*, including *Plots*,
# *Makie*, *Gadfly*, *Winston*, and probably a few others. We like *Makie* for
# complex layouts and fine-grained controls.

# After checking that the relationship between $Y$ abd $X$ looks suitably
# linear, we can start thinking about the optimization algorithm. Optimization
# requires a target, otherwise known as a loss function. We will use the mean
# squared error estimator, which as its name suggests, compare the actual values
# to the predictions, and returns the sum of their differences squared, divided
# by the number of elements (to make the score dimensionless with regards to
# sample size).

ℒ(Y, Ŷ) = sum((Y .- Ŷ) .^ 2.0) / length(Y)

# !!!WARNING The purpose of this module is not to give an in-depth treatment of
# gradient descent applied to linear regression. There are dozens of online
# resources already doing this. If you feel like you need to know more about the
# underlying theory, now is a good time to pause your reading and have a look at
# these resources.

# We can measure the loss that we would get based on random values of $m$ and
# $b$ drawn in the unit interval:

m₀, b₀ = rand(2)
Ŷ₀ = m₀ .* X .+ b₀
ℒ(Y, Ŷ₀)

# It's not very good! We can get visual confirmation of the poor fit by adding a
# line to our plot:

lines!(
    scplot,
    [minimum(X), maximum(X)],
    (x) -> m₀ .* x .+ b₀;
    color = :grey,
    linestyle = :dash,
)
figure

# How do we fix this? The gradient descent algorithm works by mapping the loss
# value $L$ to the parameters values. Specifically, the *gradient* is given by

# $$
# \nabla f' = \begin{bmatrix}
#    \frac{\partial L}{\partial m} &&
#    \frac{\partial L}{\partial b}
# \end{bmatrix}
# $$

# The value of $\partial L/\partial m$ is the partial derivative of the log
# function with regards to $m$, and can be calculated from the definition of the
# loss function. In *Julia*, there are a number of autodiff packages like
# *Zygote* who make this task a lot easier, but for the purpose of this example,
# it is a good idea to see what we can build out of the base language.

# After some calculations, we can get the two components of the gradient. We
# will express them as functions:

∂m(X, Y, Ŷ) = -(2 / length(X)) * sum(X .* (Y .- Ŷ));
∂c(X, Y, Ŷ) = -(2 / length(X)) * sum(Y .- Ŷ);

# We can finally wrap these two function within a single function expressing the
# gradient $\nabla f$:

∇f(X, Y, Ŷ) = [∂m(X, Y, Ŷ), ∂c(X, Y, Ŷ)]

# In gradient descent, the update scheme for the parameters is very simple; at
# each iteration, we transform $m$ and $b$ by substracting the values in the
# gradient. In other words, $\mathbf{p} = \mathbf{p} - \nabla f$, where
# $\mathbf{p}$ is a column vector storing the parameters.

# What is the gradient like at our initial (very bad estimate)? We can call the
# `∇f` function to get the answer:

∇f(X, Y, Ŷ₀)

# These look like very large values. There are two reasons for this. The first
# is that our initial guess is, as we have seen from the figure, very bad.
# Therefore, we expect to move quite far away from the parameter values. The
# second reason (far more important here) is that we are being a little
# over-eager in our learning. The risk with learning too much is that we can
# move so far away that we will miss the correct value, by jumping straight over
# it.

# In order to solve this problem, we will add a *learning rate* $\eta$, which is
# a small value (much smaller than 1) by which we will multiply the gradient, so
# that our update scheme becomes $\mathbf{p} = \mathbf{p} - \eta\times \nabla f$:

η = 1e-3;

# We can now check that our move is much smaller in magnitude:

η .* ∇f(X, Y, Ŷ₀)

# Excellent! With these elements, we are ready to start solving our problem. We
# can generate an initial solution at random:

𝐩 = rand(2)

# And now, we very simply iterate over a set number of epochs (both the number
# of epochs and the learning rate are *hyperparameters* of the model), updating
# the values of $\mathbf{p}$ as we go along:

epochs = 10_000
for i in 1:epochs
    𝐩 .-= η .* ∇f(X, Y, 𝐩[1] .* X .+ 𝐩[2])
end

# After the training epochs are done, we can get a look at the result (note that
# we use a ternary expression to decide how to report the sign of the
# elevation). We mostly care about the value of the loss function, and the value
# of the parameters:

"""
Best model: ŷ ≈ $(round(𝐩[1]; digits=2))x $(𝐩[2]<0 ? "" : "+") $(round(𝐩[2]; digits=2))
Loss: ℒ ≈ $(round(ℒ(𝐩[1] .* X .+ 𝐩[2], Y); digits=4))
""" |> println

# As always, visualisation provides a good sanity check of these results, and
# our line should now be much closer to the cloud of points:

lines!(
    scplot,
    [minimum(X), maximum(X)],
    (x) -> 𝐩[1] .* x .+ 𝐩[2];
    color = :tomato,
)
figure

# One noteworthy thing about this example is that building our own (admittedly
# not very general, and not very efficient) gradient descent optimizer was
# possible in a very small number of lines of code, and using only functions
# from *Julia*'s standard library. There are a lot of packages dedicated to
# performing this task extremely efficiently; but this example shows how we can
# easily get to a working solution, which is interesting both for experimenting
# with new approaches, and for learning new skills.