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
   - graciellehigino
   - gabrieldansereau
weight: 2
draft: true
status: construction
---

In this capstone, we will implement a Naive Bayes classifier, to make
predictions about the cultivar to which wheat seeds belong. This is a
classification task, meaning that we want to get an answer that looks like
`class A` or `class B`, as opposed to a regression problem in which we would
like to get an answer like `length = 0.8cm`. At its core, Naive Bayes
classification assumes that the probability of belonging to a class based on a
single measurement is the probability that this value measures originates from
the distribution of know values for the class. For example, we know that the
road runner (*Tastyus supersonicus*) runs at a speed of 25.8 ± 1.2 mph, whereas
the coyote (*Eatius birdius*) runs at a speed of 21.5 ± 1.8 mph. If we measure
an unidentified animal going 24.6 mph in a area where coyotes are three quarters
of the total population, we can use NBC to get the probability that it is a
coyote or a roadrunner:

````julia
using Distributions

speed_coyote = Normal(21.5, 1.8)
speed_roadrunner = Normal(25.8, 1.2)
measured_speed = 24.6

P_roadrunner = 0.25 * pdf(speed_roadrunner, measured_speed)
P_coyote = 0.75 * pdf(speed_coyote, measured_speed)

[:roadrunner, :coyote][argmax([P_roadrunner, P_coyote])]
````


````
:roadrunner
````





The [Wikipedia page][nbcwp] has a very clear introduction to the theory, and we
will adhere to its notation here. In short, given an array $\mathbf{x}$ of
observations of multiple features, the probability ($p(C_k | x)$) that this
sample belongs to the class $C_k$ is *proportional* to $p(C_k) \prod p(x_i |
C_k)$. Further, we can get the class to which the sample should be assigned
using $\hat y = \text{argmax}_{k \in K} p(C_k) \prod p(x_i | C_k)$ - the class
that is the most probable is taken as the guess.

[nbcwp]:https://en.wikipedia.org/wiki/Naive_Bayes_classifier

Calculating $p(x_i | C_k)$ assumes that we know the distribution of the values
of the *i*-th variable in class $C_k$, which is not necessarily true. In this
example we will assume that all we know for sure is the average and standard
deviation, meaning that the distribution we will use should be a normal
distribution, which has the maximal entropy given the information available.

We will re-use the dataset from the [neural network with *Flux*][neuralnet]
capstone, and so we will skip over the details of how these data can be
downloaded:

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
Random.seed!(42);
seeds = seeds[shuffle(1:end), :]
first(seeds, 3)
````



<table class="data-frame"><thead><tr><th></th><th>area</th><th>perimeter</th><th>compactness</th><th>kernel_length</th><th>kernel_width</th><th>asymmetry</th><th>kernel_groove</th><th>cultivar</th></tr><tr><th></th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th></tr></thead><tbody><p>3 rows × 8 columns</p><tr><th>1</th><td>17.32</td><td>15.91</td><td>0.8599</td><td>6.064</td><td>3.403</td><td>3.824</td><td>5.922</td><td>2.0</td></tr><tr><th>2</th><td>17.08</td><td>15.38</td><td>0.9079</td><td>5.832</td><td>3.683</td><td>2.956</td><td>5.484</td><td>1.0</td></tr><tr><th>3</th><td>12.79</td><td>13.53</td><td>0.8786</td><td>5.224</td><td>3.054</td><td>5.483</td><td>4.958</td><td>3.0</td></tr></tbody></table>



To see how well our technique performs, we will split the dataset in two,
keeping 20 samples for the validation, and the rest to get information on the
distributions:

````julia
seeds = seeds[1:(end-20),:];
leftovers = seeds[(end-19):end,:];
````





As it is, our first task is to summarize the data in `seeds` in a table
containing, for every measure and every cultivar, the average and standard
deviation. The next steps will involve a fair amount of manipulations using the
`DataFrames` package, and it is a good idea to look at the documentation for the
various functions. Note that using a dataframe here is absolutely not required,
but in the process of shaping our data, we will use the most common
transformations.

