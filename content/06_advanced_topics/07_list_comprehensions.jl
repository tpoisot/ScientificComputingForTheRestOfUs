# ---
# title: List comprehensions
# status: alpha
# ---

# In the previous modules, we use iteration by writing code spread across multiple lines.
# This is the usual way to do it, but sometimes it would be nice to have a more concise
# syntax, if for example we only want to perform a very simple operation. In this module, we
# will have a look at list comprehension, a way to create (and manipulate) lists concisely.

# <!--more-->

# For our example, we will work on text analysis. We will, specifically, look at William
# Shakespeare's sonnets, and try to find one we like, and then find another sonnet which is
# the most similar. This is a slightly more difficult task that the previous modules, but
# a nice little intermezzo between jumping into the next topics. 

# We will rely on the {{Languages}} package, 

using Languages
import Downloads

#

sonnets_url = "https://www.gutenberg.org/cache/epub/1041/pg1041.txt"
sonnets = Downloads.download(sonnets_url)

# 

sonnets_text = readlines(sonnets)
filter!(!isempty, sonnets_text)

#

index_start = findfirst(isequal("by William Shakespeare"), sonnets_text)
index_stop = findfirst(
    isequal("*** END OF THE PROJECT GUTENBERG EBOOK THE SONNETS ***"),
    sonnets_text,
)

#

sonnets_text = sonnets_text[(index_start + 1):(index_stop - 1)]

#

sonnets_text = [replace(line, r"^\s+" => "") for line in sonnets_text]

#

roman_numerals = r"^[CIVXML]*$"

#

match(roman_numerals, sonnets_text[1])

#

match(roman_numerals, sonnets_text[2])

#

starts = findall(line -> !isnothing(match(roman_numerals, line)), sonnets_text)
stops = push!(starts[2:end], length(sonnets_text)) .- 1

#

documents = [sonnets_text[(starts[i] + 1):stops[i]] for i in axes(stops, 1)]

#

stop_en = stopwords(Languages.English())

# We can now pick a sonnet we like, to get a sense of how the data are currently organized.

documents[55]

#

join(documents[55], " ")

# 

lowercase(replace(join(documents[55], " "), r"[,:.;’'!]" => ""))

#

function cleanup(lines::Vector{String})
    text = join(lines, " ")
    text = replace(text, "’d" => "ed")
    text = replace(text, "’s" => "")
    text = replace(text, "’ll" => " will")
    text = replace(text, "’ " => "")
    text = replace(text, "-" => " ")
    text = replace(text, "-" => " ") # these are two different signs!
    text = replace(text, r"[,:.;!?‘’]" => "")
    return lowercase(text)
end

#

cleaned_sonnets = [cleanup(sonnet) for sonnet in documents]

#

wordbags =
    [filter(w -> !(w in stop_en), split(sonnet, " ")) for sonnet in cleaned_sonnets]

#

function cosine_similarity(d1, d2)
    all_words = unique(vcat(d1, d2))
    counts = zeros(Int8, 2, length(all_words))
    for (i, w) in enumerate(all_words)
        counts[1, i] = length(findall(isequal(w), d1))
        counts[2, i] = length(findall(isequal(w), d2))
    end
    AB = sum(counts[1, :] .* counts[2, :])
    A = sqrt(sum(counts[1, :] .^ 2.0))
    B = sqrt(sum(counts[2, :] .^ 2.0))
    return AB / (A * B)
end

#

scores = [
    (i, j, cosine_similarity(wordbags[i], wordbags[j])) for
    i in 1:(length(wordbags) - 1)
    for j in (i + 1):length(wordbags)
]

# 

similarto = [score for score in scores if (score[1] == 55) | (score[2] == 55)]

# 

findmax([score[3] for score in similarto])

#

similarto[16]

#

documents[16]
