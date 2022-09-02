import Bibliography
import BibInternal
import Mustache

bibfile = joinpath(@__DIR__, "references.bib")
references = Bibliography.import_bibtex(bibfile)
