There are a lot of misunderstandings out there, such as:

- Literate programming means writing profuse comments that repeat what the code says.

- Documentation systems like JavaDoc or Doxygen are literate programming.

----------------------------------------------------------------------

Minor detail: Knuth pretty-prints his source code: it is typeset in a language-aware that chooses different fonts (bold, italics) for keywords, variables, comments, and the like. Modern programmers are more used to calling this "syntax highlighting", and letting these different aspects differ by colour rather than by font choice. According to https://en.wikipedia.org/w/index.php?title=Syntax_highlighting&oldid=717509187#History_and_limitations syntax highlighting in the current sense took off when “In 1985 Ben Shneiderman suggested "color coding of text strings to suggest meaning"”. Literate programming predates that. (Actually I find it hard to believe that there was no syntax highlighting in, say, Emacs, before 1985. In any case, literate programming is as old as ~1978.) Also it does things like showing `->` as a single arrow glyph and highlighting spaces within text strings with another glyph unfamiliar to modern programmers, but in principle this should be fine. Perhaps the biggest unfamiliarity is with not using a monospace (fixed-width) font. Many programmers react negatively to it (https://programmers.stackexchange.com/questions/5473/does-anyone-prefer-proportional-fonts). So making "weave" change the way it typesets code may help. (To read later: http://www.wilfred.me.uk/blog/2014/09/27/the-definitive-guide-to-syntax-highlighting/ via https://www.reddit.com/r/emacs/comments/3b2ubz/thoughts_on_fontlocking/) Overall, there is some scope for cross-pollination of ideas here, between WEB/CWEB's notion of pretty-printing, and the rest of the world's best ideas on syntax highlighting. https://en.wikipedia.org/w/index.php?title=Secondary_notation&oldid=737510762

----------------------------------------------------------------------

Note about sections: LP has this idea of "sections", which is something self-contained and understandable (typically a page or so long). A section can refer to other sections, etc., so that your entire program is a single "web" of interconnected components. Modern programmers do have a few levels of organization:

    code -> function -> class(?) -> file/module -> directory (-> directory)*

