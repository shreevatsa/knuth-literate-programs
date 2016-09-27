@s variable int
@s clause int
\datethis
@*Intro. This program is part of a series of ``SAT-solvers'' that I'm putting
together for my own education as I prepare to write Section 7.2.2.2 of
{\sl The Art of Computer Programming}. My intent is to have a variety of
compatible programs on which I can run experiments to learn how different
approaches work in practice.

This time I'm implementing {\mc WALKSAT}, a notable development of the
{\mc WALK} algorithm that was featured in {\mc SAT7}. Instead of
using completely random choices when a variable is flipped, {\mc WALKSAT}
makes a more informed decision. The {\mc WALKSAT} method was introduced
by B.~Selman, H.~A. Kautz, and B.~Cohen in {\sl National Conference
on Artificial Intelligence\/ \bf12} (1994), 337--343.

@ If you have already read {\mc SAT7}, or any other program of this
series, you might as well skip now past the rest of this introduction,
and past the code for the
``I/O wrapper'' that is presented in the next dozen or so
sections, because you've seen it before. (Except that there are some
new command-line options.)

The input appears on |stdin| as a series of lines, with one clause per line.
Each clause is a sequence of literals separated by spaces. Each literal is
a sequence of one to eight ASCII characters between \.{!} and \.{\}},
inclusive, not beginning with \.{\~},
optionally preceded by \.{\~} (which makes the literal ``negative'').
For example, Rivest's famous clauses on four variables,
found in 6.5--(13) and 7.1.1--(32) of {\sl TAOCP}, can be represented by the
following eight lines of input: 
$$\chardef~=`\~
\vcenter{\halign{\tt#\cr
x2 x3 ~x4\cr
x1 x3 x4\cr
~x1 x2 x4\cr
~x1 ~x2 x3\cr
~x2 ~x3 x4\cr
~x1 ~x3 ~x4\cr
x1 ~x2 ~x4\cr
x1 x2 ~x3\cr}}$$
Input lines that begin with \.{\~\ } are ignored (treated as comments).
The output will be `\.{\~?}' if the algorithm could not
find a way to satisfy the input clauses.
Otherwise it will be a list of noncontradictory literals that cover each
clause, separated by spaces. (``Noncontradictory'' means that we don't
have both a literal and its negation.) The input above would, for example,
yield `\.{\~?}'; but if the final clause were omitted, the output would
be `\.{\~x1} \.{\~x2} \.{x3}', together
with either \.{x4} or \.{\~x4} (but not both). No attempt is made to
find all solutions; at most one solution is given.

The running time in ``mems'' is also reported, together with the approximate
number of bytes needed for data storage. One ``mem'' essentially means a
memory access to a 64-bit word.
(These totals don't include the time or space needed to parse the
input or to format the output.)

@ So here's the structure of the program. (Skip ahead if you are
impatient to see the interesting stuff.)

@d o mems++ /* count one mem */
@d oo mems+=2 /* count two mems */
@d ooo mems+=3 /* count three mems */

@c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "gb_flip.h"
typedef unsigned int uint; /* a convenient abbreviation */
typedef unsigned long long ullng; /* ditto */
@<Type definitions@>;
@<Global variables@>;
@<Subroutines@>;
main (int argc, char *argv[]) {
  register uint c,g,h,i,j,k,l,p,q,r,ii,kk,ll,fcount;
  @<Process the command line@>;
  @<Initialize everything@>;
  @<Input the clauses@>;
  if (verbose&show_basics)
    @<Report the successful completion of the input phase@>;
  @<Set up the main data structures@>;
  imems=mems, mems=0;
  @<Solve the problem@>;
  if (verbose&show_basics)
  fprintf(stderr,
    "Altogether %llu+%llu mems, %llu bytes, %d trial%s, %llu steps.\n",
               imems,mems,bytes,trial+1,trial?"s":"",step);
}

@ @d show_basics 1 /* |verbose| code for basic stats */
@d show_choices 2 /* |verbose| code for backtrack logging */
@d show_details 4 /* |verbose| code for further commentary */
@d show_gory_details 8 /* |verbose| code turned on when debugging */

@<Glob...@>=
int random_seed=0; /* seed for the random words of |gb_rand| */
int verbose=show_basics; /* level of verbosity */
int hbits=8; /* logarithm of the number of the hash lists */
int buf_size=1024; /* must exceed the length of the longest input line */
ullng maxsteps; /* maximum steps per walk (|maxthresh*n| by default) */
unsigned int maxthresh=50;
int maxtrials=1000000; /* maximum walks to try */
double nongreedprob=0.4; /* the probability bias for nongreedy choices */
unsigned long nongreedthresh; /* coerced since |gb_next_rand| is |long| */
ullng imems,mems; /* mem counts */
ullng thresh=0; /* report when |mems| exceeds this, if |delta!=0| */
ullng delta=0; /* report every |delta| or so mems */
ullng timeout=0x1fffffffffffffff; /* give up after this many mems */
ullng bytes; /* memory used by main data structures */

