@info ARGS

lesson = first(ARGS)

import Pkg
using Weave
cd(joinpath("content", lesson))
Pkg.activate(".")
weave(
    "_index.Jmd",
    out_path=joinpath("..", "..", "..", "dist", "content", lesson, "_index.md"),
    doctype="github"
)