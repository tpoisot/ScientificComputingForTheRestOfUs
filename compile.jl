using Pkg
Pkg.activate(".")

using Weave

const content_folder = joinpath(pwd(), "content")

for content_type in ["lessons", "primers", "capstones"]
    this_content_folder = joinpath(content_folder, content_type)
    raw_files = filter(x -> endswith(x, ".Jmd"), readdir(this_content_folder))
    for this_file in raw_files
        weave(joinpath(this_content_folder, this_file), doctype="github")
    end
end
