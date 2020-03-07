---
title: Neural network with Flux
slug: neuralnetwork
concepts:
   - control flow
   - working with files
packages:
   - Flux
   - CSV
   - DataFrames
   - Random
   - Statistics
contributors:
  - francisbanville
  - tpoisot
weight: 1
---

***short intro text goes here***

````julia
using Flux
import CSV
using DataFrames
using Random
using Statistics
````





The first thing we need to do is download our data, which we will store in our
local folder. The data are available from the [UCI Machine Learning
repository][uci]. To make sure that we do not download the dataset more often
than necessary, we will write a short function to download the dataset if it
doesn't exist, and if it exists, to return it as a data frame:

[uci]: https://archive.ics.uci.edu/ml/machine-learning-databases/00236/seeds_dataset.txt

````julia
function get_dataset(url, filename)
	if !isfile(filename)
		download(url, filename)
	end
	return dropmissing(CSV.read(filename; header=0, delim='\t'))
end
const seed_url = "https://archive.ics.uci.edu/ml/machine-learning-databases/00236/seeds_dataset.txt"
seeds = get_dataset(seed_url, "seeds.txt");
````



````julia
first(seeds, 3)
````



<table class="data-frame"><thead><tr><th></th><th>Column1</th><th>Column2</th><th>Column3</th><th>Column4</th><th>Column5</th><th>Column6</th><th>Column7</th><th>Column8</th></tr><tr><th></th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th></tr></thead><tbody><p>3 rows × 8 columns</p><tr><th>1</th><td>15.26</td><td>14.84</td><td>0.871</td><td>5.763</td><td>3.312</td><td>2.221</td><td>5.22</td><td>1.0</td></tr><tr><th>2</th><td>14.88</td><td>14.57</td><td>0.8811</td><td>5.554</td><td>3.333</td><td>1.018</td><td>4.956</td><td>1.0</td></tr><tr><th>3</th><td>14.29</td><td>14.09</td><td>0.905</td><td>5.291</td><td>3.337</td><td>2.699</td><td>4.825</td><td>1.0</td></tr></tbody></table>



Note that we rely on `dropmissing`, because the original dataset is not properly
formated, and some columns are delimited by more than one tabulation. These
malformed rows will be dropped.

At this point, our column names are not very informative - we can look up the
metadata for this dataset, and rename them as follows:

| Variable                | column | new name         |
| ----------------------- | ------ | ---------------- |
| area                    | 1      | `:area`          |
| perimeter               | 2      | `:perimeter`     |
| compactness             | 3      | `:compactness`   |
| length of kernel        | 4      | `:kernel_length` |
| width of kernel         | 5      | `:kernel_width`  |
| asymmetry coefficient   | 6      | `:asymmetry`     |
| length of kernel groove | 7      | `:kernel_groove` |
| cultivar (ID)           | 8      | `:cultivar`      |

````julia
rename!(seeds,
  [:Column1 => :area, :Column2 => :perimeter,
  :Column3 => :compactness, :Column4 => :kernel_length,
  :Column5 => :kernel_width, :Column6 => :asymmetry,
  :Column7 => :kernel_groove, :Column8 => :cultivar]
  )
seeds[1:5,:]
````



<table class="data-frame"><thead><tr><th></th><th>area</th><th>perimeter</th><th>compactness</th><th>kernel_length</th><th>kernel_width</th><th>asymmetry</th><th>kernel_groove</th><th>cultivar</th></tr><tr><th></th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th></tr></thead><tbody><p>5 rows × 8 columns</p><tr><th>1</th><td>15.26</td><td>14.84</td><td>0.871</td><td>5.763</td><td>3.312</td><td>2.221</td><td>5.22</td><td>1.0</td></tr><tr><th>2</th><td>14.88</td><td>14.57</td><td>0.8811</td><td>5.554</td><td>3.333</td><td>1.018</td><td>4.956</td><td>1.0</td></tr><tr><th>3</th><td>14.29</td><td>14.09</td><td>0.905</td><td>5.291</td><td>3.337</td><td>2.699</td><td>4.825</td><td>1.0</td></tr><tr><th>4</th><td>13.84</td><td>13.94</td><td>0.8955</td><td>5.324</td><td>3.379</td><td>2.259</td><td>4.805</td><td>1.0</td></tr><tr><th>5</th><td>16.14</td><td>14.99</td><td>0.9034</td><td>5.658</td><td>3.562</td><td>1.355</td><td>5.175</td><td>1.0</td></tr></tbody></table>



