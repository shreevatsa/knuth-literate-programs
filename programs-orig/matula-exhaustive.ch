@x
The trees are given on the command line, each as a string of
``parent pointers'';
this string has one character per node. The first character is always
`\..', standing for the (nonexistent) parent of the root; the next character is
always `\.0', standing for the parent of node~1; and the $(k+1)$st character
stands for the parent of node~$k$, which can be any number less than~$k$.
Numbers larger than~\.9 are encoded by lowercase letters;
numbers larger than~\.z (which represents 35) are encoded by uppercase letters.
Numbers larger than~\.Z (which represents 61) are presently
disallowed; but some day I'll make another version of this program, with
different conventions for the input.

The root of $S$ is assumed to have degree~1. Thus it is actually both a
root and a leaf, and the string for~$S$ will have only one occurrence of~\.0.

For example, here are some trees used in an early test:
$$\eqalign{S&=\.{.0111444759a488cfch};\cr
T&=\.{.011345676965cc5ffh5cklfn55qjstuuwxxwwuCCuFCpppqrtGOHJRLMNO};\cr}$$
can you find $S$ within $T$?
$$S=\vcenter{\epsfbox{matula.S}}\,;\qquad
  T=\vcenter{\epsfbox{matula.T}}\,.$$
@y
This version of the program tries every pair of free trees $S$ and $T$,
where $S$ has $m$ nodes and $T$ has $n$ nodes. (I hacked it by modifying the
tree-generation routine of {\mc GRACEFUL-TREES}.)
@z
@x
@d maxn 62 /* could be greatly increased if I had another input convention */
@y
@d maxn 16 /* could be increased if desired, but probably not by much */
@d maxtrees 32768 /* there are 32508 free trees of size $\le16$ */
@d maxmtrees 128 /* there are 115 oriented trees of size 7 */
@d maxindex maxtrees+maxmtrees*maxmtrees
@z
@x
unsigned long long mems; /* memory references */
@y
#include <math.h>
int mm,nn; /* command-line parameters */
unsigned long long mems; /* memory references */
@z
@x
  register int d,e,g,i,j,k,m,n,p,q,r,s,v,z;
  @<Process the command line@>;
  imems=mems,mems=0;
  if (m>n)  fprintf(stderr,"There's no solution, because m>n!\n");
  else { 
    @<Solve the problem@>;
    @<Report the solution@>;
  }
  fprintf(stderr,"Altogether %lld+%lld mems.\n",
                           imems,mems);
@y
  register int d,e,g,i,j,k,m,n,p,q,r,s,v,z;
  @<Process the command line@>;
  @<Build a trie for locating all |m|-vertex free trees@>;
  @<Build a trie for locating all |n|-vertex free trees@>;
  imems=mems,mems=0;
  @<Set up $S$, the first $m$-node tree@>;
  while (1) {
    @<Set up $T$, the first $n$-node tree@>;
    while (1) {
      startmems=mems;
      @<Solve the problem@>;
      @<Record the solution@>;
      @<Change $T$ to the next $n$-node tree, or |break|@>;
    }
    @<Change $S$ to the next $m$-node tree, or |break|@>;
  }
  @<Sign off@>;
@z
@x
@ @<Process the command line@>=
if (argc!=3) {
  fprintf(stderr,"Usage: %s S_parents T_parents\n",
              argv[0]);
  exit(-1);
}
@<Input the tree $S$@>;
@<Input the tree $T$@>;

@*Data structures for the trees.
@y
@ @<Process the command line@>=
if (argc!=3 || sscanf(argv[1],"%d",
                   &mm)!=1 || sscanf(argv[2],"%d",
                   &nn)!=1) {
  fprintf(stderr,"Usage: %s m n\n",
              argv[0]);
  exit(-1);
}
if (mm<3 || mm>nn || nn>maxn) {
  fprintf(stderr,"Sorry, I'm configured to handle only 2 < m <= n <= %d.\n",
                                             maxn);
  exit(-2);
}
m=mm,n=nn;

@*The trie of all free trees.
Let $m=\lfloor(n-1)/2\rfloor$. According to the theory in exercise
7.2.1.6--90 of {\sl The Art of Computer Programming}, every free tree
on $n$ vertices is either centroidal or bicentroidal: It either has a unique
centroid, in which case the other vertices form an oriented forest,
having no trees of size $>m$; or it has two centroids, in which case
the children of each centroid form oriented forests of size~$m$.
The bicentroidal case occurs only when $n$ is even.

