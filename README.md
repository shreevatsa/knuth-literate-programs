# Misunderstandings about Literate Programming
What does Knuth mean by "literate programming"?

It is clearest if we look at actual examples.

Starting with the most prominent examples (TeX and METAFONT), may be too forbidding.
And like them, many of the earliest published examples require that

> Before you try to read a WEB program, you should be familiar with the Pascal language.

Knuth has moved on from Pascal to C, and has published many examples of literate
programming [on his website](https://cs.stanford.edu/~uno/programs.html).  But they
are in the CWEB format (`.w` files), and people with only a passing curiosity (or
none) in literate programming may not take the trouble to download and run them
through `cweave` and `tex`, to read them the way they were intended to be read.

So I've done that here.
