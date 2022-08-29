using Literate

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

# Function for callouts
function replace_callouts(content)
    content = replace(
        content,
        r"!{3}[ ]{0,1}INFO ((.+\n)+)\n" =>
            s"{{< callout information >}}\n\1{{< /callout >}}\n\n",
    )
    content = replace(
        content,
        r"!{3}[ ]{0,1}OPINION ((.+\n)+)\n" =>
            s"{{< callout opinion >}}\n\1{{< /callout >}}\n\n",
    )
    content = replace(
        content,
        r"!{3}[ ]{0,1}DANGER ((.+\n)+)\n" =>
            s"{{< callout danger >}}\n\1{{< /callout >}}\n\n",
    )
    content = replace(
        content,
        r"!{3}[ ]{0,1}WARNING ((.+\n)+)\n" =>
            s"{{< callout warning >}}\n\1{{< /callout >}}\n\n",
    )
    return content
end

function replace_images(content)
    content = replace(
        content,
        r"!\[\]\((\d+.\w{3})\)\n" => s"\n![](/plots/\1)\n",
    )
    return content
end

function replace_mermaid(content)
    content = replace(
        content,
        r"MERMAID\n((.+\n)+)\n" =>
            s"<div class='mermaid' align='center'>\n\1</div>\n\n",
    )
    return content
end

function post_processor(content)
    return content |> replace_callouts |> replace_images |> replace_mermaid
end

# Actually build the content
for file in files_to_build
    try
        destination_folder = replace(file, "content" => joinpath("dist", "content"))
        path_elements = splitpath(destination_folder)
        # Folder and file
        root = joinpath(path_elements[1:(end - 1)])
        stem = replace(path_elements[end], ".jl" => "")
        # Create the location
        ispath(root) || mkpath(root)
        Literate.markdown(
            file,
            root;
            flavor = Literate.CommonMarkFlavor(),
            config = Dict("credit" => false, "execute" => true),
            name = stem,
            postprocess = post_processor,
        )
        # Move images
        images = filter(endswith(".png"), readdir(root; join = true))
        if ~isempty(images)
            images_go_to = joinpath(@__DIR__, "dist", "static", "plots")
            ispath(images_go_to) || mkpath(images_go_to)
            for image in images
                mv(image, joinpath(images_go_to, last(splitpath(image))); force = true)
            end
        end
    catch e
        print(e)
    end
end