We shall construct a table of all oriented forests of size $<n$, containing
no tree of size $>m$. Each $t$-node oriented forest is represented by its
canonical level sequence $c_1\ldots c_t$, where $c_k$ is the depth
of the $k$th node in preorder, for $1\le k\le t$. The sequence is canonical
if the substrings for sibling subtrees in each family appear in
nonincreasing lexicographic order.

Say that $c_1\ldots c_t$ is {\it legal\/} if it is canonical for an
oriented forest with no tree of size $>m$. For example, suppose $m=4$.
The sequence 02010101 is illegal because it isn't a level sequence.
(In a level sequence we always have $c_{k+1}\le c_k+1$.)
The sequence 01110120 is illegal because it's not canonical ($0111<012$).
The sequence 01201111 is illegal because 01111 is a tree of size~5.
The sequence 01201120 is illegal because it's not canonical ($1<12$).
The sequence 01201110 is legal, and so is 012012010.
Our job is to tabulate every legal $c_1\ldots c_t$ with $t<n$.

We shall generate the legal sequences for $t=1$, then $t=2$, \dots,
then $t=n-1$.
And for fixed~$t$, we'll generate them in decreasing lexicographic order,
as in exercise 7.2.1.6--90, starting with the largest --- which consists of
the first $t$ elements of the cyclic sequence
$012\ldots(m{-}1)012\ldots(m{-}1)0\ldots\,$.

If $c_1\ldots c_t$ is legal, so is its prefix $c_1\ldots c_{t-1}$,
assuming that $t>1$. So also is its lexicographic predecessor
$c_1\ldots c_{t-1}(c_t{-}1)$, assuming that $c_t>0$. Thus the
legal sequences form a trie.

We shall build a trie data structure with two arrays, called
|c| and |up|. If $k$ represents $c_1\ldots c_t$ then
$c[k]=c_t$;
|up[k]| represents $c_1\ldots c_{t-1}$; and
$k+1$ represents $c_1\ldots c_{t-1}(c_t{-}1)$, if $c_t>0$.

This program also computes the associated sequence of {\it parent\/}
pointers, $p_1\ldots p_t$, by adding a third array called |np|, where
$|np|[k]=p_t$ when $k$ represents $c_1\ldots c_t$. For example,
the parent pointers that correspond to 012110121010 are 012110454070.

@<Glob...@>=
void make_sstring(int k); void make_tstring(int k);
char sstring[maxn+1]=".",tstring[maxn+1]=".";
int up[maxtrees]; /* parent in trie */
int down[maxtrees]; /* leftmost child in trie */
int c[maxtrees]; /* $c_t$ coordinate in trie */
int np[maxtrees]; /* $p_t$ coordinate in trie */
int ptr; /* the first unused entry of |up|, |c|, and |np| */
int cc[maxn]; /* the current level sequence */
int pp[maxn]; /* the current parent sequence */
int start[maxn]; /* where forests of each size begin */

@ When |maketrie(n)| is done, |start[t]| will be the number of
forests of size~|<t| that contain
no tree of size exceeding $\lfloor(n-1)/2\rfloor$, for $1\le t\le n$.

(This program assumes that |n>2|.)

@<Sub...@>=
void maketrie(int n) {
  register int i,j,k,l,m,q,t,cstar;
  m=(n-1)>>1;
  o,start[1]=k=1,ptr=2;
   /* |up[1]=c[1]=0| handles the first sequence, $c_1$ */
  oo,cc[0]=pp[0]=-1; /* ``the level above the forest'' */
  for (t=1;t<n-1;t++) @<Generate the sequences $c_1\ldots c_{t+1}$
                            from the sequences $c_1\ldots c_t$@>;
  if (oo,start[m+1]-start[m]>maxmtrees) {
    fprintf(stderr,"Recompile me with maxmtrees>=%d!\n",
                          start[m+1]-start[m]);
    exit(-66);
  }
  o,start[n]=ptr;
}

@ At this point |k=start[t]|.

When |k>start[t]|, the computation for $k$ usually has a lot in common with
the computation for $k-1$. Therefore there's considerable potential
for optimization. But I've opted for simplicity today.

