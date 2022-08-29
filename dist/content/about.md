---
title: Informations and further reading
---

## Who is this material for?

This material is aimed at people who have already interacted with a computer
using a programming language, but want to adopt best practices that make their
code more robust. It can also be used to facilitate the onboarding of new people
in your lab or your project.

Scientific computing can be very diverse, ranging from a few-step analysis
of small data sets to simulations running for weeks on supercomputers.
We focus on the most common situations that every scientist encounters
at some stage of a research project: data analyses performed on a standard
desktop computer. The general ideas and principles that we expose carry over
to other situations as well, but the concrete tools and methods may not
be suitable for tasks requiring special hardware such as GPUs or supercomputers,
or for projects requiring a significant software development effort.

We will use the [Julia][jl] programming language; but you don't need to know
anything about it either. We will keep the discussion very general. In fact, you
will see that good practices for scientific computing have very little to do
with tools and technical things; instead, they rely on thinking about
programming in a slightly different way. You will be able to apply these
principles to any language you prefer to use.

[jl]: http://julialang.org/

## How to use this material

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

## Want to see this material as a workshop?

This material can be given in a workshop format, ideally over two days, covering
several lessons and one or two capstone examples. Please contact [Timothée
Poisot](mailto:timothee.poisot@umontreal.ca) for more information.

## Want to contribute to this material?

There are a number of ways to contribute. Before you start, please have a look
at our [Code of Conduct][coc]. It boils down to *be nice and respectful* -- no
contribution, no matter how amazing it may be, justifies or excuses bad
behaviour. For the actual details on how to contribute, head over to the
[guidelines][guid].

[coc]: https://github.com/tpoisot/ScientificComputingForTheRestOfUs/blob/master/CODE_OF_CONDUCT.md
[guid]: https://github.com/tpoisot/ScientificComputingForTheRestOfUs/blob/main/CONTRIBUTING.md

## Want to read more?

In a rush? Yes you are. We suggest ["Good enough practices in scientific
computing"][goodenough] to get you started.

A little bit more time? We think ["Best practices in scientific
computing"][best] might suit you.

Want a more complete thing to read? ["The pragmatic programmer"][pragm] is a
masterpiece. I have also heard great things about ["Clean code"][cleanc]. The
online book ["How to think like a computer scientist"][httlacs] is based on
Julia, and very thorough. Finally, ["Hands-on design patterns and best practices
with Julia"][handson] is a wonderfully accessible book that will make you a
better programmer, even if *Julia* is not your main language.

If you still have some time, you can read something about [ways to improve user
confidence in your software][userconf], or ways to [elevate code as a research
output][elevate].

[Code is Science][codeissci] is a very nice project about making peer review of
scientific code more common. They have a list of [issues you can
tackle][cisissues] to help!

[codeissci]: http://www.codeisscience.com/
[cisissues]: https://github.com/yochannah/code-is-science/issues/

Finally, a short [Q&A at *Nature Jobs*][qanda] about this project.

[qanda]: https://web.archive.org/web/20171114145519/http://blogs.nature.com/naturejobs/2017/11/10/techblog-timothee-poisot-data-science-for-the-rest-of-us/

[userconf]: https://ojs.library.queensu.ca/index.php/IEE/article/view/5644
[elevate]: http://www.cell.com/trends/ecology-evolution/abstract/S0169-5347(15)00290-6

[httlacs]: https://benlauwens.github.io/ThinkJulia.jl/latest/book.html

[goodenough]: http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005510
[best]: http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1001745
[pragm]: https://www.amazon.ca/Pragmatic-Programmer-Journeyman-Master/dp/020161622X/ref=as_li_ss_tl?ie=UTF8&linkCode=sl1&tag=&linkId=0ff8cca36522d8539b26e536778bbb5e
[cleanc]: https://www.amazon.ca/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882
[handson]: https://www.packtpub.com/product/hands-on-design-patterns-and-best-practices-with-julia/9781838648817

![license](https://img.shields.io/github/license/tpoisot/ScientificComputingForTheRestOfUs.svg?style=flat-square)

## Special thanks to...

**Comments, ideas, feedback**: Hao Ye, Philipp Bayer, Tim Head, Ethan White, Andrew MacDonald

**Other contributions**: Konrad Hinsen
