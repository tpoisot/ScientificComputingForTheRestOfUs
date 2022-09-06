# ---
# title: Consuming data from APIs
# status: rc
# ---

# Not all data come from static files. In a large number of scientific
# applications, we need to collect data from websites, often using a [RESTful
# API][rest]. In this module, we will use a very simple example to show how we
# can collect data about postal codes, get them as a JSON file, and process
# them.

# [rest]: https://www.redhat.com/en/topics/api/what-is-a-rest-api

# <!--more-->

# In order to make this example work, we will need two things: a way to interact
# with remote servers (provided by the {{HTTP}} package), and a way to read JSON
# data (using {{JSON}}, as we have seen in the previous module.)

import HTTP
import JSON

# In this example, we will get the names and coordinates of the various post
# codes in [Rimouski][riki], a (small) city in Québec, Canada. The
# [`zippopotam.us`][zip] website offers an API that we can access without a
# login or an access token, and is therefore perfect for this example.

# [riki]: https://en.wikipedia.org/wiki/Rimouski
# [zip]: https://api.zippopotam.us

# The basic loop of interaction with an API for data retrieval is:

# 1. Figure out the correct query parameters; there is no global recipe here,
#    each API will have its documentation explaining which keywords can be used
#    and what values they accept
# 2. Write the URL to the correct endpoint, composed of the API root and the
#    query parameters
# 3. Perform an HTTP request (usually `GET`) on this endpoint
# 4. Check the response status (`200` is a good sign, anything else should be
#    checked against the [IANA status codes list][iana])
# 5. Read the body of the response in the correct format (usually JSON, but each
#    API will have its own documentation)

# [iana]: https://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml

# !!!INFO HTTP status codes are a "soft" standard that most people and services
# agree on. For example, `404` means that the resource was not found, `403` that
# it is forbidden to access, and `500` that something went wrong on the server.
# If you work with APIs often as part of your work, it is very important to get
# acquainted with them.

# In our case, after reading the API documentation, we know that we need to get
# to the endpoint that is given by `country/province/name`:

api_root = "https://api.zippopotam.us"
place = (country = "ca", province = "qc", name = "rimouski")
endpoint = "$(api_root)/$(place.country)/$(place.province)/$(place.name)"

# Now that we have this endpoint setup, we can perform a `GET` request, which is
# one of the many [HTTP verbs][verbs]. A `GET` request will request the content
# of a page for our consumption. Other commnly used verbs include `LIST` (to get
# a list of multiple resources), `POST` to upload formatted data, and `PATCH` to
# edit data on the API.

# [verbs]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods

res = HTTP.get(endpoint)

# Because `res` is a new type of object, we can take a look at its fields:

typeof(res)

#-

fieldnames(typeof(res))

# The first thing we want to check is the response status, specifically that it
# is equal to `200`:

isequal(200)(res.status)

# We can also inspect the headers:

res.headers

# This stores a lot of interesting information, but as a vector of pairs. We can
# make our life significantly easier by turning this into a dictionary. For
# example, we can confirm that the API is indeed giving us data in the
# `application/json` format:

Dict(res.headers)["Content-Type"]

# With this information, we can get the actual content of our request, which is
# stored in the `body` field.

# !!!DANGER The `body` field is *cleared* when first accessed. This is a strange
# quirk, but it do be like that. The safest way to handle the body (because we
# do not want to lose our request!) is to store it in a variable.

body = res.body
typeof(body)

# This is unexpected! We were promised an `application/json` content, and here
# we are with a long array of unsigned 8-bit encoded integers. Why? In a
# nutshell: there is no reason to expect that we will be querying text. We can
# use {{HTTP}} to request sound, images, videos, or even streaming data. And so
# what we get is the *raw* output. Thankfully, we can transform it into a
# string:

String(copy(body))

# !!!WARNING We are using `copy` here because if we access `body` directly, it
# *will* be cleared. The recommended design pattern when dealing with {{HTTP}}
# responses it to process the `body` field in one go, to avoid losing this
# information:

# We are now a step away from having our JSON object:

riki = JSON.parse(String(body))

# !!!WARNING If you run this line a second time, it will fail -- this is because
# you have access these `body` already, and so it is now empty. This module has
# a lot of warnings. Welcome to working with remote data.

# The output we get is now our standard JSON object, so we can do a little thing
# like:

for place in riki["places"]
    @info "The post code for $(place["place name"]) is $(place["post code"])"
end

# Most APIs we use in practice for research are a lot more data-rich, and can
# have highly structured fields. When this is the case, it is a good idea to
# take the output and represent it as a custom type: an example of this approach
# can be found in, *e.g.*, the {{GBIF}} package for biodiversity data retrieval.