# ---
# title: Consuming data from APIs
# status: alpha
# ---

# <!--more-->

using HTTP, JSON

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

endpoint = "https://api.zippopotam.us/ca/qc/rimouski"

#-

res = HTTP.get(endpoint)

#-

res.status

#- 

JSON.parse(String(res.body))