@ On the command line one can specify any or all of the following options:
\smallskip
\item{$\bullet$}
`\.v$\langle\,$integer$\,\rangle$' to enable various levels of verbose
 output on |stderr|.
\item{$\bullet$}
`\.h$\langle\,$positive integer$\,\rangle$' to adjust the hash table size.
\item{$\bullet$}
`\.b$\langle\,$positive integer$\,\rangle$' to adjust the size of the input
buffer.
\item{$\bullet$}
`\.s$\langle\,$integer$\,\rangle$' to define the seed for any random numbers
that are used.
\item{$\bullet$}
`\.d$\langle\,$integer$\,\rangle$' to set |delta| for periodic state reports.
\item{$\bullet$}
`\.t$\langle\,$integer$\,\rangle$' to define the maximum number of steps per
random walk.
\item{$\bullet$}
`\.c$\langle\,$integer$\,\rangle$' to define the maximum number of steps per
variable, per random walk, if the \.t parameter hasn't been given.
(The default is 50.) 
\item{$\bullet$}
`\.w$\langle\,$integer$\,\rangle$' to define the maximum number of walks
attempted.
\item{$\bullet$}
`\.p$\langle\,$float$\,\rangle$' to define the probability |nongreedprob| of
nongreedy choices.
\item{$\bullet$}
`\.T$\langle\,$integer$\,\rangle$' to set |timeout|: This program will
abruptly terminate, when it discovers that |mems>timeout|.

@<Process the command line@>=
for (j=argc-1,k=0;j;j--) switch (argv[j][0]) {
case 'v': k|=(sscanf(argv[j]+1,"%d",&verbose)-1);@+break;
case 'h': k|=(sscanf(argv[j]+1,"%d",&hbits)-1);@+break;
case 'b': k|=(sscanf(argv[j]+1,"%d",&buf_size)-1);@+break;
case 's': k|=(sscanf(argv[j]+1,"%d",&random_seed)-1);@+break;
case 'd': k|=(sscanf(argv[j]+1,"%lld",&delta)-1);@+thresh=delta;@+break;
case 't': k|=(sscanf(argv[j]+1,"%llu",&maxsteps)-1);@+break;
case 'c': k|=(sscanf(argv[j]+1,"%u",&maxthresh)-1);@+break;
case 'w': k|=(sscanf(argv[j]+1,"%d",&maxtrials)-1);@+break;
case 'p': k|=(sscanf(argv[j]+1,"%lf",&nongreedprob)-1);@+break;
case 'T': k|=(sscanf(argv[j]+1,"%lld",&timeout)-1);@+break;
default: k=1; /* unrecognized command-line option */
}
if (k || hbits<0 || hbits>30 || buf_size<=0) {
  fprintf(stderr,
     "Usage: %s [v<n>] [h<n>] [b<n>] [s<n>] [d<n>]",argv[0]);
  fprintf(stderr," [t<n>] [c<n>] [w<n>] [p<f>] [T<n>] < foo.sat\n");
  exit(-1);
}
if (nongreedprob<0.0 || nongreedprob>1.0) {
  fprintf(stderr,"Parameter p should be between 0.0 and 1.0!\n");
  exit(-666);
}

@*The I/O wrapper. The following routines read the input and absorb it into
temporary data areas from which all of the ``real'' data structures
can readily be initialized. My intent is to incorporate these routines in all
of the SAT-solvers in this series. Therefore I've tried to make the code
short and simple, yet versatile enough so that almost no restrictions are
placed on the sizes of problems that can be handled. These routines are
supposed to work properly unless there are more than
$2^{32}-1=4$,294,967,295 occurrences of literals in clauses,
or more than $2^{31}-1=2$,147,483,647 variables or clauses.

In these temporary tables, each variable is represented by four things:
its unique name; its serial number; the clause number (if any) in which it has
most recently appeared; and a pointer to the previous variable (if any)
with the same hash address. Several variables at a time
are represented sequentially in small chunks of memory called ``vchunks,''
which are allocated as needed (and freed later).

@d vars_per_vchunk 341 /* preferably $(2^k-1)/3$ for some $k$ */

