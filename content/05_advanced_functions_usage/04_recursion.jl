# ---
# title: Recursion
# status: alpha
# ---

# What is recursion, if not recursion persevering? In this module, we will see
# how to call functions recursively, and discuss when this is appropriate in
# real life.

# <!--more-->

# A very important type of sequences in molecular biology are palyndromic
# sequences, where reading them on one strand gives a sequence that is
# complementary to the sequence we get when reading it on the other strand. For
# example, the *EcoR1* restriction site has a sequence of GAATTC on the 5' to 3'
# strand, and its complement is CTTAAG on the 3' to 5' strand.

# Can we write a function to check whether a sequence is a palyndrome?
# Absolutely! And we will do so using recursion. But what is recursion? In a few
# words, it is the process of a function calling itself until some stopping
# condition has been met. For example, our function can check that the first
# basis on the 5' to 3' strand is the same as the last basis on the 3' to 5'
# strand, and then do the second and second to last, until the sequence has been
# exhausted or a mismatch found.

# Using recursion, we can write this function without using a loop!

function palyndrome(seq5, seq3, index = 1)
    if index > length(seq5)
        return true
    end
    @info "Checking position $(index)"
    if seq5[index] == seq3[end - index + 1]
        return palyndrome(seq5, seq3, index + 1)
    else
        return false
    end
end

# First, let's ensure that this function works:

palyndrome("GAATTC", "CTTAAG")

#-

palyndrome("GATTTC", "CTAAAG")

# Now, let's take a little dive into what happens internally. We start by
# checking the stop condition (this is counter-intuitive, but it be like that
# sometimes). If we have met the stop conditions, *i.e.* if we have read the
# sequence across all sites, then we know it is a palyndrome and we return
# `true`.

# !!!OPINION The `end-index+1` index in the comparison has a `+1` because
# *Julia* indexes from 1, not 0, and this makes a lot of people angry, because
# programmers are actively looking for reasons to be angry sometimes. Just voice
# on opinion about the tabulations versus spaces, and you'll see what we mean.

# If we have not yet reached the end of the sequence, we perform the comparison.
# If the two bases are different, the sequence is *not* a palyndrome, and we
# return `false`; but if the two bases match, we call the function *again*, this
# time with the next index value.

# !!!WARNING As with `while` loops, recursion will stop whenever recursion will
# stop whenever recursion will stop whenev... sorry what we were going to say
# is: you need to ensure that the stop condition can be reached.

# There are a few reasons to use recursion as opposed to loops. In some cases
# (like looking up inside folders, or looking up values in binary trees), this
# is a much more efficient way to work. Recursion can work with distributed
# computing as well, by starting different calls to the function on multiple
# threads or machines.

# But this is not to say that recursion has not issues - it can perform worse
# than iteration in a substantial amount of cases, and is generally requiring
# that you think about problems in a different way. In any case, it is an
# important tool to have in your programming toolbox!