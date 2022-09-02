import Bibliography
import BibInternal
import Mustache

bibfile = joinpath(@__DIR__, "references.bib")
references = Bibliography.import_bibtex(bibfile)

#x = references["wilson2017good"]
x = references["wilson2014best"]

function format(name::BibInternal.Name)
    _tmpl = Mustache.mt"<span class='name'>{{{:first}}} {{{:particle}}} {{{:middle}}} {{{:last}}}</span>"
    return Mustache.render(_tmpl, name)
end

function format(names::Vector{BibInternal.Name})
    byline = join(format.(names), ", ", " and ")
    return "<span class='authors'>" * replace(byline, r"[ ]+" => s" ") * "</span>"
end

function format(publication::BibInternal.In)
    _tmpl = Mustache.mt"""
        <span class='journal'>{{{:journal}}}</span>
        {{{#:volume}}}{{{:volume}}}{{{/:volume}}}
        {{{#:number}}}({{{:number}}}){{{/:number}}}
        """
    return Mustache.render(_tmpl, publication)
end

format(x.authors)
format(x.in)
