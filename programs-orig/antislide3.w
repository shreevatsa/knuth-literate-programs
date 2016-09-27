\datethis
@*Antisliding blocks. This program illustrates techniques of finding all
nonequivalent solutions to an exact cover problem. I wrote it after returning
from Japan in November, 1996, because Nob was particularly interested in the
answers. (Two years ago I had written a similar program, which however did not
remove inequivalent solutions; in 1994 I removed them by hand after generating
all possible solutions.)

The general question is to pack $2\times2\times1$ blocks into an $l\times
m\times n$ array in such a way that the blocks cannot slide. This means that
there should be at least one occupied cell touching each of the six faces of
the block; cells outside the array are always considered to be occupied.
For example, one such solution when $l=m=n=3$ is
\def\layer#1{\vbox{\tt\let\\=\cr\halign{&\kern3pt##\kern3pt\cr#1\crcr}}}
$$\layer{1&1&.\\1&1&2\\3&3&2}\qquad
  \layer{5&4&4\\5&.&2\\3&3&2}\qquad
  \layer{5&4&4\\5&6&6\\.&6&6}.$$
But
$$\layer{1&1&2\\1&1&2\\3&3&.}\qquad
  \layer{4&4&2\\.&.&2\\3&3&.}\qquad
  \layer{4&4&.\\.&5&5\\.&5&5}$$
is not a solution, because blocks \.2, \.3, and \.5 can slide.

Two solutions are considered to be the same if they are isomorphic---that is,
if there's a symmetry that takes one into the other. In this sense the
solution
$$\layer{1&1&.\\2&3&3\\2&3&3}\qquad
  \layer{1&1&4\\2&.&4\\2&5&5}\qquad
  \layer{6&6&4\\6&6&4\\.&5&5}$$
is no different from the first solution given above. Up to 48 symmetries are
possible, obtained by permuting and complementing the coordinates in
three-dimensional space. It turns out that the $3\times3\times3$ case has only
one solution, besides the trivial case in which no blocks at all are present.

Before writing this program I tried to find highly symmetric solutions to the
$4\times4\times4$ problem without using a computer. I found
a beautiful 12-block solution
$$\layer{.&1&1&.\\2&1&1&3\\2&4&4&3\\.&4&4&.}\qquad
  \layer{5&5&6&6\\2&.&.&3\\2&.&.&3\\7&7&8&8}\qquad
  \layer{5&5&6&6\\9&.&.&A\\9&.&.&A\\7&7&8&8}\qquad
  \layer{.&B&B&.\\9&B&B&A\\9&C&C&A\\.&C&C&.}$$
which has 24 symmetries and
leaves the center cells and corner cells empty. But I saw no easy way to
prove that an antisliding arrangement with fewer than 12 blocks is possible.
This experience whetted my curiosity and got me ``hooked'' on the problem,
so I couldn't resist writing this program even though I have many other
urgent things to do. I'm considering it the final phase of my exciting visit
to Japan. (I apologize for not having time to refine it further.)

Note: The program assumes that $l=m$ if any two of the dimensions are equal.
Then the number of symmetries is 8 if $l\ne m$, or 16 if $l=m\ne n$, or
48 if $l=m=n$.

@d ll 4 /* the first dimension */
@d mm 4 /* the second dimension */
@d nn 4 /* the third */
@d ss 48 /* the number of symmetries */

@c
#include <stdio.h>

@<Type definitions@>@;
@<Global variables@>@;
@<Subroutines@>@;
@#
main(argc,argv)
  int argc;
  char *argv[];
{
  @<Local variables@>;
  if (argc>1) {
    verbose=argc-1; /* set |verbose| to the number of command-line arguments */
    sscanf(argv[1],"%d",&spacing);
  }
  @<Set up data structures for antisliding blocks@>;
  @<Backtrack through all solutions@>;
  @<Make redundancy checks to see if the backtracking was consistent@>;
  printf("Altogether %d solutions.\n",count);
  if (verbose) @<Print a profile of the search tree@>;
}

