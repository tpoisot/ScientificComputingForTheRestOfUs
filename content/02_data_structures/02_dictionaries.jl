# ---
# title: Dictionaries and pairs
# status: alpha
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

# collect

# pairs

# zip