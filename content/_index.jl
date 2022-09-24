# ---
# title: Welcome!
# ---

# **One specific challenge, when writing code as a scientist, is that we care *a
# lot* about getting the *right* answer; but of course, the *right* answer is
# not always obvious. So we should be very careful with the code we write. A
# piece of code that crashes is annoying; but a piece of code that runs, and
# give you the wrong answer can compromise your science and your career. This
# guide will help you adopt practices that make it less likely to introduce
# mistakes in your code, and more likely to catch them. Hopefully, this will let
# all of us write code we can trust more.**

# Good principles in scientific computing can help you write code that is easier
# to maintain, easier to reproduce, and easier to debug. But it can be difficult
# to find an introduction to get you started. The goal of this project is to
# provide reproducible documents you can use to get started on the most important
# points. You can use these lessons on your own, or as a group.

#=
<div class="main-links">
    <span>
        <i class="fa-solid fa-question"></i>
        <a href="about" title="About the project">About the project</a>
    </span>
    <span>
        <i class="fa-solid fa-screwdriver-wrench"></i>
        <a href="howto" title="How to use this material">How to use this material</a>
    </span>
    <span>
        <i class="fa-solid fa-book"></i>
        <a href="readinglist" title="Suggested readings">Suggested readings</a>
    </span>
    <span>
        <i class="fa-brands fa-discord"></i>
        <a href="https://discord.gg/Ak2pK3yG9M" target="_blank" title="Join the Discord channel">Join the Discord channel</a>
    </span>
</div>
=#

# This material has been designed according to three core ideas:

# First, **each module is short**, and introduces a *single* concept. In many
# places, you will notice advice redirecting you to the documentation. The
# [*Julia* manual](https://docs.julialang.org/en/v1/) is extremely thorough, and
# the point of this material is to show "how things work" (as opposed to going
# into all of the different ways they can be made to work).

# Second, **this material is *not* about showcasing different packages**. There
# are some situations where we will need to go into the details of *e.g.*
# {{Makie}} for plotting, but it is expected that you will, again, read the
# documentation for the packages that are loaded. Every time a package is
# mentioned, you can click on its name to be redirected to the [Julia Packages
# page][jlhub]; packages with no documentation on the hub (like *e.g.* {{Base}}
# have a different styling). The material relies most of the time only on
# packages from *Julia*'s standard library.

# [jlhub]: https://juliapackages.com/

# Finally, **no error messages**. This is an important design concept. Although
# error messages happen in the daily practice of programming, the point of this
# material is to anticipate and handle exceptions gracefully.