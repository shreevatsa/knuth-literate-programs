---
title: Examples of literate programming
---

## Introduction

This page contains PDF versions of some literate programs by Donald Knuth, posted on his webpage at <https://cs.stanford.edu/~knuth/programs.html>. Most of them are in the CWEB system, in which the programmer (Knuth in this case) writes a `.w` file, which is processed either:

- (for the compiler) `foo.w` —-`ctangle`--> `foo.c` (producing a `.c` file that is not very human-readable), or
- (for the human reader) `foo.w` --`cweave`--> `cweave.tex` (producing a `.tex` file to be typeset into PDF, which is the version that is meant to be read).

Prof. Knuth has posted the `.w` files on his webpage, but I'm afraid that many casual readers may not take the time to install `cweave` and `tex`, and thus may try to read the `.w` file directly. So here I've put the typeset versions for anyone to read.

This is the note on his website:

> I write lots of [CWEB](https://cs.stanford.edu/~knuth/cweb.html) programs, primarily for my own edification. If there is sufficient interest, I'll make a large subset of them available via the Internet. For now, I'm listing only a few. […]

He also adds a note that many of the programs “use the conventions and library of [The Stanford GraphBase](https://cs.stanford.edu/~knuth/sgb.html)”.

Here are the programs as listed on his webpage, with the `.w` and `.ch` links changed to corresponding `.pdf` files (from running `cweave` and typesetting them). There may be some errors in the conversion; let me (Shreevatsa) know. (Several "I", "my" etc. below refer to Prof. Knuth, as the list is copied from his webpage.)

## CWEB programs

- [HWTIME](hwtime.pdf) Brief demonstration of CWEB: "Hello, world" plus time (October 1992) ("used as a handout for a lecture on literate programming that I once gave at Frys Electronics in Sunnyvale")

- [SHAM](sham.pdf) Enumerates symmetrical Hamiltonian cycles (December 1992) ("The next two show (by quite different methods) that exactly 2,432,932 knight's tours are unchanged by 180-degree rotation of the chessboard.")

- [OBDD](obdd.pdf) Enumerates perfect matchings of bipartite graphs (May 1996)

- [REFLECT](reflect.pdf); also a [change file for REFLECT](reflect-ch.pdf). Enumerates equivalence classes of reflection networks, aka CC systems (January 1991)

- [HULL](hull.pdf), [HULLS](hulls.pdf), [HULLT](hullt.pdf), [HULLTR](hulltr.pdf) Programs used as examples in [Axioms and Hulls](https://cs.stanford.edu/~knuth/aah.html); also change files for [ngons](hulld-ngon.pdf), [square deletion](hulld-square.pdf), and [uniform input distribution](hulld-unif.pdf) ("was used to compute some of the tables in [Axioms and Hulls](https://cs.stanford.edu/~knuth/aah.html) that several people have asked about.")

- [TCALC](tcalc.pdf) Interactively calculates with humungous numbers (December 1994)

- [DECAGON](decagon.pdf); also a [change file for DECAGON (stars)](decagon-star.pdf); also a [change file for DECAGON (color)](decagon-color.pdf); also a [change file for DECAGON (color stars)](decagon-colorstar.pdf). Packs golden triangles into decagons, stars, pentagons, etc. (September 1994)

- [ANTISLIDE](antislide.pdf); also a [change file for ANTISLIDE](antislide-nocorner.pdf) Finds solutions to Strijbos's antisliding block puzzle (November 1994)
- [ANTISLIDE3](antislide3.pdf) Improved version of ANTISLIDE, finds all nonisomorphic solutions (December 1996)

- [SETSET](setset.pdf) Enumerates nonisomorphic unplayable hands in the game of SET® (February 2001)
- [SETSET-ALL](setset-all.pdf) Improvement of SETSET---fifty times faster---when a huge automorphism group is considered (March 2001)
- [SETSET-RANDOM](setset-random.pdf) Simple Monte Carlo routine to validate the previous two programs (March 2001)

- [SLIDING](sliding.pdf) Finds solutions to sliding block puzzles (November 2001; revised January 2009 and September 2020)

- [STRAIGHTEN](straighten.pdf) Computes irreducible matrix representations of permutations (August 2003)

- [DOMINATION](domination.pdf) Computes the covering relation for an interesting partial ordering of multiset permutations (August 2003)

- [FOG2MF](fog2mf.pdf) Rudimentary conversion from Fontographer to METAFONT (August 1996)

- [LAGFIB](lagfib.pdf) Calculator of weights related to the random number generator below (July 1997)

- [GARSIA-WACHS](garsia-wachs.pdf) Simple implementation of Algorithm 6.2.2G (January 1998, revised September 2004)

- [HALFTONE](halftone.pdf) Preprocessor for typeset halftones; also example input files [lisa-64](https://cs.stanford.edu/~knuth/programs/lisa-64), [lisa-rot](https://cs.stanford.edu/~knuth/programs/lisa-rot), [lisa-128](https://cs.stanford.edu/~knuth/programs/lisa-128), [lin-64](https://cs.stanford.edu/~knuth/programs/lin-64), [lin-rot](https://cs.stanford.edu/~knuth/programs/lin-rot), [lin-128](https://cs.stanford.edu/~knuth/programs/lin-128), [lib-64](https://cs.stanford.edu/~knuth/programs/lib-64), [lib-rot](https://cs.stanford.edu/~knuth/programs/lib-rot), [lib-128](https://cs.stanford.edu/~knuth/programs/lib-128) (June 1998)

- [DOT-DIFF](dot-diff.pdf) Preprocessor for halftones by dot diffusion; also an example input file [lisa-512](https://cs.stanford.edu/~knuth/programs/lisa-512), and a [change file for EPS output](dot-diff-eps.pdf) (June 1998)

- [TOGPAP](togpap.pdf) Generates examples of halftones for paper P116 on dot diffusion (June 1998)

- [DANCE](dance.pdf), [POLYOMINOES](polyominoes.pdf), [POLYIAMONDS](polyiamonds.pdf), [POLYSTICKS](polysticks.pdf), [QUEENS](queens.pdf)
  Generates examples for paper P159 on dancing links (July 1999); and another, [SUDOKU](sudoku.pdf) (February 2005); also a [change file for Monte Carlo estimates](dance-random.pdf) (corrected 25 Jan 07)

- [GDANCE](gdance.pdf), [MACMAHON-TRIANGLES-SYM-TILE](macmahon-triangles-sym-tile.pdf), [XGDANCE](xgdance.pdf), [GDANCE-CUTOFF](gdance-cutoff.pdf) Experimental extensions of the Dancing Links algorithm (November 2000)

- [HAMDANCE](hamdance.pdf) A dancing-link-based program for Hamiltonian circuits (May 2001, slightly revised March 2010), which you might want to compare to the more traditional algorithm of [HAM](ham.pdf)

- [POLYNUM](polynum.pdf), [POLYSLAVE](polyslave.pdf), and their change files [POLYNUM-RESTART](polynum-restart.pdf) and [POLYSLAVE-RESTART](polyslave-restart.pdf) for long runs. Enumerates polyominoes with Iwan Jensen's algorithm, thousands of times faster than previous approaches (but is a memory hog); also [notes from Jensen](https://cs.stanford.edu/~knuth/programs/jensen.txt) about potential further improvements and the probable value of t(48); also a MetaPost source file [polyomino.mp](https://cs.stanford.edu/~knuth/programs/polyomino.mp) to make an illustration for the documentation of both POLYNUM and a now-obsolete program [POLYENUM](polyenum.pdf)

- [ADVENT](advent.pdf) The original Crowther/Woods Adventure game, Version 1.0, translated into CWEB form (version of 21 January 2022); this program was published as Chapter 27 of my [Fun and Games book](https://cs.stanford.edu/~knuth/fg.html), and errata can be in the corrections to pages 235--394 that appear on that webpage

- [ROST](rost.pdf) Monte Carlo confirmation of exercise 5.1.4--40 (October 1998)

- [RAN-PRIM](ran-prim.pdf) Monte Carlo exploration of exercise 5.3.4--40 (October 1998)

- [STRONGCHAIN](strongchain.pdf) finds shortest strong addition chains, also called Lucas chains or Chebyshev chains (August 2000)

- [KODA-RUSKEY](koda-ruskey.pdf) A fascinating generalized reflected Gray-code generator (new version, June 2001)

- [LI-RUSKEY](li-ruskey.pdf) An even more fascinating, massive generalization of the previous program (June 2001); also a PostScript illustration [li-ruskey.1](https://cs.stanford.edu/~knuth/programs/li-ruskey.1) made by the MetaPost source file [li-ruskey.mp](https://cs.stanford.edu/~knuth/programs/li-ruskey.mp)

- [SPIDERS](spiders.pdf) A further improvement to the previous two (December 2001), and its PostScript illustration [deco.5](https://cs.stanford.edu/~knuth/programs/deco.5)

- [TOPSWOPS](topswops.pdf) and [TOPSWOPS-FWD](topswops-fwd.pdf) Two ways to find the longest plays of John Conway's "topswops" game (August 2001)

- [CO-DEBRUIJN](co-debruijn.pdf) A quick-and-dirty implementation of the recursive coroutines Algorithms 7.2.1.1R and 7.2.1.1D, which generate a de Bruijn cycle; also a Mathematica program [co-debruijn.m](https://cs.stanford.edu/~knuth/programs/co-debruijn.m) to check the ranking and unranking functions in exercises 7.2.1.1--97 through 99

- [POSETS0](posets0.pdf) and [POSETS](posets.pdf) Two programs to evaluate the numbers in Sloane's sequence A006455, formerly M1805 (December 2001)

- [ERECTION](erection.pdf).
  The algorithms described in my paper “Random Matroids” (March 2003)

- [UNAVOIDABLE](unavoidable.pdf).
  A longest word that avoids all n-letter subwords in an interesting minimal set constructed by Champernaud, Hansel, and Perrin (July 2003)

- [UNAVOIDABLE2](unavoidable2.pdf).
  A longest word that avoids all n-letter subwords in an interesting minimal set constructed by Mykkeltveit (August 2003)

- [GRAYSPAN](grayspan.pdf), [SPSPAN](spspan.pdf), [GRAYSPSPAN](grayspspan.pdf), and a [MetaPost source file for SPSPAN](../programs-orig/spspan.mp), plus an auxiliary program [SPGRAPH](spgraph.pdf).
  Three instructive ways to generate all spanning trees of a graph (August 2003)

- [SAND](sand.pdf)
  A hastily written program to experiment with sandpiles as in exercise 7.2.1.6--103 (December 2004)

- [ZEILBERGER](zeilberger.pdf), [FRANÇON](francon.pdf), [VIENNOT](viennot.pdf), an [explanatory introduction](tcb.pdf), and a [MetaPost source file for VIENNOT](../programs-orig/kepler.mp).
  Three Catalan bijections related to Strahler numbers, pruning orders, and Kepler towers (February 2005)

- [LINKED-TREES](linked-trees.pdf).
  An amazingly short program to generate linked trees with given node degrees (March 2005)

- [VACILLATE](vacillate.pdf).
  A program to experiment with set partitions and vacillating tableau loops (May 2005)

- [EMBED](embed.pdf).
  An algorithm of Hagauer, Imrich, and Klav&#382;ar to embed a median graph in a hypercube (June 2005)

- [LP](lp.pdf).
  An expository implementation of linear programming (August 2005)

- [HORN-COUNT](horn-count.pdf).
  A program to enumerate Horn functions; also a change file [`krom-count.ch`](krom-count.pdf), which adapts it to Krom functions (aka 2SAT instances) (August 2005)

- [15PUZZLE-KORF0](15puzzle-korf0.pdf) and [15PUZZLE-KORF1](15puzzle-korf1.pdf).
  Two programs to solve 15-puzzle problems rather fast (but not state-of-the-art) (August 2005)

-   [ACHAIN0](achain0.pdf),
    [ACHAIN1](achain1.pdf),
    [ACHAIN2](achain2.pdf),
    [ACHAIN3](achain3.pdf),
    [ACHAIN4](achain4.pdf), and
    [ACHAIN-ALL](achain-all.pdf).
    A series of programs to find minimal addition chains (September 2005),
    plus a trivial auxiliary program
    [ACHAIN-DECODE](achain-decode.pdf).

-   [HYPERBOLIC](hyperbolic.pdf)
    and a [MetaPost source file for HYPERBOLIC](../programs-orig/hyperbolic.mp)</dt>
    <dd>A program that analyzes and helps to draw the hyperbolic plane tiling
made from 36-45-90 triangles (October 2005)</dd>

-   [BOOLCHAINS](../programs-orig/boolchains.tgz)
    <dd>A suite of programs that find the complexity of almost all Boolean functions of five variables (December 2005)</dd>

-   [FCHAINS4X](fchains4x.pdf) and a [change file for don't-cares](fchains4x-dontcares.pdf)
    <dd>Programs for interactive minimization of multiple-output 4-input Boolean functions
    using the `greedy footprint' method (February 2006, revised October 2010)</dd>

-   [TICTACTOE](../programs-orig/tictactoe.tgz), a gzipped tar file `tictactoe.tgz`
    <dd>Various programs used when preparing the tic-tac-toe examples in Section 7.1.2 (March 2006)</dd>

-   [PRIME-SIEVE](prime-sieve.pdf) and its much faster (but more complex) cousin
    [PRIME-SIEVE-SPARSE](prime-sieve-sparse.pdf), plus a change file
    [PRIME-SIEVE-BOOT](prime-sieve-boot.pdf) to compute several million
    primes to be input by the other programs.
    <dd>Programs for the segmented sieve of Eratosthenes on 64-bit machines, tuned for
    finding all large gaps between primes in the neighborhood of 10^18 (May 2006)</dd>

-   [MAXCLIQUES](maxcliques.pdf)
    <dd>The Moody--Hollis algorithm for listing all maximal cliques, all maximal independent sets,
    and/or all minimal vertex covers (July 2006, corrected November 2008)</dd>

-   [ULAM](ulam.pdf) and a
    [change file for 64-bit machines](ulam-longlong.pdf)
    <dd>Short program to compute the Ulam numbers 1, 2, 3, 4, 6, ... (September 2006) --- but see the vastly improved version below, dated July 2016!</dd>

-   [HWB-FAST](hwb-fast.pdf)
    <dd>Short program to compute the profile of the hidden weight function, given a
    permutation of the variables (April 2008)</dd>

-   [YPLAY](yplay.pdf)
    <dd>Simple program to play with Schensted's Y function (April 2008)</dd>

-   [BDD12](bdd12.pdf)
    <dd>A program to find the best and worst variable orderings for a given BDD (May 2008)</dd>

-   [BDD14](bdd14.pdf) and a
    [typical driver program](bddl-rgrowth.pdf) to generate input for it
    <dd>Bare-bones BDD package that I used for practice when preparing Section 7.1.4 of TAOCP
    (May 2008; version of September 2011)</dd>

-   [BDD15](bdd15.pdf)
    <dd>Bare-bones ZDD package that I used for practice when preparing Section 7.1.4 of TAOCP
    (August 2008)</dd>

-   [SIMPATH](simpath.pdf),
    [SIMPATH-REDUCE](simpath-reduce.pdf),
    [SIMPATH-EXAMPLE](../programs-orig/simpath-example.tgz),
    and change files for
    [cycles](simpath-cycles.pdf),
    [Hamiltonian paths](simpath-ham.pdf), and
    [Hamiltonian paths with one endpoint given](simpath-ham-any.pdf)</dt>
    <dd>Several programs to make ZDDs for simple paths of graphs (August 2008)</dd>

-   [SIMPATH-DIRECTED-CYCLES](simpath-directed-cycles.pdf)
    <dd>And another for simple cycles in directed graphs (August 2008)</dd>

-   [EULER-TRAIL](euler-trail.pdf)
    <dd>A simple algorithm that computes an Eulerian trail of a given
    connected graph (March 2010)</dd>

-   [CELTIC-PATHS](celtic-paths.pdf)
    <dd>A fun program to typeset certain Celtic knots, using special fonts
    [CELTICA](../programs-orig/celtica.mf),
    [CELTICA13](../programs-orig/celtica13.mf),
    [CELTICB](../programs-orig/celticb.mf),
    [CELTICB13](../programs-orig/celticb13.mf); you also need this
    [simple illustration](../programs-orig/celtic-picture.1) (August 2010)</dd>

-   [NNNCMBX.MF](../programs-orig/nnncmbx.mf)
    <dd>The font used for my paper ``N-ciphered texts'' (1981, 1987, 2010)</dd>

-   [DRAGON-CALC](dragon-calc.pdf)
    <dd>An interactive program to compute with and display generalized dragon curves (September 2010)</dd>

-   [SQUAREGRAPH](squaregraph.pdf)
    <dd>Brute-force enumeration of all small squaregraphs ---
    an very interesting class of median graphs, generalizing polyominoes
    (August 2011)</dd>

-   [SQUAREGRAPH-RAND](squaregraph-rand.pdf)
    <dd>A short routine that generates more-or-less random pairs of chord
    edges, obtaining squaregraphs by "crocheting" them around the boundary</dd>

-   [TREEPROBS](treeprobs.pdf) and
    an [illustration for its documentation](../programs-orig/treeprobs.1)
    <dd>Computes probabilities in Bayesian binary tree networks (July 2011)</dd>

-   [GRAPH-SIG-V0](graph-sig-v0.pdf)
    <dd>A simple program that helps find automorphisms of a graph (July 2015)</dd>

-   <a name="skew-ternary"></a>
    [SKEW-TERNARY-CALC](skew-ternary-calc.pdf)
    and a <a href="programs/skew-ternary-calc.mp">MetaPost file
    for its illustrations</a>
    <dd>Computes planar graphs that correspond to ternary trees in an
    amazing way; here's a
    [PDF file for its documentation](../programs-orig/skew-ternary-calc.pdf)</dd>

-   [RANDOM-TERNARY](random-ternary.pdf)
    <dd>Implementation of Panholzer and Prodinger's beautiful algorithm
    for generating random ternary trees<br>
    (see also the change files
    [RANDOM-TERNARY-QUADS](random-ternary-quads.pdf) and
    [SKEW-TERNARY-CALC-RAW](skew-ternary-calc-raw.pdf)
    with which you can use this with SKEW-TERNARY-CALC)</dd>

-   [DIMACS-TO-SAT](dimacs-to-sat.pdf) and
    [SAT-TO-DIMACS](sat-to-dimacs.pdf)</dt>
    <dd>Filters to convert between DIMACS format for SAT problems and the symbolic semantically meaningful format used in the programs below</dd>

-   [SAT0](sat0.pdf)
    <dd>My implementation of Algorithm 7.2.2.2A (very basic SAT solver)</dd>

-   [SAT0W](sat0w.pdf)
    <dd>My implementation of Algorithm 7.2.2.2B (teeny tiny SAT solver)</dd>

-   [SAT8](sat8.pdf)
    <dd>My implementation of Algorithm 7.2.2.2W (WalkSAT)</dd>

-   [SAT9](sat9.pdf)
    <dd>My implementation of Algorithm 7.2.2.2S (survey propagation SAT solver)</dd>

-   [SAT10](sat10.pdf)
    <dd>My implementation of Algorithm 7.2.2.2D (Davis-Putnam SAT solver)</dd>

-   [SAT11](sat11.pdf)
    <dd>My implementation of Algorithm 7.2.2.2L (lookahead 3SAT solver)</dd>

-   [SAT11K](sat11k.pdf)
    <dd>Change file to adapt SAT11 to clauses of arbitrary length</dd>

-   [SAT12](sat12.pdf) and the companion program
    [SAT12-ERP](sat12-erp.pdf)</dt>
    <dd>My implementation of a simple preprocessor for SAT</dd>

-   [SAT13](sat13.pdf)
    <dd>My implementation of Algorithm 7.2.2.2C (conflict-driven clause learning SAT solver)</dd>

-   [SAT-LIFE](../programs-orig/sat-life.tgz)
    <dd>Various programs to formulate Game of Life problems as SAT problems (July 2013)</dd>

-   [SAT-NFA](sat-nfa.pdf)
    <dd>Produce a forcing encoding of regular languages into SAT
    via nondeterministic finite automata (April 2016)</dd>

-   [SATexamples](../programs-orig/SATexamples.tgz)
    <dd>Programs for various examples of SAT in Section 7.2.2.2 of TAOCP; also more than a hundred benchmarks (updated 08 July 2015)</dd>

-   [BACK-20Q](back-20q.pdf) and a
    [change file](back-20q-backmod9,15.pdf) for the
    paradoxical variant, and
    [another](back-20q-backmod9,15-indet.pdf)
    <dd>A backtrack program to analyze Don Woods's Twenty Questions (August 2015)</dd>

-   [BACK-MXN-WORDS-NEW](back-mxn-words-new.pdf) and
    [BACK-MXN-WORDS-MXM](back-mxn-words-mxn.pdf). with
    [some word lists](words.tgz)</dt>
    <dd>Demonstration backtrack programs for word rectangles (August 2015)</dd>

-   [BACK-PDI](back-pdi.pdf)
    <dd>A backtrack program to find perfect digital invariants (e.g. 153=1^3+5^3+3^3)
    (September 2015)</dd>

-   [BACK-PI-DAY](back-pi-day.pdf)
    <dd>A backtrack program that solves exercise 7.2.2--68 with an interesting bitwise method (March 2018)</dd>

-   [COMMAFREE-EASTMAN](commafree-eastman.pdf) and
    [COMMAFREE-EASTMAN-NEW](commafree-eastman-new.pdf)</dt>
    <dd>Eastman's encoding algorithm for commafree codes of odd block lengths (September 2015 and December 2015)</dd>

-   [SAT-COMMAFREE](sat-commafree.pdf)
    <dd>Clauses to construct binary commafree codes with one codeword per cycle class (September 2015)</dd>

-   [BACK-COMMAFREE4](back-commafree4.pdf)
    <dd>Finds all commafree 4-letter codes of given size on small alphabets (September 2015)</dd>

-   [BACK-SKELETON](back-skeleton.pdf)
    <dd>Finds potential skeleton multiplication puzzles whose special digits
    obey a given pixel pattern (January 2016)</dd>

-   [BACK-DISSECT](back-dissect.pdf)
    <dd>Finds dissections of a square into a given shape (February 2016)</dd>

-   [BACK-GRACEFUL-KMP3](back-graceful-kmp3.pdf)
    <dd>Finds graceful labelings of the graphs $K_m \times P_3$ (August 2020)</dd>

-   [ULAM-GIBBS](ulam-gibbs.pdf) and the auxiliary
    illustration file
    [<tt>ulam-gibbs.1</tt>](../programs-orig/ulam-gibbs.1)
    <dd>Computes billions of Ulam numbers if you've got enough memory (July 2016)
    [(read the documentation)](ulam-gibbs.ps)</dd>

-   [DLX1](dlx1.pdf)
    <dd>Algorithm 7.2.2.1X for exact cover via dancing links (September 2016 and August 2017, an update of the old DANCE program above)</dd>

-   [QUEENS-DLX](queens-dlx.pdf)
    <dd>Simple program to generate DLX data for the n queens problem</dd>

-   [POLYOMINO-DLX](polyomino-dlx.pdf),
    [POLYIAMOND-DLX](polyiamond-dlx.pdf), and
    [POLYCUBE-DLX](polycube-dlx.pdf)
    <dd>Programs to generate polyform data for the DLX solvers</dd>

-   [SUDOKU-DLX](sudoku-dlx.pdf),
    [SUDOKU-GENERAL-DLX](sudoku-general-dlx.pdf), and
    [DLX1-SUDOKU](dlx1-sudoku.pdf)
    <dd>Improved programs for solving sudoku puzzles with DLX1</dd>

-   [FILLOMINO-DLX](fillomino-dlx.pdf)
    <dd>Converting a fillomino puzzle to an exact cover problem (May 2020)</dd>

-   <dt>
    [DE-BRUIJN-DLX](ian-dlx.pdf)
    [IAN-DLX](ian-dlx.pdf)
    [MACMAHON-TRIANGLES-DLX](macmahon-triangles-dlx.pdf)
    [MASYU-DLX](masyu-dlx.pdf)
    [PI-DAY-DLX](pi-day-dlx.pdf)
    [SLITHERLINK-DLX](slitherlink-dlx.pdf)
    [TORTO-DLX](torto-dlx.pdf)
    [WINDMILL-DOMINOES-DLX](windmill-dominoes-dlx.pdf)
    [WORD-RECT-DLX](word-rect-dlx.pdf)
    </dt>
    <dd>Miscellaneous additional driver programs for exact covering</dd>

-   [DLX2](dlx2.pdf)
    <dd>Algorithm 7.2.2.1C, the extension to color-controlled covers (September 2016, an update of the old GDANCE program above)</dd>

-   [DLX-PRE](dlx-pre.pdf)
    <dd>A preprocessor for DLX data (March 2017)</dd>

-   <dt>[DLX2-POLYOM](dlx2-polyom.pdf) and
    [DLX2-WORDSEARCH](dlx2-wordsearch.pdf) and
    [DLX2-SHARP](dlx2-sharp.pdf) and
    [DLX2-CUTOFF](dlx2-cutoff.pdf) and
    [DLX2-KLUDGE](dlx2-kludge.pdf) and
    [DLX2-CUTOFF-KLUDGE](dlx2-cutoff-kludge.pdf)
    [DLX2-LOOP](dlx2-loop.pdf)
    </dt>
    <dd>Examples of change files typically used to reformat solutions found by DLX2 or to change its logic for column choice, etc.</dd>

-   [DLX3](dlx3.pdf)
    <dd>Algorithm 7.2.2.1M, the extension to general column sums (December 2017)</dd>

-   <dt>[DLX3-SHARP](dlx3-sharp.pdf) and
    [DLX3-SHARP-WORDCROSS](dlx3-sharp-wordcross.pdf) and
    [DLX3-REDRECT](dlx3-redrect.pdf) and
    [DLX3-MOTLEY](dlx3-motley.pdf)
    </dt>
    <dd>Examples of change files for DLX3 (November 2017)</dd>

-   <dt>[REDRECT-DLX](redrect-dlx.pdf) and
    [MOTLEY-DLX](motley-dlx.pdf) and
    [QUEENDOM-DLX](queendom-dlx.pdf)
    </dt>
    <dd>Examples of driver files for DLX3 (March 2017)</dd>

-   [DLX5](dlx5.pdf)
    <dd>Algorithm 7.2.2.1C$, the extension to min-cost covers (July 2018)</dd>

-   [DLX6](dlx6.pdf)
    <dd>Algorithm 7.2.2.1Z, "dancing with ZDDs" (February 2019)</dd>

-   [DLX6-NOMRV](dlx6-noMRV.pdf)
    <dd>a change file that branches on items in strictly left-to-right order</dd>

-   [SSXCC1](ssxcc1.pdf)
    <dd>an experimental rewrite of DLX2, using sparse-set data structures instead of dancing links (November 2020, revised November 2022)</dd>

-   <dt>[SSXCC2](ssxcc2.pdf) and
    [SSXCC3](ssxcc3.pdf)</dt>
    <dd>like SSXCC1 but with an experimental branching heuristic (November 2022)</dd>

-   [XCCDC1](xccdc1.pdf)
    <dd>a major extension of SSXCC1, maintains full domain consistency (November 2022)</dd>

-   <dt>[XCCDC2](xccdc2.pdf) and
    [XCCDC3](xccdc3.pdf)</dt>
    <dd>like XCCDC1 but with an experimental branching heuristic (November 2022)</dd>

-   [INFTY-QUEENS](infty-queens.pdf)
    <dd>Exploration of the infinity queens problem (November 2017)</dd>

-   <dt>[GRACEFUL-COUNT](graceful-count.pdf) and
    [GRACEFUL-COUNT-SMALL](graceful-count-small.pdf)</dt>
    <dd>Counting graceful labelings that are connected (with graceful data structures!) (November 2019)</dd>

-   <dt>[GRACEFUL-DLX](graceful-dlx.pdf) and
    [GRACEFUL-DLX-DOMAINS](graceful-dlx-domains.pdf) and
    [GRACEFUL-DLX-PRESETS](graceful-dlx-presets.pdf)</dt>
    <dd>To generate DLX2 data for graceful labeling (October 2020)</dd>

-   [SQUAREPAL](squarepal.pdf)
    <dd>Finds n-bit binary squares that are palindromic (December 2019)</dd>

-   [HISTOSCAPE-COUNT](histoscape-count.pdf) and
    [HISTOSCAPE-UNRANK](histoscape-unrank.pdf)</dt>
    <dd>Enumerates $m\times n$ histoscapes that are trivalent polyhedra, or
    finds the $k$th solution in that enumeration (April 2020)</dd>

-   [WHIRLPOOL-COUNT](whirlpool-count.pdf)
    <dd>Enumerates $m\times n$ whirlpool permutations for small $m$ and $n$
    (April 2020)</dd>

-   <dt>[WHIRLPOOL2N-ENCODE](whirlpool2n-encode.pdf) and
    [WHIRLPOOL2N-DECODE](whirlpool2n-decode.pdf)</dt>
    <dd>Exhibits a bijection between $2\times n$ whirlpool permutations
    and up-up-or-down-down permutations of size $2n-1$ (May 2020)</dd>

-   [GRAPH-HASH](graph-hash.pdf)
    <dd>Quick way to compute an isomorphic variant that distinguishes small graphs (December 2020)</dd>

-   [HOPCROFT-KARP](hopcroft-karp.pdf)
    <dd>The Hopcroft&ndash;Karp algorithm for maximum cardinality bipartite matching (April 2021)</dd>

-   <dt>[MATULA](matula.pdf) and
    [illustration matula.S](../programs-orig/matula.S) and
    [illustration matula.T](../programs-orig/matula.T) and
    [illustration matula.ST](../programs-orig/matula.ST)</dt>
    <dd>Efficient subtree isomorphism testing (May 2021)</dd>

-   <dt>[MATULA-BIG](matula-big.pdf) and
    [MATULA-BIG-PLANTED](matula-big-planted.pdf)</dt>
    <dd>Change files for MATULA allowing large trees in rectree format (May 2021)</dd>

-   [MATULA-EXHAUSTIVE](matula-exhaustive.pdf)
    <dd>Change file for MATULA that tests all m-trees against all n-trees (May 2021)</dd>

-   [TCHOUKAILLON-ARRAYS](tchoukaillon-arrays.pdf)
    <dd>Generates some fascinating numerical patterns (June 2021)</dd>

-   [OFFLINE-TREE-INSERTION](offline-tree-insertion.pdf)
    <dd>Tarjan's efficient solution to a new exercise about binary tree insertion
    (September 2021)</dd>

-   <dt>[FLOORPLAN-TO-TWINTREE](floorplan-to-twintree.pdf),
    [FLOORPLAN-TO-TWINTREE-TTFORM](floorplan-to-twintree-ttform.pdf),
    [TWINTREE-TO-BAXTER](twintree-to-baxter.pdf),
    [BAXTER-TO-FLOORPLAN](baxter-to-floorplan.pdf)</dt>
    <dd>A trilogy of interesting bijections between floorplans, twintrees,
    and Baxter permutations (September 2021)</dd>

-   <dt>[QUEENON-PARTITION](queenon-partition.pdf),
    [QUEENON-PARTITION.mp](../programs-orig/queenon-partition.mp),
    [QUEENON-PARTITION.0](../programs-orig/queenon-partition.0),
    [QUEENON-PARTITION.1](../programs-orig/queenon-partition.1)</dt>
    <dd>A program to compute and illustrate Simkin's discretizations
    of &ldquo;queenons&rdquo; (September 2021)</dd>

-   <dt>[PARTIAL-LATIN-GAD](partial-latin-gad.pdf) and
    changefile
    [PARTIAL-LATIN-GAD-SWAP](partial-latin-gad-swap.pdf)</dt>
    <dd>Finds all ways to complete a partially specified latin square
    (a &ldquo;quasigroup with holes&rdquo;) (October 2021)</dd>

-   <dt>[RANDOM-DFS-A](random-dfs-a.pdf) and
    [RANDOM-DFS-B](random-dfs-b.pdf)</dt>
    <dd>Empirical tests on the arcs of &ldquo;jungles&rdquo; produced by depth-first
    search on random digraphs, using two random models (November 2021)</dd>