@<Generate the sequences $c_1\ldots c_{t+1}$...@>=
{
  for (o,start[t+1]=ptr;k<start[t+1];k++) {
    for (i=t,j=k,q=-1;i;i--,o,j=up[j]) {
      oooo,cc[i]=c[j],pp[i]=np[j];
      if (cc[i]==0 && q<0) q=i; /* |q| is position of rightmost root */
    }
  @<Determine $c^*$ for the sequence $c_1\ldots c_t$@>;
  o,down[k]=ptr;
  for (o,q=t,j=cc[t]-cstar; j>=0;o,j--,q=pp[q]) ;
  for (j=cstar;j>=0;j--)
     oooo,up[ptr]=k,c[ptr]=j,np[ptr]=q,q=pp[q],ptr++;
  }
}

@ The goal here is to determine $c^*$, the largest level that
can legally follow the sequence of levels $c_1\ldots c_t$.

@<Determine $c^*$ for the sequence $c_1\ldots c_t$@>=
if (q+m==t+1) cstar=0; /* the final tree already has |m| nodes */
else for (o,l=cc[t],cstar=l+1,j=t;l>=0;o,l--,j=pp[j]) {
  @<Check canonicity at level |l|@>;
}

@ At this point |j| is maximal with |cc[j]=l|; this means that
|j| is the ancestor of |t| at level |l|. If |j| has a left sibling,
we decrease |cstar| if necessary so that the substring starting
at |j| doesn't exceed the substring starting at that sibling.

@<Check canonicity at level |l|@>=
if (o,cc[j-1]>=l) { /* yes, there is a left sibling */
  for (q=j-1;o,cc[q]>l;q--) ; /* find where its subtree begins */
  for (i=1;j+i<=t;i++) if (oo,cc[q+i]!=cc[j+i]) break;
  if (j+i>t) {
    if (o,cstar>cc[q+i]) cstar=cc[q+i]; /* retain lexicographic order */
  }@+else if (cc[q+i]<cc[j+i])
    fprintf(stderr,"I'm confused!\n"); /* previous lexicographic test failed */
}

@*Data structures for the trees.
@z
@x
@ @<Input the tree $S$@>=
if (o,argv[1][0]!='.') {
  fprintf(stderr,"The root of S should have `.' as its parent!\n");
  exit(-10);
}
for (m=1;o,argv[1][m];m++) {
  if (m==maxn) {
    fprintf(stderr,"Sorry, S must have at most %d nodes!\n",
                 maxn);
    exit(-11);
  }
  p=decode(argv[1][m]);
  if (p<0) {
    fprintf(stderr,"Illegal character `%c' in S!\n",
                        argv[1][m]);
    exit(-12);
  }
  if (p>=m) {
    fprintf(stderr,"The parent of %c must be less than %c!\n",
                            encode(m),encode(m));
    exit(-13);
  }
  if (p==0 && m>1) {
    fprintf(stderr,"The root of S must have only one child!\n");
    exit(-13);
  }
  oo,q=snode[p].child,snode[p].child=m; /* |m| becomes the first child */
  o,snode[m].sib=q;
}

@ @<Input the tree $T$@>=
if (o,argv[2][0]!='.') {
  fprintf(stderr,"The root of T should have `.' as its parent!\n");
  exit(-20);
}
for (n=1;o,argv[2][n];n++) {
  if (n==maxn) {
    fprintf(stderr,"Sorry, T must have at most %d nodes!\n",
                 maxn);
    exit(-21);
  }
  p=decode(argv[2][n]);
  if (p<0) {
    fprintf(stderr,"Illegal character `%c' in T!\n",
                        argv[2][n]);
    exit(-22);
  }
  if (p>=n) {
    fprintf(stderr,"The parent of %c must be less than %c!\n",
                            encode(n),encode(n));
    exit(-23);
  }
  oo,q=tnode[p].child,tnode[p].child=n; /* |n| becomes the first child */
  o,tnode[n].sib=q;
}
@<Allocate the arcs@>;
fprintf(stderr,
  "OK, I've got %d nodes for S and %d nodes for T, max degree %d.\n",
                   m,n,maxdeg);
@y
@ @<Build a trie for locating all |m|-vertex free trees@>=
maketrie(m);
for (o,k=1;k<start[m];k++) oooo,mup[k]=up[k],mp[k]=np[k];
oo,mstart=start[m-1],mstop=start[m];
if ((m&1)==0) oo,mshortstart=start[(m>>1)-1],mshortstop=start[m>>1];

@ As we proceed, $S$ will be the tree rooted at~0
for which the parent of node~$k$ is |pm[k]|, for $1\le k<m$.

@<Set up $S$, the first $m$-node tree@>=
mphase=0,mstep=mstart,mserial=0;
for (k=m-1,j=mstep;k;k--) oooo,pm[k]=mp[j],upm[k]=j=mup[j];
@<Convert the |pm| array into a tree $S$ in |snode|@>;