To ensure that our results will be consistent every time we run them, we will
set the initial state of our random number generator.

````julia
Random.seed!(42);
````





At this point, we still need to decide on how many samples will be used for
training, and how many will be used for testing. As usual, we will use 70% of
the dataset for training, and so we need to calculate how many samples this
amounts to.

````julia
n_training = convert(Int64, round(0.7*size(seeds, 1);digits=0))
````


````
139
````





Because the data set is ordered (by cultivar, specifically), we cannot simply
take the first 139 samples. Instead, we will shuffle the rows of our
dataframe, and take the first 139 of that:

````julia
seeds = seeds[shuffle(1:end), :]
first(seeds, 3)
````



<table class="data-frame"><thead><tr><th></th><th>area</th><th>perimeter</th><th>compactness</th><th>kernel_length</th><th>kernel_width</th><th>asymmetry</th><th>kernel_groove</th><th>cultivar</th></tr><tr><th></th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th></tr></thead><tbody><p>3 rows × 8 columns</p><tr><th>1</th><td>17.32</td><td>15.91</td><td>0.8599</td><td>6.064</td><td>3.403</td><td>3.824</td><td>5.922</td><td>2.0</td></tr><tr><th>2</th><td>17.08</td><td>15.38</td><td>0.9079</td><td>5.832</td><td>3.683</td><td>2.956</td><td>5.484</td><td>1.0</td></tr><tr><th>3</th><td>12.79</td><td>13.53</td><td>0.8786</td><td>5.224</td><td>3.054</td><td>5.483</td><td>4.958</td><td>3.0</td></tr></tbody></table>



We are now satistified about the fact that the dataset is aranged in a random
way. This means that we can split it into a training and testing component:

````julia
trn_set, tst_set = seeds[1:n_training, :], seeds[(n_training+1):end, :]
size(trn_set)
````


````
(139, 8)
````





The next step is to extract the features (information we use for classification)
and the labels (the categories to predict). Because our cultivar information is
stored as a floating point number, we must first one-hot encode it. As the
labels are initially randomly arranged, it is also very important to specificy
their order. For performance reasons, *Flux* requires that instances be stored
as columns in a matrix, so we will also need to transpose our data. Because this
will need to be done for both testing and training set, we can write a function:


````julia
function get_features_and_labels(data_set)
	features = transpose(convert(Matrix, data_set[!, Not(:cultivar)]))
	labels = Flux.onehotbatch(data_set.cultivar, sort(unique(data_set.cultivar)))
	return (features, labels)
end
````


````
get_features_and_labels (generic function with 1 method)
````





With this function, we do not need to type the same code twice to get our
training and testing sets correctly split:

````julia
trn_features, trn_labels = get_features_and_labels(trn_set);
tst_features, tst_labels = get_features_and_labels(tst_set);
````





As a starting point, we will use a simple neural network with one input layer,
containing one input neuron for every feature, and one output neuron for every
label, which will be densely connected. We will then apply the softmax function
to decide which label should be assigned. This is done using the following
syntax in *Flux*:

````julia
one_layer = Chain(
	Dense(size(trn_features,1), size(trn_labels,1)),
	softmax
	)
````


````
Chain(Dense(7, 3), softmax)
````





In order to train this network, we need to decide on an optimiser, which in our
case will be a gradient descent with a rate of learning of 0.01:

