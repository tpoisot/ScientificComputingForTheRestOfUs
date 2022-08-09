using Literate
using TOML
using JSON

# Get the folder with the main content
content_folder = joinpath(@__DIR__, "content")

# Function to remove everything that isn't a Literate folder
function isvalid(_folder)::Bool
    isdir(_folder) || return false
    "_index.jl" in readdir(_folder) || return false
    return true
end

# List of folders to build
folders_to_build = filter(isvalid, readdir(content_folder; join=true))

# Actually build the content
for folder in folders_to_build
    destination_folder = replace(folder, "content" => joinpath("dist", "content"))
    ispath(destination_folder) && mkpath(destination_folder)
    index_file = joinpath(folder, "_index.jl")
    Literate.markdown(index_file, destination_folder; flavor = Literate.CommonMarkFlavor())
end