@ @<Global...@>=
int verbose=0; /* $>0$ to show solutions, $>1$ to show partial ones too */
int count=0; /* number of antisliding solutions found so far */
int spacing=1; /* if |verbose|, we output solutions when |count%spacing==0| */
int profile[ll*mm*nn+1], prof_syms[ll*mm*nn+1],
 prof_cons[ll*mm*nn+1], prof_frcs[ll*mm*nn+1]; /* statistics */

@*Data structures. An exact cover problem is defined by a matrix $M$ of 0s
and~1s. The goal is to find a set of rows containing exactly one~1 in each
column.

In our case the rows stand for possible placements of blocks; the
columns stand for cells of the $l\times m\times n$ array. There are
$l(m-1)(n-1)+(l-1)m(n-1)+(l-1)(m-1)n$ rows for placements of $2\times2\times1$
blocks and an additional $lmn$ rows for $1\times1\times1$ blocks that
correspond to unoccupied cells.

The heart of this program is its data structure for the matrix $M$. There is
one node for each 1 in~$M$, and the 1s of each row are cyclically linked via
|left| and |right| fields. Each node also contains an array of pointers
|sym[0]|, |sym[1]|, \dots, which point to the nodes that are equivalent under
each symmetry of the problem. Furthermore, the nodes for 1s in each column are
doubly linked together by |up| and |down| fields.

Although the pointers are called |left|, |right|, |up|, and |down|, the row
lists and column lists need not actually be linked together in any particular
order. The row lists remain unchanged, but the column lists will change
dynamically because we will implicitly remove rows from $M$ that contain 1s in
columns that are already covered as we are constructing a solution.

@s row_struct int
@s col_struct int

@<Type def...@>=
typedef struct node_struct {
  struct node_struct *left,*right; /* predecessor and successor in row */
  struct node_struct *up,*down; /* predecessor and successor in column */
  struct node_struct *sym[ss]; /* symmetric equivalents */
  struct row_struct *row; /* the row containing this node */
  struct col_struct *col; /* the column containing this node */
} node;

@ Each column corresponds to a cell of the array. Special information for
each cell is stored in an appropriate record, which points to the
$1\times1\times1$ block node for that cell (also called the cell head).
We maintain a doubly linked list of the
cells that still need to be covered, using |next| and |prev| fields;
also a count of the number of ways that remain to cover a given cell.
A few other items are maintained to facilitate the bookkeeping.

@<Type def...@>=
typedef struct col_struct {
  node head; /* the empty option for this cell */
  int len; /* the number of options for covering it */
  int init_len; /* initial value of |len|, for redundancy check */
  struct col_struct *prev,*next; /* still-to-be-covered neighbors */
  node *filled; /* node by which this column was filled */
  int empty;
   /* is this cell covered by the empty ($1\times1\times1$) option? */
  int nonempty; /* is this cell known to be nonempty? */
  char name[4]; /* coordinates of this cell, as a string for printing */
  struct col_struct *invsym[ss]; /* reverse pointers to |sym| in |head| */
} cell;

@ One |cell| struct is called the root. It serves as the head of the
list of columns that need to be covered, and is identifiable by the fact
that its |name| is empty.

@<Glob...@>=
cell root; /* gateway to the unsettled columns */

@ The rows of $M$ also have special data structures:
We need to know which sets of two or four cells are neighbors of the
faces of a block. These are listed in the option records,
followed by null pointers.

@<Type def...@>=
typedef struct row_struct {
  cell *neighbor[22]; /* sets of cells that shouldn't all be empty */
  int neighbor_ptr; /* size of the |neighbor| info */
} option;

@* Initialization. Like most table-driven programs, this one needs to
construct its tables, using a rather long and boring routine. In compensation,
we will be able to avoid tedious details in the rest of the code.

@<Glob...@>=
cell cells[ll][mm][nn]; /* columns of the matrix */
option opt[ll][mm][nn],
 optx[ll][mm-1][nn-1],opty[ll-1][mm][nn-1],optz[ll-1][mm-1][nn]; /* rows */
