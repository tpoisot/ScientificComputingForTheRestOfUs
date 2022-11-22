# ---
# title: Strings, symbols, and text
# status: rc
# ---

# In this module, we will look at string and characters, *i.e.* representations
# of text. These objects are really interesting in *Julia* because not only do
# they store information, they can store a little bit of computation as well.
# The point of this module is to go through the basics of what strings are, and
# we will revisit advanced operations in later sections.

# <!--more-->

# A few modules into this class, it is time to write what we usually write as a
# first instruction:

"Hello, world"

# This is a `String` -- we can check that it is a string by asking for its type,
# which is

typeof("Hello, world")

# Note that *Julia* is not really picky about what goes into a string. Unicode
# characters are perfectly valid:

"Γεια!" |> typeof

# Strings behave a little like arrays. They have a length:

length("Hello, world!")

# This length is the number of characters, including spaces, in the string. As a
# rule, almost everything with a length can be indexed:

"Hello, world!"[1:5]

# And as before, indexing from the end works as well:

"Hello, world!"[(end - 5):(end - 1)]

# Strings have a number of specific methods to transform them:

titlecase("Hello, world!")

#-

lowercase("Hello, world!")

#- 

uppercase("Hello, world!")

# There are a few others, that are all documented. Looking at `?titlecase`
# should set you on your way.

# One of the reasons why strings are special is that we can sneak a little
# computation in them, using something called string interpolation:

"The answer to Life, the Universe and Everything is $(rand(1:100))"

# This is an interesting construct when we want to print out some information.
# Everything that is wrapper in the `$()` block will be executed first, and the
# output will be replaced within the string.

# It is also possible to join strings together, in a most unintuitive way:

"Hello" * ", " * "world" * "!"

# !!!INFO There is, actually, a reason for which strings are concatenated using
# `*`, and it has to do with this representing the least amount of departure
# from what `*` means in a mathematical context.

# String can also have multiple lines:

"""
Hello
world
!
"""

# Note that the line breaks have been replaced by the line break character
# (`\n`). Indeed, you can use line breaks and tabulations (`\t`) in your
# strings. They will be correctly replaced when using the `print` (or `println`;
# see the documentation of both to see how they differ) function:

print("This\tis\ta\ttabulation")

# *Julia* can also represent single characters. We can for example compare `a`
# and `É`:

'a'

#-

'É'

# The representation of a character is a little bit more rich than that of a
# string, and we can get information about its case, its unicode value, its
# category, and a number of other informations that can be useful when dealing
# with a string.

# We can extract the characters of a string in the following way:

Char("Hello world!"[end])

# But importantly, we can also create a string out of characters:

String(['H', 'e', 'l', 'l', 'o'])

# Strings are not *quite* a vector of characters, but we can convert a vector of
# characters into a string!

# There is one more data structure to represent textual or categorical
# information: symbols. Symbols are incredibly powerful. The way to declare a
# symbol is to preface it with `:`, or to call the `Symbol` function on a
# string:

:α

#-

Symbol("α")

# Symbols are not mutable, and are extremely useful to represent categories. In
# many situations, comparing the equality of two symbols is also much faster
# than comparing the equality of two strings, which is important when working
# with increasing data volumes.

# There are a number of additional operations on text-like objects we can do,
# including substitutions, matching, and advanced replacements. They will be
# covered in later modules.
