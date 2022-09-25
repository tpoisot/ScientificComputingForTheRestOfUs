using Literate
import HTTP
import Pkg

# References
include(joinpath(@__DIR__, "bibliorender.jl"))
bibfile = joinpath(@__DIR__, "references.bib")
references = Bibliography.import_bibtex(bibfile)

# aiiiii
files_to_build = []

# Get the top-level folders
content_path = joinpath(@__DIR__, "content")

mkpath(joinpath(@__DIR__, "dist", "content"))

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
    content = replace(
        content,
        r"!{3}[ ]{0,1}DOMAIN ((.+\n)+)\n" =>
            s"{{< callout domain >}}\n\1{{< /callout >}}\n\n",
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

function replace_reference(content)
    rx = r"!{3}[ ]{0,1}REF (.+)"
    content = replace(
        content,
        rx =>
            s ->
                "{{< callout reference >}}\n" *
                fmt(references[match(rx, s).captures[1]]) * "{{< /callout >}}\n\n",
    )
    return content
end

function fmt_pkg(pkgname)
    hub_url = "https://juliapackages.com/p/$(pkgname)"
    try
        HTTP.request("GET", hub_url)
    catch error
        return "<span class='package no-hub'><span class='pkgname'>$(pkgname)</span></span>"
    else
        return "<span class='package'><span class='pkgname'><a href='$(hub_url)' target='_blank'>$(pkgname)</a></span></span>"
    end
end

function replace_packagename(content)
    rx = r"{{(\w+)}}"
    content = replace(
        content,
        rx => s -> fmt_pkg(match(rx, s).captures[1]),
    )
    return content
end

function post_processor(content)
    return content |> replace_callouts |> replace_images |> replace_mermaid |>
           replace_reference |> replace_packagename
end

# Actually build the content
for file in files_to_build
    # This is super-duper required because when calling Pkg stuff within a
    # module, it changes the current project outside of the module as well,
    # which is supercharged turbo mega-bullshit
    Pkg.activate(pwd())
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
        append!(images, filter(endswith(".svg"), readdir(root; join = true)))
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

# Walk the content directory
for (root, dirs, files) in walkdir(content_path)
    index_file = filter(isequal("_index.md"), files)
    if ~isempty(index_file)
        readme = only(index_file)
        src = joinpath(root, readme)
        dst = replace(src, "content" => "dist/content")
        cp(src, dst; force = true)
    end
end