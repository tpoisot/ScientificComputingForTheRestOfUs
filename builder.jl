using Literate
using TOML
using JSON

# aiiiii
files_to_build = []

# Get the top-level folders
content_path = joinpath(@__DIR__, "content")

# Walk the content directory
for (root, dirs, files) in walkdir(content_path)
    source_files = filter(endswith(".jl"), files)
    if ~isempty(source_files)
        append!(files_to_build, joinpath.(root, source_files))
    end
end

# Actually build the content
for file in files_to_build
    try
        destination_folder = replace(file, "content" => joinpath("dist", "content"))
        path_elements = splitpath(destination_folder)
        # Folder and file
        root = joinpath(path_elements[1:(end-1)])
        stem = replace(path_elements[end], ".jl" => "")
        # Create the location
        ispath(root) || mkpath(root)
        Literate.markdown(file, root; flavor=Literate.CommonMarkFlavor(), config=Dict("credit" => false, "execute" => true), name=stem)
    catch e
        print(e)
    end
end
