Starting with the most prominent examples (TeX and METAFONT), may be too forbidding.
And like them, many of the earliest published examples require that

> Before you try to read a WEB program, you should be familiar with the Pascal language.

Knuth has moved on from Pascal to C, and has published many examples of literate
programming [on his website](https://cs.stanford.edu/~uno/programs.html).  But they
are in the CWEB format (`.w` files), and people with only a passing curiosity (or
none) in literate programming may not take the trouble to download and run them
through `cweave` and `tex`, to read them the way they were intended to be read.



Looking at examples first will be good before you read the [paper](http://www.literateprogramming.com/knuthweb.pdf).

Knuth's examples:

- In WEB:
  - glue.web (Fixed-Point Glue Setting) http://northstar-www.dartmouth.edu/doc/texmf-dist/doc/generic/knuth/tex/glue.pdf https://tug.org/TUGboat/tb03-1/tb05knuth.pdf
  - Literate programming paper (Generating Primes): Distributed in [texmf/doc/web/](http://www.pd.infn.it/TeX/doc/web/) also online at e.g. [here](http://www.cs.tufts.edu/~nr/cs257/archive/don-knuth/web.pdf)
  - Bentley _Programming Pearls_ columns
      - May 1986: generate M random integers in 1 to N
      - April 1987: Print k most common words in a file
  - TeX
  - METAFONT
- In CWEB:
  - Included with CWEB distribution (https://www.ctan.org/tex-archive/web/c_cpp/cweb/examples)
  - Stanford GraphBase (32 programs)
  - MMIXWARE (10 programs)
  - The list of programs on his website.

Other people's examples:

- van Wyk's columns
    - July 1987 Printing common words (by David Hanson)
    -
- Thimbleby's Java code at http://www.harold.thimbleby.net/cv/files/cpp.pdf (pages 13 to 15) which does not use any literate-programming features.
- Norman Ramsey, "A simple solver for linear equations containing nonlinear operators" http://docs.lib.purdue.edu/cgi/viewcontent.cgi?article=2241&context=cstech
- Les Carr's "Animated Code Annotator": http://users.ecs.soton.ac.uk/lac/annann.html -- shows the evolution of a file through its diffs / commit history for a file.
- see e.g. http://www.math.umd.edu/~hking/MorseExtract.w

Also:

- https://github.com/izabera/ulam/ which has un-literate-d Knuth's ULAM :-)
