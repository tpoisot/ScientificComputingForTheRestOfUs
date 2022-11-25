# ---
# title: Documenting functions
# status: beta
# ---

# In this module, we will look at what is probably the most important part of writing
# a function: writing its documentation. By the end of this module, you will be able to
# write a docstring for your function that is accessible through *Julia*'s help mode.

# <!--more-->

# Documenting functions is *essential*. It will help you recall what they do and how to use
# them, and without documentation, your code might as well not exist. *Julia* offers ways to
# see the documentation for functions (type `?` at the REPL), and ways to develop manuals
# for your code (see {{Documenter}} and {{DocumenterTools}}).

# !!!OPINION There are different levels of documentation. Good code is its own
# documentation. Good comments convey the purpose of the code, and are a good way to keep
# track of insights about how it actually works. Good docstrings remove the ambiguities
# about how to use a function and what it does. Good vignettes and example show how to
# actually work with these functions. Each of these things (with the exception of examples
# if you are not building a large package), when neglected, makes users less likely to use
# your code well, or at all.

# Defining the docstring (*i.e.* a text that serves as an explanation for the function) is
# done by adding a special long-form string, which uses `"""` as the delimiters, on the
# lines immediately before the function declaration. The first line of this docstring is by
# convention the signature of the function.

# We can write a very simple example, using a function called `twice`, which returns twice
# its input. This is not terribly interesting, but we can document this function in details:

"""
    twice(x::T) where {T <: Real}

The function `twice` will return, for an input `x` which is a `Real` number, the result of the x+x operation.

**Example**:

```julia-repl
julia> twice(2)
4
```
"""
function twice(x::T) where {T <: Real}
    return x + x
end

# Note that the content of the docstring is in the markdown language - we can have a lot of
# markup, including tables, bullet points, numbered lists, code blocks, etc... In fact, if
# we print the documentation entry for this function, it will show up (depending on your
# environment) as a formatted string:

@doc twice

# When we add a new method, we can document it as well. This is because documentation
# entries for a function are collected together:

"""
    twice(::Type{R}, x::T) where {R <: Real, T <: Real}

The function `twice` will return, for an input `x` which is a `Real` number, the result of the x+x operation. The result will be converted to the type `R` given as the first argument, which must also be a real number.

**Example**:

```julia-repl
julia> twice(Float32, 2)
4.0f0
```
"""
function twice(::Type{R}, x::T) where {R <: Real, T <: Real}
    return convert(R, x + x)
end

# If we now ask for the documentation of `twice`, we will be able to see two entries:

@doc twice

# The functions in this material almost never have a docstring, which is justified by the
# fact that they actually do: it is the text around them that explains how they are built.
# In short, we care more about building the function than about using it, and this very
# special use-case means that we can justify not having a documentation. In actual research
# work, functions *must* be documented.
