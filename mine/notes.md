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

http://www.harold.thimbleby.net/cv/files/cweb.pdf

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

Another example (on a poor blog post) of a programmer complaining about not being able to see the "real" source code: https://hackaday.com/2016/06/06/learn-to-program-with-literate-programming/#comment-3047421

----------------------------------------------------------------------

Knuth interview: https://web.archive.org/web/20000302101053/http://www.clbooks.com/nbb/knuth.html

He mentions some literate programming (CWeb, Stanford GraphBase)

----------------------------------------------------------------------

An excellent summary of the advantages of literate programming, from

Glenn Strong, _A Literate Programming Tool for Concurrent Clean_, May 15, 2001

https://www.cs.tcd.ie/publications/tech-reports/reports.01/TCD-CS-2001-13.pdf

[BEGIN QUOTE]

#### 1.2 The advantages of literate programming

Various advantages are claimed for literate programming. They can
be summarised under two main headings.

##### 1.2.1 Improved programs

Most users of literate programming systems claim that they produce
better programs when they use literate programming techniques. In
general, the reasons for this vary, but include

1. The greater care that is taken when writing each section of the
program. Because the programmer is thinking about the reader
of the program (even if such a reader is completely hypothetical),
greater care is taken over each section of code as it is written.

2. The greater freedom allowed by the use of chunks. Sections of
code can be isolated without the need to place them within separate
functions (procedures, methods, whatever the programming
language allows). In general, it does not always make sense to
move a small section of code into a separate subroutine, even if
the clarity of the program might benefit from having the code
isolated. Put simply, it is not always practical to formulate arguments
and prepare a subroutine, even if the clarity of the code
might benefit from it.

3. The close association between the program code and the specifi-
cation for what the code should do. In most cases the documentation
for each code chunk acts not as a description of what the
code does, but what it should do. When the program does not
behave as the documentation says it should, it is the program
that is at fault. The division of the program into small chunks (a
typical chunk will be about a half-dozen to a dozen lines of code)
usually makes it quite simple to identify when a program is not
consistent with its specification.

##### 1.2.2 Improved documentation

There is little question that literate programs are better documented
than programs produced by more usual means.

1. The documentation exists. This may seem trivial, but many software
projects are documented poorly if at all. Once the program
has been written, the job is usually seen as done. From the point
of view of programming this is correct, of course, but when it
becomes necessary to maintain the program the lack of documentation
can be a major problem. By forcing the documentation
to be developed at the same time as the program itself, literate
programming ensures that all code is documented.

2. The program documentation is usually correct. That it, the program
documentation usually describes the algorithms and data
structures used by the program accurately. The close association
between the code and documentation means that the documentation
is far more likely to be updated as the code is changed,
rather than at some future date (which often never arrives).

3. The program documentation is usually also far more usable than
normal documentation. The ability to present documentation
side by side with the actual code which implements the features
being discussed clarifies the situation greatly. Also, the navigation
material produced by most literate programming tools (automatic
indexing and cross referencing of identifiers, for instance,
or hypertext tools) improve comprehension of the program. This
is a great boon to program maintenance, as it allows a programmer
to trace questionable sections of the program. Returning to
a program after an interval of, say, a year makes it clear how
useful this is.

[END QUOTE]

----------------------------------------------------------------------

"prettyprinting remains the most contentious issue
within the literate programming community"

----------------------------------------------------------------------

A thought exercise: Take an existing codebase, and suppose that you want to give someone a "guided tour of the codebase". How would you do this, while adding absolutely *minimal* comments? The tools you can use are: dividing the code into sections, and putting them in some order. ("Read this, then read that... the most important stuff is here...".) That may give a better idea of literate programming than "comment a lot".

----------------------------------------------------------------------

A reason for scepticism about literate programming: it assumes that these coincide:

- The organization/order for exposition (formatting for publication, e.g. publishing your entire program as a book or article, for someone to read)
- The organization/order for making the program maintainable (easier to change, easier to debug)

Making programs easy to change has not typically been on top of Knuth's priorities: beyond the stage of fixing bugs, he prefers to make programs stable, and to understand the program fully and simply *re-edit* it (make a new program) when it substantially changes.

----------------------------------------------------------------------

