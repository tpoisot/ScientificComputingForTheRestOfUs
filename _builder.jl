lesson = first(ARGS)

import Pkg

using Weave
using TOML
using JSON

cd(joinpath("content", lesson))

Pkg.activate(".")
Pkg.instantiate()

if isfile("Project.toml")
    _proj = TOML.parsefile("Project.toml")
    if "deps" in keys(_proj)
        dpath = joinpath("..","..", "..", "dist", "data", "dependencies", lesson)
        ispath(dpath) || mkpath(dpath)
        open(joinpath(dpath, "deps.json"),"w") do f
            JSON.print(f, _proj["deps"])
        end
    end
end

weave(
    "_index.Jmd",
    out_path=joinpath("..", "..", "..", "dist", "content", lesson, "_index.md"),
    doctype="github"
)