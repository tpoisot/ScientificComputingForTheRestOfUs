JMD := $(shell find content -name "_index.Jmd")
MD := $(patsubst content/%Jmd,dist/content/%md,$(JMD))

all: $(MD)
.PHONY: all

$(MD): dist/content/%md: content/%Jmd 
	julia --project _builder.jl $(patsubst content/%/_index.Jmd,%,$<)