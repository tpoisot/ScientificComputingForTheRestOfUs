# ---
# title: Documenting functions
# status: alpha
# ---

# In this module,

# <!--more-->

"""
    twice(x::T) where {T <: Real}

The function `twice` will return, for an input `x` which is a `Real` number, the result of the x+x operation.
"""
function twice(x::T) where {T <: Real}
    return x + x
end

#-

@doc twice

#-

"""
    twice(::Type{R}, x::T) where {R <: Real, T <: Real}

The function `twice` will return, for an input `x` which is a `Real` number, the result of the x+x operation. The result will be converted to the type `R` given as the first argument, which must also be a real number.
"""
function twice(::Type{R}, x::T) where {R <: Real, T <: Real}
    return convert(R, x + x)
end

#-

twice(Float64, 2)

#-

@doc twice
