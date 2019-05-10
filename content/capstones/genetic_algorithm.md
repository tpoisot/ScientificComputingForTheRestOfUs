---
title: Genetic algorithm
weight: 1
status: draft
packages:
  - StatsPlots
  - StatsKit
  - Statistics
concepts:
  - data frames
  - generic code
  - type system
---

Genetic algorithm is a heuristic that takes heavy inspiration from evolutionary
biology, to explore a space of parameters rapidly and converge to an optimum.
Every solution is a "genome", and the combinations can undergo mutation and
recombination. By simulating a process of reproduction, over sufficiently many
generation, this heuristic usually gives very good results. It is also simple to
implement, and this is what we will do!

A genetic algorithm works by measuring the fitness of a solution (*i.e.* its fit
to a problem we have defined). We can then pick solution for "reproduction",
which involves recombination at various points in the "genome", and finally a
step for the mutation of offspring. There are an almost infinite number of
variations at each of these steps, but we will limit ourselves to a simple case
here.

Specifically, we will use the `DataFrames` and `CSV` package (installed in
`StatsKit`) to read a table containing metabolic rates of species, and then use
genetic algorithm to try and find out the scaling exponent linking mass to the
field metabolic rate.

[Source of data](https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/1365-2656.12086)

````julia
using StatsKit
using StatsPlots
url = "http://sciencecomputing.io/data/metabolicrates.csv"
tmp = download(url)
rates = CSV.read(tmp)
rates[1:5,:]
````



<table class="data-frame"><thead><tr><th></th><th>Class</th><th>Order</th><th>Family</th><th>Genus</th><th>Species</th><th>Study</th><th>M (kg)</th><th>FMR (kJ / day)</th></tr><tr><th></th><th>String</th><th>String</th><th>String</th><th>String</th><th>String</th><th>String</th><th>Float64</th><th>Float64</th></tr></thead><tbody><p>5 rows × 8 columns</p><tr><th>1</th><td>Mammalia</td><td>Carnivora</td><td>Odobenidae</td><td>Odobenus</td><td>rosmarus</td><td>Acquarone et al 2006</td><td>1370.0</td><td>345000.0</td></tr><tr><th>2</th><td>Mammalia</td><td>Carnivora</td><td>Odobenidae</td><td>Odobenus</td><td>rosmarus</td><td>Acquarone et al 2006</td><td>1250.0</td><td>417400.0</td></tr><tr><th>3</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>7.4</td><td>3100.0</td></tr><tr><th>4</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>6.95</td><td>2898.0</td></tr><tr><th>5</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>8.9</td><td>3528.0</td></tr></tbody></table>



Let's have a look at the names of the columns:

````julia
names(rates)
````


````
8-element Array{Symbol,1}:
 :Class                  
 :Order                  
 :Family                 
 :Genus                  
 :Species                
 :Study                  
 Symbol("M (kg)")        
 Symbol("FMR (kJ / day)")
````





We will replace the last two names:

````julia
rename!(rates, names(rates)[end-1] => :mass)
rename!(rates, names(rates)[end] => :fmr)
rates = rates[rates[:mass].<1e3,:]
rates[1:10,:]
````



<table class="data-frame"><thead><tr><th></th><th>Class</th><th>Order</th><th>Family</th><th>Genus</th><th>Species</th><th>Study</th><th>mass</th><th>fmr</th></tr><tr><th></th><th>String</th><th>String</th><th>String</th><th>String</th><th>String</th><th>String</th><th>Float64</th><th>Float64</th></tr></thead><tbody><p>10 rows × 8 columns</p><tr><th>1</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>7.4</td><td>3100.0</td></tr><tr><th>2</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>6.95</td><td>2898.0</td></tr><tr><th>3</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>8.9</td><td>3528.0</td></tr><tr><th>4</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>9.6</td><td>3881.0</td></tr><tr><th>5</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>9.4</td><td>3830.0</td></tr><tr><th>6</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>9.3</td><td>4284.0</td></tr><tr><th>7</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>9.35</td><td>3906.0</td></tr><tr><th>8</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>8.15</td><td>2386.0</td></tr><tr><th>9</th><td>Aves</td><td>Procellariiformes</td><td>Diomedeidae</td><td>Diomedea</td><td>exulans</td><td>Adams et al 1986</td><td>6.7</td><td>2374.0</td></tr><tr><th>10</th><td>Mammalia</td><td>Carnivora</td><td>Otariidae</td><td>Arctocephalus</td><td>gazella</td><td>Arnould et al 1996</td><td>32.75</td><td>17430.3</td></tr></tbody></table>



