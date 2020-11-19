@info ARGS

lesson = first(ARGS)

import Pkg
using Weave
root = pwd()
target_file = joinpath("dist", replace(source_file, "index.Jmd" => "index.md"))
cd(joinpath("content", lesson))
Pkg.activate(".")
weave(
    "_index.Jmd",
    out_path=joinpath(pwd(), "dist", "content", lesson, "index.md"),
    doctype="github"
)