Knuth in "Fixed-point glue setting":

> As I gain more experience with WEB, I am finding
> that it significantly improves my ability to write reliable
> programs quickly. This is a pleasant surprise,
> since I had designed WEB mainly as a documentation
> tool.

Note also that it's called "WEB System of Structured Documentation" and "CWEB System of Structured Documentation".

----------------------------------------------------------------------

Thimbleby, warp:

> "One of the main reasons
> why literate programming is unsuitable for general publication purposes is that its conventions need
> explaining to readers"

Mentions an important wrinkle:

> Just as there is a continuum from laboratory notebooks to polished published results, there is a
> continuum from explaining entire programs, as required for instance for internal documentation, to
> explaining specific code and algorithms for journal publication.

Do you want to publish your entire program (including routine parts that are not interesting), or selectively publish the important parts that you actually want others to read?

----------------------------------------------------------------------

Thimbleby, warp

> Code and documentation are interleaved in a file, and as they are adjacent in
> the same file it is *very* much easier to keep them consistent. Reducing the obstacles for editing both
> together, and increasing pride in the polished results, has an invigorating effect on programming, as
> well as on dissemination

----------------------------------------------------------------------

More:

> In the past, few people wrote literate programs using tools they had not written themselves, because
> if you built your own tool, you understood its behaviour and building your own system was easier than
> fathoming out the workings of someone else’s tools. Furthermore, most tools make assumptions, and
> circumventing the imposed approach to fit in with a particular project may be harder than starting from
> scratch. Today, only a few literate programming tools have survived the test of time.

> Despite its advantages, after almost 20 years the use of literate programming for publishing
> code in the mainstream literature is now negligible. In whatever ways people may be using literate
> programming internally in software development projects (in lab notebook type uses), it is evidently not
> addressing the needs of the broader research community for publication. Probably the main reason for
> literate programming failing to survive in the literature is that it imposes its own styles and conventions
> (e.g., modules), which adds significantly to the ‘noise’ of a paper and makes it hard to conform to
> journal style requirements

----------------------------------------------------------------------