@<Type...@>=
typedef union {
  char ch8[8];
  uint u2[2];
  long long lng;
} octa;
typedef struct tmp_var_struct {
  octa name; /* the name (one to eight ASCII characters) */
  uint serial; /* 0 for the first variable, 1 for the second, etc. */
  int stamp; /* |m| if positively in clause |m|; |-m| if negatively there */
  struct tmp_var_struct *next; /* pointer for hash list */
} tmp_var;
@#
typedef struct vchunk_struct {
  struct vchunk_struct *prev; /* previous chunk allocated (if any) */
  tmp_var var[vars_per_vchunk];
} vchunk;

@ Each clause in the temporary tables is represented by a sequence of
one or more pointers to the |tmp_var| nodes of the literals involved.
A negated literal is indicated by adding~1 to such a pointer.
The first literal of a clause is indicated by adding~2.
Several of these pointers are represented sequentially in chunks
of memory, which are allocated as needed and freed later.

@d cells_per_chunk 511 /* preferably $2^k-1$ for some $k$ */

@<Type...@>=
typedef struct chunk_struct {
  struct chunk_struct *prev; /* previous chunk allocated (if any) */
  tmp_var *cell[cells_per_chunk];
} chunk;

@ @<Glob...@>=
char *buf; /* buffer for reading the lines (clauses) of |stdin| */
tmp_var **hash; /* heads of the hash lists */
uint hash_bits[93][8]; /* random bits for universal hash function */
vchunk *cur_vchunk; /* the vchunk currently being filled */
tmp_var *cur_tmp_var; /* current place to create new |tmp_var| entries */
tmp_var *bad_tmp_var; /* the |cur_tmp_var| when we need a new |vchunk| */
chunk *cur_chunk; /* the chunk currently being filled */
tmp_var **cur_cell; /* current place to create new elements of a clause */
tmp_var **bad_cell; /* the |cur_cell| when we need a new |chunk| */
ullng vars; /* how many distinct variables have we seen? */
ullng clauses; /* how many clauses have we seen? */
ullng nullclauses; /* how many of them were null? */
ullng cells; /* how many occurrences of literals in clauses? */

@ @<Initialize everything@>=
gb_init_rand(random_seed);
buf=(char*)malloc(buf_size*sizeof(char));
if (!buf) {
  fprintf(stderr,"Couldn't allocate the input buffer (buf_size=%d)!\n",
            buf_size);
  exit(-2);
}
hash=(tmp_var**)malloc(sizeof(tmp_var)<<hbits);
if (!hash) {
  fprintf(stderr,"Couldn't allocate %d hash list heads (hbits=%d)!\n",
           1<<hbits,hbits);
  exit(-3);
}
for (h=0;h<1<<hbits;h++) hash[h]=NULL;

@ The hash address of each variable name has $h$ bits, where $h$ is the
value of the adjustable parameter |hbits|.
Thus the average number of variables per hash list is $n/2^h$ when there
are $n$ different variables. A warning is printed if this average number
exceeds 10. (For example, if $h$ has its default value, 8, the program will
suggest that you might want to increase $h$ if your input has 2560
different variables or more.)

All the hashing takes place at the very beginning,
and the hash tables are actually recycled before any SAT-solving takes place;
therefore the setting of this parameter is by no means crucial. But I didn't
want to bother with fancy coding that would determine $h$ automatically.

@<Input the clauses@>=
while (1) {
  if (!fgets(buf,buf_size,stdin)) break;
  clauses++;
  if (buf[strlen(buf)-1]!='\n') {
    fprintf(stderr,
      "The clause on line %lld (%.20s...) is too long for me;\n",clauses,buf);
    fprintf(stderr," my buf_size is only %d!\n",buf_size);
    fprintf(stderr,"Please use the command-line option b<newsize>.\n");
    exit(-4);
  }
  @<Input the clause in |buf|@>;
}
if ((vars>>hbits)>=10) {
  fprintf(stderr,"There are %llu variables but only %d hash tables;\n",
     vars,1<<hbits);
  while ((vars>>hbits)>=10) hbits++;
  fprintf(stderr," maybe you should use command-line option h%d?\n",hbits);
}
clauses-=nullclauses;
if (clauses==0) {
  fprintf(stderr,"No clauses were input!\n");
  exit(-77);
}
if (vars>=0x80000000) {
  fprintf(stderr,"Whoa, the input had %llu variables!\n",vars);
  exit(-664);
}
if (clauses>=0x80000000) {
  fprintf(stderr,"Whoa, the input had %llu clauses!\n",clauses);
  exit(-665);
}
if (cells>=0x100000000) {
  fprintf(stderr,"Whoa, the input had %llu occurrences of literals!\n",cells);
  exit(-666);
}