node blockx[ll][mm-1][nn-1][4],blocky[ll-1][mm][nn-1][4],
 blockz[ll-1][mm-1][nn][4]; /* nodes */

@ @<Set up data structures for antisliding blocks@>=
@<Set up the cells@>;
@<Set up the options@>;
@<Set up the nodes@>;

@ @<Set up the cells@>=
q=&root;
for (i=0;i<ll;i++) for (j=0;j<mm;j++) for (k=0;k<nn;k++) {
  c=&cells[i][j][k]; q->next=c; c->prev=q; q=c; p=&(c->head);
  p->left=p->right=p->up=p->down=p;
  p->row=&opt[i][j][k]; p->col=c;
  @<Fill in the symmetry pointers of |c|@>;
  c->name[0]=i+'0'; c->name[1]=j+'0'; c->name[2]=k+'0';
  c->len=1;
}
q->next=&root; root.prev=q;

@ @<Fill in the symmetry pointers of |c|@>=
for (s=0;s<ss;s++) {
  switch (s>>3) {
   case 0: ii=i; jj=j; kk=k; break;
   case 1: ii=j; jj=i; kk=k; break;
   case 2: ii=k; jj=j; kk=i; break;
   case 3: ii=i; jj=k; kk=j; break;
   case 4: ii=j; jj=k; kk=i; break;
   case 5: ii=k; jj=i; kk=j; break;
  }
  if (s&4) ii=ll-1-ii;
  if (s&2) jj=mm-1-jj;
  if (s&1) kk=nn-1-kk;
  p->sym[s]=&(cells[ii][jj][kk].head);
  cells[ii][jj][kk].invsym[s]=c;
}

@ @<Set up the options@>=
@<Set up the |optx| options@>;
@<Set up the |opty| options@>;
@<Set up the |optz| options@>;

@ @d ox(j1,k1,j2,k2) { optx[i][j][k].neighbor[kk++]=&cells[i][j1][k1];
                       optx[i][j][k].neighbor[kk++]=&cells[i][j2][k2];
                       optx[i][j][k].neighbor[kk++]=NULL; }
@d oxx(i1) {optx[i][j][k].neighbor[kk++]=&cells[i1][j][k];
            optx[i][j][k].neighbor[kk++]=&cells[i1][j][k+1];
            optx[i][j][k].neighbor[kk++]=&cells[i1][j+1][k];
            optx[i][j][k].neighbor[kk++]=&cells[i1][j+1][k+1];
            optx[i][j][k].neighbor[kk++]=NULL; }

@<Set up the |optx| options@>=
for (i=0;i<ll;i++) for (j=0;j<mm-1;j++) for (k=0;k<nn-1;k++) {
  kk=0;
  if (j) ox(j-1,k,j-1,k+1);
  if (j<mm-2) ox(j+2,k,j+2,k+1);
  if (k) ox(j,k-1,j+1,k-1);
  if (k<nn-2) ox(j,k+2,j+1,k+2);
  if (i) oxx(i-1);
  if (i<ll-1) oxx(i+1);
  optx[i][j][k].neighbor_ptr=kk;
}

@ @d oy(i1,k1,i2,k2) { opty[i][j][k].neighbor[kk++]=&cells[i1][j][k1];
                       opty[i][j][k].neighbor[kk++]=&cells[i2][j][k2];
                       opty[i][j][k].neighbor[kk++]=NULL; }
@d oyy(j1) {opty[i][j][k].neighbor[kk++]=&cells[i][j1][k];
            opty[i][j][k].neighbor[kk++]=&cells[i][j1][k+1];
            opty[i][j][k].neighbor[kk++]=&cells[i+1][j1][k];
            opty[i][j][k].neighbor[kk++]=&cells[i+1][j1][k+1];
            opty[i][j][k].neighbor[kk++]=NULL; }