@ @<Glob...@>=
int mup[maxtrees]; /* a version of |up|, for $m$-node trees */
int mp[maxtrees]; /* version of |np|, for $m$-node trees */
int pm[maxn]; /* the parents of nodes in the current $S$ */
int upm[maxn]; /* where we've been when setting |pm| */
int mstart,mstop,mshortstart,mshortstop; /* trie boundaries for making $S$ */
int mphase,mstep,mstepx,mserial; /* controllers for the loop on $S$ */

@ Matula's routine will want the root of $S$ to be a leaf. So we first
use |tnode| to create the free tree specified by |pm|; then we
move a leaf to root position of |tnode|; finally we produce the
desired tree in |snode| by copying and remapping |tnode|.
(I got this code from {\mc MATULA-BIG}.)

@<Convert the |pm| array into a tree $S$ in |snode|@>=
o,tnode[0].child=tnode[0].sib=0;
for (k=1;k<m;k++) {
  o,p=pm[k];
  oo,q=tnode[p].child,tnode[p].child=k;
  o,tnode[k].child=0,tnode[k].sib=q;
}
@<Make the root of |tnode| into a leaf@>;
@<Copy and remap |tnode| into |snode|@>;

@ I thought this would be easier than it has turned out to be.
Did I miss something? It's a nice little exercise in datastructurology.

Node 0 moves to node |m|, so that it can become a child or a sibling.

@<Make the root of |tnode| into a leaf@>=
oo,r=m,p=tnode[0].child,tnode[r].child=p,tnode[r].sib=0;
while (o,q=tnode[p].child) { /* make |p| the root, retaining its child |q| */
  o,k=tnode[p].sib,s=tnode[q].sib;
  o,tnode[p].sib=0;
  o,tnode[q].sib=r;
  o,tnode[r].child=k,tnode[r].sib=s;
  r=p,p=q;
}
ooo,s=tnode[p].sib,tnode[p].sib=0,tnode[p].child=r,tnode[r].child=s;
/* now |p| is the root */

@ @<Copy and remap |tnode| into |snode|@>=
for (gg=k=0;k<m;k++) o,snode[k].child=snode[k].sib=0;
copyremap(p);
if (gg!=m) {
  fprintf(stderr,"I'm basically confused!\n");
  exit(-666);
}
oo,snode[0].arc=snode[m].arc;

@ This recursion is a bit tricky, and I wonder what's the best way to explain it.
(An exercise for the reader.) 

@<Sub...@>=
int gg; /* global counter for remapping */
void copyremap(int r) {
  register int p,q;
  mems+=suboverhead;
  gg++;
  o,p=tnode[r].child;
  if (!p) return;
  o,snode[gg-1].child=gg; /* copy a (remapped) child pointer */
  while (1) {
    q=gg; /* the future interior name of |p| */
    copyremap(p);
    o,p=tnode[p].sib;
    if (!p) return;
    o,snode[q].sib=gg; /* copy a (remapped) sibling pointer */
  }
}

@ @<Change $S$ to the next $m$-node tree, or |break|@>=
mserial++;
if (mphase) @<Do a bicentroidal |m|-step change for $S$, or |break|@>@;
else if (++mstep<mstop) {
  for (k=m-1,j=mstep;k;k--) {
    ooo,pm[k]=mp[j],j=mup[j];
    if (o,j==upm[k]) break; /* we've been there and done that */
    o,upm[k]=j;
  }
}@+else if (m&1) break;
else @<Set up $S$, the first bicentroidal $m$-node tree@>;
@<Convert the |pm| array into a tree $S$ in |snode|@>;

@ The bicentroidal trees require us to run two loops, for
trees of size~|m/2|.

@<Set up $S$, the first bicentroidal $m$-node tree@>=
{
  mphase=1,mstep=mshortstart;
  for (k=(m>>1)-1,j=mshortstart;k;k--) oooo,pm[k]=mp[j],upm[k]=j=mup[j];
  @<Set up the right half of bicentroidal $S$ beginning at |mstep|@>;
}  

@ @<Set up the right half of bicentroidal $S$ beginning at |mstep|@>=
mstepx=mstep;
for (k=m-1,j=mstepx;k>(m>>1);k--) oooo,pm[k]=mp[j]+(m>>1),upm[k]=j=mup[j];

