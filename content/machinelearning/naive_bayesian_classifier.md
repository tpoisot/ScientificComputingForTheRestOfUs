---
title: Neural Bayes classifier
slug: naivebayes
concepts:
  - control flow
  - working with files
  - iteration
  - grouping and aggregation
packages:
   - CSV
   - DataFrames
   - Random
   - Statistics
   - Distributions
contributors:
   - tpoisot
weight: 2
draft: true
status: construction
---

In this capstone, we will implement a Naive Bayes classifier, to make
predictions about the cultivar to which wheat seeds belong. This is the same
dataset used in the [neural network with *Flux*][neuralnet] example, and so we
will skip over the details of how to download the data:

[neuralnet]: {{< ref "/machinelearning/neural_network_flux.md" >}}

````julia
import CSV
using DataFrames

function get_dataset(url, filename)
	if !isfile(filename)
		download(url, filename)
	end
	return dropmissing(CSV.read(filename; header=0, delim='\t'))
end
const seed_url = "https://archive.ics.uci.edu/ml/machine-learning-databases/00236/seeds_dataset.txt"
seeds = get_dataset(seed_url, "seeds.txt");
````





As always, we will rename the columns to make it easier to reference them:

````julia
rename!(seeds,
  [:Column1 => :area, :Column2 => :perimeter,
  :Column3 => :compactness, :Column4 => :kernel_length,
  :Column5 => :kernel_width, :Column6 => :asymmetry,
  :Column7 => :kernel_groove, :Column8 => :cultivar]
  )

using Random
seeds = seeds[shuffle(1:end), :]
first(seeds, 3)
````



<table class="data-frame"><thead><tr><th></th><th>area</th><th>perimeter</th><th>compactness</th><th>kernel_length</th><th>kernel_width</th><th>asymmetry</th><th>kernel_groove</th><th>cultivar</th></tr><tr><th></th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th></tr></thead><tbody><p>3 rows × 8 columns</p><tr><th>1</th><td>12.73</td><td>13.75</td><td>0.8458</td><td>5.412</td><td>2.882</td><td>3.533</td><td>5.067</td><td>1.0</td></tr><tr><th>2</th><td>11.65</td><td>13.07</td><td>0.8575</td><td>5.108</td><td>2.85</td><td>5.209</td><td>5.135</td><td>3.0</td></tr><tr><th>3</th><td>13.16</td><td>13.55</td><td>0.9009</td><td>5.138</td><td>3.201</td><td>2.461</td><td>4.783</td><td>1.0</td></tr></tbody></table>



The task in which we are interested is to predict the cultivar to which a seeds
belong, by using Naive Bayes classification to use the distribution of
morphological features. At its core, Naive Bayes classification assumes that the
probability of belonging to a class based on a single measurement depends on the
probability of observing this measurement knowing the distribution for the
class, and that different mesaurements are independent. In short, this means
that the probability that a sample defined by an array $\mathbf{x}$ of
observations belongs to class $C_k$ is *proportional to* $p(C_k) \prod p(x_i |
C_k)$. Further, we can get the class to which the sample should be assigned
using $\hat y = \text{argmax}_{k \in K} p(C_k) \prod p(x_i | C_k)$.

Calculating $p(_i | C_k)$ assumes that we know the distribution of the values of
the *i*-th variable in class $C_k$ - this is not necessarily true, and in this
example we will assume that all we know for sure is the average and standard
deviation, meaning that the distribution we will use is a normal.

To see how well our technique performs, we will split the dataset in two,
keeping 10 samples for the validation:

````julia
seeds = seeds[1:(end-21),:];
leftovers = seeds[(end-20):end,:];
````





As it is, our first task is to summarize the data in `seeds` in a table
containing, for every measure and every cultivar, the average and standard
deviation. Because we have *a lot* of variables, it is likely easier to reshape the data to a long format:

````julia
long_seeds = stack(seeds, Not(:cultivar))
first(long_seeds, 3)
````



