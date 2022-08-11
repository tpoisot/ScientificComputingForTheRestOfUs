# ---
# title: Flowcharts
# weight: 2
# ---

#=
One of the most powerful tool to plan a programming task is to draw a flochart.
In simple terms, a flowchart will let you map the different steps that the
program will have to follow, and see what is required for each of them. To
illustrate, we will use a flowchart not of a program, but of a pancake recipe.

At the beginning, it can be useful to break the task down into coarse steps:

{{< mermaid >}}
graph LR

prepare --> cook
cook --> eat
{{< /mermaid >}}

This is not much to look at, but this is a very high-level view of what we want
to achieve. It is also easy to zoom in on every task, and try to further break
it down into smaller tasks. Let's do this for the task at left: *prepare*.

{{< mermaid >}}
graph LR

liquid[liquid ingredients] --> batter
solid[solid ingredients] --> batter
batter --> cook
cook --> eat
{{< /mermaid >}}

"All" we have done so far is to split the *prepare* step into the preparation of
solid and liquid ingredients. To come up with a full flowchart, we need to
repeat this process until we are satisfied by the completeness of it:

{{< mermaid >}}
graph LR

liquid[liquid ingredients] --> mix{mix}
solid[solid ingredients] --> mix
mix --> batter
batter --> cook{cook}
cook --> eat{eat}
{{< /mermaid >}}

Notice that we have introduced a new shape: the rotated square will be used to
note *actions*, and anything else will be either an output or an input of these
actions.

{{< callout opinion >}}
We like the idea of using different shapes to indicate different steps: what
goes in, what is the action, are there any artifacts produced or side-effects?
This being said, even a very coarse flowchart can help you.
{{< /callout >}}

If we repeat the exercise for most of the boxes, we may end up with a flowchart
like this. It might seem a little overwhelming at first, but this is a helpful
document. It maps out the precise steps and processes in your project, and can
help you both to *plan* what to write, but also to *understand* what you have
written previously.

{{< mermaid >}}
graph TD

flour --> sift{sift}
sugar --> mix1{mix}
bak[baking powder] --> mix1
salt --> mix1
sift --> mix1

milk --> mix2{mix}
eggs --> whisk1{whisk}
whisk1 --> mix2
butter --> melt{melt}
melt --> mix2

mix1 --> combine{combine}
mix2 --> combine
combine --> batter

griddle[flat griddle] --> heat{heat}

batter --> cook{cook}
heat --> cook

cook --> flip{flip}
flip --> cook2{cook}
cook2 --> pancake

pancake --> eat{eat}

{{< /mermaid >}}

See how a simple task ("make crepes!") can be broken down into dozens of litle
steps, each representing a single well-defined action? Programming is,
essentially, that. We are going to need to specificy things as unambiguously as
possible, and breaking the big tasks down is going to be immensely helpful. 
=#