but LP gives infinite levels of organization. E.g. even at the function level it lets you split out the error-checking that is meant to be done within that function into a separate section, and that makes you do it more carefully. (See comments by Knuth at the UseR! conference, by Normal Ramsey in the FAQ, Knuth's wc example). More importantly, it *enforces* it (if you don't refer to some other section then it's not part of the program). You could insist that each directory should have a README that says "this directory contains the following files... the purpose of each file is..." but it may not get updated. A good code-reviewer can say "this section is getting too complicated to understand as a unit, could you out refactor and move some parts to their own section?". Otherwise programmers do have rules of thumb (various ad-hoc rules, such as that a function should not be more than N lines long), but it doesn't apply across the board. No one looks at the top-level, notices when some new file is added and makes sure it's accounted for in the README.

Even if we don't switch to literate programming, this could be something enforced in code: "you added file X but it doesn't exist in the web" or whatever.

This is something non-literate programming misses: people may actually have good ideas about code organization / managing complexity at one level (say, the level of a file) but forget about it when it gets to the module/component level. **We have all had the experience of opening up a directory that is just a bunch of files, and not knowing which file to look at first! There is no indication of which ones are central and which ones are peripheral.**

With literate programming, every level is the same: like a self-similar recursive structure. (Of course this may also be a downside: one may *want* different ways of managing complexity at the topmost level than at the function level. But it seems that the advantage outweighs the disadvantages.)

If you look at Knuth's original TeX78 code, he had actually written it the "normal" way, split into separate files.

          TEXHDR.SAI 1978.08.07  header file included by independently compiled modules
          TEXSYN.SAI 1978.08.07  syntax module
          TEXSEM.SAI 1978.08.07  semantics module
          TEXOUT.SAI 1978.08.01  output module
          TEXEXT.SAI 1978.03.10  extension module
          TEXSYS.SAI 1978.08.05  main program
          TEXPRE.SAI 1978.08.07  preprocessor to make hyphenation tables, basic macros

He edited these files as late as 1982. Similarly for METAFONT:

        mf79 (from the time of the first METAFONT manual)
          ROMAN.SAI 1978.05.27  example of how I made fonts before METAFONT
          MFHDR.SAI 1979.10.15  header file included by independently compiled modules
          MFNTRP.SAI 1979.10.15 interpreter module
          MFRAST.SAI 1979.10.18 semantics module
          MFOUT.SAI 1979.10.21  output module
          MFSYS.SAI 1979.10.15  main program
          MFPRE.SAI 1979.10.15  preprocessor to make basic macros

Which he continued to edit until 1984.

So he moved to the single "WEB" of LP because it was a *better* way of organizing/managing this code, than the file-based organization.

----------------------------------------------------------------------

A possible introduction to literate programming, for modern programmers:
1. Read about "README-driven development"
2. Combine that with the idea that if you don't keep your code and README together, they'll go out of sync.

(Further refinements are that you probably need a README at each level, for each function, etc.
"RDD": http://tom.preston-werner.com/2010/08/23/readme-driven-development.html / https://news.ycombinator.com/item?id=1627246 )

See also http://timelessrepo.com/literate-programming.html which mentions README-driven development but is actually aware of literate programming.

----------------------------------------------------------------------

Another one-sentence intro to LP: write your program as a web of sections each independently understandable.

----------------------------------------------------------------------

The organization in LP is based on a book. In Knuth's case, books are his life: writing a book (TAOCP) is his life's work, his side projects (TeX and METAFONT) are connected with making beautiful books. He has an expository bent, and has successfully organized large amounts of material into an excellent series of books. He is very familiar with a book's way of organizing material into sections, with a book's way of looking up information (go look in the index and in the table of contents, flip to the relevant page / section and read it, etc...)

But many people in the youngest generation do not read books! They may read works of fiction and non-fiction, but reference books not so much. (Books that you can read all the way through but also read isolated sections of, like TAOCP.)

This may be one reason why LP does not take off.

----------------------------------------------------------------------

Comment for leaving at:

http://programmers.stackexchange.com/a/6446/3220

Literate programming doesn't mean that you trust the "comments" more than the code. In fact, the non-code text meant for the reader shouldn't even say what the code does (what's the point of repeating that, instead of letting the reader read the code itself)? If you look at Knuth's own literate programs (ADD EXAMPLES HERE), he does not usually say in his text portion what the code does. Reading the code remains the best way of knowing what it does; the text part only helps you choose which code to look at.

Nevertheless, this answer hits upon what is IMO one of the main reasons LP did not take off and it is a challenge to: programmers are too used to wanting to read the "real" code! They will simply not settle for reading the pretty-printed output of `weave`. (I don't know why!) This is interesting, because e.g. C programmers don't insist on reading the assembly code which is the "real" code: they are willing to accept the C code as the real code. Similarly, when a function is invoked from inside another, no one insists that the function definition be expanded into this function, because that's what the "real" code is. But those who try LP, and don't try it long enough, still think of the output as `tangle` as the "real" code ("that the compiler sees").

----------------------------------------------------------------------

Comment for leaving at:

http://programmers.stackexchange.com/a/148980/3220

I disagree with "Literate programming seeks to develop software in programming languages that more closely models the thought process of humans, rather than the thought process of machines." Knuth's most prominent examples of literate programming are in Pascal (WEB), and more recently C (CWEB) — both languages that are closer to the machines than to humans. Instead, Literate Programming is a way of *organizing* the code you write (whether in high-level/declarative/imperative/low-level or whatever languages) as a "web" of interconnected sections each independently understandable. See examples:

----------------------------------------------------------------------

Read this:

https://programmers.stackexchange.com/questions/188316/is-there-a-reason-that-tests-arent-written-inline-with-the-code-that-they-test

-- some of those concerns apply to why modern programmers may not take well to literate programming either.

I think one challenge that comes up time and again, with literate programming, is that programmers are very used to reading, and consequently want to read, the "real" code:

> Readability. Interspersing "real" code and tests will make it harder to read the real code.

----------------------------------------------------------------------

See also:

https://programmers.stackexchange.com/questions/135218/what-is-the-difference-between-writing-test-cases-for-bdd-and-tdd

----------------------------------------------------------------------

The more I see literate programming, the more I feel that the biggest barrier is that programmers will not get used to seeing only the displayed output, rather than the raw source code. They are too used to WYSIWYG :-) Knuth is used to writing a book, where the typeset version is the "reality" that he looks at the most, and the "markup language" (TeX) that produces this reality is considered just something you edit when you need. Programmers want to think of the source code as the reality.

Perhaps the editor should display the code as typeset (e.g. when you open the `.w` file, the editor might show you the typeset version), except that when you declare intent to edit a section (or paragraph?) it drops you into source code. Note that Knuth uses TeX for even his comments: things like $p_ord^2$.

----------------------------------------------------------------------

Knuth puts "This code is used in section ..." at the *end* of each section, but I feel it makes more sense for it to be at the beginning (instead/also), because it sets the context for what the section is about. E.g. see section 21 in Knuth's primes.web (LP paper).

----------------------------------------------------------------------

Programmers understand that they should make each function not-too-long and understandable by itself in isolation (but in practice possibly with some context about where it's called from) -- when it gets too long, move a part of the function into its own function, etc. -- but Literate Programming takes it further and says that your entire program must consist of such understandable sections. This can be higher level than a single function, and also lower level like blocks of code.

Some of the limitations Knuth was trying to solve have been solved by language features (and also people not caring so much about performance), but some are real.

----------------------------------------------------------------------

Thimbleby understands that "It is assumed that C programmers are probably prejudiced in favor of a constant-width font..." !

----------------------------------------------------------------------

Thimbleby points out that (his) Cweb: "In fact, these are really options which should have been provided by quite separate software tools."

This is a general feature of many systems designed by Knuth, including TeX -- they are diametrically opposed to the philosophy of "one thing well" and aim to be a self-contained useful system, including an input processor, output processor, and everything in between, rather than using standard libraries for that purpose.

----------------------------------------------------------------------

https://steve-yegge.blogspot.com/2008/02/portrait-of-n00b.html -- to someone who thinks of "literate programming" as "commenting profusely", Steve Yegge here seems to be the very antithesis. But ironically, with Grok (cross-references, etc.) he has produced the closest thing to WEB that is used widely (tens of thousands of Google programmers).

----------------------------------------------------------------------

http://lambda-the-ultimate.org/node/3663#comment-51865 (about "Literate Haskell")

> One traditional LP feature that Haskell rightfully rejects is that of allowing the LP system to define its own code abstractions, i.e. being able to name code fragments and reuse them by name. That feature of older LP systems seems to have just been a workaround for languages with limited abstraction mechanisms, and detracted from what the focus of those systems should have been.
> In the classic systems like (C)WEB, this contributed to a problematic distance between the LP sources and the code which the compiler or interpreter saw. Any system that involves running some sort of tangle & weave operations as separate tasks so that the compiler sees something different than the programmer is ultimately doomed.

----------------------------------------------------------------------

http://lambda-the-ultimate.org/node/3663#comment-51909

> I used Leo for organizing a major rewrite (9? years ago). Literate programming was 'ok', but the major revelation for me was the usefulness of outline editors.
> Since then I've been complaining about having to put code (and documentation) in "files".

----------------------------------------------------------------------

Daly of Axiom: http://lambda-the-ultimate.org/node/3663#comment-62440

Like a novel, parts that are invalidated may need to be rewritten.

----------------------------------------------------------------------
