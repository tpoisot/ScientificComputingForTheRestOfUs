# ---
# title: Naive Bayes Classifier
# status: beta
# ---

# Naive Bayes Classifiers are formidable because they can learn so much about a
# dataset based on relatively scarce information. In this module, we will build
# one from scratch, using (mostly) methods from *Julia*'s standard library.

# <!--more-->

# The logic under Naive Bayes Classifiers (NBC) is really simple: there is a
# sample (an instance), defined by a series of values (the features), called
# $\mathbf{x}$. These values are 

# !!!WARNING As with all modules in this section, the point is not to give a
# throrough treatment of the algorithm. You can explore the many resources
# explaining how NBC works.

raw_seeds_file = download(
    "https://archive.ics.uci.edu/ml/" *
    "machine-learning-databases/00236/seeds_dataset.txt",
)

# The original dataset has a few issues, notably related to the fact that some
# rows have two tabulation characters where they should only have one. In order
# to correct this, we will replace every instance of `\t\t` with `\t`, then save
# and load the correct dataset -- do check out the documentation for `open` and
# `write` if you need a refresher on how they operate.

seeds_file = tempname()
open(seeds_file, "w") do f
    return write(f, replace(String(read(raw_seeds_file)), "\t\t" => "\t"))
end

# Now that we do have the dataset in a temporary file, we can use
# `DelimitedFiles` to load it, and specify that the field separator is `\t`:

using DelimitedFiles
seeds = readdlm(seeds_file, '\t')
seeds[1:3, :]

# The first seven columns are features, and the last column is the class. The
# features are well documented on the [dataset page][seedpage]. It does make
# sense to extract the features as their own matrix, and the classes as their
# own vector:

# [seedpage]: https://archive-beta.ics.uci.edu/ml/datasets/seeds

features = seeds[:, 1:(end - 1)];
classes = Int.(vec(seeds[:, end]));

# With this is mind, we can start thinking about the way to setup our
# distributions to build our NBC. We might fit the "correct" distribution for
# each instance. For the purpose of this exercise, we will simply assume that we
# can get a good summary distribution by assuming that we know the mean and
# standard deviation for each column (within each cultivar), and use a Normal
# distribution.

# !!!INFO The choice of the Normal distribution here can be motivated by the
# fact that, if we know $\mu$ and $\sigma$, this is the distribution with
# maximum entropy; in other words, it is an admission that we don't know a lot.

# We know the total number of dimensions, so we can initialize an empty array of
# `Normal{Float64` distributions:

using Distributions
D = Matrix{Normal{Float64}}(undef, size(features, 2), length(unique(classes)))
size(D)

# With this done, we can start updating the values of our Normal distributions:

using Statistics
for class in unique(classes)
    subfeatures = features[findall(isequal(class), classes), :]
    μ = mean(subfeatures; dims = 1)
    σ = std(subfeatures; dims = 1)
    for feature in 1:size(features, 2)
        D[feature, class] = Normal(μ[feature], σ[feature])
    end
end

# We can have a look at, *e.g.*, the first four features for the first cultivar:

D[1:4, 1]

# And just like this, we are *almost* ready to run our analysis. Recall from the
# very brief introduction to NBC that the point is to (i) measure the pdf of a
# point in the distribution of its feature within the class, (ii) multiply these
# values across features, and (iii) take the argmax across classes to get an
# answer.

# We can grab a point to test:

test_idx = rand(1:size(features, 1))
x = features[test_idx, :]
y = classes[test_idx]
println("Point $(test_idx) with class $(y)")

# We can check the score that we would get for this test point on class 3 with a
# really nifty one-liner:

pdf.(D[:, 3], x) |> prod

# In order to scale this to the entire matrix `D`, we can use the `mapslices`
# function, which will apply a function to slices of an array:

scores = vec(mapslices(d -> prod(pdf.(d, x)), D; dims = 1))

# These scores do not sum to one (because we do not really use the Bayes
# formula). In this situation, it is probably a good idea to pass the output
# through the softmax function:

softmax(v::Vector{T}) where {T <: Real} = exp.(v) ./ sum(exp.(v))
scores |> softmax

# Remember that the information we want to get is our argmax, which is to say:

scores |> softmax |> argmax

# The output of `argmax` is the predicted class of our sample.

# Of course, we can now perform this process on *all* points in the dataset.
# Before we do so, we will create a *confusion table*, in which we will track
# the predicted *v.* observed scores:

C = zeros(Int64, length(unique(classes)), length(unique(classes)))

# !!! WARNING **SOMETHING ABOUT TEST AND TRAIN AND HOW THIS IS NOT REAL
# VALIDATION** but also NBC works with summary statistics really well

# And we loop

for i in axes(features, 1)
    local x, y, scores
    x = features[i, :]
    y = classes[i]
    scores = vec(mapslices(d -> prod(pdf.(d, x)), D; dims = 1))
    ŷ = argmax(softmax(scores))
    C[y, ŷ] += 1
end

# We can check the performance of the NBC approach for this dataset:

C

# Check the accuracy

using LinearAlgebra
accuracy = sum(diag(C)) / sum(C)
println("Leave-One-Out (not really) accuracy: $(round(Int64, accuracy*100))%")