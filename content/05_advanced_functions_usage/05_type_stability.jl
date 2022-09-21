# ---
# title: Type stability
# status: alpha
# ---

# In this module, we will talk about *type stability*, and see how we can
# annotate the functions in *Julia* to be explicit about what type they return.

# <!--more-->

function nope()::Nothing
    return nothing
end

#-

nope()