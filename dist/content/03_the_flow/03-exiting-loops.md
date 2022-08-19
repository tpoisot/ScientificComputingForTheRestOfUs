---
title: Exiting loops
weight: 3
---

In the previous two modules, we have written loops that terminate when a
condition is met (`while`), or when the collection has been iterated over
entirely (`for`). In some cases, we may want to fine-tune the behavior of our
iteration. In these cases, we can use some special keywords to jump out of the
loop entirely, or skip some steps.

Let's say that we want to generate sequences of mRNA that look legit enough to
fool a very naïve program, which is a good thing because we will use a very
naïve program to generate them. Specifically, we want sequences that will have
an *AUG* codon at the start, end with one of ochre (*UAA*), amber (*UAG*), or
opal (*UGA*), located at some multiple number of three bases after the start
codon. To make things a little more fun, we can also get sequences that are
only between 40 and 50 bases long.

An example of such a sequence is (minus the length requirement):

````julia
seq = "AUGUGAGAGUAA"
````

````
"AUGUGAGAGUAA"
````

Assuming that our RNA sequence is going to be represented as a string, we can
check its "validity" with a series of simple tests. First, that the length of
the sequence is a multiple of three:

````julia
iszero(length(seq) % 3)
````

````
true
````

Then that the first three positions are a start codon:

````julia
isequal("AUG")(seq[1:3])
````

````
true
````

Finally, that the last three positions are a stop codon:

````julia
seq[(end-2):end] in ["UAA", "UAG", "UGA"]
````

````
true
````

We can now start *generating* sequences like this at random. Our strategy in
this module will be to start from a giant sequence:

````julia
rnd_seq = String(rand("AUGC", 10_000));
rnd_seq[1:10]
````

````
"CAUGUCUGAG"
````

We will then look for possible initiations sites (using the `findall`
function), then for all of the possible sites we found, we can look for all
possible stop positions, then check that the sequence has a length between 40
and 50 which is also a multiple of three. And because we presumably want to
repeat this process a lot, we want to do as few iterations as possible. This
is where `continue` and `break` will be very useful.

In order to use `continue` and `break` efficiently, it helps to have a sense
of when we need to skip to the next possible solution, and a sense of when we
can stop the iteration entirely. Let's therefore setup a quick example. We can
find the first start codon:

````julia
start_position = findfirst("AUG", rnd_seq)
````

````
2:4
````

The codon position is represented as a range (you can check with `typeof`),
specifically a `UnitRange`. We can therefore get the position where it starts
with

````julia
start_position[begin]
````

````
2
````

We can look for the next *UGA* stop codon after this position (this is mostly
an unsubtle way to get you to look at the documentation for `findnext`, as we
will use `findall` to brute-force our way through the actual problem):

````julia
stop_position = findnext("UGA", rnd_seq, start_position[end])
````

````
7:9
````

Again, this is expressed as a range, and so the sequence will stop at

````julia
stop_position[end]
````

````
9
````

Its *length* is therefore

````julia
stop_position[end] - start_position[begin] + 1
````

````
8
````

When do we want to skip an iteration? A first criteria is that, assuming we do
not call `findnext`, the stop codon starts *before* the start codon -- this is
when we call `continue` to move on, as nothing about this sequence will be
useful (the sequence would in fact be empty). Using the short-circuit notation
to avoid writing a full `if` statement, we can express this as the following
one-liner (it is not going to work outside of a loop, as `continue` has no
effect):

~~~
(stop_position[begin] > start_position[end]) || continue
~~~

Similarly, we want to skip ahead if the sequence length is not a multiple of
three:

~~~
iszero(seq_length % 3) || continue
~~~

Only when the sequence length is between 40 and 50 do we want to save the
sequence, and exit (`break`) out of the loop:

~~~
if 40 <= seq_length <= 50
    tmp_seq = rnd_seq[start_position[begin]:stop_position[end]]
    break
end
~~~

With this information, we can build an actual loop. We are decidedly not being
fancy here, by using `findall` to get all instances of both start and stop
codons, and essentially hoping that the random sequence is long enough that we
will find a subset of it with the correct properties:

````julia
seq_found = false

for start_position in findall("AUG", rnd_seq)
    global seq_found
    global tmp_seq
    for stop_codon in ["UAA", "UAG", "UGA"]
        for stop_position in findall(stop_codon, rnd_seq)

            (stop_position[begin] > start_position[end]) || continue

            seq_length = stop_position[end] - start_position[begin] + 1

            iszero(seq_length % 3) || continue

            if 40 <= seq_length <= 50
                seq_found = true
                tmp_seq = rnd_seq[start_position[begin]:stop_position[end]]
                break
            end

        end

        seq_found && break

    end

    seq_found && break

end
````

````julia
print("Found a sequence of length $(length(tmp_seq)):\n$(tmp_seq)")
````

````
Found a sequence of length 45:
AUGAUCACAUGGAGGAGCUCAUCGUAAUUGUUUAAGACCAAAUGA
````