@ @<Input the clause in |buf|@>=
for (j=k=0;;) {
  while (buf[j]==' ') j++; /* scan to nonblank */
  if (buf[j]=='\n') break;
  if (buf[j]<' ' || buf[j]>'~') {
    fprintf(stderr,"Illegal character (code #%x) in the clause on line %lld!\n",
      buf[j],clauses);
    exit(-5);
  }
  if (buf[j]=='~') i=1,j++;
  else i=0;
  @<Scan and record a variable; negate it if |i==1|@>;
}
if (k==0) {
  fprintf(stderr,"(Empty line %lld is being ignored)\n",clauses);
  nullclauses++; /* strictly speaking it would be unsatisfiable */
}
goto clause_done;
empty_clause: @<Remove all variables of the current clause@>;
clause_done: cells+=k;

@ We need a hack to insert the bit codes 1 and/or 2 into a pointer value.

@d hack_in(q,t) (tmp_var*)(t|(ullng)q)

@<Scan and record a variable; negate it if |i==1|@>=
{
  register tmp_var *p;
  if (cur_tmp_var==bad_tmp_var) @<Install a new |vchunk|@>;
  @<Put the variable name beginning at |buf[j]| in |cur_tmp_var->name|
     and compute its hash code |h|@>;
  @<Find |cur_tmp_var->name| in the hash table at |p|@>;
  if (p->stamp==clauses || p->stamp==-clauses) @<Handle a duplicate literal@>@;
  else {
    p->stamp=(i? -clauses: clauses);
    if (cur_cell==bad_cell) @<Install a new |chunk|@>;
    *cur_cell=p;
    if (i==1) *cur_cell=hack_in(*cur_cell,1);
    if (k==0) *cur_cell=hack_in(*cur_cell,2);
    cur_cell++,k++;
  }
}

@ @<Install a new |vchunk|@>=
{
  register vchunk *new_vchunk;
  new_vchunk=(vchunk*)malloc(sizeof(vchunk));
  if (!new_vchunk) {
    fprintf(stderr,"Can't allocate a new vchunk!\n");
    exit(-6);
  }
  new_vchunk->prev=cur_vchunk, cur_vchunk=new_vchunk;
  cur_tmp_var=&new_vchunk->var[0];
  bad_tmp_var=&new_vchunk->var[vars_per_vchunk];
}  

@ @<Install a new |chunk|@>=
{
  register chunk *new_chunk;
  new_chunk=(chunk*)malloc(sizeof(chunk));
  if (!new_chunk) {
    fprintf(stderr,"Can't allocate a new chunk!\n");
    exit(-7);
  }
  new_chunk->prev=cur_chunk, cur_chunk=new_chunk;
  cur_cell=&new_chunk->cell[0];
  bad_cell=&new_chunk->cell[cells_per_chunk];
}  

@ The hash code is computed via ``universal hashing,'' using the following
precomputed tables of random bits.

@<Initialize everything@>=
for (j=92;j;j--) for (k=0;k<8;k++)
  hash_bits[j][k]=gb_next_rand();

@ @<Put the variable name beginning at |buf[j]| in |cur_tmp_var->name|...@>=
cur_tmp_var->name.lng=0;
for (h=l=0;buf[j+l]>' '&&buf[j+l]<='~';l++) {
  if (l>7) {
    fprintf(stderr,
        "Variable name %.9s... in the clause on line %lld is too long!\n",
        buf+j,clauses);
    exit(-8);
  }
  h^=hash_bits[buf[j+l]-'!'][l];
  cur_tmp_var->name.ch8[l]=buf[j+l];
}
if (l==0) goto empty_clause; /* `\.\~' by itself is like `true' */
j+=l;
h&=(1<<hbits)-1;

@ @<Find |cur_tmp_var->name| in the hash table...@>=
for (p=hash[h];p;p=p->next)
  if (p->name.lng==cur_tmp_var->name.lng) break;
if (!p) { /* new variable found */
  p=cur_tmp_var++;
  p->next=hash[h], hash[h]=p;
  p->serial=vars++;
  p->stamp=0;
}

@ The most interesting aspect of the input phase is probably the ``unwinding''
that we might need to do when encountering a literal more than once
in the same clause.

@<Handle a duplicate literal@>=
{
  if ((p->stamp>0)==(i>0)) goto empty_clause;
}

