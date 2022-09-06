import Bibliography
import BibInternal

function fmt(name::BibInternal.Name)
    replace(join([name.first, name.middle, name.last], " "), r"(\s+)" => s" ")
end

function fmt(authors::Vector{BibInternal.Name})
    join(fmt.(authors), ", ", " & ")
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
    return "$(auth) ($(entry.date.year)). $(title); $(pubedin)\n$(link)"
end