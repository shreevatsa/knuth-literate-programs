# Bugs: After `make clean`, running `make` generates some files, then `make clean` is needed again, etc.

outputfiles = \
	sham.pdf \
	obdd.pdf \
reflect.pdf reflect-ch.pdf \
	hull.pdf hulls.pdf hullt.pdf hulltr.pdf \
	tcalc.pdf \
	decagon.pdf decagon-star.pdf decagon-color.pdf decagon-colorstar.pdf \
	antislide.pdf antislide-nocorner.pdf antislide3.pdf \
	setset.pdf setset-all.pdf setset-random.pdf \
	sliding.pdf \
	straighten.pdf \
	domination.pdf \
	fog2mf.pdf \
	lagfib.pdf \
	garsia-wachs.pdf \
	halftone.pdf \
	dot-diff.pdf \
	dot-diff-eps.pdf \
	togpap.pdf \
	dance.pdf polyominoes.pdf polyiamonds.pdf polysticks.pdf queens.pdf sudoku.pdf dance-random.pdf \
	gdance.pdf macmahon-triangles-sym-tile.pdf xgdance.pdf gdance-cutoff.pdf \
	hamdance.pdf \
	polynum.pdf polyslave.pdf polynum-restart.pdf polyslave-restart.pdf polyenum.pdf \
	advent.pdf \
	rost.pdf \
	ran-prim.pdf \
	strongchain.pdf \
	koda-ruskey.pdf \
	li-ruskey.pdf \
	spiders.pdf \
	topswops.pdf topswops-fwd.pdf \
	co-debruijn.pdf \
	posets0.pdf posets.pdf \
	erection.pdf \
	unavoidable.pdf unavoidable2.pdf \
	grayspan.pdf grayspspan.pdf spgraph.pdf \
	spspan.pdf \
	sand.pdf \
	zeilberger.pdf francon.pdf viennot.pdf \
	linked-trees.pdf \
	vacillate.pdf \
	embed.pdf \
	lp.pdf \
	horn-count.pdf \
	15puzzle-korf0.pdf 15puzzle-korf1.pdf \
	achain0.pdf achain1.pdf achain2.pdf achain3.pdf achain4.pdf achain-all.pdf achain-decode.pdf\
	hyperbolic.pdf \
	fchains4x.pdf \
	tictactoe0.pdf tictactoe1.pdf tictactoe2.pdf tictactoe3.pdf tictactoe4.pdf tictactoe5.pdf tictactoe6.pdf tictactoe7.pdf \
	prime-sieve.pdf prime-sieve-sparse.pdf \
	maxcliques.pdf \
	ulam.pdf \
	hwb-fast.pdf \
	yplay.pdf \
	bdd12.pdf \
	bdd14.pdf bddl-rgrowth.pdf \
	bdd15.pdf \
	simpath.pdf simpath-reduce.pdf simpath-directed-cycles.pdf \
	euler-trail.pdf \
	celtic-paths.pdf \
	dragon-calc.pdf \
	squaregraph.pdf squaregraph-rand.pdf \
	treeprobs.pdf \
	graph-sig-v0.pdf \
	 \

# boolchains tictactoe -- is a .tgz of several programs
# simpath-example.tgz

prereq = polyomino.2 spspan.1 kepler.2 hyperbolic.1

round1 = tcb.pdf

%.tex: %.w
	cweave $<

%.pdf: %.tex
# pdftex "\year=9999 \month=12 \day=99 \time=5999 \input " $<
	if pdftex $< | grep "Non-PDF special ignored"; then tex $< && dvipdfmx ${basename $@}.dvi; fi

changefiles = decagon-star.pdf decagon-color.pdf decagon-colorstar.pdf antislide-nocorner.pdf dot-diff-eps.pdf dance-random.pdf gdance-cutoff.pdf polynum-restart.pdf polyslave-restart.pdf fchains4x-dontcares.pdf prime-sieve-boot.pdf prime-sieve-sparse-boot.pdf ulam-longlong.pdf simpath-cycles.pdf simpath-ham.pdf

all: $(prereq) $(round1) $(outputfiles) $(changefiles) krom-count.pdf simpath-ham-any.pdf

tcb.pdf: tcb.tex zeilberger.tex zeilberger.idx francon.tex viennot.tex
	tex tcb
	dvipdfmx tcb.dvi

krom-count.pdf:
	cweave horn-count.w $(basename $@).ch $(basename $@).tex
	pdftex $(basename $@)
	rm -v $(basename $@).{idx,log,scn,toc,tex}

simpath-ham-any.pdf:
	cweave simpath.w $(basename $@).ch $(basename $@).tex
	pdftex $(basename $@)
	rm -v $(basename $@).{idx,log,scn,toc,tex}

$(changefiles):
	cweave $(shell x=$@; echo $${x%-*}) $(basename $@).ch $(basename $@).tex
	pdftex $(basename $@)
	rm -v $(basename $@).{idx,log,scn,toc,tex}

reflect-ch.pdf: reflect.w reflect.ch
	cweave reflect.w reflect.ch reflect-ch.tex
	pdftex $(basename $@)
	rm -v $(basename $@).{idx,log,scn,toc,tex}

$(prereq):
	mpost $(basename $@).mp

clean:
	rm -vf *.{idx,log,scn,toc,dvi,mpx}
	rm -vf {francon,viennot,zeilberger}.tex
	rm -vf {kepler,polyomino,spspan}.{0,1,2}
