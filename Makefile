jl = julia

lessons_sources := $(wildcard _lessons/*.Jmd)
capstones_sources := $(wildcard _capstones/*.Jmd)

all: lessons capstones

%.md: %.Jmd
	$(jl) -e 'using Weave; weave("$<", doctype="github")'

lessons: $(patsubst %.Jmd,%.md,$(lessons_sources))

capstones: $(patsubst %.Jmd,%.md,$(capstones_sources))

dependencies:
	$(jl) -e 'Pkg.add("Weave")'
