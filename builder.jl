using Literate
import HTTP
import Pkg

# This code is here to manage the references -- references are specific callout
# blocks that only have a bibtex key in them (for now), and can only be articles
# (for now)
include(joinpath(@__DIR__, "bibliorender.jl"))
bibfile = joinpath(@__DIR__, "references.bib")
references = Bibliography.import_bibtex(bibfile)

# This will store all of the .jl files that need to be built
files_to_build = String[]

# Get the top-level folders
content_path = joinpath(@__DIR__, "content")
mkpath(joinpath(@__DIR__, "dist", "content"))

# Walk the content directory to identify the .jl files - everything that is in
# the content folder and is a Julia file gets built, no exception. Note that
# even the index pages are julia files
for (root, dirs, files) in walkdir(content_path)
    source_files = filter(endswith(".jl"), files)
    if ~isempty(source_files)
        append!(files_to_build, joinpath.(root, source_files))
    end
end

# This function feans with the five callouts: info, opinion, warning, danger,
# and domain-specific info -- these are then handled by a Hugo shortcode + sass
# code
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

# This function is a bit fucky because the plots all get sent to a specific
# folder in the static files folder, so we need to look at every image link and
# correct it directly in the markdown file. Also Literate is really fond of
# changing the naming of images and so this wrecks out shit everytime. Thanks
# Literate.
function replace_images(content)
    content = replace(
        content,
        r"!\[\]\((.+.\w{3})\)\n" => s"\n![](/plots/\1)\n",
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

# This manages reference callouts. I forgot how. Some regexp and my apparently
# net positive karma balance.
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

# This one I like - it looks for a package name, and tries to look for its page
# on the juliahub. If it doesn't exist, it's styled differently in the text.
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
        
        # Get the correct paths
        root = joinpath(path_elements[1:(end - 1)])
        stem = replace(path_elements[end], ".jl" => "")
        
        # Create the location of the built lesson if it doesn't exist
        ispath(root) || mkpath(root)
        
        # For local builds speedup, check file existence and mtime before
        # deciding to build
        dist = joinpath(root, stem*".md")
        build = ~isfile(dist)
        if isfile(dist)
            build = mtime(file) > mtime(dist)
        end

        # Build the document
        if build
            Literate.markdown(
                file,
                root;
                flavor = Literate.CommonMarkFlavor(),
                config = Dict("credit" => false, "execute" => true),
                name = stem,
                postprocess = post_processor,
            )
        end

        # Move images for this lesson
        isimage(f) = endswith(".png")(f) || endswith(".svg")(f) 
        images = filter(isimage, readdir(root; join = true))
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