Because we have *a lot* of variables, it is likely easier to reshape
the data to a long format:

````julia
long_seeds = stack(seeds, Not(:cultivar))
first(long_seeds, 3)
````



<table class="data-frame"><thead><tr><th></th><th>variable</th><th>value</th><th>cultivar</th></tr><tr><th></th><th>Symbol</th><th>Float64</th><th>Float64</th></tr></thead><tbody><p>3 rows × 3 columns</p><tr><th>1</th><td>area</td><td>17.32</td><td>2.0</td></tr><tr><th>2</th><td>area</td><td>17.08</td><td>1.0</td></tr><tr><th>3</th><td>area</td><td>12.79</td><td>3.0</td></tr></tbody></table>



We can now calculate the mean and standard deviation for all combinations of
variables and cultivars:

````julia
using Statistics
distribution_data = by(long_seeds, Not(:value), μ = :value => mean, σ = :value => std)
first(distribution_data, 3)
````



<table class="data-frame"><thead><tr><th></th><th>variable</th><th>cultivar</th><th>μ</th><th>σ</th></tr><tr><th></th><th>Symbol</th><th>Float64</th><th>Float64</th><th>Float64</th></tr></thead><tbody><p>3 rows × 4 columns</p><tr><th>1</th><td>area</td><td>2.0</td><td>18.3338</td><td>1.42026</td></tr><tr><th>2</th><td>area</td><td>1.0</td><td>14.312</td><td>1.15313</td></tr><tr><th>3</th><td>area</td><td>3.0</td><td>11.8672</td><td>0.722666</td></tr></tbody></table>



This is the sort of table one can find in a publication - in fact, the greatness
of Naive Bayes classification is that it can work even if you only have access
to the moments of the distribution, and not to the raw data themselves!

We now need to create statistical distributions from the information in this
table - in *Julia*, a dataframe can store just about any type of information,
so it is perfectly fine to store the object representing the normal distribution
for each variable and cultivar in a new column.

````julia
distribution_data.distribution = [Normal(row.μ, row.σ) for row in eachrow(distribution_data)]
````


````
21-element Array{Normal{Float64},1}:
 Normal{Float64}(μ=18.333809523809517, σ=1.4202583006456944)  
 Normal{Float64}(μ=14.312033898305087, σ=1.1531333320955184)  
 Normal{Float64}(μ=11.867192982456144, σ=0.7226655875150318)  
 Normal{Float64}(μ=16.139365079365078, σ=0.598993437994842)   
 Normal{Float64}(μ=14.279152542372882, σ=0.5509906067651469)  
 Normal{Float64}(μ=13.244912280701756, σ=0.3498832601587969)  
 Normal{Float64}(μ=0.8831063492063493, σ=0.015794955023635513)
 Normal{Float64}(μ=0.8807694915254234, σ=0.015726830294636812)
 Normal{Float64}(μ=0.849321052631579, σ=0.020734337779584246) 
 Normal{Float64}(μ=6.152365079365081, σ=0.2639895710053532)   
 ⋮                                                            
 Normal{Float64}(μ=3.6754603174603178, σ=0.18729800520757373) 
 Normal{Float64}(μ=3.2431694915254243, σ=0.17427625241734326) 
 Normal{Float64}(μ=2.8497543859649124, σ=0.140664657037041)   
 Normal{Float64}(μ=3.6029841269841265, σ=1.1826898605279395)  
 Normal{Float64}(μ=2.722477966101695, σ=1.1786889249278267)   
 Normal{Float64}(μ=4.724087719298246, σ=1.1998727355239114)   
 Normal{Float64}(μ=6.023619047619047, σ=0.2534568378710555)   
 Normal{Float64}(μ=5.078237288135592, σ=0.2448924703495358)   
 Normal{Float64}(μ=5.121754385964913, σ=0.16573508128311212)
````