@<Set up the |opty| options@>=
for (i=0;i<ll-1;i++) for (j=0;j<mm;j++) for (k=0;k<nn-1;k++) {
  kk=0;
  if (i) oy(i-1,k,i-1,k+1);
  if (i<ll-2) oy(i+2,k,i+2,k+1);
  if (k) oy(i,k-1,i+1,k-1);
  if (k<nn-2) oy(i,k+2,i+1,k+2);
  if (j) oyy(j-1);
  if (j<mm-1) oyy(j+1);
  opty[i][j][k].neighbor_ptr=kk;
}

@ @d oz(i1,j1,i2,j2) { optz[i][j][k].neighbor[kk++]=&cells[i1][j1][k];
                       optz[i][j][k].neighbor[kk++]=&cells[i2][j2][k];
                       optz[i][j][k].neighbor[kk++]=NULL; }
@d ozz(k1) {optz[i][j][k].neighbor[kk++]=&cells[i][j][k1];
            optz[i][j][k].neighbor[kk++]=&cells[i][j+1][k1];
            optz[i][j][k].neighbor[kk++]=&cells[i+1][j][k1];
            optz[i][j][k].neighbor[kk++]=&cells[i+1][j+1][k1];
            optz[i][j][k].neighbor[kk++]=NULL; }

@<Set up the |optz| options@>=
for (i=0;i<ll-1;i++) for (j=0;j<mm-1;j++) for (k=0;k<nn;k++) {
  kk=0;
  if (i) oz(i-1,j,i-1,j+1);
  if (i<ll-2) oz(i+2,j,i+2,j+1);
  if (j) oz(i,j-1,i+1,j-1);
  if (j<mm-2) oz(i,j+2,i+1,j+2);
  if (k) ozz(k-1);
  if (k<nn-1) ozz(k+1);
  optz[i][j][k].neighbor_ptr=kk;
}

@ @<Set up the nodes@>=
@<Set up the |blockx| nodes@>;
@<Set up the |blocky| nodes@>;
@<Set up the |blockz| nodes@>;

@ @<Set up the |blockx| nodes@>=
for (i=0;i<ll;i++) for (j=0;j<mm-1;j++) for (k=0;k<nn-1;k++) {
  for (t=0; t<4; t++) {
    p=&blockx[i][j][k][t];
    p->right=&blockx[i][j][k][(t+1)&3];
    p->left=&blockx[i][j][k][(t+3)&3];
    c=&cells[i][j+((t&2)>>1)][k+(t&1)];
    pp=c->head.up;
    pp->down=c->head.up=p; p->up=pp; p->down=&(c->head);
    p->row=&optx[i][j][k];
    p->col=c; c->len++;
  }
  make_syms(blockx[i][j][k]);
}

@ @<Set up the |blocky| nodes@>=
for (i=0;i<ll-1;i++) for (j=0;j<mm;j++) for (k=0;k<nn-1;k++) {
  for (t=0; t<4; t++) {
    p=&blocky[i][j][k][t];
    p->right=&blocky[i][j][k][(t+1)&3];
    p->left=&blocky[i][j][k][(t+3)&3];
    c=&cells[i+((t&2)>>1)][j][k+(t&1)];
    pp=c->head.up;
    pp->down=c->head.up=p; p->up=pp; p->down=&(c->head);
    p->row=&opty[i][j][k];
    p->col=c; c->len++;
  }
  make_syms(blocky[i][j][k]);
}

@ @<Set up the |blockz| nodes@>=
for (i=0;i<ll-1;i++) for (j=0;j<mm-1;j++) for (k=0;k<nn;k++) {
  for (t=0; t<4; t++) {
    p=&blockz[i][j][k][t];
    p->right=&blockz[i][j][k][(t+1)&3];
    p->left=&blockz[i][j][k][(t+3)&3];
    c=&cells[i+((t&2)>>1)][j+(t&1)][k];
    pp=c->head.up;
    pp->down=c->head.up=p; p->up=pp; p->down=&(c->head);
    p->row=&optz[i][j][k];
    p->col=c; c->len++;
  }
  make_syms(blockz[i][j][k]);
}

