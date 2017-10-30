# Scientific Computing (for the rest of us)

One specific challenge, when writing code as a scientist, is that we care *a
lot* about getting the *right* answer; but of course, the *right* answer is not
always obvious. So we should be very careful with the code we write. A piece of
code that crashes is annoying; but a piece of code that runs, and give you the
wrong answer can compromise your science and your career. This guide will help
you adopt practices that make it less likely to introduce mistakes in your code,
and more likely to catch them. Hopefully, this will let all of us write code we
can trust more.

Good principles in scientific computing can help you write code that is easier
to maintain, easier to reproduce, and easier to debug. But it can be difficult
to find an introduction to get you started. The goal of this project is to
provide reproducible documents you can use to get started on the most important
points. You can use these lessons on your own, or as a group.

This material is aimed at people who have already interacted with a computer
using a programming language, but want to adopt best practices that make their
code more robust. It can also be used to facilitate the onboarding of new people
in your lab or in your project.

Scientific computing should not be adressed only to those of us with terabytes
upon terabytes of data, or the need to distribute computations across thousands
of cores, or need GP-GPU programming. Most of us researchers do not have these
needs, and we will not discuss them at all here. But if you do these sort of
things, you are more than welcome to contribute your valuable experience to
these lessons.

And do you want good news? You don't need to install anything! We rely on [the
Binder project][binder], a cloud-based service to run reproducible documents. We
will use the [Julia][jl] language; but you don't need to know anything about it
either. We will keep the discussion very general, and not use any of the (very
cool!) language-specific features and syntax.

In fact, you will see that good practices for scientific computing have very
little to do with tools and technical things; instead, they rely on thinking
about programming in a slightly different way. You will be able to apply these
principles to any language you prefer to use.

[binder]: https://beta.mybinder.org/
[jl]: http://julialang.org/

## Table of contents

Clicking on the title of each lesson below will launch it in a new window.

1. :notebook: [Lesson 1][l1binder] - using notebooks (approx. 10 minutes)
    - cells and states
    - order of execution
    - exporting and saving your work
1. :arrows_clockwise: Lesson 2 - the flow of execution
1. :computer: Lesson 3 - writing functions
1. :bug: Lesson 4 - preventing errors with defensive programming
1. :hammer: Lesson 5 - debugging our way out of errors we forgot to prevent

[l1binder]: https://beta.mybinder.org/v2/gh/tpoisot/ScientificComputingForTheRestOfUs/master?filepath=lessons%2F01_introduction_to_notebooks.ipynb
[l2binder]: https://beta.mybinder.org/v2/gh/tpoisot/ScientificComputingForTheRestOfUs/master?filepath=lessons%2F02_flow_of_execution.ipynb

## Contributing

There are a number of ways to contribute. Before you start, please have a look
at our [Code of Conduct][coc]. It boils down to *be nice and respectful* -- no
contribution, no matter how amazing it may be, justifies or excuses bad
behaviour.

[coc]: https://github.com/tpoisot/ScientificComputingForTheRestOfUs/blob/master/CODE_OF_CONDUCT.md

The first thing you can do is comment on Issues that have the ["Request for
feedback"][feedback] label. They represent situations for which we are actively
seeking community feedback, and anyone is always welcome to chime in.

[feedback]: https://github.com/tpoisot/ScientificComputingForTheRestOfUs/labels/request%20for%20feedback

If there is a more specific point you would like to raise, you can [create a new
Issue][new_issue], and explain your idea, critique, or comment. And of course,
you can always browse the [current Issues][issues], to get a sense of what is
being discussed.

[new_issue]: https://github.com/tpoisot/ScientificComputingForTheRestOfUs/issues/new
[issues]: https://github.com/tpoisot/ScientificComputingForTheRestOfUs/issues

If you want to contribute more, then great! Have a look at the [contribution
guidelines][cguid] first, to get you started with setting up a development
environment. You can have a look at ["Good first issues"][first], if you want
some inspiration.

[cguid]: https://github.com/tpoisot/ScientificComputingForTheRestOfUs/blob/master/CONTRIBUTING.md
[first]: https://github.com/tpoisot/ScientificComputingForTheRestOfUs/labels/good%20first%20issue

## Authors

## Want to read more?

In a rush? Yes you are. We suggest ["Good enough practices in scientific
computing"][goodenough] to get you started.

A little bit more time? We think ["Best practices in scientific
computing"][best] might suit you.

Want a more complete thing to read? ["The pragmatic programmer"][pragm] is a
masterpiece. I have also heard great things about ["Clean code"][cleanc].

[goodenough]: http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005510
[best]: http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1001745
[pragm]: https://www.amazon.ca/Pragmatic-Programmer-Journeyman-Master/dp/020161622X/ref=as_li_ss_tl?ie=UTF8&linkCode=sl1&tag=&linkId=0ff8cca36522d8539b26e536778bbb5e
[cleanc]: https://www.amazon.ca/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882

## Other information

[![license](https://img.shields.io/github/license/tpoisot/ScientificComputingForTheRestOfUs.svg?style=flat-square)]()
[![Binder](https://img.shields.io/badge/launch-binder-ff69b4.svg?style=flat-square)](https://beta.mybinder.org/v2/gh/tpoisot/ScientificComputingForTheRestOfUs/master?filepath=lessons)