Of course, this format is not ideal for what we're about to do (measure the
probability that a sample belongs to a class), so we will unstack it by cultivar
(this drops the `μ` and `σ` columns, but they are not needed anymore):

````julia
distributions = unstack(distribution_data, :cultivar, :variable, :distribution)
````



<table class="data-frame"><thead><tr><th></th><th>cultivar</th><th>area</th><th>asymmetry</th><th>compactness</th><th>kernel_groove</th><th>kernel_length</th><th>kernel_width</th><th>perimeter</th></tr><tr><th></th><th>Float64</th><th>Normal…⍰</th><th>Normal…⍰</th><th>Normal…⍰</th><th>Normal…⍰</th><th>Normal…⍰</th><th>Normal…⍰</th><th>Normal…⍰</th></tr></thead><tbody><p>3 rows × 8 columns</p><tr><th>1</th><td>1.0</td><td>Normal{Float64}(μ=14.312, σ=1.15313)</td><td>Normal{Float64}(μ=2.72248, σ=1.17869)</td><td>Normal{Float64}(μ=0.880769, σ=0.0157268)</td><td>Normal{Float64}(μ=5.07824, σ=0.244892)</td><td>Normal{Float64}(μ=5.50188, σ=0.224089)</td><td>Normal{Float64}(μ=3.24317, σ=0.174276)</td><td>Normal{Float64}(μ=14.2792, σ=0.550991)</td></tr><tr><th>2</th><td>2.0</td><td>Normal{Float64}(μ=18.3338, σ=1.42026)</td><td>Normal{Float64}(μ=3.60298, σ=1.18269)</td><td>Normal{Float64}(μ=0.883106, σ=0.015795)</td><td>Normal{Float64}(μ=6.02362, σ=0.253457)</td><td>Normal{Float64}(μ=6.15237, σ=0.26399)</td><td>Normal{Float64}(μ=3.67546, σ=0.187298)</td><td>Normal{Float64}(μ=16.1394, σ=0.598993)</td></tr><tr><th>3</th><td>3.0</td><td>Normal{Float64}(μ=11.8672, σ=0.722666)</td><td>Normal{Float64}(μ=4.72409, σ=1.19987)</td><td>Normal{Float64}(μ=0.849321, σ=0.0207343)</td><td>Normal{Float64}(μ=5.12175, σ=0.165735)</td><td>Normal{Float64}(μ=5.2374, σ=0.139699)</td><td>Normal{Float64}(μ=2.84975, σ=0.140665)</td><td>Normal{Float64}(μ=13.2449, σ=0.349883)</td></tr></tbody></table>



And with this information, we are ready to make a prediction. We will keep the
cultivar information from the `leftovers` dataset, and then remove it to
simulate what would happen if we had, for example, spilled all of our wheat
kernels and had to put them in the correct kernel bags.

````julia
true_cultivar = leftovers.cultivar
select!(leftovers, Not(:cultivar))
first(leftovers, 3)
````



<table class="data-frame"><thead><tr><th></th><th>area</th><th>perimeter</th><th>compactness</th><th>kernel_length</th><th>kernel_width</th><th>asymmetry</th><th>kernel_groove</th></tr><tr><th></th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th><th>Float64</th></tr></thead><tbody><p>3 rows × 7 columns</p><tr><th>1</th><td>17.36</td><td>15.76</td><td>0.8785</td><td>6.145</td><td>3.574</td><td>3.526</td><td>5.971</td></tr><tr><th>2</th><td>12.21</td><td>13.47</td><td>0.8453</td><td>5.357</td><td>2.893</td><td>1.661</td><td>5.178</td></tr><tr><th>3</th><td>16.19</td><td>15.16</td><td>0.8849</td><td>5.833</td><td>3.421</td><td>0.903</td><td>5.307</td></tr></tbody></table>



Let's take the first row. We want to get the probability of every observation being
taken from the distribution of this variable for every cultivar. The probability
that this sample comes from cultivar 2 knowing its area is:

````julia
pdf(distributions.area[2], leftovers.area[1])
````


