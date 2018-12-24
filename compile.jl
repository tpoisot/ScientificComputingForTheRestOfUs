using Pkg
Pkg.activate(".")

using Weave

const content_folder = joinpath(pwd(), "content")

scss_files = ["configuration", "index"]
for scss_file in scss_files
    run(`sass themes/shebang/static/css/$(scss_file).scss themes/shebang/static/css/$(scss_file).css`)
end


for content_type in ["lessons", "primers", "capstones"]
    this_content_folder = joinpath(content_folder, content_type)
    raw_files = filter(x -> endswith(x, ".Jmd"), readdir(this_content_folder))
    for this_file in raw_files
        @info this_file
        weave(joinpath(this_content_folder, this_file), doctype="hugo")
    end
end