@ @<Do a bicentroidal |m|-step change for $S$, or |break|@>=
{
  if (++mstepx==mshortstop)
    @<Change $S$ to the next bicentroidal $m$-node tree, or |break|@>@;
  else {
    for (k=m-1,j=mstepx;k;k--) {
      ooo,pm[k]=mp[j]+(m>>1),j=mup[j];
      if (o,j==upm[k]) break; /* we've been there and done that */
      o,upm[k]=j;
    }
  }
}

@ @<Change $S$ to the next bicentroidal $m$-node tree, or |break|@>=
{
  if (++mstep==mshortstop) break;
  for (k=(m>>1)-1,j=mstep;k;k--) {
    ooo,pm[k]=mp[j],j=mup[j];
    if (o,j==upm[k]) break; /* we've been there and done that */
    o,upm[k]=j;
  }
  @<Set up the right half of bicentroidal $S$ beginning at |mstep|@>;
}

@ @<Build a trie for locating all |n|-vertex free trees@>=
maketrie(n);
oo,nstart=start[n-1],nstop=start[n];
if ((n&1)==0) oo,nshortstart=start[(n>>1)-1],nshortstop=start[n>>1];

@ As we proceed, $T$ will be the tree rooted at~0
for which the parent of node~$k$ is |pn[k]|, for $1\le k<n$.

@<Set up $T$, the first $n$-node tree@>=
nphase=0,nstep=nstart,nserial=0;
for (k=n-1,j=nstep;k;k--) oooo,pn[k]=np[j],upn[k]=j=up[j];
@<Convert the |pn| array into a tree $T$ in |tnode|@>;

@ @<Glob...@>=
int pn[maxn]; /* the parents of nodes in the current $T$ */
int upn[maxn]; /* where we've been when setting |pn| */
int nstart,nstop,nshortstart,nshortstop; /* trie boundaries for making $T$ */
int nphase,nstep,nstepx,nserial; /* controllers for the loop on $T$ */

@ The tree in |tnode| is fancier than the tree in |snode|, because
Matula's algorithm will use its |deg| and |arc| fields.

@<Convert the |pn| array into a tree $T$ in |tnode|@>=
o,tnode[0].child=tnode[0].sib=0;
for (k=1;k<n;k++) {
  o,head[k]=0;
  o,p=pn[k];
  oo,q=tnode[p].child,tnode[p].child=k;
  o,tnode[k].child=0,tnode[k].sib=q;
}
@<Allocate the arcs@>;

@ @<Change $T$ to the next $n$-node tree, or |break|@>=
nserial++;
if (nphase) @<Do a bicentroidal |n|-step change for $T$, or |break|@>@;
else if (++nstep<nstop) {
  for (k=n-1,j=nstep;k;k--) {
    ooo,pn[k]=np[j],j=up[j];
    if (o,j==upn[k]) break; /* we've been there and done that */
    o,upn[k]=j;
  }
}@+else if (n&1) break;
else @<Set up $T$, the first bicentroidal $n$-node tree@>;
@<Convert the |pn| array into a tree $T$ in |tnode|@>;

@ The bicentroidal trees require us to run two loops, for
trees of size~|n/2|.

@<Set up $T$, the first bicentroidal $n$-node tree@>=
{
  nphase=1,nstep=nshortstart;
  for (k=(n>>1)-1,j=nshortstart;k;k--) oooo,pn[k]=np[j],upn[k]=j=up[j];
  @<Set up the right half of bicentroidal $T$ beginning at |nstep|@>;
}  

@ @<Set up the right half of bicentroidal $T$ beginning at |nstep|@>=
nstepx=nstep;
for (k=n-1,j=nstepx;k>(n>>1);k--) oooo,pn[k]=np[j]+(n>>1),upn[k]=j=up[j];

@ @<Do a bicentroidal |n|-step change for $T$, or |break|@>=
{
  if (++nstepx==nshortstop)
    @<Change $T$ to the next bicentroidal $n$-node tree, or |break|@>@;
  else {
    for (k=n-1,j=nstepx;k;k--) {
      ooo,pn[k]=np[j]+(n>>1),j=up[j];
      if (o,j==upn[k]) break; /* we've been there and done that */
      o,upn[k]=j;
    }
  }
}

@ @<Change $T$ to the next bicentroidal $n$-node tree, or |break|@>=
{
  if (++nstep==nshortstop) break;
  for (k=(n>>1)-1,j=nstep;k;k--) {
    ooo,pn[k]=np[j],j=up[j];
    if (o,j==upn[k]) break; /* we've been there and done that */
    o,upn[k]=j;
  }
  @<Set up the right half of bicentroidal $T$ beginning at |nstep|@>;
}

