using Pkg
Pkg.activate(".")

using Weave
using Random

const content_folder = joinpath(pwd(), "content")

#scss_files = ["configuration", "index"]
#for scss_file in scss_files
#    run(`sass themes/shebang/static/css/$(scss_file).scss themes/shebang/static/css/$(scss_file).css`)
#end

for content_type in ["lessons", "primers", "capstones", "machinelearning"]
    this_content_folder = joinpath(content_folder, content_type)
    raw_files = filter(x -> endswith(x, ".Jmd"), readdir(this_content_folder))
    for this_file in raw_files
        Random.seed!(42) # All files have the same seed - will it work in Weave?
        target_file = replace(this_file, ".Jmd" => ".md")
        file_time = mtime(joinpath(this_content_folder, this_file))
        trgt_time = mtime(joinpath(this_content_folder, target_file))

        if file_time > trgt_time
            @info "UPDATING:   $(joinpath(content_type, target_file))"
            weave(joinpath(this_content_folder, this_file), doctype="hugo")
            @info "UPDATED:   $(joinpath(content_type, target_file))"
        else
            @info "NOT CHANGED: $(joinpath(content_type, target_file))"
        end
    end
end