````
0.22205286406535693
````





To do this for all samples, we will assign a unique `id` to our observations for
the test, and then stack both dataframes by variable;

````julia
leftovers.id = 1:size(leftovers,1)
s_leftovers = stack(leftovers, Not(:id))
s_distributions = stack(distributions, Not(:cultivar))
rename!(s_distributions, :value => :distribution)
````



<table class="data-frame"><thead><tr><th></th><th>variable</th><th>distribution</th><th>cultivar</th></tr><tr><th></th><th>Symbol</th><th>Normal…⍰</th><th>Float64</th></tr></thead><tbody><p>21 rows × 3 columns</p><tr><th>1</th><td>area</td><td>Normal{Float64}(μ=14.312, σ=1.15313)</td><td>1.0</td></tr><tr><th>2</th><td>area</td><td>Normal{Float64}(μ=18.3338, σ=1.42026)</td><td>2.0</td></tr><tr><th>3</th><td>area</td><td>Normal{Float64}(μ=11.8672, σ=0.722666)</td><td>3.0</td></tr><tr><th>4</th><td>asymmetry</td><td>Normal{Float64}(μ=2.72248, σ=1.17869)</td><td>1.0</td></tr><tr><th>5</th><td>asymmetry</td><td>Normal{Float64}(μ=3.60298, σ=1.18269)</td><td>2.0</td></tr><tr><th>6</th><td>asymmetry</td><td>Normal{Float64}(μ=4.72409, σ=1.19987)</td><td>3.0</td></tr><tr><th>7</th><td>compactness</td><td>Normal{Float64}(μ=0.880769, σ=0.0157268)</td><td>1.0</td></tr><tr><th>8</th><td>compactness</td><td>Normal{Float64}(μ=0.883106, σ=0.015795)</td><td>2.0</td></tr><tr><th>9</th><td>compactness</td><td>Normal{Float64}(μ=0.849321, σ=0.0207343)</td><td>3.0</td></tr><tr><th>10</th><td>kernel_groove</td><td>Normal{Float64}(μ=5.07824, σ=0.244892)</td><td>1.0</td></tr><tr><th>11</th><td>kernel_groove</td><td>Normal{Float64}(μ=6.02362, σ=0.253457)</td><td>2.0</td></tr><tr><th>12</th><td>kernel_groove</td><td>Normal{Float64}(μ=5.12175, σ=0.165735)</td><td>3.0</td></tr><tr><th>13</th><td>kernel_length</td><td>Normal{Float64}(μ=5.50188, σ=0.224089)</td><td>1.0</td></tr><tr><th>14</th><td>kernel_length</td><td>Normal{Float64}(μ=6.15237, σ=0.26399)</td><td>2.0</td></tr><tr><th>15</th><td>kernel_length</td><td>Normal{Float64}(μ=5.2374, σ=0.139699)</td><td>3.0</td></tr><tr><th>16</th><td>kernel_width</td><td>Normal{Float64}(μ=3.24317, σ=0.174276)</td><td>1.0</td></tr><tr><th>17</th><td>kernel_width</td><td>Normal{Float64}(μ=3.67546, σ=0.187298)</td><td>2.0</td></tr><tr><th>18</th><td>kernel_width</td><td>Normal{Float64}(μ=2.84975, σ=0.140665)</td><td>3.0</td></tr><tr><th>19</th><td>perimeter</td><td>Normal{Float64}(μ=14.2792, σ=0.550991)</td><td>1.0</td></tr><tr><th>20</th><td>perimeter</td><td>Normal{Float64}(μ=16.1394, σ=0.598993)</td><td>2.0</td></tr><tr><th>21</th><td>perimeter</td><td>Normal{Float64}(μ=13.2449, σ=0.349883)</td><td>3.0</td></tr></tbody></table>



These dataframes have one identical column (`:variable`), which we can use to
`join` them:

````julia
s_merged = join(s_leftovers, s_distributions, on=:variable)
first(s_merged, 3)
````



