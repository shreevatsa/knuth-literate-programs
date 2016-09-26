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

# List

From [Knuth's website](https://cs.stanford.edu/~uno/programs.html):

<blockquote>
<dl>
<dt><a href="programs/sham.w">SHAM</a></dt>
<dd>Enumerates symmetrical Hamiltonian cycles (December 1992)</dd>
<dt><a href="programs/obdd.w.gz">OBDD</a></dt>
<dd>Enumerates perfect matchings of bipartite graphs (May 1996)</dd>
<dt><a href="programs/reflect.w.gz">REFLECT</a>; also a
<a href="programs/reflect.ch.gz">change file for REFLECT</a></dt>
<dd>Enumerates equivalence classes of reflection networks, aka CC systems
(January 1991)</dd>
<dt><a href="programs/hull.w">HULL</a>,
<a href="programs/hulls.w">HULLS</a>,
<a href="programs/hullt.w">HULLT</a>,
<a href="programs/hulltr.w">HULLTR</a></dt>
<dd>Programs used as examples in
<a href="aah.html"><cite>Axioms and Hulls</cite></a>; also change files for
<a href="programs/hulld-ngon.ch">ngons</a>,
<a href="programs/hulld-square.ch">square deletion</a>, and
<a href="programs/hulld-unif.ch">uniform input distribution</a></dd>
<dt><a href="programs/tcalc.w.gz">TCALC</a></dt>
<dd>Interactively calculates with humungous numbers (December 1994)</dd>
<dt><a href="programs/decagon.w.gz">DECAGON</a>; also a
<a href="programs/decagon-star.ch.gz">change file for DECAGON (stars)</a>;
also a
<a href="programs/decagon-color.ch.gz">change file for DECAGON (color)</a>;
also a
<a href="programs/decagon-colorstar.ch.gz">change file for DECAGON (color
stars)</a></dt>
<dd>Packs golden triangles into decagons, stars, pentagons, etc.
(September 1994)</dd>
<dt><a href="programs/antislide.w.gz">ANTISLIDE</a>; also a
<a href="programs/antislide-nocorner.ch.gz">change file for ANTISLIDE</a></dt>
<dd>Finds solutions to Strijbos's antisliding block puzzle (November 1994)</dd>
<dt><a href="programs/antislide3.w.gz">ANTISLIDE3</a></dt>
<dd>Improved version of ANTISLIDE, finds all nonisomorphic solutions (December 1996)</dd>
<dt><a href="programs/setset.w">SETSET</a></dt>
<dd>Enumerates nonisomorphic unplayable hands in the game of SET&#174; (February 2001)</dd>
<dt><a href="programs/setset-all.w">SETSET-ALL</a></dt>
<dd>Improvement of SETSET---fifty times faster---when a huge automorphism group is considered (March 2001)</dd>
<dt><a href="programs/setset-random.w">SETSET-RANDOM</a></dt>
<dd>Simple Monte Carlo routine to validate the previous two programs (March 2001)</dd>
<dt><a href="programs/sliding.w">SLIDING</a></dt>
<dd>Finds solutions to sliding block puzzles (November 2001; revised January 2009)</dd>
<dt><a href="programs/straighten.w">STRAIGHTEN</a><dt>
<dd>Computes irreducible matrix representations of permutations (August 2003)</dd>
<dt><a href="programs/domination.w">DOMINATION</a><dt>
<dd>Computes the covering relation for an interesting partial ordering
of multiset permutations (August 2003)</dd>
<dt><a href="programs/fog2mf.w">FOG2MF</a></dt>
<dd>Rudimentary conversion from Fontographer to METAFONT (August 1996)</dd>
<dt><a href="programs/lagfib.w">LAGFIB</a></dt>
<dd>Calculator of weights related to the random number generator below (July 1997)</dd>
<dt><a href="programs/garsia-wachs.w">GARSIA-WACHS</a></dt>
<dd>Simple implementation of Algorithm 6.2.2G (January 1998, revised September 2004)</dd>
<dt><a href="programs/halftone.w">HALFTONE</a></dt>
<dd>Preprocessor for typeset halftones; also example input files
<a href="programs/lisa-64">lisa-64</a>,
<a href="programs/lisa-rot">lisa-rot</a>,
<a href="programs/lisa-128">lisa-128</a>,
<a href="programs/lin-64">lin-64</a>,
<a href="programs/lin-rot">lin-rot</a>,
<a href="programs/lin-128">lin-128</a>,
<a href="programs/lib-64">lib-64</a>,
<a href="programs/lib-rot">lib-rot</a>,
<a href="programs/lib-128">lib-128</a> (June 1998)</dd>
<dt><a href="programs/dot-diff.w">DOT-DIFF</a></dt>
<dd>Preprocessor for halftones by dot diffusion; also an example input file
<a href="programs/lisa-512">lisa-512</a>,
and a <a href="programs/dot-diff-eps.ch">change file for EPS output</a>
(June 1998)</dd>
<dt><a href="programs/togpap.w">TOGPAP</a></dt>
<dd>Generates examples of halftones for paper P116 on dot diffusion (June 1998)</dd>
<dt><a name="dancing"></a><a href="programs/dance.w">DANCE</a>,
<a href="programs/polyominoes.w">POLYOMINOES</a>,
<a href="programs/polyiamonds.w">POLYIAMONDS</a>,
<a href="programs/polysticks.w">POLYSTICKS</a>,
<a href="programs/queens.w">QUEENS</a></dt>
<dd>Generates examples for paper P159 on dancing links (July 1999); and another,
<a href="programs/sudoku.w">SUDOKU</a> (February 2005); also a
<a href="programs/dance-random.ch">change file for Monte Carlo estimates</a> (corrected 25 Jan 07)</dd>
<dt><a href="programs/gdance.w">GDANCE</a>,
<a href="programs/macmahon-triangles-sym-tile.w">MACMAHON-TRIANGLES-SYM-TILE</a>,
<a href="programs/xgdance.w">XGDANCE</a>,
<a href="programs/gdance-cutoff.ch">GDANCE-CUTOFF</a></dt>
<dd>Experimental extensions of the Dancing Links algorithm (November 2000)</dd>
<dt><a href="programs/hamdance.w">HAMDANCE</a></dt>
<dd>A dancing-link-based program for Hamiltonian circuits (May 2001, slightly revised March 2010),
which you might
want to compare to the more traditional algorithm of
<a href="programs/ham.w">HAM</a></dd>
<dt><a name="polyominoes"></a><a href="programs/polynum.w">POLYNUM</a>,
<a href="programs/polyslave.w">POLYSLAVE</a>, and their change files
<a href="programs/polynum-restart.ch">POLYNUM-RESTART</a> and
<a href="programs/polyslave-restart.ch">POLYSLAVE-RESTART</a> for long runs</dt>
<dd>Enumerates polyominoes with Iwan Jensen's algorithm, thousands of times
faster than previous approaches (but is a memory hog); also
<a href="programs/jensen.txt">notes from Jensen</a> about potential further
improvements and the probable value of t(48); also a MetaPost source
file <a href="programs/polyomino.mp">polyomino.mp</a> to make an illustration
for the documentation of both POLYNUM and a now-obsolete program
<a href="programs/polyenum.w">POLYENUM</a></dd>
<dt><a name="advent"></a><a href="programs/advent.w.gz">ADVENT</a></dt>
<dd>The original Crowther/Woods Adventure game, Version 1.0, translated into CWEB form (version of 09 October 2014); this program was published as Chapter 27
of my <a href="fg.html">Fun and Games book</a>, and errata can be
in the corrections to pages 235--394 that appear on that webpage</dd>
<dt><a href="programs/rost.w">ROST</a></dt>
<dd>Monte Carlo confirmation of exercise 5.1.4--40 (October 1998)</dd>
<dt><a href="programs/ran-prim.w">RAN-PRIM</a></dt>
<dd>Monte Carlo exploration of exercise 5.3.4--40 (October 1998)</dd>
<dt><a href="programs/strongchain.w">STRONGCHAIN</a></dt>
<dd>finds shortest strong addition chains, also called Lucas chains or
Chebyshev chains (August 2000)</dd>
<dt><a name="Gray"></a><a href="programs/koda-ruskey.w">KODA-RUSKEY</a></dt>
<dd>A fascinating generalized reflected Gray-code generator (new version, June 2001)</dd>
<dt><a href="programs/li-ruskey.w">LI-RUSKEY</a></dt>
<dd>An even more fascinating, massive generalization of the previous
program (June 2001); also a PostScript illustration
<a href="programs/li-ruskey.1"><tt>li-ruskey.1</tt></a> made by the
MetaPost source file <a href="programs/li-ruskey.mp"><tt>li-ruskey.mp</tt></a>
</dd>
<dt><a href="programs/spiders.w">SPIDERS</a></dt>
<dd>A further improvement to the previous two (December 2001),
and its PostScript illustration
<a href="programs/deco.5"><tt>deco.5</tt></a></dd>
<dt><a href="programs/topswops.w">TOPSWOPS</a> and
<a href="programs/topswops-fwd.w">TOPSWOPS-FWD</a></dt>
<dd>Two ways to find the longest plays of John Conway's "topswops" game
(August 2001)</dd>
<dt><a href="programs/co-debruijn.w">CO-DEBRUIJN</a></dt>
<dd>A quick-and-dirty implementation of the
recursive coroutines Algorithms 7.2.1.1R and 7.2.1.1D, which
generate a de Bruijn cycle; also a Mathematica program
<a href="programs/co-debruijn.m"><tt>co-debruijn.m</tt></a> to
check the ranking and unranking functions in exercises
7.2.1.1--97 through 99</dd>
<dt><a href="programs/posets0.w">POSETS0</a> and
 <a href="programs/posets.w">POSETS</a></dt>
<dd>Two programs to evaluate the numbers in Sloane's sequence A006455, formerly M1805 (December 2001)</dd>
<dt><a href="programs/erection.w">ERECTION</a><dt>
<dd>The algorithms described in my paper ``Random Matroids'' (March 2003)</dd>
<dt><a href="programs/unavoidable.w">UNAVOIDABLE</a><dt>
<dd>A longest word that avoids all n-letter subwords in an interesting minimal
set constructed by Champernaud, Hansel, and Perrin (July 2003)</dd>
<dt><a href="programs/unavoidable2.w">UNAVOIDABLE2</a><dt>
<dd>A longest word that avoids all n-letter subwords in an interesting minimal
set constructed by Mykkeltveit (August 2003)</dd>
<dt><a href="programs/grayspan.w">GRAYSPAN</a>,
    <a href="programs/spspan.w">SPSPAN</a>,
    <a href="programs/grayspspan.w">GRAYSPSPAN</a>,
and a <a href="programs/spspan.mp">MetaPost source file for SPSPAN</a>,
plus an auxiliary program <a href="programs/spgraph.w">SPGRAPH</a></dt>
<dd>Three instructive ways to generate all spanning trees of a graph (August 2003)</dd>
<dt><a href="programs/sand.w">SAND</a></dt>
<dd>A hastily written program to experiment with sandpiles as in exercise 7.2.1.6--103
 (December 2004)</dd>
<dt><a name="tcb"></a>
<a href="programs/zeilberger.w">ZEILBERGER</a>,
<a href="programs/francon.w">FRAN&Ccedil;ON</a>,
<a href="programs/viennot.w">VIENNOT</a>,
an <a href="programs/tcb.tex">explanatory introduction</a>,
and a <a href="programs/kepler.mp">MetaPost source file for VIENNOT</a></dt>
<dd>Three Catalan bijections related to Strahler numbers, pruning orders,
and Kepler towers (February 2005)</dd>
<dt><a href="programs/linked-trees.w">LINKED-TREES</a></dt>
<dd>An amazingly short program to generate linked trees with given node degrees (March 2005)</dd>
<dt><a href="programs/vacillate.w">VACILLATE</a></dt>
<dd>A program to experiment with set partitions and vacillating tableau loops (May 2005)</dd>
<dt><a href="programs/embed.w">EMBED</a></dt>
<dd>An algorithm of Hagauer, Imrich, and Klav&#382;ar to embed a median
graph in a hypercube (June 2005)</dd>
<dt><a href="programs/lp.w">LP</a></dt>
<dd>An expository implementation of linear programming (August 2005)</dd>
<dt><a href="programs/horn-count.w">HORN-COUNT</a></dt>
<dd>A program to enumerate Horn functions; also a change file
<a href="programs/krom-count.ch"><tt>krom-count.ch</tt></a>, which adapts
it to Krom functions (aka 2SAT instances) (August 2005)</dd>
<dt><a href="programs/15puzzle-korf0.w">15PUZZLE-KORF0</a> and
<a href="programs/15puzzle-korf1.w">15PUZZLE-KORF1</a></dt>
<dd>Two programs to solve 15-puzzle problems rather fast (but not state-of-the-art) (August 2005)</dd>
<dt><a href="programs/achain0.w">ACHAIN0</a>,
<a href="programs/achain1.w">ACHAIN1</a>,
<a href="programs/achain2.w">ACHAIN2</a>,
<a href="programs/achain3.w">ACHAIN3</a>,
<a href="programs/achain4.w">ACHAIN4</a>, and
<a href="programs/achain-all.w">ACHAIN-ALL</a></dt>
<dd>A series of programs to find minimal addition chains (September 2005),
plus a trivial auxiliary program
<a href="programs/achain-decode.w">ACHAIN-DECODE</a>.</dd>
<dt><a href="programs/hyperbolic.w">HYPERBOLIC</a>
and a <a href="programs/hyperbolic.mp">MetaPost source file for HYPERBOLIC</a></dt>
<dd>A program that analyzes and helps to draw the hyperbolic plane tiling
made from 36-45-90 triangles (October 2005)</dd>
<dt><a href="programs/boolchains.tgz">BOOLCHAINS</a></dt>
<dd>A suite of programs that find the complexity of almost all Boolean functions of five variables (December 2005)</dd>
<dt><a href="programs/fchains4x.w">FCHAINS4X</a> and
and a <a href="programs/fchains4x-dontcares.ch">change file for don't-cares</a></dt>
<dd>Programs for interactive minimization of multiple-output 4-input Boolean functions
using the `greedy footprint' method (February 2006, revised October 2010)</dd>
<dt><a href="programs/tictactoe.tgz">TICTACTOE</a>, a gzipped tar file <tt>tictactoe.tgz</tt></dt>
<dd>Various programs used when preparing the tic-tac-toe examples in Section 7.1.2 (March 2006)</dd>
<dt><a href="programs/prime-sieve.w">PRIME-SIEVE</a> and its much faster (but more complex) cousin
 <a href="programs/prime-sieve-sparse.w">PRIME-SIEVE-SPARSE</a>, plus a change file
 <a href="programs/prime-sieve-boot.ch">PRIME-SIEVE-BOOT</a> to compute several million
 primes to be input by the other programs</dt>
<dd>Programs for the segmented sieve of Eratosthenes on 64-bit machines, tuned for
finding all large gaps between primes in the neighborhood of 10^18 (May 2006)</dd>
<dt><a href="programs/maxcliques.w">MAXCLIQUES</a></dt>
<dd>The Moody--Hollis algorithm for listing all maximal cliques, all maximal independent sets,
and/or all minimal vertex covers (July 2006, corrected November 2008)</dd>
<dt><a href="programs/ulam.w">ULAM</a> and a
 <a href="programs/ulam-longlong.ch">change file for 64-bit machines</a></dt>
<dd>Short program to compute the Ulam numbers 1, 2, 3, 4, 6, ... (September 2006) --- but see the vastly improved version below, dated July 2016!</dd>
<dt><a href="programs/hwb-fast.w">HWB-FAST</a></dt>
<dd>Short program to compute the profile of the hidden weight function, given a
permutation of the variables (April 2008)</dd>
<dt><a href="programs/yplay.w">YPLAY</a></dt>
<dd>Simple program to play with Schensted's Y function (April 2008)</dd>
<dt><a href="programs/bdd12.w">BDD12</a></dt>
<dd>A program to find the best and worst variable orderings for a given BDD (May 2008)</dd>
<dt><a name="bdd14"></a><a href="programs/bdd14.w">BDD14</a> and a
<a href="programs/bddl-rgrowth.w">typical driver program</a> to generate input for it</dt>
<dd>Bare-bones BDD package that I used for practice when preparing Section 7.1.4 of TAOCP
(May 2008; version of September 2011)</dd>
<dt><a name="bdd15"></a><a href="programs/bdd15.w">BDD15</a></dt>
<dd>Bare-bones ZDD package that I used for practice when preparing Section 7.1.4 of TAOCP
(August 2008)</dd>
<dt><a href="programs/simpath.w">SIMPATH</a>,
    <a href="programs/simpath-reduce.w">SIMPATH-REDUCE</a>,
    <a href="programs/simpath-example.tgz">SIMPATH-EXAMPLE</a>,
and change files for
    <a href="programs/simpath-cycles.ch">cycles</a>,
    <a href="programs/simpath-ham.ch">Hamiltonian paths</a>, and
    <a href="programs/simpath-ham-any.ch">Hamiltonian paths with one endpoint given</a></dt>
<dd>Several programs to make ZDDs for simple paths of graphs (August 2008)</dd>
<dt><a href="programs/simpath-directed-cycles.w">SIMPATH-DIRECTED-CYCLES</a></dt>
<dd>And another for simple cycles in directed graphs (August 2008)</dd>
<dt><a href="programs/euler-trail.w">EULER-TRAIL</a></dt>
<dd>A simple algorithm that computes an Eulerian trail of a given
connected graph (March 2010)</dd>
<dt><a name="celtic"></a><a href="programs/celtic-paths.w">CELTIC-PATHS</a></dt>
<dd>A fun program to typeset certain Celtic knots, using special fonts
<a href="programs/celtica.mf">CELTICA</a>,
<a href="programs/celtica13.mf">CELTICA13</a>,
<a href="programs/celticb.mf">CELTICB</a>,
<a href="programs/celticb13.mf">CELTICB13</a>; you also need this
<a href="programs/celtic-picture.1">simple illustration</a> (August 2010)</dd>
<dt><a href="programs/nnncmbx.mf">NNNCMBX.MF</a></dt>
<dd>The font used for my paper ``N-ciphered texts'' (1981, 1987, 2010)</dd>
<dt><a href="programs/dragon-calc.w">DRAGON-CALC</a></dt>
<dd>An interactive program to compute with and display generalized dragon curves (September 2010)</dd>
<dt><a href="programs/squaregraph.w">SQUAREGRAPH</a></dt>
<dd>Brute-force enumeration of all small squaregraphs ---
an very interesting class of median graphs, generalizing polyominoes
(August 2011)</dd>
<dt><a href="programs/squaregraph-rand.w">SQUAREGRAPH-RAND</a></dt>
<dd>A short routine that generates more-or-less random pairs of chord
edges, obtaining squaregraphs by "crocheting" them around the boundary</dd>
<dt><a name="treeprobs"></a><a href="programs/treeprobs.w">TREEPROBS</a></dt>
<dd>Computes probabilities in Bayesian binary tree networks (July 2011)</dd>
<dt><a href="programs/graph-sig-v0.w">GRAPH-SIG-V0</a></dt>
<dd>A simple program that helps find automorphisms of a graph (July 2015)</dd>
<dt><a name="skew-ternary"></a>
<a href="programs/skew-ternary-calc.w">SKEW-TERNARY-CALC</a>
and a <a href="programs/skew-ternary-calc.mp">MetaPost file
for its illustrations</a></dt>
<dd>Computes planar graphs that correspond to ternary trees in an
amazing way; here's a
<a href="programs/skew-ternary-calc.pdf">PDF file for its documentation</a></dd>
<dt><a href="programs/random-ternary.w">RANDOM-TERNARY</a></dt>
<dd>Implementation of Panholzer and Prodinger's beautiful algorithm
for generating random ternary trees<br>
(see also the change files
<a href="programs/random-ternary-quads.ch">RANDOM-TERNARY-QUADS</a> and
<a href="programs/skew-ternary-calc-raw.ch">SKEW-TERNARY-CALC-RAW</a>
with which you can use this with SKEW-TERNARY-CALC)</dd>
<dt><a href="programs/dimacs-to-sat.w">DIMACS-TO-SAT</a> and
<a href="programs/sat-to-dimacs.w">SAT-TO-DIMACS</a></dt>
<dd>Filters to convert between DIMACS format for SAT problems and the symbolic semantically meaningful format used in the programs below</dd>
<dt><a href="programs/sat0.w">SAT0</a></dt>
<dd>My implementation of Algorithm 7.2.2.2A (very basic SAT solver)</dd>
<dt><a href="programs/sat0w.w">SAT0W</a></dt>
<dd>My implementation of Algorithm 7.2.2.2B (teeny tiny SAT solver)</dd>
<dt><a href="programs/sat8.w">SAT8</a></dt>
<dd>My implementation of Algorithm 7.2.2.2W (WalkSAT)</dd>
<dt><a href="programs/sat9.w">SAT9</a></dt>
<dd>My implementation of Algorithm 7.2.2.2S (survey propagation SAT solver)</dd>
<dt><a href="programs/sat10.w">SAT10</a></dt>
<dd>My implementation of Algorithm 7.2.2.2D (Davis-Putnam SAT solver)</dd>
<dt><a href="programs/sat11.w">SAT11</a></dt>
<dd>My implementation of Algorithm 7.2.2.2L (lookahead 3SAT solver)</dd>
<dt><a href="programs/sat11k.ch">SAT11K</a></dt>
<dd>Change file to adapt SAT11 to clauses of arbitrary length</dd>
<dt><a href="programs/sat12.w">SAT12</a> and the companion program
<a href="programs/sat12-erp.w">SAT12-ERP</a></dt>
<dd>My implementation of a simple preprocessor for SAT</dd>
<dt><a href="programs/sat13.w">SAT13</a></dt>
<dd>My implementation of Algorithm 7.2.2.2C (conflict-driven clause learning SAT solver)</dd>
<dt><a href="programs/sat-life.tgz">SAT-LIFE</a></dt>
<dd>Various programs to formulate Game of Life problems as SAT problems (July 2013)</dd>
<dt><a href="programs/sat-nfa.w">SAT-NFA</a></dt>
<dd>Produce a forcing encoding of regular languages into SAT
 via nondeterministic finite automata (April 2016)</dd>
<dt><a href="programs/SATexamples.tgz">SATexamples</a></dt>
<dd>Programs for various examples of SAT in Section 7.2.2.2 of TAOCP; also more than a hundred benchmarks (updated 08 July 2015)</dd>
<dt><a href="programs/back-20q.w">BACK-20Q</a> and a
<a href="programs/back-20q-backmod9,15.ch">change file</a> for the
paradoxical variant, and
<a href="programs/back-20q-backmod9,15-indet.ch">another</a></dt>
<dd>A backtrack program to analyze Don Woods's Twenty Questions (August 2015)</dd>
<dt><a href="programs/back-mxn-words-new.w">BACK-MXN-WORDS-NEW</a> and
    <a href="programs/back-mxn-words-mxn.w">BACK-MXN-WORDS-MXM</a>. with
    <a href="words.tgz">some word lists</a></dt>
<dd>Demonstration backtrack programs for word rectangles (August 2015)</dd>
<dt><a href="programs/back-pdi.w">BACK-PDI</a></dt>
<dd>A backtrack program to find perfect digital invariants (e.g. 153=1^3+5^3+3^3)
(September 2015)</dd>
<dt><a name="commafree"></a>
<a href="programs/commafree-eastman.w">COMMAFREE-EASTMAN</a> and
<a href="programs/commafree-eastman-new.w">COMMAFREE-EASTMAN-NEW</a></dt>
<dd>Eastman's encoding algorithm for commafree codes of odd block lengths (September 2015 and December 2015)</dd>
<dt><a href="programs/sat-commafree.w">SAT-COMMAFREE</a></dt>
<dd>Clauses to construct binary commafree codes with one codeword per cycle class (September 2015)</dd>
<dt><a href="programs/back-commafree4.w">BACK-COMMAFREE4</a></dt>
<dd>Finds all commafree 4-letter codes of given size on small alphabets (September 2015)</dd>
<dt><a href="programs/back-skeleton-shortest.w">BACK-SKELETON-SHORTEST</a></dt>
<dd>Finds potential skeleton multiplication puzzles whose special digits
obey a given pixel pattern (January 2016)</dd>
<dt><a href="programs/back-dissect.w">BACK-DISSECT</a></dt>
<dd>Finds dissections of a square into a given shape (February 2016)</dd>
<dt><a href="programs/ulam-gibbs.w">ULAM-GIBBS</a> and the auxiliary
illustration file
<a href="programs/ulam-gibbs.1"><tt>ulam-gibbs.1</tt></a></dt>
<dd>Computes billions of Ulam numbers if you've got enough memory (July 2016)
<a href="ulam-gibbs.ps">(read the documentation)</a></dd>
<dt><a href="programs/dlx1.w">DLX1</a></dt>
<dd>Algorithm 7.2.2.1D for exact cover via dancing links (September 2016, an update of the old DANCE program above)</dd>
<dt><a href="programs/dlx2.w">DLX2</a></dt>
<dd>Algorithm 7.2.2.1C, the extension to color-controlled covers (September 2016, an update of the old GDANCE program above)</dd>
</dl>
</blockquote>