Much better! Now let's try to figure out the relationship between the last two
variables:

````julia
scatter(rates[:mass], rates[:fmr], c=:teal, leg=false, msc=:transparent)
xaxis!(:log10, "Mass (kg)")
yaxis!(:log10, "Field Metabolic Rate (kj per day)")
````


{{< figure src="../figures/genetic_algorithm_4_1.png" title="Relationship between field metabolic rate and mass - this is a neat log-log relationship, and so linear regression will give us the exponent."  >}}


Neat! This is a log-log relationship, so we can represent this problem as:

$$\text{log}{10}(\text{FMR}) \propto m\times\text{log}_{10}(\text{M})+b$$

To simplify the problem a little bit, we will average the values within species;
because the relation is log-log, we will average the log of the value (as
opposed to taking the log of the averages).

````julia
rates = by(rates, [:Genus, :Species], [:mass, :fmr] => x -> (mass=mean(log10.(x.mass)), fmr=mean(log10.(x.fmr))))
````



<table class="data-frame"><thead><tr><th></th><th>Genus</th><th>Species</th><th>mass</th><th>fmr</th></tr><tr><th></th><th>String</th><th>String</th><th>Float64</th><th>Float64</th></tr></thead><tbody><p>132 rows × 4 columns</p><tr><th>1</th><td>Diomedea</td><td>exulans</td><td>0.952967</td><td>3.35304</td></tr><tr><th>2</th><td>Arctocephalus</td><td>gazella</td><td>1.53131</td><td>4.32877</td></tr><tr><th>3</th><td>Sula</td><td>sula</td><td>0.0263231</td><td>3.07421</td></tr><tr><th>4</th><td>Macrotus</td><td>californicus</td><td>-1.88828</td><td>1.33622</td></tr><tr><th>5</th><td>Microtus</td><td>pennsylvanicus</td><td>-1.44936</td><td>1.9947</td></tr><tr><th>6</th><td>Tarsipes</td><td>rostratus</td><td>-2.04591</td><td>1.43081</td></tr><tr><th>7</th><td>Muscicapa</td><td>striata</td><td>-1.84164</td><td>1.71799</td></tr><tr><th>8</th><td>Parus</td><td>major</td><td>-1.74771</td><td>1.98197</td></tr><tr><th>9</th><td>Turdus</td><td>merula</td><td>-1.01773</td><td>2.256</td></tr><tr><th>10</th><td>Hirundo</td><td>tahitica</td><td>-1.85214</td><td>1.86032</td></tr><tr><th>11</th><td>Merops</td><td>viridis</td><td>-1.4707</td><td>1.88447</td></tr><tr><th>12</th><td>Sciurus</td><td>carolinensis</td><td>-0.234011</td><td>2.74503</td></tr><tr><th>13</th><td>Tachycineta</td><td>bicolor</td><td>-1.72656</td><td>2.02483</td></tr><tr><th>14</th><td>Uria</td><td>aalge</td><td>-0.0270878</td><td>3.24895</td></tr><tr><th>15</th><td>Poecile</td><td>cincta</td><td>-1.89461</td><td>1.70534</td></tr><tr><th>16</th><td>Poecile</td><td>montanus</td><td>-1.94412</td><td>1.63366</td></tr><tr><th>17</th><td>Myrmecobius</td><td>fasciatus</td><td>-0.317247</td><td>2.41855</td></tr><tr><th>18</th><td>Phocarctos</td><td>hookeri</td><td>2.05169</td><td>4.72295</td></tr><tr><th>19</th><td>Thalassarche</td><td>chrysostoma</td><td>0.563635</td><td>3.37201</td></tr><tr><th>20</th><td>Arctocephalus</td><td>galapagoensis</td><td>1.55174</td><td>3.61429</td></tr><tr><th>21</th><td>Eudyptula</td><td>minor</td><td>0.0364043</td><td>2.90196</td></tr><tr><th>22</th><td>Meleagris</td><td>gallopavo</td><td>0.645128</td><td>3.18936</td></tr><tr><th>23</th><td>Aplodontia</td><td>rufa</td><td>-0.145026</td><td>3.15469</td></tr><tr><th>24</th><td>Pygoscelis</td><td>adeliae</td><td>0.603158</td><td>3.59675</td></tr><tr><th>25</th><td>Lanius</td><td>excubitor</td><td>-1.20904</td><td>2.04835</td></tr><tr><th>26</th><td>Lontra</td><td>canadensis</td><td>0.892097</td><td>3.65534</td></tr><tr><th>27</th><td>Lepilemur</td><td>ruficaudatus</td><td>-0.149247</td><td>2.63522</td></tr><tr><th>28</th><td>Troglodytes</td><td>aedon</td><td>-2.01739</td><td>1.4347</td></tr><tr><th>29</th><td>Haliaeetus</td><td>leucocephalus</td><td>0.602276</td><td>3.37909</td></tr><tr><th>30</th><td>Phascolarctos</td><td>cinereus</td><td>0.908989</td><td>3.21824</td></tr><tr><th>31</th><td>Cinclus</td><td>cinclus</td><td>-1.20855</td><td>2.29673</td></tr><tr><th>32</th><td>Lasiorhinus</td><td>krefftii</td><td>1.44413</td><td>3.5773</td></tr><tr><th>33</th><td>Lasiorhinus</td><td>latifrons</td><td>1.38097</td><td>3.70967</td></tr><tr><th>34</th><td>Vombatus</td><td>ursinus</td><td>1.51603</td><td>3.78164</td></tr><tr><th>35</th><td>Carollia</td><td>perspicillata</td><td>-1.71068</td><td>1.88646</td></tr><tr><th>36</th><td>Petauroides</td><td>volans</td><td>0.00753945</td><td>2.72367</td></tr><tr><th>37</th><td>Fulmarus</td><td>glacialis</td><td>-0.126472</td><td>3.10663</td></tr><tr><th>38</th><td>Rissa</td><td>tridactyla</td><td>-0.420975</td><td>2.92362</td></tr><tr><th>39</th><td>Alle</td><td>alle</td><td>-0.784829</td><td>2.83927</td></tr><tr><th>40</th><td>Vulpes</td><td>cana</td><td>0.0</td><td>2.82607</td></tr><tr><th>41</th><td>Syconycteris</td><td>australis</td><td>-1.76277</td><td>1.88305</td></tr><tr><th>42</th><td>Martes</td><td>americana</td><td>-0.0171296</td><td>2.90197</td></tr><tr><th>43</th><td>Callipepla</td><td>gambelii</td><td>-0.844064</td><td>1.95387</td></tr><tr><th>44</th><td>Rangifer</td><td>tarandus</td><td>1.78472</td><td>4.19983</td></tr><tr><th>45</th><td>Tachyglossus</td><td>aculeatus</td><td>0.492571</td><td>2.79445</td></tr><tr><th>46</th><td>Arvicola</td><td>amphibius</td><td>-1.08329</td><td>2.13</td></tr><tr><th>47</th><td>Cervus</td><td>elaphus</td><td>2.03136</td><td>4.40097</td></tr><tr><th>48</th><td>Ptychoramphus</td><td>aleuticus</td><td>-0.760601</td><td>2.61139</td></tr><tr><th>49</th><td>Falco</td><td>tinnunculus</td><td>-0.72375</td><td>2.54676</td></tr><tr><th>50</th><td>Phalacrocorax</td><td>carbo</td><td>0.324477</td><td>3.31983</td></tr><tr><th>51</th><td>Sterna</td><td>hirundo</td><td>-0.887319</td><td>2.54728</td></tr><tr><th>52</th><td>Aptenodytes</td><td>patagonicus</td><td>1.12795</td><td>3.92474</td></tr><tr><th>53</th><td>Cavia</td><td>magna</td><td>-0.311605</td><td>2.61032</td></tr><tr><th>54</th><td>Phyllostomus</td><td>hastatus</td><td>-1.1178</td><td>2.1106</td></tr><tr><th>55</th><td>Cepphus</td><td>grylle</td><td>-0.42255</td><td>2.9141</td></tr><tr><th>56</th><td>Oenanthe</td><td>oenanthe</td><td>-1.6138</td><td>1.9516</td></tr><tr><th>57</th><td>Ficedula</td><td>hypoleuca</td><td>-1.87544</td><td>1.82567</td></tr><tr><th>58</th><td>Lophophanes</td><td>cristatus</td><td>-1.95587</td><td>1.60564</td></tr><tr><th>59</th><td>Periparus</td><td>ater</td><td>-2.02337</td><td>1.67074</td></tr><tr><th>60</th><td>Ficedula</td><td>albicollis</td><td>-1.79852</td><td>1.89268</td></tr><tr><th>61</th><td>Arenaria</td><td>interpres</td><td>-0.969918</td><td>2.54153</td></tr><tr><th>62</th><td>Calidris</td><td>canutus</td><td>-0.847682</td><td>2.52832</td></tr><tr><th>63</th><td>Petrogale</td><td>lateralis</td><td>0.343409</td><td>2.78533</td></tr><tr><th>64</th><td>Alouatta</td><td>palliata</td><td>0.789046</td><td>3.3366</td></tr><tr><th>65</th><td>Bradypus</td><td>variegatus</td><td>0.618408</td><td>2.79541</td></tr><tr><th>66</th><td>Petaurus</td><td>breviceps</td><td>-0.923658</td><td>2.1996</td></tr><tr><th>67</th><td>Spheniscus</td><td>demersus</td><td>0.498371</td><td>3.28511</td></tr><tr><th>68</th><td>Sminthopsis</td><td>crassicaudata</td><td>-1.77992</td><td>1.81188</td></tr><tr><th>69</th><td>Macropus</td><td>eugenii</td><td>0.665677</td><td>3.0799</td></tr><tr><th>70</th><td>Setonix</td><td>brachyurus</td><td>0.269277</td><td>2.71932</td></tr><tr><th>71</th><td>Macropus</td><td>giganteus</td><td>1.60763</td><td>3.88978</td></tr><tr><th>72</th><td>Odocoileus</td><td>hemionus</td><td>1.64843</td><td>4.41821</td></tr><tr><th>73</th><td>Thylogale</td><td>billardierii</td><td>0.697758</td><td>3.1524</td></tr><tr><th>74</th><td>Isoodon</td><td>obesulus</td><td>0.0732698</td><td>2.78976</td></tr><tr><th>75</th><td>Macronectes</td><td>giganteus</td><td>0.592092</td><td>3.62064</td></tr><tr><th>76</th><td>Oceanites</td><td>oceanicus</td><td>-1.37071</td><td>2.13575</td></tr><tr><th>77</th><td>Sorex</td><td>araneus</td><td>-2.0876</td><td>1.7285</td></tr><tr><th>78</th><td>Lemmus</td><td>sibiricus</td><td>-1.26134</td><td>2.30164</td></tr><tr><th>79</th><td>Calidris</td><td>alba</td><td>-1.23165</td><td>2.35721</td></tr><tr><th>80</th><td>Calidris</td><td>alpina</td><td>-1.28936</td><td>2.33587</td></tr><tr><th>81</th><td>Calidris</td><td>fuscicollis</td><td>-1.40894</td><td>2.27784</td></tr><tr><th>82</th><td>Calidris</td><td>maritima</td><td>-1.10237</td><td>2.48813</td></tr><tr><th>83</th><td>Calidris</td><td>minuta</td><td>-1.56839</td><td>2.18926</td></tr><tr><th>84</th><td>Charadrius</td><td>hiaticula</td><td>-1.24803</td><td>2.33927</td></tr><tr><th>85</th><td>Stercorarius</td><td>longicaudus</td><td>-0.477163</td><td>2.80128</td></tr><tr><th>86</th><td>Pongo</td><td>pygmaeus</td><td>1.73488</td><td>3.82576</td></tr><tr><th>87</th><td>Archilochus</td><td>alexandri</td><td>-2.43933</td><td>1.49593</td></tr><tr><th>88</th><td>Lampornis</td><td>clemenciae</td><td>-2.0576</td><td>1.90898</td></tr><tr><th>89</th><td>Calypte</td><td>anna</td><td>-2.35079</td><td>1.40107</td></tr><tr><th>90</th><td>Peromyscus</td><td>leucopus</td><td>-1.72836</td><td>1.54374</td></tr><tr><th>91</th><td>Tamias</td><td>striatus</td><td>-1.0171</td><td>2.15396</td></tr><tr><th>92</th><td>Lama</td><td>glama</td><td>1.67816</td><td>4.14529</td></tr><tr><th>93</th><td>Microcebus</td><td>murinus</td><td>-1.22088</td><td>1.93983</td></tr><tr><th>94</th><td>Eremitalpa</td><td>granti</td><td>-1.68881</td><td>1.08193</td></tr><tr><th>95</th><td>Lepus</td><td>americanus</td><td>0.129663</td><td>2.99048</td></tr><tr><th>96</th><td>Eulemur</td><td>fulvus</td><td>0.244134</td><td>2.76885</td></tr><tr><th>97</th><td>Lemur</td><td>catta</td><td>0.351411</td><td>2.7824</td></tr><tr><th>98</th><td>Pachyptila</td><td>desolata</td><td>-0.829592</td><td>2.58797</td></tr><tr><th>99</th><td>Lagopus</td><td>leucura</td><td>-0.437492</td><td>2.50162</td></tr><tr><th>100</th><td>Phalaenoptilus</td><td>nuttallii</td><td>-1.29706</td><td>1.70634</td></tr><tr><th>101</th><td>Haematopus</td><td>moquini</td><td>-0.789592</td><td>2.40994</td></tr><tr><th>102</th><td>Progne</td><td>subis</td><td>-1.31028</td><td>2.18747</td></tr><tr><th>103</th><td>Sterna</td><td>paradisaea</td><td>-0.995787</td><td>2.50212</td></tr><tr><th>104</th><td>Carollia</td><td>brevicauda</td><td>-2.06255</td><td>1.65596</td></tr><tr><th>105</th><td>Glossophaga</td><td>commissarisi</td><td>-1.74031</td><td>1.69231</td></tr><tr><th>106</th><td>Anoura</td><td>caudifer</td><td>-1.94013</td><td>1.71861</td></tr><tr><th>107</th><td>Aepyprymnus</td><td>rufescens</td><td>0.462762</td><td>3.1657</td></tr><tr><th>108</th><td>Phainopepla</td><td>nitens</td><td>-1.63958</td><td>1.91648</td></tr><tr><th>109</th><td>Estrilda</td><td>troglodytes</td><td>-2.17289</td><td>1.73803</td></tr><tr><th>110</th><td>Cormobates</td><td>leucophaea</td><td>-1.62525</td><td>1.91062</td></tr><tr><th>111</th><td>Malurus</td><td>cyaneus</td><td>-2.08355</td><td>1.53313</td></tr><tr><th>112</th><td>Chalybura</td><td>urochrysia</td><td>-2.14388</td><td>1.76283</td></tr><tr><th>113</th><td>Thalurania</td><td>colombica</td><td>-2.30908</td><td>1.57307</td></tr><tr><th>114</th><td>Melanerpes</td><td>formicivorus</td><td>-1.08525</td><td>2.28282</td></tr><tr><th>115</th><td>Acanthorhynchus</td><td>tenuirostris</td><td>-2.01175</td><td>1.72053</td></tr><tr><th>116</th><td>Phylidonyris</td><td>novaehollandiae</td><td>-1.76596</td><td>1.85745</td></tr><tr><th>117</th><td>Phylidonyris</td><td>pyrrhopterus</td><td>-1.83565</td><td>1.88024</td></tr><tr><th>118</th><td>Strix</td><td>occidentalis</td><td>-0.238742</td><td>2.34967</td></tr><tr><th>119</th><td>Hirundo</td><td>rustica</td><td>-1.68825</td><td>2.08131</td></tr><tr><th>120</th><td>Passerculus</td><td>sandwichensis</td><td>-1.73181</td><td>1.88349</td></tr><tr><th>121</th><td>Nectarinia</td><td>violacea</td><td>-2.02082</td><td>1.81744</td></tr><tr><th>122</th><td>Philetairus</td><td>socius</td><td>-1.5948</td><td>1.67894</td></tr><tr><th>123</th><td>Barnardius</td><td>zonarius</td><td>-0.842978</td><td>2.2647</td></tr><tr><th>124</th><td>Eolophus</td><td>roseicapilla</td><td>-0.508404</td><td>2.5507</td></tr><tr><th>125</th><td>Melopsittacus</td><td>undulatus</td><td>-1.55492</td><td>1.76729</td></tr><tr><th>126</th><td>Neophema</td><td>petrophila</td><td>-1.20204</td><td>2.02572</td></tr><tr><th>127</th><td>Struthio</td><td>camelus</td><td>1.78542</td><td>4.21025</td></tr><tr><th>128</th><td>Geophaps</td><td>plumifera</td><td>-1.06363</td><td>1.85031</td></tr><tr><th>129</th><td>Proteles</td><td>cristata</td><td>0.905457</td><td>3.35049</td></tr><tr><th>130</th><td>Oryx</td><td>leucoryx</td><td>1.91921</td><td>4.1819</td></tr><tr><th>131</th><td>Vulpes</td><td>rueppellii</td><td>0.240031</td><td>2.98299</td></tr><tr><th>132</th><td>Vulpes</td><td>vulpes</td><td>0.628186</td><td>3.37876</td></tr></tbody></table>



