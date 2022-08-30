---
title: How to use this material
---


The best way to read this material is to keep a window with either
[JuliaBox][jlbox] or a terminal running *Julia* open, and **type** the code. It
is tempting to copy and paste, but typing the code actually matters.

Snippets of code that are *important* are presented this way:

~~~ julia
[rand(i) for i in 1:5]
~~~

Bits of code of lower importance (pseudocode or code you are not meant to type),
are presented this way:

~~~ raw
for each_element in vector
  function(each_element)
end
~~~

Finally, the output of code is presented this way:

~~~
2-element Array{Float64,1}:
 0.1
 0.0
~~~

Throughout the lessons, we have added some asides -- they are ranked in order of
importance. The first are "informations":

{{< callout information >}}
All that should matter in the choice of tools, language, environment, is that it
lets you become productive, and solve the problem you want to solve.
{{< /callout >}}

"Opinions" are points we would like to raise for the reader's consideration, and
can be ignored. Example:

{{< callout opinion >}}
People who think it's OK to criticize others based on their choice of language,
OS, text editor, etc, should go home and think about what they did.
{{< /callout >}}

"Warnings" are points that can be important, but not necessarily as a novice. It
is worth keeping a mental note of them, especially in the long term. Example:

{{< callout warning >}}
Any time you are about to comment on people's choice of tools, ask yourself
whether this is really necessary, and the answer is usually "no". The Good Tool
is the one that works for its user.
{{< /callout >}}

"Dangers" are really important points, that can prove especially dangerous or
risky to everyone. They are worth reading a few times over. Example:

{{< callout danger >}}
This toxic behaviour is driving brilliant people away, and should never be
tolerated. Disliking Windows has not made anyone edgy or cool since
1998.
{{< /callout >}}

More rarely, there will be a few "Big Brain Time" callouts, meant to
contextualize the code with do with some mentions of domain knowledge.

{{< callout domain >}}
It's big brain time!
{{< /callout >}}