@ @<Sub...@>=
make_syms(pp)
  node pp[];
{
  register char *q;
  register int s,t,imax,imin,jmax,jmin,kmax,kmin,i,j,k;
  for (s=0;s<ss;s++) {
    imax=jmax=kmax=-1; imin=jmin=kmin=1000;
    for (t=0;t<4;t++) {
      q=pp[t].col->head.sym[s]->col->name; i=q[0]-'0'; j=q[1]-'0'; k=q[2]-'0';
      if (i<imin) imin=i; if (i>imax) imax=i;
      if (j<jmin) jmin=j; if (j>jmax) jmax=j;
      if (k<kmin) kmin=k; if (k>kmax) kmax=k;
    }
    if (imin==imax) @<Map to |blockx| nodes@>@;
    else if (jmin==jmax) @<Map to |blocky| nodes@>@;
    else @<Map to |blockz| nodes@>;
  }
}

@ @<Map to |blockx| nodes@>=
for (t=0;t<4;t++) {
  q=pp[t].col->head.sym[s]->col->name; i=q[0]-'0'; j=q[1]-'0'; k=q[2]-'0';
  pp[t].sym[s]=&blockx[i][jmin][kmin][(j-jmin)*2+k-kmin];
}

@ @<Map to |blocky| nodes@>=
for (t=0;t<4;t++) {
  q=pp[t].col->head.sym[s]->col->name; i=q[0]-'0'; j=q[1]-'0'; k=q[2]-'0';
  pp[t].sym[s]=&blocky[imin][j][kmin][(i-imin)*2+k-kmin];
}

@ @<Map to |blockz| nodes@>=
for (t=0;t<4;t++) {
  q=pp[t].col->head.sym[s]->col->name; i=q[0]-'0'; j=q[1]-'0'; k=q[2]-'0';
  pp[t].sym[s]=&blockz[imin][jmin][k][(i-imin)*2+j-jmin];
}

@* Backtracking and isomorph rejection.
The basic operation of this program is a backtrack 
search, which repeatedly finds an uncovered cell and tries to cover it in
all possible ways. We save lots of work if we always choose a cell that has the
fewest remaining options. The program considers each of those options in turn;
a given option covers certain cells and removes all other options that
cover those cells. We must backtrack if we run out of options for any
uncovered cell.

The solutions are sequences $a_1\,a_2\ldots a_l$, where each $a_k$ is a node.
Node $a_k$ belongs to column~$c_k$, the cell chosen for covering at level~$k$,
and to row~$r_k$, the option chosen for covering that cell.