We can look at the simplified data:

````julia
scatter(10.0.^rates[:mass], 10.0.^rates[:fmr], c=:teal, leg=false, msc=:transparent)
xaxis!(:log10, "Mass (kg)")
yaxis!(:log10, "Field Metabolic Rate (kj per day)")
````


{{< figure src="../figures/genetic_algorithm_6_1.png" title="Same data, but a little bit less points. In addition, aggregating by species doesn't increase the impact that well sampled species will have on the regression output."  >}}


{{< callout information >}}
In this capstone, we will try to write a very general code for genetic
algorithms. It is possible to come up with a more specific code, but spending
time to think about making code general is almost always wise, since it means we
can seamlessly re-use already written code.
{{< /callout >}}

Genetic algorithms represent the state of the problem as "genomes", which here
will be composed of two genes: $m$ and $b$. There are a few decisions we need to
take already: how large is our initial population, and how much standing
variation do we have?

Just to be a little fancier than usual, we will define a *type* for our genomes:

````julia
mutable struct Genome
  m::Float64
  b::Float64
end
````





{{< callout information >}}
Defining a new type is *absolutely not* necessary. We are only doing it to show
some interesting features of Julia.
{{< /callout >}}

This means that our population will be of the type `Vector{Genome}`. Now, we
will *add methods* to some of Julia's existing function, so we can write code
that will read exactly like native code would:

