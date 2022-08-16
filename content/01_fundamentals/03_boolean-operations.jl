# ---
# title: Booleans operations
# weight: 3
# ---

# ## Programming really *is* a language

# But if you understand three words, you will be able to hold a good
# conversation with your computer! These three words are *if*, *for*, and
# *while*. If you have some previous experience with writing code, you can skim
# through this lesson and the next.

# One great way to make your code robust is to keep it very simple, and one
# great way to keep your code very simple is to recognize that often, we want to
# do one of three things: do one thing if something happens (`if`), do one thing
# to a series of things (`for`), or do one thing until something happens
# (`while`). These three possibilities define what we call the *control flow*,
# or the *flow of execution*. In the current lesson, we will focus on
# understanding the `if` statement.

# ## After this lesson, you will be able to ...

# - ... express your problems in Boolean terms (true/false)
# - ... understand the different Boolean operators
# - ... create conditionals

# ## Tossing coins and planning trips

# Let's imagine a situation where we have a coin, and we can toss this coin. One
# output of this observation is whether the coin landed on its head, or on its
# tail. We can express the outcome of coin toss as a *statement*: "it is true
# that the coin landed on its head", or "it is not true that the coin landed on
# its head".

# This is not how we would think about the outcome as humans. It would be more
# natural to say "head" or "tail". But expressing things as *true* or not true
# (which we call *false*) is much more easier for computers to understand. A
# great deal of programming is finding out ways to reduce the outcomes to
# *true*/*false* statements.

# In fact, there is a name for this type of data: Boolean. In the Boolean world,
# things are either *true*, or *false*, and we decide accordingly. Very often,
# we think in Boolean terms without noticing it! For example, when wondering if
# it is faster to go to work by bus, or by bike, we are expressing in our own
# way the question of "going to work by bus is faster than by bike, true or
# false?".

# And then, we will of course take a decision based on the outcome of this
# question. "If it is faster to go by bike, then I will go by bike".

# Have you noticed that the word *if* appeared a lot in the past few sentences?
# It is because `if` is the first way to control the flow of execution. It is
# one of the words that many programming languages already know (we call these
# *keywords*), and it lets us decide what to do when confronted with alternative
# choices.

# Let's say I am sitting in my office, and I need to attend a meeting on the
# other side of campus. After looking at the itinerary, I can either bike (4
# minutes) or walk (13 minutes). To decide what to do, I can ask the following
# question to my computer:

# ~~~
# walking takes 13 minutes
# biking takes 4 minutes
# if (walking is faster than biking)
#     tell me to walk
# ~~~

# This block above is called *pseudocode*. It is a way to start expressing our
# ideas in a language we can understand, but that resembles what the computer
# speaks. We will write quite a lot of it.

# Now, let's give this a try - before you do, what do you think will happen?

time_by_foot = 13
time_by_bike = 4
if time_by_foot < time_by_bike
    println("You should walk")
end


# Uh, weird! Nothing happened.

# Let's think about why. We asked the computer to compare the time by foot and
# the time by bike; if the time by foot is shorter, then we print a line
# (`println`) telling us to walk. But we know that the time by foot is *not*
# shorter, and so does the computer. And for this reason, whatever is between
# `if` and `end` is *not* executed. Testing that conditions are met are one way
# to save time -- we do not want to run operations that are not useful.

# In the above example, we gave no alternative to the computer. To decide
# between two (or more) things to do, we need to use `if`'s frequent partner:
# `else`. Let's try again:

time_by_foot = 13
time_by_bike = 4
if time_by_foot < time_by_bike
    println("You should walk")
else
    println("You should bike")
end

# This time, we get the right output: `You should bike`. This brings a very
# important point: we need to be *explicit*; when talking with humans, we can
# understand (or guess) what the alternative choice is. Computers have no such
# abilities: everything that happens is the outcome of things we (or others)
# have written in the code.

# In practice, we will want to make decisions based on several factors. This is a
# thing at which Boolean values excel: we can perform *operations* on them. The
# most common ones are *not*, *or*, and *and*.

# The *not* operation is, quite literaly, the opposite of a statement. For
# example, if we state "it is true that the coin landed on its head", then *not*
# this statement is "it is *not* true that the coin landed on its head", which
# is the same thing as "it is false than the coin landed on its head".

# Most programming languages use `!x` to mean *not x*. If we run the code below,
# what you do think will happen?

println(!true)

#-

println(!false)

# Adding `!` in front of a statement will return the *other* Boolean value.

# Boolean values can also be *combined*. Coming back to deciding on a mode of
# transportation: the same trip by subway would take 8 minutes. Biking is still
# faster, but what if it is raining? We can add a rule, to say:

# ~~~
# if it rains
#     take the subway
# else
#     if the subway is faster than biking
#         take the subway
#     else
#         take the bike
# ~~~

# This block above is called a *nested* statement. We start with an `if`, and
# then *within it*, have another `if`. This is not *too* bad, but increasing the
# nestedness of statements is a very effective way of having too much
# complexity! And too much complexity is, in turn, a great way to introduce
# mistakes that are hard to understand. This is, generally, the opposite of what
# we want to do.

# So we can re-word this expression slightly:

# ~~~
# if (the subway is faster than the bike) or (it rains)
#     take the subway
# else
#     take the bike
# ~~~

# There is a new word here: *or*. The *or* operator will look at both statements
# (Is the subway faster? Is it raining?), and return `true` if *either* of them
# is true. Let's have a look:


println("true or false:\t", true || false)
#-
println("false or false:\t", false || false)
#-
println("false or true:\t", false || true)
#-
println("true or true:\t", true || true)
#-

# Most programming languages will use `||` or `or` or `|` to write the *or*
# operation. We can now fine tune our code, to decide between the subway and the
# bike, as a function of the weather. Run the cell below: what do you expect?

time_by_subway = 8
time_by_bike = 4
rain = true

#-

if (time_by_subway < time_by_bike) | rain
    println("You should take the subway")
else
    println("You should bike")
end

# Because it rains (`rain = true`), our code is correctly telling us to take the
# subway.

# At this point, it is important to note that there are many, many ways to write
# the same code. Maybe you would like to ask the question "Is it *not* raining?"
# instead, or decide which mode of transporation takes the longest time. As long
# as they give the correct answer, all of these formulations are valid. The
# important thing is that they let you write code that is easy to read, and easy
# to understand.

# What if nested statements are easier to understand for you? Well, this is
# fine. The most important thing is to write code that prevents you from making
# mistakes. If you are more confident in your nested statements, then use them!

# Before we move on, there is a final operation on Booleans we need to discuss:
# *and*. Most programming languages will use `&` or `&&` or `and` to describe
# it. The *and* operation will look at both statements, and return *true* only
# if both are *true*:

println("true and false:\t", true && false)
#-
println("false and false:\t", false && false)
#-
println("false and true:\t", false && true)
#-
println("true and true:\t", true && true)

# **So far**, we have learned about Boolean values, and the *if* operation.
# Using *if* is a way to look at a statement, and do different things when it is
# true or false. In a lot of cases, we want to also perform operations on a
# large number of elements. To do so, we will use the second word: *for*. But
# because it is a confusing one, we will do so in the next lesson.