> many errors in their use
> were undetectable (e.g., there would be no warning if you failed to shift the > key and accidentally
> typed a dot instead: //.—which would be just ignored comment). In short, they suffered from all of
> the problems of conventional literate programming codes, @[, @;, @’ and so on (there are over 30
> such codes, plus a collection of cryptic TEX macros, such as \0). Indeed when Knuth and Levy say of
> the @’ code that ‘this code is dangerous’ you know something is wrong, and to be avoided for a
> reliable system!

----------------------------------------------------------------------

Thimbleby's ideas about using XML in comments (instead of a bunch of control codes) made me look into whether something like that exists for JavaScript. Looks like there is some precedent: see https://msdn.microsoft.com/en-us/library/bb514138.aspx and http://www.kraigbrockschmidt.com/2013/02/06/xml-tags-code-intellisense/

----------------------------------------------------------------------

From Weinberg, "The Psychology of Computer Programming" (1971), Chapter 1 "Reading Programs".

> ... Even programmers do not read programs.
>
> But isn't it quite proper that only the machine should read programs?
> Weren't the programs written for the machine? Yes and no. Even if we
> were not concerned with program modification and with the interfaces
> between programs, reading programs might not be such a bad idea
> from the point of view of learning about programming.
>
> Programming is, among other things, a kind of writing. One way to
> learn writing is to write, but in all other forms of writing, one also reads.
> We read examples—both good and bad—to facilitate learning. But how
> many programmers learn to write programs by reading programs? A
> few, but not many. And with the advent of terminals, things are getting
> worse, for the programmer may not even see his own program in a form
> suitable for reading. In the old days—which in computing is not so long
> ago—we had less easy access to machines and couldn't afford to wait
> for learning from actual machine runs. Turnaround was often so bad that
> programmers would while away the time by reading each others'
> programs. Some even went so far as to read programs from the program
> library—which in those days was still a library in the old sense of the
> term.
>
> But, alas, times change. Just as television has turned the heads of the
> young from the old-fashioned joys of book reading, so have terminals
> and generally improved turnaround made the reading of programs the
> mark of a hopelessly old-fashioned programmer. Late at night, when the
> grizzled old-timer is curled up in bed with a sexy subroutine or a
> mystifying macro, the young blade is busily engaged in a dialogue with his
> terminal. No doubt it is much more thrilling to be face to face with
> the giant computer than merely wrapped in quiet contemplation of the
> work of others. But is it more edifying?
>
> A young novelist of our time was recently asked who were his favorite
> authors. He responded simply that he never read novels, as his ideas
> were so new and superior to anyone else's that reading would only be a
> waste of his time. As you might expect, his work did not support his
> thesis. Perhaps the same could be said for some of our radical young
> programmers. Perhaps there is something to be gained from reading
> other people's programs—if only the amusement engendered by their bad
> examples. ...


----------------------------------------------------------------------

Maybe it's time to start compiling a bibliography of Literate Programming reading material.

- One already exists at Nelson Beebe's bibliography: http://ftp.math.utah.edu/pub/tex/bib/litprog.html ordered by name at http://www.literateprogramming.com/litprog-bib.pdf
- Yet to read: https://www.desy.de/user/projects/LitProg/FAQs.html https://www.desy.de/user/projects/LitProg/Samples.html

Already read:

1982 Fixed-Point Glue Setting: An Example of WEB, Donald E. Knuth
https://tug.org/TUGboat/tb03-1/tb05knuth.pdf
Also included as a nice hyperlinked PDF (but without the preamble) in TeX distributions (`texdoc glue`):
http://northstar-www.dartmouth.edu/doc/texmf-dist/doc/generic/knuth/tex/glue.pdf
http://math.sut.ac.th/lab/software/texlive/texmf-dist/doc/generic/knuth/tex/glue.pdf

1983-09 The WEB System of Structured Documentation (STAN-CS-83-980), Donald E. Knuth
http://infolab.stanford.edu/pub/cstr/reports/cs/tr/83/980/CS-TR-83-980.pdf
210 pages (11 pages WEB manual, plus details) (R42 in Knuth's CV)

1983-09 Literate Programming (STAN-CS-83-981), Donald E. Knuth
[Not available online, not even listed in Knuth's CV, supposedly 15 pages]

1984-08 Literate Programming in C: Cweb manual, Harold W. Thimblebly
Not online, just "Cweb manual" at http://www.harold.thimbleby.net/cv/publications.html
University of York, techreport HT331, abstract in Beebe's bibtex:
>   {\bf Cweb} is a system of structured documentation based of Knuth's {\tt WEB}. The philosophy behind both {\bf cweb} and {\tt WEB} is that an experienced programmer, who wants to provide the best possible documentation of his or her software products, needs two things simultaneously: a language for formatting and a language for programming. When both are appropriately combined we obtain a system much more useful than either language separately. {\bf Cweb} combines {\bf C} source with ({\bf di}){\bf troff} (or {\bf nroff}) documentation (whereas {\tt WEB} operates with Pascal and \TeX). The full facilities of {\bf C} and {\bf troff} are available to the user.\par {\bf Cweb} operates effectively with existing Unix text and program development tools, such as {\bf make}, {\bf tbl}, {\bf eqn}. If speed is important, {\bf cweb} has a built-in formatter which is much faster (and less resource consuming) the {\bf troff} for drafting or using with a lineprinter.

1984-09 Literate Programming, Donald E. Knuth
[Published] http://comjnl.oxfordjournals.org/content/27/2/97
[Submitted] http://www.literateprogramming.com/knuthweb.pdf = http://homepages.cwi.nl/~storm/teaching/reader/Knuth84.pdf = http://www.cs.tufts.edu/~nr/cs257/archive/don-knuth/web.pdf
[What font?] http://www.cs.upc.edu/~eipec/pdf/web.pdf
Knuth's paper copy-pasted into a slideshow by a couple of students:
http://cs.haifa.ac.il/~shuly/teaching/05/programming-languages/presentations/03.pdf

1993-12-07 Interview, Knuth
https://web.archive.org/web/20000302101053/http://www.clbooks.com/nbb/knuth.html

1994 Literate Programming Simplified, Ramsey
http://www.literateprogramming.com/lpsimp.pdf

1994-08-18 Literate Programming Library
https://www.desy.de/user/projects/LitProg.html

1994-08-23 Literate Programming FAQ, David B. Thompson
http://vasc.ri.cmu.edu/old_help/Programming/Literate/literate-FAQ.gz

1994-10-17 Literate Programming -- Propaganda and Tools, Christopher Lee
http://vasc.ri.cmu.edu/old_help/Programming/Literate/literate.html
Linked from https://cs.stanford.edu/~uno/lp.html but not so great

2000 Literate Programming, Harold Thimbleby in The Encyclopedia of Computer Science
http://www.harold.thimbleby.net/cv/files/litprog.pdf
A short, 2-page encyclopedia entry for Literate Programming: good introduction.

2001-05-15 A Literate Programming Tool for Concurrent Clean, Glenn Strong
https://www.cs.tcd.ie/publications/tech-reports/reports.01/TCD-CS-2001-13.pdf
16 pages. The second half of the paper (section 4 onwards) is about pretty-printing, but the rest is great.

2003-06-25 Explaining code for publication, Harold Thimbleby
https://www.harold.thimbleby.net/cv/files/warp.pdf
24 pages. Has a lot of great quotes about Literate Programming (see notes
above), and presents a light-weight system based on extracting the documentation
from comments: but uses XML so that the documentation-extractor stays
simple. (Very important!)

2011?  literate-programming.rb, Ryan Tomayko
http://timelessrepo.com/literate-programming.html
Someone who has actually looked at literate programming.
Not later than 2011, going by date of https://news.ycombinator.com/item?id=2089912

2013 Why I'm Trying Literate Programming, Shane Celis
http://www.shanecelis.com/2013/05/20/why-im-trying-literate-programming/
^ This is good too

----------------------------------------------------------------------

Some problems with Knuth-style literate programming:

- he assumes one wants to read and understand the whole program, keep the whole thing in their head. (He has a nearly superhuman ability to do this, but most others don't want this: they want to understand pieces at a time, not the book-sized program as a whole.)

- It's optimized for printing on paper, not so great when jumping around on screen.

- When looking at a section, there is a lot of "context" that is relevant: what are the local variables defined outside this section, what invariants will hold when this is called, etc. These are hard to figure out by looking at the section in isolation.

----------------------------------------------------------------------

> Literate programming has a niche: write once, read many programs which are maintained by a single person and which seldom have many major improvements.

> This simply doesn't describe most projects that I've been associated with in a lifetime (I'm now retired) of professional software development. It's not a surprise that Literate Programming is the product of a university professor, whose job is exposition to students, rather than the tens of thousands of working software developers who have to work with code on a daily basis.

-- Comment by John Roth at http://languagelog.ldc.upenn.edu/nll/?p=10693

See also an interesting comment by Matt Pharr on that thread: http://languagelog.ldc.upenn.edu/nll/?p=10693#comment-563359
(Matt Pharr won an Academy Award for a literate-programming book! And mentioned it in his acceptance speech!)

> (Regarding John Roth's university professor comment: I've been a professional software developer ever since leaving grad school.)
>
> ...
> 
> I don't believe that literate programming is necessarily appropriate for all software; as many folks have pointed out, a lot of software isn't so complex that it's necessary, and the literate programming approach definitely introduces additional burden. I'd estimate that the total work involved is basically the sum of the work to write a software system plus the work to write a book. As it turns out that writing a book is a big undertaking, this is a pretty substantial effort. Many programmers certainly aren't good writers or don't enjoy writing.

----------------------------------------------------------------------

Comment by Daly (of Axiom) at https://news.ycombinator.com/item?id=10071207 (haven't read the rest of the thread):

> There are some "gold standard" literate programs: "Physically Based Rendering" by Pharr and Humphreys won an academy award. "Lisp in Small Pieces" contains a complete lisp implementation including the interpreter and compiler. The book "Implementing Elliptic Curve Cryptography" is another example.

----------------------------------------------------------------------

TODO for myself: get all the *early* Knuth programs and documentation (in WEB) that came out of the TeX project: TeX (tex, tripman, glue), TeXware (pooltype, tftopl, pltotf, dvitype), mf (mf, trapman), mfware (gftype, gftopk, gftodvi, mft), etc (vftovp, vptovf), web (weave, tangle, webman). Put them up.
