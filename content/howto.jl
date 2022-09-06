# ---
# title: How to use this material
# ---

# The best way to read this material is to keep a terminal running *Julia* open,
# and **type** the code. It is tempting to copy and paste, but typing the code
# actually matters. The sections (and modules within them) are presented in
# chronological order, and whenever possible (most of the time) introduce one
# concept at a time. Every so often, an illustration or example will start to
# re-use previous knowledge, and this gets more common in the later sections.
# The content is definitely designed to be read from beginning to end!

# The lessons have a release cycle, and the current position of the modules in
# this cycle is indicated below the module summary. The release cycle has four
# steps: not usable (which is self explanatory), in development (most of the
# content is present but the lesson is probably not sufficiently polished for
# self-directed learning), awaiting testing (we are confident that the material
# is ready but this has not been tested with enough learners), and finally,
# release (we have observed this module working well in the wild). A very good
# way to contribute is to look at modules awaiting testing and give feedback
# (using [Discord][discord] or [GitHub issues][issues]), or to check out modules
# in development and jumping into adding content!

# [discord]: https://discord.gg/Ak2pK3yG9M
# [issues]: https://github.com/tpoisot/ScientificComputingForTheRestOfUs/issues

# Whenever a package is discussed, it will be presented in a little box, like
# *e.g.* {{Distributions}}. Clicking on this link will open a new window with
# the Julia packages documentation hub, which will hopefully provide you with an
# incentive to checkout what the packages do!

# You will notice that there are very few comments in the material. This is
# because the text surrounding the code *are* the comments. The modules are
# actual *Julia* scripts, executed using the {{Literate}} package. This ensure
# that whatever you see on screen is the result of an actual code execution.
# Furthermore, there is no hidden code!

# Snippets of code that are *important* are presented this way (and their
# output, when not silenced, is immediately below them):

[rand() for i in 1:5]

# Bits of code of lower importance (pseudocode or code you are not meant to
# type), are presented this way:

# ~~~ raw
# for each_element in vector
#   function(each_element)
# end
# ~~~

# Throughout the lessons, we have added some asides -- they are ranked in order
# of importance. The first are "informations":

# !!!INFO All that should matter in the choice of tools, language, environment,
# is that it lets you become productive, and solve the problem you want to
# solve.

# "Opinions" are points we would like to raise for the reader's consideration,
# and can be ignored. Example:

# !!!OPINION People who think it's OK to criticize others based on their choice
# of language, OS, text editor, etc, should go home and think about what they
# did.

# "Warnings" are points that can be important, but not necessarily as a novice.
# It is worth keeping a mental note of them, especially in the long term.
# Example:

# !!! WARNING Any time you are about to comment on people's choice of tools, ask
# yourself whether this is really necessary, and the answer is usually "no". The
# Good Tool is the one that works for its user.

# "Dangers" are really important points, that can prove especially dangerous or
# risky to everyone. They are worth reading a few times over. Example:

# !!!DANGER This toxic behaviour is driving brilliant people away, and should
# never be tolerated. Disliking Windows has not made anyone edgy or cool since
# 1998.

# More rarely, there will be a few "Big Brain Time" callouts, meant to
# contextualize the code with do with some mentions of domain knowledge.

# !!!DOMAIN It's big brain time!

# If you want to contribute, there are a number of ways to do so! Before you
# start, please have a look at our [Code of Conduct][coc]. It boils down to *be
# nice and respectful* -- no contribution, no matter how amazing it may be,
# justifies or excuses bad behaviour. For the actual details on how to
# contribute, head over to the [guidelines][guid].

# [coc]: https://github.com/tpoisot/ScientificComputingForTheRestOfUs/blob/master/CODE_OF_CONDUCT.md
# [guid]: https://github.com/tpoisot/ScientificComputingForTheRestOfUs/blob/main/CONTRIBUTING.md