@z
@x
if (m==0) goto yes_sol; /* every boy matches every girl */
@y
if (m==0) goto yes_sol; /* every boy matches every girl */
if (m*n>record) {
  record=m*n;
  make_sstring(mserial);
  make_tstring(nserial);
  fprintf(stderr," ...matching %d boys to %d girls (%s,%s)\n",
                               m,n,sstring,tstring);
}
@z
@x
@*Index.
@y
@ @<Record the solution@>=
emems=mems-startmems;
if (z>0) oo,msols[mserial]++,nsols[nserial]++,totsols++;
@<Update the runtime stats@>;

@ We maintain the mean and variance and max of |emems|, the number of
mems elapsed while solving an $S$-$T$ embedding problem,
using Welford's method; see 4.2.2--(16) in {\sl Seminumerical Algorithms}.

@<Update the runtime stats@>=
{
  register double del;
  samp+=1.0;
  if (emems>ememsmax) ememsmax=emems,shardest=mserial,thardest=nserial;
  del=emems-ememsmean;
  ememsmean+=del/samp;
  ememsvar+=del*(emems-ememsmean);
}

@ @<Glob...@>=
unsigned long long startmems;
int emems,ememsmax,shardest,thardest;
double ememsmean,ememsvar,samp;
int msols[maxtrees],nsols[maxtrees];
unsigned long long totsols;
int record;

@ @d errorbar(x) ((x)? sqrt((x)/(samp*(samp-1.0))): 0.0)

@<Sign off@>=
printf("I examined %d %d-trees and %d %d-trees (total %g cases).\n",
               mserial,m,nserial,n,samp);
printf("There were %lld cases with S embeddable in T.\n",
                totsols);
printf("Observed running time in mems was %g +- %g;\n",
               ememsmean,errorbar(ememsvar));
make_sstring(shardest),make_tstring(thardest);
printf("the hardest case (%d mems) was S=%s versus T=%s.\n",
                       ememsmax,sstring,tstring);
printf("Here are extremes for S embeddings:\n");
for (k=p=0,q=nserial;k<mserial;k++) {
  if (msols[k]>=p)
    p=msols[k],make_sstring(k),printf("   %s:%d\n",
                                           sstring,p);
  if (msols[k]<=q)
    q=msols[k],make_sstring(k),printf(" %s:%d\n",
                                           sstring,q);
}
printf("Here are extremes for T embeddings:\n");
for (k=p=0,q=mserial;k<nserial;k++) {
  if (nsols[k]>=p)
    p=nsols[k],make_tstring(k),printf("   %s:%d\n",
                                           tstring,p);
  if (nsols[k]<=q)
    q=nsols[k],make_tstring(k),printf(" %s:%d\n",
                                           tstring,q);
}
printf("Altogether %lld+%lld mems for this computation.\n",
           imems,mems);

@ @<Sub...@>=
void make_sstring(int k) {
  register j,t,i,d;
  if (mstart+k<mstop) {
    for (j=mm-1,t=mstart+k;j;j--,t=mup[t]) 
      sstring[j]=encode(mp[t]);
  }@+else {
    d=mshortstop-mshortstart,k-=mstop-mstart;
    for (i=0;k>=d;i++,d--) k-=d;
    for (j=(mm>>1)-1,t=mshortstart+i;j;j--,t=mup[t]) 
      sstring[j]=encode(mp[t]);
    sstring[mm>>1]='0';
    for (j=mm-1,t=mshortstart+i+k;j>(mm>>1);j--,t=mup[t])
      sstring[j]=encode((mm>>1)+mp[t]);
  }
}
@#
void make_tstring(int k) {
  register j,t,i,d;
  if (nstart+k<nstop) {
    for (j=nn-1,t=nstart+k;j;j--,t=up[t]) 
      tstring[j]=encode(np[t]);
  }@+else {
    d=nshortstop-nshortstart,k-=nstop-nstart;
    for (i=0;k>=d;i++,d--) k-=d;
    for (j=(nn>>1)-1,t=nshortstart+i;j;j--,t=up[t]) 
      tstring[j]=encode(np[t]);
    tstring[nn>>1]='0';
    for (j=nn-1,t=nshortstart+i+k;j>(nn>>1);j--,t=up[t])
      tstring[j]=encode((nn>>1)+np[t]);
  }
}

@*Index.
@z
