# ---
# title: Dictionaries and pairs
# status: rc
# ---

# In this module, we will explore two very useful data structures: dictionaries,
# which serve as "key-value" stores, and pairs, which serve as (essentially) the
# same thing but smaller.

# <!--more-->

# What is a dictionary? Essentially, it is a data structure that is mutable (we
# can modify it), and associates a value to a key. Let's start with a simple
# illustration, to give a taxonomic description of the common house mouse, [*Mus
# musculus*][mus]:

# [mus]: https://en.wikipedia.org/wiki/House_mouse

# !!!OPINION In practice, and this is a feature we will explore later,
# representation of highly structured information is a good opportunity to
# define one's own types.

mus_musculus = Dict([
    "vernacular" => "House mouse",
    "kingdom" => "Animalia",
    "phylum" => "Chordata",
    "class" => "Mammalia",
    "order" => "Rodentia",
    "family" => "Muridae",
    "genus" => "Mus",
    "subgenus" => "Mus",
    "species" => "musculus",
    "authority" => "L. 1758"
])

# The construction of the dictionary is a call to `Dict`, and the argument is an
# array (we know because it starts with `[` and ends with `]`) of pairs of
# elements. A pair is noted as `key => value`, which is something we will
# explore a little bit more in just a minute.

# Note how the keys in the input and the keys in the output are in different
# orders. By default, the order of elements in dictionaries is not fixed, but
# this is not particulary concerning because we can access the different entries
# in a lot of ways.

# Additionally, note that the dictionary we have created is *parametric*: its
# keys are of the `String` type, and its values are of the `String` type as
# well. In a few modules, we will explore a concept called "element dispatch",
# where we can use this information. For now, just use this as a reminder of
# what is stored in your dictionary.

# !!!INFO In some cases, we would prefer an ordered dictionary. This is a
# feature offered by a few different packages. As we tend to not rely on ordered
# dictionaries, we will not discuss these packages here.

# In order to extract a value from a dictionary, we access is using its key:

mus_musculus["order"]

# Of course, this is going to fail if there is no `"order"` key to be found. For
# example, not all species will have a `"subgenus"`, or a `"subspecies"` key. It
# is therefore safer to handle data access with `get`:

get(mus_musculus, "subgenus", nothing)

# The last argument of `get` is the value to be returned in case the key does
# not exist. We can check that this is indeed protecting us against exceptions
# by trying to access a key that is not in our object:

get(mus_musculus, "subspecies", nothing)

# In order to get a list of the keys for a given dictionary, we can use the
# `keys` function:

keys(mus_musculus)

# This is a strange little object (a `KeySet`), which we can iterate over (and
# we will see what iteration is in a future module); to get it to a format we
# know, we can pass it through `collect`:

mus_keys = collect(keys(mus_musculus))

# We can do the same thing with the `values` of a dictionary:

mus_values = collect(values(mus_musculus))

# An interesting little command is `zip`: we can use it to create a dictionary
# from two arrays, one with the keys and one with the values:

mus_zip = Dict(zip(mus_keys, mus_values))

# !!!DANGER Of course, this assumes that the keys and the values are in the
# correct order, because there is no way for *Julia* to know which value should
# be associated to each key.

# The final data structure related to dictionaries is the Pair`. A pair
# associates one key to one value:

pair_one_two = 1 => 2

# We can use a different notation as well:

pair_one_two_take_2 = Pair(1,2)

# The elements of a pair can be accessed using `first` and `last`:

first(pair_one_two)

#-

last(pair_one_two)

# Why are we talking about pairs here? Because dictionaries are simply a series
# of pairs wearing a trench coat:

eltype(collect(mus_musculus))

# We can `collect` a dictionary into a vector of `Pair`, but more importantly,
# we can *create* a dictionary *from* a vector of pairs. This is, indeed, what
# we have done when we created the `mus_musculus` variable.

# A final noteworthy information is that we can expand dictionaries, by adding
# keys:

mus_musculus["IUCN"] = "least concern"

# This is also more properly expressed as:

setindex!(mus_musculus, "IUCN", "least concern")

# And we can, similarly, *remove* information from a dictionary:

delete!(mus_musculus, "subgenus")

# Note that this function does *not* throw an exception if we try to delete a
# key that does not exist. If we want to delete a key but keep track of its
# value, the right function to use is `pop!`:

mus_iucn_status = pop!(mus_musculus, "IUCN", nothing)

# This will remove the key from the dictionary, but save the value to a
# variable. The third argument specifies what should be returned if the key
# doesn't exist, in order to avoid an exception:

pop!(mus_musculus, "IUCN", nothing)

# In summary, pairs and dictionaries are extremely useful data structures when
# there is a need to associate a value with a more memorable name. They have a
# lot of uses when, for example, storing the parameters of a model, or reading
# [JSON][json] files.

# [json]: https://en.wikipedia.org/wiki/JSON