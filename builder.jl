using Literate
using TOML
using JSON

# Get the top-level folders
content_folder = readdir(joinpath(@__DIR__, "content"); join=true, sort=true)

# Function to remove everything that isn't a Literate folder
function isvalid(_folder)::Bool
    isdir(_folder) || return false
    "_index.jl" in readdir(_folder) || return false
    return true
end

# List of folders to build
folders_to_build = filter(isvalid, content_folder)

# Actually build the content
for folder in folders_to_build
    try
        destination_folder = replace(folder, "content" => joinpath("dist", "content"))
        ispath(destination_folder) && mkpath(destination_folder)
        index_file = joinpath(folder, "_index.jl")
        Literate.markdown(index_file, destination_folder; flavor=Literate.CommonMarkFlavor(), config=Dict("credit" => false, "execute" => true))
    catch e
        print(e)
    end
end