@ An input line that begins with `\.{\~\ }' is silently treated as a comment.
Otherwise redundant clauses are logged, in case they were unintentional.
(One can, however, intentionally
use redundant clauses to force the order of the variables.)

@<Remove all variables of the current clause@>=
while (k) {
  @<Move |cur_cell| backward to the previous cell@>;
  k--;
}
if ((buf[0]!='~')||(buf[1]!=' '))
  fprintf(stderr,"(The clause on line %lld is always satisfied)\n",clauses);
nullclauses++;

@ @<Move |cur_cell| backward to the previous cell@>=
if (cur_cell>&cur_chunk->cell[0]) cur_cell--;
else {
  register chunk *old_chunk=cur_chunk;
  cur_chunk=old_chunk->prev;@+free(old_chunk);
  bad_cell=&cur_chunk->cell[cells_per_chunk];
  cur_cell=bad_cell-1;
}

@ Notice that the old ``temporary variable'' data goes away here.
(A bug bit me in the first version of the code because of this.)

@<Move |cur_tmp_var| backward to the previous temporary variable@>=
if (cur_tmp_var>&cur_vchunk->var[0]) cur_tmp_var--;
else {
  register vchunk *old_vchunk=cur_vchunk;
  cur_vchunk=old_vchunk->prev;@+free(old_vchunk);
  bad_tmp_var=&cur_vchunk->var[vars_per_vchunk];
  cur_tmp_var=bad_tmp_var-1;
}

@ @<Report the successful completion of the input phase@>=
fprintf(stderr,
  "(%llu variables, %llu clauses, %llu literals successfully read)\n",
                       vars,clauses,cells);

@*SAT solving, version 8. The {\mc WALKSAT} algorithm is only a little bit
more complicated than the {\mc WALK} method, but the differences mean that
we cannot simulate simultaneous runs with bitwise operations.

Let $x=x_1\ldots x_n$ be a binary vector that represents all $n$ variables,
and let $T$ be a given tolerance (representing the amount of patience that
we have). We start by setting $x$ to a completely random vector;
then we repeat the following steps, at most $T$ times:
{\smallskip\narrower\noindent
 Check to see if $x$ satisfies all the clauses. If so, output~$x$; we're done!
 If not, select a clause $c$ that isn't true, uniformly at random from
 all such clauses; say $c$ is the union of $k$ literals,
 $l_1\vee\cdots\vee l_k$. Sort those literals according to their
 ``break count,'' which is the number of clauses that will become false
 when that literal is flipped. Choose a literal to flip by the following
 method: If no literal has a break count of zero, and if a biased coin turns
 up heads, choose $l_j$ at random from among all $k$ literals.
 Otherwise, choose $l_j$ at random from among those with smallest break count.
 Then change the bit of~$x$ that will make $l_j$ true.
\par}
\smallskip\noindent If that random walk doesn't succeed, we can
try again with another starting value of~$x$, until we've seen
enough failures to be convinced that we're probably doomed to defeat.

@ The data structures are somewhat interesting, but not tricky: There are
four main arrays, |cmem|, |vmem|, |mem|, and |tmem|. Structured
|clause| nodes appear in |cmem|, and structured |variable| nodes
appear in |vmem|. Each clause points to a sequential list of literals
in~|mem|; each literal points to a sequential list of clauses in~|tmem|,
which is essentially the ``transpose'' of the information in~|mem|.
If |fcount| clauses are currently false, the first |fcount| entries
of~|cmem| also contain the indices of those clauses.

As in most previous programs of this series, the literals $x$ and $\bar x$
are represented internally by $2k$ and $2k+1$ when $x$ is the $k$th variable.

The symbolic names of variables are kept separately in |nmem|, not in |vmem|,
for reasons of efficiency. (Otherwise a |variable| struct would
take up five octabytes, and addressing would be slower.)

@d value(l) (vmem[(l)>>1].val^((l)&1))

@<Type...@>=
typedef struct {
  uint val; /* the variable's current value */
  uint breakcount; /* how many clauses are false except for this variable */
  uint pos_start,neg_start; /* where the clause lists start in |tmem| */
} variable;
typedef struct {
  uint start; /* where the literal list starts in |mem| */
  uint tcount; /* how many of those literals are currently true? */
  uint fplace; /* if |tcount=0|, which |fslot| holds this clause? */
  uint fslot; /* the number of a false clause, if needed */
} clause;

@ @<Glob...@>=
clause *cmem; /* the master array of clauses */
variable *vmem; /* the master array of variables */
uint *mem; /* the master array of literals in clauses */
uint *cur_mcell; /* the current cell of interest in |mem| */
uint *tmem; /* the master array of clauses containing literals */
octa *nmem; /* the master array of symbolic variable names */
int trial; /* which trial are we on? */
ullng step; /* which step are we on? */
uint *best; /* temporary array to hold literal names for a clause */

@ Here is a subroutine that prints a clause symbolically. It illustrates
some of the conventions of the data structures that have been explained above.
I use it only for debugging.

@<Sub...@>=
void print_clause(uint c) { /* the first clause is called clause 1, not 0 */
  register uint l,ll;
  fprintf(stderr,"%d:",c); /* show the clause number */
  for (l=cmem[c-1].start;l<cmem[c].start;l++) {
    ll=mem[l];
    fprintf(stderr," %s%.8s(%d)",ll&1? "~": "",nmem[ll>>1].ch8,value(ll));
  }
  fprintf(stderr,"\n");
}

@ Another version of that routine, used to display unsatisfied clauses
in verbose mode, shows the current breakcounts of each literal.

@<Sub...@>=
void print_unsat_clause(uint c) {
  register uint l,ll;
  fprintf(stderr,"%d:",c); /* show the clause number */
  for (l=cmem[c-1].start;l<cmem[c].start;l++) {
    ll=mem[l];
    fprintf(stderr," %s%.8s(%d)",ll&1? "~": "",nmem[ll>>1].ch8,
             vmem[ll>>1].breakcount);
  }
  fprintf(stderr,"\n");
}

@ Similarly, we can list the clause numbers that contain a given literal.
(Notice the limits on~|c| in the loop here.)

@<Sub...@>=
void print_literal_uses(uint l) {
  register uint ll,c;
  ll=l>>1;
  fprintf(stderr,"%s%.8s(%d) is in",l&1?"~":"",nmem[ll].ch8,value(l));
  for (c=(l&1?vmem[ll].neg_start:vmem[ll].pos_start);
       c<(l&1?vmem[ll+1].pos_start:vmem[ll].neg_start); c++)
    fprintf(stderr," %d",tmem[c]);
  fprintf(stderr,"\n");
}

@*Initializing the real data structures.
We're ready now to convert the temporary chunks of data into the
form we want, and to recycle those chunks.

@<Set up the main data structures@>=
@<Allocate the main arrays@>;
@<Initialize the |pos_start| and |neg_start| fields@>;
@<Copy all the temporary cells to the |mem| and |cmem| arrays
   in proper format@>;
@<Copy all the temporary variable nodes to the |nmem| array in proper format@>;
@<Set up the |tmem| array@>;
@<Check consistency@>;

@ @<Allocate the main arrays@>=
free(buf);@+free(hash); /* a tiny gesture to make a little room */
vmem=(variable*)malloc((vars+1)*sizeof(variable));
if (!vmem) {
  fprintf(stderr,"Oops, I can't allocate the vmem array!\n");
  exit(-12);
}
bytes=(vars+1)*sizeof(variable);
nmem=(octa*)malloc(vars*sizeof(octa));
if (!nmem) {
  fprintf(stderr,"Oops, I can't allocate the nmem array!\n");
  exit(-13);
}
bytes+=vars*sizeof(octa);
mem=(uint*)malloc(cells*sizeof(uint));
if (!mem) {
  fprintf(stderr,"Oops, I can't allocate the big mem array!\n");
  exit(-10);
}
bytes+=cells*sizeof(uint);
tmem=(uint*)malloc(cells*sizeof(uint));
if (!tmem) {
  fprintf(stderr,"Oops, I can't allocate the big tmem array!\n");
  exit(-14);
}
bytes+=cells*sizeof(uint);
cmem=(clause*)malloc((clauses+1)*sizeof(clause));
if (!cmem) {
  fprintf(stderr,"Oops, I can't allocate the cmem array!\n");
  exit(-11);
}
bytes+=(clauses+1)*sizeof(clause);

@ @<Initialize the |pos_start| and |neg_start| fields@>=
for (c=vars; c; c--) o,vmem[c-1].pos_start=vmem[c-1].neg_start=0;

@ @<Copy all the temporary cells to the |mem| and |cmem| arrays...@>=
for (c=clauses,cur_mcell=mem+cells,kk=0; c; c--) {
  o,cmem[c].start=cur_mcell-mem,k=0;
  @<Insert the cells for the literals of clause |c|@>;
  if (k>kk) kk=k; /* maximum clause size seen so far */
}
if (cur_mcell!=mem) {
  fprintf(stderr,"Confusion about the number of cells!\n");
  exit(-99);
}
cmem[0].start=0;
best=(uint*)malloc(kk*sizeof(uint));
if (!best) {
  fprintf(stderr,"Oops, I can't allocate the best array!\n");
  exit(-16);
}
bytes+=kk*sizeof(uint);

@ The basic idea is to ``unwind'' the steps that we went through while
building up the chunks.

@d hack_out(q) (((ullng)q)&0x3)
@d hack_clean(q) ((tmp_var*)((ullng)q&-4))

@<Insert the cells for the literals of clause |c|@>=
for (i=0;i<2;k++) {
  @<Move |cur_cell| back...@>;
  i=hack_out(*cur_cell);
  p=hack_clean(*cur_cell)->serial;
  cur_mcell--;
  o,*cur_mcell=l=p+p+(i&1);
  if (l&1) oo,vmem[l>>1].neg_start++;
  else oo,vmem[l>>1].pos_start++;
}

@ @<Set up the |tmem| array@>=
for (j=k=0;k<vars;k++) {
  o,i=vmem[k].pos_start, ii=vmem[k].neg_start;
  o,vmem[k].pos_start=j+i, vmem[k].neg_start=j+i+ii;
  j=j+i+ii;
}
o,vmem[k].pos_start=j; /* |j=cells| at this point */
for (c=k=0,o,kk=cmem[1].start;k<cells;k++) {
  if (k==kk) o,c++,kk=cmem[c+1].start;
  l=mem[k];
  if (l&1) ooo,i=vmem[l>>1].neg_start-1,tmem[i]=c,vmem[l>>1].neg_start=i;
  else     ooo,i=vmem[l>>1].pos_start-1,tmem[i]=c,vmem[l>>1].pos_start=i;
}

@ @<Copy all the temporary variable nodes...@>=
for (c=vars; c; c--) {
  @<Move |cur_tmp_var| back...@>;
  o,nmem[c-1].lng=cur_tmp_var->name.lng;
}

@ We should now have unwound all the temporary data chunks back to their
beginnings.

@<Check consistency@>=
if (cur_cell!=&cur_chunk->cell[0] ||
     cur_chunk->prev!=NULL ||
     cur_tmp_var!=&cur_vchunk->var[0] ||
     cur_vchunk->prev!=NULL) {
  fprintf(stderr,"This can't happen (consistency check failure)!\n");
  exit(-14);
}
free(cur_chunk);@+free(cur_vchunk);

@*Doing it. So we take random walks.

@<Solve the problem@>=
if (maxsteps==0) maxsteps=maxthresh*vars;
nongreedthresh=nongreedprob*(unsigned long)0x80000000;
for (trial=0;trial<maxtrials;trial++) {
  if (delta && (mems>=thresh)) {
    thresh+=delta;
    fprintf(stderr," after %lld mems, beginning trial %d\n",mems,trial+1);
  }@+else if (verbose&show_choices)
    fprintf(stderr,"beginning trial %d\n",trial+1);
  @<Initialize all values@>;
  if (verbose&show_details) @<Print the initial guess@>;
  @<Initialize the clause data structures@>;
  for (step=0;;step++) {
    if (fcount==0) @<Print a solution and |goto done|@>;
    if (mems>timeout) {
      fprintf(stderr,"TIMEOUT!\n");
      goto done;
    }
    if (step==maxsteps) break;
    @<Choose a random unsatisfied clause, |c|@>;
    @<Choose a literal |l| in |c|@>;
    @<Flip the value of |l|@>;
  }
}
printf("~?\n"); /* we weren't able to satisfy all the clauses */
if (verbose&show_basics) fprintf(stderr,"DUNNO\n");
trial--; /* restore the actual number of trials made */
done:

@ The macro |gb_next_rand()| delivers a 31-bit random integer,
and my convention is to charge four mems whenever it is called.

@<Initialize all values@>=
for (k=0,r=1;k<vars;k++) {
  if (r==1) mems+=4,r=gb_next_rand()+(1U<<31);
  o,vmem[k].val=r&1, r>>=1;
  vmem[k].breakcount=0;
}

@ @<Initialize the clause data structures@>=
fcount=0;
for (c=k=0;c<clauses;c++) {
  o,kk=cmem[c+1].start;
  p=0; /* |p| true literals seen so far in clause |c| */
  for (;k<kk;k++) {
    o,l=mem[k];
    if (o,value(l)) p++,ll=l;
  }
  o,cmem[c].tcount=p;
  if (p<=1) {
    if (p) oo,vmem[ll>>1].breakcount++;
    else oo,cmem[c].fplace=fcount,cmem[fcount++].fslot=c;
  }
}

@ @<Choose a random unsatisfied clause, |c|@>=
if (verbose&show_gory_details) {
  fprintf(stderr,"currently false:\n");
  for (k=0;k<fcount;k++) print_unsat_clause(cmem[k].fslot+1);
}
mems+=5,c=cmem[gb_unif_rand(fcount)].fslot;
if (verbose&show_choices)
  fprintf(stderr,"in %u(%d)",c+1,fcount);

@ @<Choose a literal |l| in |c|@>=
oo,k=cmem[c].start,kk=cmem[c+1].start,h=kk-k;
ooo,p=mem[k],r=vmem[p>>1].breakcount,best[0]=p,j=1;
for (k++;k<kk;k++) {
  oo,p=mem[k],q=vmem[p>>1].breakcount;
  if (q<=r) {
    if (q<r) o,r=q,best[0]=p,j=1;
    else o,best[j++]=p;
  }
}
if (r==0) goto greedy;
if (mems+=4,(gb_next_rand()<nongreedthresh)) {
  mems+=5,l=mem[kk-1-gb_unif_rand(h)],g=0;
  goto got_l;
}
greedy: g=1;
if (j==1) l=best[0];
else mems+=5,l=best[gb_unif_rand(j)];
got_l: p=l>>1;
if (verbose&show_choices) {
  if (verbose&show_details)
    fprintf(stderr,", %d*%d of %d%s,",r,j,h,g?"":" nongreedy");
  fprintf(stderr," flip %s%.8s (cost %d)\n",
     vmem[p].val?"":"~",nmem[p].ch8,vmem[p].breakcount);
}

@ At this point |p=l>>1|.

@<Flip the value of |l|@>=
if (l&1) {
  oo,k=vmem[p].neg_start, kk=vmem[p+1].pos_start;
  @<Make clauses |tmem[k]|, |tmem[k+1]|, \dots\ happier@>;
  o,vmem[p].breakcount=h, vmem[p].val=0;
  k=vmem[p].pos_start, kk=vmem[p].neg_start;
  @<Make clauses |tmem[k]|, |tmem[k+1]|, \dots\ sadder@>;
}@+else {
  o,k=vmem[p].pos_start, kk=vmem[p].neg_start;
  @<Make clauses |tmem[k]|, |tmem[k+1]|, \dots\ happier@>;
  o,vmem[p].breakcount=h, vmem[p].val=1;
  o,k=kk, kk=vmem[p+1].pos_start;
  @<Make clauses |tmem[k]|, |tmem[k+1]|, \dots\ sadder@>;
}

@ @<Make clauses |tmem[k]|, |tmem[k+1]|, \dots\ happier@>=
for (h=0;k<kk;k++) {
  ooo,c=tmem[k],j=cmem[c].tcount,cmem[c].tcount=j+1;
  if (j<=1) {
    if (j) @<Decrease the breakcount of |c|'s critical variable@>@;
    else { /* delete |c| from false list */
      oo,i=cmem[c].fplace,q=cmem[--fcount].fslot;
      oo,cmem[i].fslot=q,cmem[q].fplace=i;
      h++; /* the flipped literal is now critical */
    }
  }
}

@ @<Make clauses |tmem[k]|, |tmem[k+1]|, \dots\ sadder@>=
for (;k<kk;k++) {
  ooo,c=tmem[k],j=cmem[c].tcount-1,cmem[c].tcount=j;
  if (j<=1) {
    if (j) @<Increase the breakcount of |c|'s critical variable@>@;
    else { /* insert |c| into false list */
      oo,cmem[fcount].fslot=c,cmem[c].fplace=fcount++; 
    }
  }
}

@ We know that |c| has exactly one true literal at this moment.

@<Decrease the breakcount of |c|'s critical variable@>=
{
  for (o,i=cmem[c].start;;i++) {
    o,q=mem[i];
    if (o,value(q)) break;
  }
  o,vmem[q>>1].breakcount--;
}

@ As an experiment, I'm swapping the first true literal into the first
position of its clause, hoping that subsequent ``decrease'' loops will
thereby be shortened.

@<Increase the breakcount of |c|'s critical variable@>=
{
  for (o,ii=i=cmem[c].start;;i++) {
    o,q=mem[i];
    if (o,value(q)) break;
  }
  o,vmem[q>>1].breakcount++;
  if (i!=ii) oo,mem[i]=mem[ii],mem[ii]=q;
}

@ @<Print the initial guess@>=
{
  fprintf(stderr," initial guess");
  for (k=0;k<vars;k++)
    fprintf(stderr," %s%.8s",vmem[k].val?"":"~",nmem[k].ch8);
  fprintf(stderr,"\n");
}

@ @<Print a solution and |goto done|@>=
{
  for (k=0;k<vars;k++)
    printf(" %s%.8s",vmem[k].val?"":"~",nmem[k].ch8);
  printf("\n");
  if (verbose&show_basics) fprintf(stderr,"!SAT!\n");
  goto done;
}

@*Index.
