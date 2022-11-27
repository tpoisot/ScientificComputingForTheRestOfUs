# ---
# title: List comprehensions
# status: alpha
# ---

# In the previous modules, we use iteration by writing code spread across multiple lines.
# This is the usual way to do it, but sometimes it would be nice to have a more concise
# syntax, if for example we only want to perform a very simple operation. In this module, we
# will have a look at list comprehension, a way to create (and manipulate) lists concisely.

# <!--more-->

# For our example, we will work on text analysis. We will, specifically, try to extract the 

# We will rely on the {{Languages}} package, 

using Languages
import Downloads

#

documents = ["https://www.gutenberg.org/cache/epub/40365/pg40365.txt"]

#

stops = stopwords(Languages.English())
