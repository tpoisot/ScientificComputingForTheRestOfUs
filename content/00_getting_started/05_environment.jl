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
# also known as {{Base}}, which is [documented][stdlib] in the manual; others
# are developped by members of the community. Together, these packages form the
# broad "*Julia* ecosystem".

# [stdlib]: https://docs.julialang.org/en/v1/

# !!!WARNING This module is usually delivered as an interactive demo. It doesn't
# work quite as well as text, but the documentation is still largely enough to
# get you up to speed. Again, reading the documentation is a core way to build
# up your skills.

# The *Julia* package manager (also known as {{Pkg}}) is a complex but [really
# well documented][pkg] beast. For this reason, this module is primarily meant
# to point you towards the documentation, for everything related to *installing*
# and *updating* packages.

# [pkg]: https://pkgdocs.julialang.org/v1/

# Nevertheless, there is one fundamental concept that is worth saying very
# explicitely: **never work in the default environment**. In most cases, this
# means that you will navigate to your working folder, and call *Julia* using

# ~~~
# julia --project
# ~~~

# Alternatively, after starting *Julia*, you can drop to the `Pkg` mode of the
# REPL by pressing `]`, and calling the `activate` command. Most of the time,
# this will be done as `activate .`, which means "activate an environment in the
# current directory".

# !!!INFO The `.` notation is a shortcut to mean *here*, `..` means "the folder
# immediately above here", and `~` means "home". In the vast majority of cases,
# we will navigate our fileystem using *Julia*'s pathing utilities.

# Of course, because {{Pkg}} is a package, it can be called programmatically,
# *i.e.* as part of a script:

import Pkg

# It offers the same commands as the package mode from the REPL; for example, we
# can activate an environemnt in a temporary directory with a nifty little
# trick:

Pkg.activate(mkpath(tempname()))

# This draws on concepts we will see (much) later, during the module on working
# with files and paths.

# We can query the status of this environment:

Pkg.status()

# This project is currently *empty*, meaning that we have not added
# *dependencies* (*i.e.* packages we will use). Let's fix this, by installing
# the {{Distributions}} package:

Pkg.add("Distributions")

# We can check that it has been installed:

Pkg.status()

# !!!INFO The reason we can do `import Pkg` without *installing* {{Pkg}} first
# is that {{Pkg}} is a part of the standard library, and comes bundled with
# *Julia*. It is, in fact, one of the most central pieces of the language.

# We can now use the {{Distributions}} package:

using Distributions
𝒩 = Normal(0.0, 0.2)

# In some cases, we may want to *remove* an existing package from our
# environment, because we have found an alternative solution. It is good
# practice to *only* keep the dependencies you actually need and use.

Pkg.rm("Distributions")
Pkg.status("Distributions")

# Another thing that the package manager can do is *garbage collection*, *i.e.*
# cleaning the versions and environments that are not used anymore:

Pkg.gc()

# This will look through all the environments *Julia* knows about, and reclaim
# disk space by removing versions of packages that are not used anymore, or
# dependencies of projects that have not been used for a long time.

# There is a lot more that you can achieve using the package manager, including
# *creating* your own packages. Reading the documentation is key here, and will
# make maintaining your projects far more efficient.