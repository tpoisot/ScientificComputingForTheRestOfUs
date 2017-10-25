# Introduction to Scientific Computing

Good principles in scientific computing can help you write code that is easier
to maintain, easier to reproduce, and easier to debug. But it can be difficult
to find an introduction to get you started. The goal of this project is to
provide reproducible documents you can use to get started on the most important
points. You can use these lessons on your own, or as a group.

This material is aimed at people who have already interacted with a computer
using a programming language, but want to adopt best practices that make their
code more robust. One specific challenge in scientific computing is that we care
about getting the *right* answer. A piece of code that crashes is annoying; but
a piece of code that runs, and give you the wrong answer can compromise your
science. Therefore, we should adopt practices that make us less likely to
introduce mistakes, and more likely to catch them. This guide will help you with
this.

This material is *not* aimed at people with terabytes upon terabytes of data, or
need to distribute computations across thousands of cores, or need GP-GPU
programming. Sorry! But if you do these sort of things, you are more than
welcome to contribute to these lessons.

And do you want good news? You don't need to install anything! We rely on [the
Binder project][binder], a cloud-based service to run reproducible documents. We
will use the [Julia][jl] language; but you don't need to know anything about it
either. We will keep the discussion very general, and not use any of the (very
cool!) language-specific features and syntax.

[binder]: https://beta.mybinder.org/
[jl]: http://julialang.org/

## Table of contents

You can start each lesson by clicking on the links below.

1. :notebook: [Lesson 1][l1binder] - using notebooks (approx. 10 minutes)
    - cells and states
    - order of execution
    - exporting and saving your work
1. :arrows_clockwise: Lesson 2 - the flow of execution
1. :computer: Lesson 3 - writing functions
1. :bug: Lesson 4 - preventing errors with defensive programming
1. :hammer: Lesson 5 - debugging our way out of errors we forgot to prevent

[l1binder]: https://beta.mybinder.org/v2/gh/tpoisot/IntroScientificComputing/master?filepath=lessons%2F01_introduction_to_notebooks.ipynb

## Contributing

There are a number of ways to contribute. Before you start, please have a look
at our [Code of Conduct][coc]. It boils down to *be nice and respectful* -- no
contribution, no matter how amazing it may be, justifies or excuses bad
behaviour.

[coc]: https://github.com/tpoisot/IntroScientificComputing/blob/master/CODE_OF_CONDUCT.md

The first thing you can do is comment on Issues that have the ["Request for
feedback"][feedback] label. They represent situations for which we are actively
seeking community feedback, and anyone is always welcome to chime in.

[feedback]: https://github.com/tpoisot/IntroScientificComputing/labels/request%20for%20feedback

If there is a more specific point you would like to raise, you can [create a new
Issue][new_issue], and explain your idea, critique, or comment. And of course,
you can always browse the [current Issues][issues], to get a sense of what is
being discussed.

[new_issue]: https://github.com/tpoisot/IntroScientificComputing/issues/new
[issues]: https://github.com/tpoisot/IntroScientificComputing/issues

If you want to contribute more, then great! Have a look at the [contribution
guidelines][cguid] first, to get you started with setting up a development
environment. You can have a look at ["Good first issues"][first], if you want
some inspiration.

[cguid]: https://github.com/tpoisot/IntroScientificComputing/blob/master/CONTRIBUTING.md
[first]: https://github.com/tpoisot/IntroScientificComputing/labels/good%20first%20issue

## Authors

## Want to read more?

In a rush? Yes you are. We suggest ["Good enough practices in scientific
computing"][goodenough] to get you started.

A little bit more time? We think ["Best practices in scientific
computing"][best] might suit you.

Want a more complete thing to read? ["The pragmatic programmer"][pragm] is a
masterpiece.

[goodenough]: http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005510
[best]: http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1001745
[pragm]: https://www.amazon.ca/Pragmatic-Programmer-Journeyman-Master/dp/020161622X/ref=as_li_ss_tl?ie=UTF8&linkCode=sl1&tag=&linkId=0ff8cca36522d8539b26e536778bbb5e


## Other information

[![license](https://img.shields.io/github/license/tpoisot/IntroScientificComputing.svg?style=flat-square)]()
