---
title: Pseudo-code
status: release
---

To facilitate the transition between diagram and code, one important step is
to write *pseudo-code*, *i.e.* text that looks reasonably like code, but is
not.

{{< callout opinion >}}
Pseudo-code is mostly useful when it comes to working on a single
function. The overall structure of the project can be done as a flowchart, and
then each function can be written as pseudo-code. This is, in fact, a really
good exercise to try with your own projects.
{{< /callout >}}

Let us try with an example - we want to sort numbers. We will write
pseudo-code for a very, *very* inefficient algorithm:

~~~
take a list of numbers X
create an empty list Y

as long as X still has elements in it
    find the minimum of X
    add it to Y
    remove it from X

return Y
~~~

This is, essentially, what *pseudo-code* is: a way to explain in your own words
what the function should do. This can be translated line-by-line into code:

| Pseudo-code                             | Code                                                 |
|-----------------------------------------|------------------------------------------------------|
| `take a list of numbers X`              | `function badsort(X::Vector{T}) where {T <: Number}` |
| `create an empty list Y`                | `Y = eltype(X)[]`                                    |
| `as long as X still has elements in it` | `while length(X) > 0`                                |
| `    find the minimum of X`             | `    m, i = findmin(X)`                              |
| `    add it to Y`                       | `    push!(Y, m)`                                    |
| `    remove it from X`                  | `    deleteat!(X, i)`                                |
|                                         | `end`                                                |
| `return Y`                              | `return Y`                                           |
|                                         | `end`                                                |

The right column is *actual* code! In practice, we rarely (never!) convert
pseudo-code to code literally. But when you are writing your first functions,
it may be a good idea.

Pseudo-code is also useful to reason about the structure of the program you
are about to start writing. A good example is when do not know which function
to use yet, or whether your functions are appropriately sized; if the
pseudo-code is getting too long, it is a good sign that you may start thinking
about smaller functions.

