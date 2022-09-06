import Bibliography
import BibInternal

function fmt(name::BibInternal.Name)
    joined_name = replace(join([name.first, name.middle, name.last], " "), r"(\s+)" => s" ")
    return joined_name
end

function fmt(authors::Vector{BibInternal.Name})
    if length(authors) >= 3
        return fmt(first(authors)) * " *et al.*"
    else
        return join(fmt.(authors), ", ", " & ")
    end
end

function fmt(access::BibInternal.Access)
    if ~isempty(access.doi)
        return "[`$(access.doi)`](https://doi.org/$(access.doi))"
    elseif ~isempty(access.url)
        return "[URL]($(access.url))"
    end
    return ""
end

function fmt(pubedin::BibInternal.In)
    return "*$(pubedin.journal)* $(pubedin.volume)($(pubedin.number)) $(pubedin.pages)"
end

function fmt(entry::BibInternal.Entry)
    auth = fmt(entry.authors)
    title = "\"$(entry.title)\""
    link = fmt(entry.access)
    pubedin = fmt(entry.in)
    bib_string = "$(auth) ($(entry.date.year)). $(title); $(pubedin)\n$(link)"
    bib_string = replace(bib_string, "{\\c{c}}" => "ç")
    bib_string = replace(bib_string, r"{(\w+)}" => s"\1")
    return bib_string
end