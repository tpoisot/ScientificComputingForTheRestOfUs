BASE_DIR := "content"
DIRS := $(shell find $(BASE_DIR) -type d)
SLUGS := $(subst content/,,$(DIRS))

$(info $(SLUGS))

all: $(SLUGS)
	julia --project _builder.jl $<