<table class="data-frame"><thead><tr><th></th><th>variable</th><th>value</th><th>id</th><th>distribution</th><th>cultivar</th></tr><tr><th></th><th>Symbol</th><th>Float64</th><th>Int64</th><th>Normal…⍰</th><th>Float64</th></tr></thead><tbody><p>3 rows × 5 columns</p><tr><th>1</th><td>area</td><td>17.36</td><td>1</td><td>Normal{Float64}(μ=14.312, σ=1.15313)</td><td>1.0</td></tr><tr><th>2</th><td>area</td><td>17.36</td><td>1</td><td>Normal{Float64}(μ=18.3338, σ=1.42026)</td><td>2.0</td></tr><tr><th>3</th><td>area</td><td>17.36</td><td>1</td><td>Normal{Float64}(μ=11.8672, σ=0.722666)</td><td>3.0</td></tr></tbody></table>



Finally, because we consider all variables independently, we can now get the
probability of every measurement coming from its appropriate distribution:

````julia
s_proba = by(s_merged, [:cultivar, :id, :variable],
	[:value, :distribution] =>  x -> (p = pdf.(x.distribution, x.value))
	)
rename!(s_proba, :x1 => :probability)
first(s_proba, 3)
````



<table class="data-frame"><thead><tr><th></th><th>cultivar</th><th>id</th><th>variable</th><th>probability</th></tr><tr><th></th><th>Float64</th><th>Int64</th><th>Symbol</th><th>Float64</th></tr></thead><tbody><p>3 rows × 4 columns</p><tr><th>1</th><td>1.0</td><td>1</td><td>area</td><td>0.0105178</td></tr><tr><th>2</th><td>2.0</td><td>1</td><td>area</td><td>0.222053</td></tr><tr><th>3</th><td>3.0</td><td>1</td><td>area</td><td>1.57414e-13</td></tr></tbody></table>



The very last step is to bring everything back together, and to multiply the
probabilities for every variable *within* every cultivar together, and get the
argmax (most probable class):

````julia
s_p = by(s_proba, [:cultivar, :id], p = :probability => prod)
s_argmax = by(s_p, :id, y = :p => argmax)
````



<table class="data-frame"><thead><tr><th></th><th>id</th><th>y</th></tr><tr><th></th><th>Int64</th><th>Int64</th></tr></thead><tbody><p>20 rows × 2 columns</p><tr><th>1</th><td>1</td><td>2</td></tr><tr><th>2</th><td>2</td><td>3</td></tr><tr><th>3</th><td>3</td><td>1</td></tr><tr><th>4</th><td>4</td><td>2</td></tr><tr><th>5</th><td>5</td><td>3</td></tr><tr><th>6</th><td>6</td><td>1</td></tr><tr><th>7</th><td>7</td><td>1</td></tr><tr><th>8</th><td>8</td><td>1</td></tr><tr><th>9</th><td>9</td><td>3</td></tr><tr><th>10</th><td>10</td><td>3</td></tr><tr><th>11</th><td>11</td><td>1</td></tr><tr><th>12</th><td>12</td><td>2</td></tr><tr><th>13</th><td>13</td><td>2</td></tr><tr><th>14</th><td>14</td><td>2</td></tr><tr><th>15</th><td>15</td><td>2</td></tr><tr><th>16</th><td>16</td><td>1</td></tr><tr><th>17</th><td>17</td><td>2</td></tr><tr><th>18</th><td>18</td><td>3</td></tr><tr><th>19</th><td>19</td><td>3</td></tr><tr><th>20</th><td>20</td><td>1</td></tr></tbody></table>



This leaves us with a column containing the class we guessed, and we can compare
it to the actual class to get the accuracy:

````julia
accuracy = mean(s_argmax.y .== true_cultivar)
````


````
0.95
````





Naive Bayes classifiers have uncanny accuracy on a lot of problems! This example
relies on dataframes to reach the answer, but of course it is a valuable
programming exercise to do it starting from a matrix of values.