````julia
import Base: zero
zero(::Type{Genome}) = Genome(0.0, 0.0)
````


````
zero (generic function with 37 methods)
````





Because we have created a `zero` method for the `Genome` type, we can create our
population:

````julia
population_size = 1_000
population = zeros(Genome, population_size)
population[1:5]
````


````
5-element Array{Main.WeaveSandBox1.Genome,1}:
 Main.WeaveSandBox1.Genome(0.0, 0.0)
 Main.WeaveSandBox1.Genome(0.0, 0.0)
 Main.WeaveSandBox1.Genome(0.0, 0.0)
 Main.WeaveSandBox1.Genome(0.0, 0.0)
 Main.WeaveSandBox1.Genome(0.0, 0.0)
````





To have a slightly more pleasing display, we can also overload the `show`
function:

````julia
import Base: show
show(io::IO, g::Genome) = print(io, "ŷ = $(round(g.m; digits=3))×x + $(round(g.b; digits=3))")
population[1:5]
````


````
5-element Array{Main.WeaveSandBox1.Genome,1}:
 ŷ = 0.0×x + 0.0
 ŷ = 0.0×x + 0.0
 ŷ = 0.0×x + 0.0
 ŷ = 0.0×x + 0.0
 ŷ = 0.0×x + 0.0