With 48 symmetries we can reduce the number of cases considered by a factor of
up to 48 if we spend a bit more time on each case, by being careful to weed
out solutions that are isomorphic to others that have been or will be found.
If $a_1\,a_2\ldots a_l$ is a solution that defines a covering~$C$,
and if $\sigma$ is a symmetry of the problem,
the nodes $\sigma a_1$, $\sigma a_2$, \dots,~$\sigma a_l$ define a covering
$\sigma C$ that is isomorphic to~$C$. For each $k$ in the range $1\le k\le l$,
let $a'_k$ be the node for which $\sigma a'_k$ is the node that covers
$\sigma c_k$ in~$\sigma C$. We will consider only solutions such that
$a'_1\,a'_2\ldots a'_l$ is lexicographically less than or equal to
$a_1\,a_2\ldots a_l$; this will guarantee that we obtain exactly one solution
from every equivalence class of isomorphic coverings. (Notice that the number
of symmetries of a given solution $a_1\,a_2\ldots a_l$ is the number of
$\sigma$ for which we have $a'_1\,a'_2\ldots a'_l=a_1\,a_2\ldots a_l$.)

If $a_l\,a_2\ldots a_l$ is a partial solution and $\sigma$ is any symmetry, we
can compute $a'_1\,a'_2\ldots a'_j$ where $j$ is the smallest subscript
such that $\sigma c_{j+1}$ has not yet been covered. The partial solution
$a_l\,a_2\ldots a_l$ can be rejected if $a'_1\,a'_2\ldots a'_j$ is
lexicographically less than $a_1\,a_2\ldots a_j$. The symmetry $\sigma$
need not be monitored in extensions of $a_l\,a_2\ldots a_l$ to higher levels
if $a'_1\,a'_2\ldots a'_j$ is lexicographically greater than $a_1\,a_2\ldots
a_j$. We keep a list at level~$l$ of all $(\sigma,j)$ for which $a'_1\,
a'_2\ldots a'_j=a_1\,a_2\ldots a_j$, where $j$ is defined as above; this
is called the {\it symcheck list}. The symcheck list is the key to
isomorph rejection.

We also maintain a list of constraints: Sets of uncovered cells that must not
all be empty; these constraints ensure an antisliding solution.

@<Glob...@>=
int symcheck_sig[(ll*mm*nn+1)*(ss-1)],
 symcheck_j[(ll*mm*nn+1)*(ss-1)]; /* symcheck list elements */
int symcheck_ptr[ll*mm*nn+2]; /* beginning of symcheck list on each level */
cell *constraint[ll*mm*nn*22]; /* sets of cells that shouldn't all be empty */
int constraint_ptr[ll*mm*nn+2]; /* beginning of constraint list on each level */
cell *force[ll*mm*nn]; /* list of cells forced to be nonempty */
int force_ptr[ll*mm*nn+1]; /* beginning of force records on each level */
cell *best_cell[ll*mm*nn+1]; /* cell chosen for covering on each level */
node *move[ll*mm*nn+1]; /* the nodes $a_k$ on each level */

@ @<Local...@>=
register int i,j,k,s; /* miscellaneous indices */
register int l; /* the current level */
register cell *c; /* the cell being covered on the current level */
register node *p; /* the current node of interest */
register cell *q; /* the current cell of interest */
register option *r; /* the current option of interest */
int ii,jj,kk,t;
node *pp;

@ As usual, I'm using labels and |goto| statements as I backtrack,
and making only a half-hearted apology for my outrageous style.

@<Backtrack through all solutions@>=
@<Initialize for level 0@>;
l=1;@+goto choose;
advance: @<Remove options that cover cells other than |best_cell[l]|@>;
if (verbose) @<Handle diagnostic info@>;
l++;
choose: @<Choose the moves at level |l|@>;
backup: l--;
if (l==0) goto done;
@<Unremove options that cover cells other than |best_cell[l]|@>;
goto unmark; /* reconsider the move on level |l| */
solution: @<Record a solution@>; goto backup;
done:

@ The usual trick in backtracking is to update the data structures in such a
way that we can faithfully downdate them as we back up. The harder cases,
namely the symcheck list and the constraint list, are explicitly recomputed on
each level so that downdating is unnecessary. The |force_ptr| array is used to
remember where forcing moves need to be downdating.

@s try x

@<Choose the moves at level |l|@>=
@<Select |c=best_cell[l]|, or |goto solution| if all cells are covered@>;
force_ptr[l]=force_ptr[l-1];
cover(c); /* remove options that cover |best_cell[l]| */
c->empty=1;
@<Set $a_l$ to the empty option of |c|;
 |goto try_again| if that option isn't allowed@>;
try: @<Mark the newly covered elements@>;
@<Compute the new constraint list; |goto unmark| if previous choices are
 disallowed@>;
@<Compute the new symcheck list; |goto unmark| if $a_1\,a_2\ldots a_l$ is
 rejected@>; 
goto advance;
unmark: @<Unmark the newly covered elements@>;
@<Delete the new forcing table entries@>;
try_again: move[l]=move[l]->up; best_cell[l]->empty=0;
if (move[l]->right!=move[l]) goto try; /* $a_l$ not the empty option */
c=best_cell[l];
uncover(c);

@ Here's a subroutine that removes all options that cover cell~|c| from all
cell lists except list~|c|.

@<Sub...@>=
cover(c)
  cell *c;
{@+register cell *l,*r;
  register node *rr,*pp,*uu,*dd;
  l=c->prev;@+r=c->next;
  l->next=r;@+r->prev=l;
  for (rr=c->head.down;rr!=&(c->head);rr=rr->down)
    for (pp=rr->right;pp!=rr;pp=pp->right) {
      uu=pp->up;@+dd=pp->down;
      uu->down=dd;@+dd->up=uu;
      pp->col->len--;
    }
}

@ Uncovering is done in precisely the reverse order. The pointers thereby
execute an exquisitely choreo\-graphed dance, which returns them almost
magically to their former state---because the old pointers still exist!
(I think this technique was invented in Japan.)

@<Subroutines@>=
uncover(c)
  cell *c;
{@+register cell *l,*r;
  register node *rr,*pp,*uu,*dd;
  for (rr=c->head.up;rr!=&(c->head);rr=rr->up)
    for (pp=rr->left;pp!=rr;pp=pp->left) {
      uu=pp->up;@+dd=pp->down;
      uu->down=dd->up=pp;
      pp->col->len++;
    }
  l=c->prev;@+r=c->next;
  l->next=r->prev=c;
}

@ @<Remove options that cover cells other than |best_cell[l]|@>=
for (p=move[l]->right;p!=move[l];p=p->right) cover(p->col);

@ @<Unremove options that cover cells other than |best_cell[l]|@>=
for (p=move[l]->left;p!=move[l];p=p->left) uncover(p->col);

@ @<Select |c=best_cell[l]|, or |goto solution| if all cells are covered@>=
q=root.next;
if (q==&root) goto solution;
for (c=q,j=q->len,q=q->next;q!=&root;q=q->next)
  if (q->len<j) c=q,j=q->len;
best_cell[l]=c;

@ @<Mark the newly covered elements@>=
for (p=move[l]->right;p!=move[l];p=p->right) {
  p->col->filled=p;
  p->col->nonempty++;
}
p->col->filled=p;
if (p->right!=p) p->col->nonempty++;

@ @<Unmark the newly covered elements@>=
for (p=move[l]->left;p!=move[l];p=p->left) {
  p->col->filled=NULL;
  p->col->nonempty--;
}
p->col->filled=NULL;
if (p->right!=p) p->col->nonempty--;

@ @<Compute the new constraint list; |goto unmark| if previous choices are
 disallowed@>=
j=constraint_ptr[l-1]; k=constraint_ptr[l];
if (p->right==p) @<Delete current cell from the constraint list, possibly
     forcing other cells to be nonempty@>@;
else {
  @<Add new constraints; |goto unmark| if previous choices are disallowed@>;
  @<Copy former constraints that are still unsatisfied@>;
}
constraint_ptr[l+1]=k;

@ @<Delete current cell from the constraint list, possibly
forcing other cells to be nonempty@>=
{
  c=p->col;
  while (j<constraint_ptr[l]) {
    kk=k;
    while ((q=constraint[j])) {
      if (q!=c) constraint[k++]=q;
      j++;
    }
    j++;
    if (k==kk+1) @<Force |constraint[kk]| to be nonempty@>@;
    else constraint[k++]=NULL;
  }
}

@ @<Force |constraint[kk]| to be nonempty@>=
{
  k=kk;
  q=constraint[k];
  if (!q->nonempty) {
    q->nonempty=1; q->len--; force[force_ptr[l]++]=q;
  }
}

@ @<Add new constraints; |goto unmark| if previous choices are disallowed@>=
r=p->row;
for (i=0;i<r->neighbor_ptr; i++) {
  kk=k;
  while ((q=r->neighbor[i])) {
    if (q->nonempty) { /* constraint is satisfied */
      do@+i++;@+while (r->neighbor[i]);
      goto no_problem;
    } else if (!q->empty) constraint[k++]=q;
    i++;
  }
  if (k>kk+1) {
    constraint[k++]=NULL;
    continue;
  }
  if (k==kk) goto unmark; /* all were covered by empty cells */
  q=constraint[kk]; q->nonempty=1; q->len--; force[force_ptr[l]++]=q;
no_problem: k=kk;
}

@ @<Copy former constraints that are still unsatisfied@>=
while (j<constraint_ptr[l]) {
  kk=k;
  while ((q=constraint[j])) {
    if (q->nonempty) goto flush; /* constraint is satisfied */
    constraint[k++]=q;
    j++;
  }
  constraint[k++]=NULL;
  j++; continue;
flush: do@+j++;@+while (constraint[j]);
  k=kk; j++;
}

@ @<Delete the new forcing table entries@>=
while (force_ptr[l]!=force_ptr[l-1]) {
  q=force[--force_ptr[l]];
  q->len++;
  q->nonempty=0;
}

@ @<Compute the new symcheck list; |goto unmark| if $a_1\,a_2\ldots a_l$ is
rejected@>=
for (k=symcheck_ptr[l-1],kk=symcheck_ptr[l]; k<symcheck_ptr[l]; k++) {
  for (i=symcheck_sig[k],j=symcheck_j[k]+1;j<=l;j++) {
    c=best_cell[j]->invsym[i]; /* $\sigma c_i$ */
    if (!c->filled) break;
    p=c->filled->sym[i]; /* $a'_i$ */
    if (p<move[j]) goto unmark;
    if (p>move[j]) goto okay;
  }
  symcheck_sig[kk]=i; symcheck_j[kk]=j-1; kk++;
okay:;
}
symcheck_ptr[l+1]=kk;

@ @<Set $a_l$ to the empty option of |c|;
 |goto try_again| if that option isn't allowed@>=
move[l]=&(c->head);
if (c->nonempty) goto try_again;

@ @<Record a solution@>=
count++;
if (verbose) {
  if (count%spacing==0) {
    printf("%d: ",count);
    for (j=1; j<l; j++) print_move(move[j]);
    if (symcheck_ptr[l]==symcheck_ptr[l-1])
      printf("(1 sym, %d blks)\n",(ll*mm*nn+1-l)/3);
    else printf("(%d syms, %d blks)\n",
       symcheck_ptr[l]-symcheck_ptr[l-1]+1,
       (ll*mm*nn+1-l)/3);
  }
}

@ @<Sub...@>=
print_move(p)
  node *p;
{
  register node *q;
  for (q=p->right;q!=p;q=q->right) printf("%s-",q->col->name);
  printf("%s ",q->col->name);
}

@ @<Handle diagnostic info@>=
{
  profile[l]++;
  prof_syms[l]+=symcheck_ptr[l+1]-symcheck_ptr[l]+1;
  prof_cons[l]+=constraint_ptr[l+1]-constraint_ptr[l];
  prof_frcs[l]+=force_ptr[l]-force_ptr[l-1];
  if (verbose>1) {
    printf("Level %d, ",l);
    print_move(move[l]);
    printf("(%d,%d,%d)\n",
      symcheck_ptr[l+1]-symcheck_ptr[l]+1,
      constraint_ptr[l+1]-constraint_ptr[l],
      force_ptr[l]-force_ptr[l-1]);
  }
}

@ @<Print a profile of the search tree@>=
{
  for (j=1;j<=ll*mm*nn;j++)
    printf(" Level %d: %d sols, %#.1f syms, %#.1f cons, %#.1f frcs\n",
      j,profile[j],
      (double)prof_syms[j]/(double)profile[j],
      (double)prof_cons[j]/(double)profile[j],
      (double)prof_frcs[j]/(double)profile[j]);
}

@ @<Initialize for level 0@>=
for (i=0;i<ll;i++) for (j=0;j<mm;j++) for (k=0;k<nn;k++) {
  c=&cells[i][j][k];
  c->init_len=c->len;
}
for (k=0;k<ss;k++) symcheck_sig[k]=k+1;
symcheck_ptr[1]=ss-1;

@ @<Make redundancy checks to see if the backtracking was consistent@>=
q=&root;
for (i=0;i<ll;i++) for (j=0;j<mm;j++) for (k=0;k<nn;k++) {
  c=&cells[i][j][k];
  if (c->nonempty || c->len!=c->init_len || c->prev!=q || q->next!=c)
    printf("Trouble at cell %s!\n", c->name);
  q=c;
}

@*Index.
