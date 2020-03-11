using Pkg
Pkg.activate(".")
Pkg.update()
Pkg.instantiate()
Pkg.build()
Pkg.precompile()

using Weave

@info pwd()

const content_folder = joinpath(pwd(), "content")

const content_types = ["lessons", "primers", "capstones", "machinelearning"]

function build_folder(folder)
    raw_files = filter(file -> endswith(file, ".Jmd"), readdir(folder))
    for this_file in raw_files
        target_file = replace(this_file, ".Jmd" => ".md")
        @info "UPDATING\t$(folder)\t$(this_file)"
        weave(joinpath(folder, this_file), doctype="hugo")
    end
end

for content_type in content_types
    @info joinpath(content_folder, content_type)
    build_folder(joinpath(content_folder, content_type))
end

#=
for content_type in ["lessons", "primers", "capstones", "machinelearning"]
    this_content_folder = joinpath(content_folder, content_type)
    raw_files = filter(x -> endswith(x, ".Jmd"), readdir(this_content_folder))
    for this_file in raw_files

        @info "UPDATING:   $(joinpath(content_type, target_file))"
        weave(joinpath(this_content_folder, this_file), doctype="hugo")
        #=
        file_time = mtime(joinpath(this_content_folder, this_file))
        trgt_time = mtime(joinpath(this_content_folder, target_file))

        if file_time > trgt_time
            @info "UPDATING:   $(joinpath(content_type, target_file))"
            weave(joinpath(this_content_folder, this_file), doctype="hugo")
            @info "UPDATED:   $(joinpath(content_type, target_file))"
        else
            @info "NOT CHANGED: $(joinpath(content_type, target_file))"
        end
        =#
    end
end
=#

#scss_files = ["configuration", "index"]
#for scss_file in scss_files
#    run(`sass themes/shebang/static/css/$(scss_file).scss themes/shebang/static/css/$(scss_file).css`)
#end