<table class="data-frame"><thead><tr><th></th><th>variable</th><th>value</th><th>cultivar</th></tr><tr><th></th><th>Symbol</th><th>Float64</th><th>Float64</th></tr></thead><tbody><p>3 rows × 3 columns</p><tr><th>1</th><td>area</td><td>12.73</td><td>1.0</td></tr><tr><th>2</th><td>area</td><td>11.65</td><td>3.0</td></tr><tr><th>3</th><td>area</td><td>13.16</td><td>1.0</td></tr></tbody></table>



We can now calculate the mean and standard deviation for all variable and
cultivar combinations:

````julia
using Statistics
distribution_data = by(long_seeds, Not(:value), μ = :value => mean, σ = :value => std)
first(distribution_data, 3)
````



<table class="data-frame"><thead><tr><th></th><th>variable</th><th>cultivar</th><th>μ</th><th>σ</th></tr><tr><th></th><th>Symbol</th><th>Float64</th><th>Float64</th><th>Float64</th></tr></thead><tbody><p>3 rows × 4 columns</p><tr><th>1</th><td>area</td><td>1.0</td><td>14.3497</td><td>1.22256</td></tr><tr><th>2</th><td>area</td><td>3.0</td><td>11.8802</td><td>0.730013</td></tr><tr><th>3</th><td>area</td><td>2.0</td><td>18.2762</td><td>1.37867</td></tr></tbody></table>



This is the sort of table one can find in a publication - in fact, the greatness
of Naive Bayes classification is that it can work if you only have access to the
moments of the distribution, and not to the raw data themselves!

We now need to create statistical distributions from the information in this
table - in *Julia*, a data frame can store just about any type of information,
so it is perfectly fine to store the object representing the normal distribution
for each variable and cultivar.

````julia
using Distributions
distribution_data.distribution = [Normal(row.μ, row.σ) for row in eachrow(distribution_data)]
````


````
21-element Array{Normal{Float64},1}:
 Normal{Float64}(μ=14.349655172413799, σ=1.222561253826875)   
 Normal{Float64}(μ=11.880161290322585, σ=0.7300134558281176)  
 Normal{Float64}(μ=18.276206896551724, σ=1.3786655480155208)  
 Normal{Float64}(μ=14.297758620689654, σ=0.581383839458949)   
 Normal{Float64}(μ=13.254193548387098, σ=0.34980345013762526) 
 Normal{Float64}(μ=16.127586206896552, σ=0.5757354117716019)  
 Normal{Float64}(μ=0.8805741379310345, σ=0.015879574879908036)
 Normal{Float64}(μ=0.8490580645161293, σ=0.020919906187194418)
 Normal{Float64}(μ=0.8816655172413795, σ=0.015609326403801011)
 Normal{Float64}(μ=5.504379310344827, σ=0.231089169968454)    
 ⋮                                                            
 Normal{Float64}(μ=3.250534482758621, σ=0.17514948157314597)  
 Normal{Float64}(μ=2.8520322580645163, σ=0.14503057537918532) 
 Normal{Float64}(μ=3.65898275862069, σ=0.18353712673598807)   
 Normal{Float64}(μ=2.6304000000000003, σ=1.219492817642114)   
 Normal{Float64}(μ=4.7935967741935475, σ=1.2528457895720606)  
 Normal{Float64}(μ=3.4840862068965506, σ=1.0989753646406795)  
 Normal{Float64}(μ=5.0807931034482765, σ=0.25513393514756877) 
 Normal{Float64}(μ=5.122919354838709, σ=0.1604192558642383)   
 Normal{Float64}(μ=6.031241379310346, σ=0.2296871488087409)
````





Of course, this format is not ideal for what we're about to do (measure the
probability that a sample belongs to a class), so we will unstack it (this drops
the `μ` and `σ` columns, but they are not needed anymore):

````julia
distributions = unstack(distribution_data, :cultivar, :variable, :distribution)
````



