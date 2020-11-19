BASE_DIR := "content"
DIRS := $(shell find $(BASE_DIR) -type d)

all: $(filter-out content content/capstones content/lessons content/machinelearning content/primers,$(DIRS))
	julia --project _builder.jl $(subst content/,,$<)