````





And we are now ready to start. At this point, it is useful to outline the
general structure of the genetic algorithm:

````julia
function GA!(p::Vector{T}, fitness::Function, mutation!::Function; generations=1_000) where {T}
  for generation in 1:generations
    fitnesses = fitness.(p)
    p = sample(p, weights(fitnesses), length(p), replace=true)
    mutation!.(p)
  end
  return nothing
end
````


````
GA! (generic function with 1 method)
````





Wouldn't it be cool if the real code was actually that simple?

What if I told you this *is* the real code? To make it work, we need to do two
things. First, we need to define a `fitness` function, which, given an input
(here, a `Genome`), will return its "score". Second, we need to define a
`mutation!` function, which will *modify* a genome.

The fitness function can be defined as follows (note that we have already taken
the log10 of the mass and FMR earlier):

````julia
const log10fmr = rates[:fmr]
const log10M = rates[:mass]

ŷ(g::Genome, x::Vector{Float64})=  g.m .* x .+ g.b

function fmr_fitness(g::Genome)
  errors = log10fmr .- ŷ(g, log10M)
  sum_of_errors_sq = sum(errors.^2.0)/length(log10fmr)
  return 1.0/sum_of_errors_sq
end
````


````
fmr_fitness (generic function with 1 method)
````