<table class="data-frame"><thead><tr><th></th><th>cultivar</th><th>area</th><th>asymmetry</th><th>compactness</th><th>kernel_groove</th><th>kernel_length</th><th>kernel_width</th><th>perimeter</th></tr><tr><th></th><th>Float64</th><th>Normal…⍰</th><th>Normal…⍰</th><th>Normal…⍰</th><th>Normal…⍰</th><th>Normal…⍰</th><th>Normal…⍰</th><th>Normal…⍰</th></tr></thead><tbody><p>3 rows × 8 columns</p><tr><th>1</th><td>1.0</td><td>Normal{Float64}(μ=14.3497, σ=1.22256)</td><td>Normal{Float64}(μ=2.6304, σ=1.21949)</td><td>Normal{Float64}(μ=0.880574, σ=0.0158796)</td><td>Normal{Float64}(μ=5.08079, σ=0.255134)</td><td>Normal{Float64}(μ=5.50438, σ=0.231089)</td><td>Normal{Float64}(μ=3.25053, σ=0.175149)</td><td>Normal{Float64}(μ=14.2978, σ=0.581384)</td></tr><tr><th>2</th><td>2.0</td><td>Normal{Float64}(μ=18.2762, σ=1.37867)</td><td>Normal{Float64}(μ=3.48409, σ=1.09898)</td><td>Normal{Float64}(μ=0.881666, σ=0.0156093)</td><td>Normal{Float64}(μ=6.03124, σ=0.229687)</td><td>Normal{Float64}(μ=6.15771, σ=0.245234)</td><td>Normal{Float64}(μ=3.65898, σ=0.183537)</td><td>Normal{Float64}(μ=16.1276, σ=0.575735)</td></tr><tr><th>3</th><td>3.0</td><td>Normal{Float64}(μ=11.8802, σ=0.730013)</td><td>Normal{Float64}(μ=4.7936, σ=1.25285)</td><td>Normal{Float64}(μ=0.849058, σ=0.0209199)</td><td>Normal{Float64}(μ=5.12292, σ=0.160419)</td><td>Normal{Float64}(μ=5.23544, σ=0.135838)</td><td>Normal{Float64}(μ=2.85203, σ=0.145031)</td><td>Normal{Float64}(μ=13.2542, σ=0.349803)</td></tr></tbody></table>



And with this information, we are ready to make a prediction. We will keep the
cultivar information from the `leftovers` dataset, and then remove it to
simulate what would happen if we had, for example, spilled all of our wheat
kernels and had to put them in the correct kernel bags.

````julia
true_cultivar = leftovers.cultivar
select!(leftovers, Not(:cultivar))
first(leftovers, 3)
````



<table class="data-frame"><thead><tr><th></th><th>area</th><th>perimeter</th><th>compactness</th><th>kernel_length</th><th>kernel_width</th><th>asymmetry</th><th>kernel_groove</th></tr><tr><th></th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th></tr></thead><tbody><p>3 rows × 7 columns</p><tr><th>1</th><td>15.69</td><td>14.75</td><td>0.9058</td><td>5.527</td><td>3.514</td><td>1.599</td><td>5.046</td></tr><tr><th>2</th><td>15.38</td><td>14.9</td><td>0.8706</td><td>5.884</td><td>3.268</td><td>4.462</td><td>5.795</td></tr><tr><th>3</th><td>18.36</td><td>16.52</td><td>0.8452</td><td>6.666</td><td>3.485</td><td>4.933</td><td>6.448</td></tr></tbody></table>



Let's take the first row. We want to get the probability of every variable being
take from the distribution of this variable for every cultivar. The probability
that this sample comes from cultivar 2 knowing its  area is:

````julia
pdf(distributions.area[2], leftovers.area[1])
````


````
0.049811385342673334
````





At this point, it might be faster to transform our table of distributions into a
matrix:

````julia
d_m = convert(Matrix, select(distributions, names(leftovers)))
````


````
3×7 Array{Union{Missing, Normal{Float64}},2}:
 Normal{Float64}(μ=14.3497, σ=1.22256)   …  Normal{Float64}(μ=5.08079, σ=0.
255134)
 Normal{Float64}(μ=18.2762, σ=1.37867)      Normal{Float64}(μ=6.03124, σ=0.
229687)
 Normal{Float64}(μ=11.8802, σ=0.730013)     Normal{Float64}(μ=5.12292, σ=0.
160419)
````



