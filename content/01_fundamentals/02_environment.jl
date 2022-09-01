# ---
# title: Environment and projects
# status: beta
# ---

# In this previous module, we did not load a single package: everything we
# wanted to do was provided by *Julia* "out of the box". In most applications,
# we will need to get functionalities from other packages, and this is where
# *Julia*'s package manager shines.

# <!--more-->

# There are two families of packages -- some are part of the *standard library*,
# which is [documenter][stdlib] in the manual; others are developped by members
# of the community. Together, these packages form the broad "*Julia* ecosystem".

# [stdlib]: https://docs.julialang.org/en/v1/

# !!!INFO This module is usually delivered as an interactive demo. It doesn't
# work quite as well as text, but the documentation is still largely enough to
# get you up to speed. Again, reading the documentation is a core way to build
# up your skills.

# The *Julia* package manager (also known as `Pkg`) is a complex but [really
# well documented][pkg] beast. For this reason, this module is primarily meant
# to point you towards the documentation, for everything related to *installing*
# and *updating* packages.

# [pkg]: https://pkgdocs.julialang.org/v1/

# Nevertheless, there is one fundamental concept that is worth saying very
# explicitely: **never work in the default environment**.