The first thing we do is "extract" the $\text{log}_{10}$ of the FMR and mass,
and turn them into vectors. Then we define a function which uses these vectors,
and does the linear prediction. You may notice that this function uses elements
from "the outside", which have not been passed as arguments, and this may not be
ideal - this is why the `log10...` variables have been declared as `const`: they
will raise a warning if they are changed.

We can check the score of an "empty" genome ($\hat y = 0$):

````julia
fmr_fitness(zero(Genome))
````


````
0.1406618826939854
````





Now, let's define a function for mutations. Because we might want to change the
rate at which parameters evolve, it would be useful to be able to generate
multiple such functions. And so, our first task is to write a function that will
return another function, which will itself modify the `Genome` object. Note that
we `return nothing` at the end, because all of this function does is change an
existing object.

````julia
function normal_error(σm::Float64, σb::Float64)
  function f(g)
    g.m = rand(Normal(g.m, σm))
    g.b = rand(Normal(g.b, σb))
    return nothing
  end
  return f
end
````


````
normal_error (generic function with 1 method)
````





We can test that this all works as expected:

````julia
change_both! = normal_error(0.01, 0.01)
initial_genome = Genome(0.2, 0.5)
change_both!(initial_genome)
initial_genome
````


````
ŷ = 0.198×x + 0.497
````