````julia
d_1 = collect(leftovers[5,:])
argmax(vec(prod(mapslices(f -> pdf.(f, d_1), d_m, dims=2); dims=2)))
````


````
2
````



````julia
leftovers.id = 1:size(leftovers,1)
s_leftovers = stack(leftovers, Not(:id))
s_distributions = stack(distributions, Not(:cultivar))
rename!(s_distributions, :value => :distribution)

s_merged = join(s_leftovers, s_distributions, on=:variable)
first(s_merged, 3)
````



<table class="data-frame"><thead><tr><th></th><th>variable</th><th>value</th><th>id</th><th>distribution</th><th>cultivar</th></tr><tr><th></th><th>Symbol</th><th>Float64</th><th>Int64</th><th>Normal…⍰</th><th>Float64</th></tr></thead><tbody><p>3 rows × 5 columns</p><tr><th>1</th><td>area</td><td>15.69</td><td>1</td><td>Normal{Float64}(μ=14.3497, σ=1.22256)</td><td>1.0</td></tr><tr><th>2</th><td>area</td><td>15.69</td><td>1</td><td>Normal{Float64}(μ=18.2762, σ=1.37867)</td><td>2.0</td></tr><tr><th>3</th><td>area</td><td>15.69</td><td>1</td><td>Normal{Float64}(μ=11.8802, σ=0.730013)</td><td>3.0</td></tr></tbody></table>

````julia
s_proba = by(s_merged, [:cultivar, :id, :variable],
	[:value, :distribution] =>  x -> (p = pdf.(x.distribution, x.value))
	)
first(s_proba, 3)
````



<table class="data-frame"><thead><tr><th></th><th>cultivar</th><th>id</th><th>variable</th><th>x1</th></tr><tr><th></th><th>Float64</th><th>Int64</th><th>Symbol</th><th>Float64</th></tr></thead><tbody><p>3 rows × 4 columns</p><tr><th>1</th><td>1.0</td><td>1</td><td>area</td><td>0.178911</td></tr><tr><th>2</th><td>2.0</td><td>1</td><td>area</td><td>0.0498114</td></tr><tr><th>3</th><td>3.0</td><td>1</td><td>area</td><td>6.65651e-7</td></tr></tbody></table>

````julia
s_p = by(s_proba, [:cultivar, :id], p = :x1 => prod)
s_argmax = by(s_p, :id, y = :p => argmax)
````



<table class="data-frame"><thead><tr><th></th><th>id</th><th>y</th></tr><tr><th></th><th>Int64</th><th>Int64</th></tr></thead><tbody><p>21 rows × 2 columns</p><tr><th>1</th><td>1</td><td>1</td></tr><tr><th>2</th><td>2</td><td>1</td></tr><tr><th>3</th><td>3</td><td>2</td></tr><tr><th>4</th><td>4</td><td>3</td></tr><tr><th>5</th><td>5</td><td>2</td></tr><tr><th>6</th><td>6</td><td>1</td></tr><tr><th>7</th><td>7</td><td>3</td></tr><tr><th>8</th><td>8</td><td>3</td></tr><tr><th>9</th><td>9</td><td>3</td></tr><tr><th>10</th><td>10</td><td>2</td></tr><tr><th>11</th><td>11</td><td>2</td></tr><tr><th>12</th><td>12</td><td>3</td></tr><tr><th>13</th><td>13</td><td>2</td></tr><tr><th>14</th><td>14</td><td>1</td></tr><tr><th>15</th><td>15</td><td>2</td></tr><tr><th>16</th><td>16</td><td>1</td></tr><tr><th>17</th><td>17</td><td>1</td></tr><tr><th>18</th><td>18</td><td>2</td></tr><tr><th>19</th><td>19</td><td>1</td></tr><tr><th>20</th><td>20</td><td>3</td></tr><tr><th>21</th><td>21</td><td>2</td></tr></tbody></table>



finally, accuracy

````julia
mean(s_argmax.y .== true_cultivar)
````


````
0.8571428571428571
````


