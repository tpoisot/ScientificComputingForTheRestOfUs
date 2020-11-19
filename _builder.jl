@info ARGS

lesson = first(ARGS)

import Pkg
using Weave
source_file = joinpath("content", lesson, "_index.Jmd")
target_file = joinpath("dist", replace(source_file, "index.Jmd" => "index.md"))
cd(joinpath("content", lesson))
Pkg.activate(".")
weave(
    source_file,
    out_path=target_file,
    doctype="github"
)