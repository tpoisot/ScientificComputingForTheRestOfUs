jl = julia

lessons_sources := $(wildcard _lessons/*.Jmd)

%.md: %.Jmd
	$(jl) -e 'using Weave; weave("$<", doctype="github")'

lessons: $(patsubst %.Jmd,%.md,$(lessons_sources))

dependencies:
	$(jl) -e 'Pkg.add("Weave")'