````julia
optimizer = Descent(0.01)
````


````
Flux.Optimise.Descent(0.01)
````





The final step is to decide on a loss function; for a classification problem, we
can usually start with cross entropy. This function will take a series of
features as a first input, and the expected labels as the second input.

````julia
loss(x, y) = Flux.crossentropy(one_layer(x), y)
````


````
loss (generic function with 1 method)
````





Before we start, we will wrap the data into an iterator, to repeat them for
every training epoch - we will start with 2000 training epochs:

````julia
data_iterator = Iterators.repeated((trn_features, trn_labels), 2000);
````





Once all of this set-up work is done, training the network is very
straightforward:

````julia
Flux.train!(loss, params(one_layer), data_iterator, optimizer)
````





As a first idea of the performance of this model, we might want to look at its
accuracy on the training set. Accuracy in this case is defined as the proportion
of correct guesses. To get the correct guesses, we need to one-cold our labels,
to transform them into a series of 1, 2, and 3 corresponding to the various
cultivars.

````julia
function accuracy(model, feat, labs)
	pred = Flux.onecold(model(feat))
	obsv = Flux.onecold(labs)
	return mean(pred .== obsv)
end
accuracy(one_layer, trn_features, trn_labels)
````


````
0.935251798561151
````





We can compare this to the testing set:

````julia
accuracy(one_layer, tst_features, tst_labels)
````


````
0.8833333333333333
````





This is a little bit lower, which is not necessarily surprising as we have used
a small dataset, a shallow network, raw input data, and a relatively modest
number of training epochs. We might now want to look at the confusin matrix for
this network:

````julia
function confusion_matrix(model, feat, labs)
  plb = Flux.onehotbatch(Flux.onecold(model(feat)), 1:3)
  labs * plb'
end
confusion_matrix(one_layer, tst_features, tst_labels)
````


````
3×3 Array{Int64,2}:
 16   1   2
  1  20   0
  3   0  17
````





A large majority of large values are on the diagonal, which corresponds to
correct predictions, but there are a few outside of the diagonal. To fix this,
we will try to complexify the network a little bit, maybe by adding a hidden
network, and changing the activation function of the first layer to a ReLU (the
default is to use a sigmoid):

````julia
hidden_size = 12
two_layers = Chain(
	Dense(size(trn_features,1), hidden_size, relu),
	Dense(hidden_size, size(trn_labels,1)),
  softmax
  )
````


````
Chain(Dense(7, 12, relu), Dense(12, 3), softmax)
````





We will re-define the loss function:

````julia
v2_loss(x, y) = Flux.crossentropy(two_layers(x), y)
````


````
v2_loss (generic function with 1 method)
````





And we can keep the data and optimiser as they are,

````julia
Flux.train!(v2_loss, params(two_layers), data_iterator, optimizer)
````





When the training is finished, we can also look at the accuracy on the training
and testing sets:

````julia
accuracy(two_layers, trn_features, trn_labels)
````


````
0.9424460431654677
````



````julia
accuracy(two_layers, tst_features, tst_labels)
````


````
0.9166666666666666
````





Let's summarize this information, by comparing the gain in accuracy when adding
one layer:




| Dataset  | One-layer model                | Two-layers model               | Change in accuracy                         |
| -------- | ------------------------------ | ------------------------------ | ------------------------------------------ |
| training | 0.935 | 0.942 | 0.007 |
| testing  | 0.883 | 0.917 | 0.033 |

We can confirm that the confusion matrix is also better, in that it has more
elements on the diagonal:

````julia
confusion_matrix(two_layers, tst_features, tst_labels)
````


````
3×3 Array{Int64,2}:
 17   1   1
  2  19   0
  1   0  19
````





For more information on neural networks and deep learning, we suggest the [free
online book of the same name][nndl], which has a lot of annotated code examples,
as well as information about the mathematics behind all of this.

[nndl]: http://neuralnetworksanddeeplearning.com/index.html