Let's now define a function to work on the actual problem:

````julia
very_gradual_change! = normal_error(1e-3, 1e-3)
````


````
(::getfield(Main.WeaveSandBox1, Symbol("#f#4")){Float64,Float64}) (generic 
function with 1 method)
````





We have all of the pieces to apply our genetic algorithm. Before starting, it is
always a good idea to try and eyeball the parameters. Judging from the plot we
made early in the lesson, the intercept is probably just around 3, so we can
probably draw it from $\mathcal{N}(\mu=3, \sigma=1)$; the slope seems to be
close to one but a little bit lower, so we can get it from
$\mathcal{N}(\mu=0.75, \sigma=0.2)$:

````julia
population = [Genome(rand(Normal(0.75,0.2)), rand(Normal(3,1))) for i in 1:500]
````


````
500-element Array{Main.WeaveSandBox1.Genome,1}:
 ŷ = 0.654×x + 5.04 
 ŷ = 0.926×x + 2.521
 ŷ = 0.674×x + 2.588
 ŷ = 1.01×x + 2.206 
 ŷ = 0.911×x + 3.044
 ŷ = 0.59×x + 3.062 
 ŷ = 0.441×x + 1.722
 ŷ = 0.614×x + 2.138
 ŷ = 0.444×x + 3.014
 ŷ = 0.651×x + 4.029
 ⋮                   
 ŷ = 0.946×x + 3.148
 ŷ = 0.367×x + 2.479
 ŷ = 0.771×x + 0.801
 ŷ = 0.933×x + 1.402
 ŷ = 0.926×x + 2.527
 ŷ = 0.532×x + 1.521
 ŷ = 0.815×x + 2.494
 ŷ = 1.156×x + 2.888
 ŷ = 0.781×x + 1.401
````



````julia
GA!(population, fmr_fitness, very_gradual_change!; generations=10000)
````





**_TODO_**

````julia
scatter(10.0.^rates[:mass], 10.0.^rates[:fmr], c=:teal, leg=false, msc=:transparent)
pred = collect(LinRange(10.0.^minimum(rates[:mass]), 10.0.^maximum(rates[:mass]), 100))
mostfit = fmr_fitness.(population) |> findmax |> last
plot!(pred, 10.0.^ŷ(population[mostfit], log10.(pred)), c=:orange, lw=2, ls=:dash)
xaxis!(:log10, "Mass (kg)")
yaxis!(:log10, "Field Metabolic Rate (kj per day)")
````


{{< figure src="../figures/genetic_algorithm_19_1.png" title="Relationship between field metabolic rate and mass - this is a neat log-log relationship, and so linear regression will give us the exponent."  >}}


We can also look at the equation for the most fit genome: ŷ = 0.685×x + 2.939.
