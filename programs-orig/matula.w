\def\dts{\mathinner{\ldotp\ldotp}}
\input epsf
@s node int

@*Intro. This program determines whether a given free tree,~$S$, is isomorphic
to a subtree of another free tree,~$T$, using an algorithm published
by David~W. Matula [{\sl Annals of Discrete Mathematics\/ \bf2} (1978),
91--106]. His algorithm is quite efficient; indeed, it runs even faster
than he thought it did! If $S$ has $m$ nodes and $T$ has $n$ nodes,
the running time is at worst proportional to $mn$ times the square root of the
maximum inner-degree of any node in~$S$, where the inner degree of
a node is the number of its nonleaf neighbors. 

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

@ The program is instrumented to record the number of mems, namely the
number of times it accesses an octabyte of memory.
(Most of the memory accesses are actually to tetrabytes (|int|s), because
this program rarely deals with two tetrabytes that are
known to be part of the same octabyte.)

@d maxn 62 /* could be greatly increased if I had another input convention */
@d o mems++ /* count one mem */
@d oo mems+=2 /* count two mems */
@d ooo mems+=3 /* count three mems */
@d oooo mems+=4 /* count four mems */
@d suboverhead 10 /* mems charged per subroutine call */
@d decode(c) ((c)>='0' && (c)<='9'? (c)-'0':
              (c)>='a' && (c)<='z'? (c)-'a'+10:@|
              (c)>='A' && (c)<='Z'? (c)-'A'+36:
             -1)
@d encode(p) ((p)<10? (p)+'0':
              (p)<36? (p)-10+'a':
              (p)<62? (p)-36+'A':
             '?')

@c
#include <stdio.h>
#include <stdlib.h>
@<Type definitions@>;
@<Global variables@>;
unsigned long long mems; /* memory references */
unsigned long long imems; /* mems during the input phase */
@<Subroutines@>;
main (int argc,char*argv[]) {
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
}

@ @<Process the command line@>=
if (argc!=3) {
  fprintf(stderr,"Usage: %s S_parents T_parents\n",
              argv[0]);
  exit(-1);
}
@<Input the tree $S$@>;
@<Input the tree $T$@>;

@*Data structures for the trees.
A |node| record is allocated for each node of a tree.
It has four fields: |child| (the index of its most recent child, if any),
|sib| (the index of its parent's previous child, if any),
|deg| (the number of neighbors), and
|arc| (the number of the arc to its parent).
The |deg| and |arc| fields aren't
actually used for~$S$, but we need them for~$T$.
Reference to the |deg| and |arc| fields in the same node counts as only one mem.

@<Type def...@>=
typedef struct node_struct {
  int child; /* who is my first child, if any? */
  int sib; /* who is the next child of my parent, if any? */
  int deg; /* how many neighbors do I have, including my parent (if any)? */
  int arc; /* which arc corresponds to the link from me to my parent? */
} node;

@ @<Glob...@>=
node snode[maxn]; /* the $m$ nodes of $S$ */
node tnode[maxn]; /* the $n$ nodes of $T$ */

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

@ The target tree $T$ has $2(n-1)$ arcs, from each nonroot node to
its parent and vice versa. The arcs from $u$ to~$v$ are assigned
consecutive integers, from 0 to~$2n-3$, in lexicographic order
of (deg($v$), $v$, $u$). (Well, the second and third components
might not be in numerical order; but all $d$~arcs from a vertex of
degree~$d$ are consecutive, beginning with the arc to the parent.)

In order to assign these numbers, we keep lists of all nodes having
a given degree, using the |arc| fields temporarily to link them together.

@<Sub...@>=
void fixdeg(int p) {
  register int d,q;
  mems+=suboverhead;
  for (o,d=1,q=tnode[p].child;q;o,d++,q=tnode[q].sib)
    fixdeg(q);
  if (p) ooo,tnode[p].arc=head[d],tnode[p].deg=d,head[d]=p;
     /* |p| is not the root; it has |d| neighbors including its parent */
  else ooo,tnode[0].arc=head[d-1],tnode[0].deg=d-1,head[d-1]=-1;
     /* root is temporarily renamed |-1| */
}

@ We set |thresh[d]| to the number of the first arc for a node
of degree $d$ or more.

@<Allocate the arcs@>=
fixdeg(0);
for (d=1,e=0;e<2*n-2;d++) {
  o,thresh[d]=e;
  for (o,p=head[d];p;e+=d,p=q) {
    if (p<0) p=0;
    oo,q=tnode[p].arc,tnode[p].arc=e;
  }
}
for (maxdeg=d-1,emax=e;d<m;d++) o,thresh[d]=emax;
@<Allocate the dual arcs@>;

@ The arc from $u$ to $v$ has a dual, namely the arc from $v$ to $u$.
(And conversely.) We've assigned numbers to the arcs that go to a
parent; the other arcs are their duals.

@ @<Allocate the dual arcs@>=
for (p=0;p<n;p++) {
  for (oo,e=(p?tnode[p].arc:tnode[p].arc-1),q=tnode[p].child;q;o,q=tnode[q].sib) {
    ooo,dual[tnode[q].arc]=++e,dual[e]=tnode[q].arc;
    oooo,uert[dual[e]]=vert[e]=p,uert[e]=vert[dual[e]]=q;
  }
}

@ @<Glob...@>=
int head[maxn]; /* heads of lists by degree */
int maxdeg; /* maximum degree seen */
int thresh[maxn]; /* where the arcs from large degree nodes start */
int vert[maxn+maxn]; /* the source vertex of each arc */
int uert[maxn+maxn]; /* the target vertex of each arc */
int dual[maxn+maxn]; /* the dual of each arc */
int emax; /* the total number of arcs */

@*The master control. There's a two-dimensional array called |sol|
that pretty much governs the computation. The first index, |p|, is a
node of~$S$; the second index, |e|, is an arc of~$T$. If |e| is
the arc from $u$ to~$v$, consider the subtree of~$T$ that's
rooted at~$u$ and includes~$v$; we call it ``subtree~|e|.''
If there's no way to embed the subtree of~$S$ rooted at~|p| to subtree~|e|,
by mapping |p| to~$v$, 
then we'll set |sol[p][e]| to zero. Otherwise we'll set |sol[p][e]| to
a nonzero value, with which we could deduce such an embedding
if called on to do so.

The basic idea is simple, working recursively up from small subtrees
to larger ones: Suppose $p$ has $r$~children, $q_1$, \dots, $q_r$;
and suppose $v$ has $s+1$ neighbors, $u_0$, \dots, $u_s$.
Suppose further that we've already computed $|sol|[q_i][e_j]$,
for $1\le i\le r$ and $0\le j\le s$, where $e_j$ is the
arc from $v$ to $u_j$. Matula's algorithm will tell us
how to compute |sol|$[p][|dual|[e_j]]$ for $0\le j\le s$.
Thus we can fill in the rows of |sol| from bottom to top;
eventually |sol[1]| will tell us if we can embed {\it all\/} of~$S$.

Let's look closely at that crucial subproblem: How, for example,
do we know if |sol|$[p][|dual|[e_0]]$ should be zero or nonzero?
That subproblem means that we want to embed subtree~|p| into
the subtree below the arc from $u_0$ to~|v|. And the subproblem
is clearly solvable if and only if we can match up each child $q_i$
of~|p| with a distinct child $u_j$ of~|v|, in such a way that
|sol|$[p_i][q_j]$ is nonzero. Aha, yes: It's a bipartite matching problem!
And there are good algorithms for bipartite matching!

More generally, consider the subproblem in which $u_j$ is a
parent of~$v$ in~$T$, while $u_0$, \dots, $u_{j-1}$, $u_{j+1}$, \dots,~$u_s$
are children. Matula discovered that these subproblems are
essentially the same, for all $j$ between $0$ and~$s$.
It's a beautiful way to save a factor of~$n$ by combining similar subproblems.

So that's what we'll do, with a recursive procedure called |solve|.

@<Solve the problem@>=
z=solve(1);

@ The task of |solve|, given a node |p| of~$S$, is to set
the values of |sol[p][e]| for each arc~|e|.

The base case of this recursion occurs when |p| is a leaf;
a leaf can be embedded anywhere.

Another easy case occurs when subtree |e| of~$T$ has too small
a degree to support any embedding.

If some descendant |d| of~|p| can't be embedded, |solve| returns |-d|.
Otherwise |solve| returns the number of $1$s in |sol[p]|.

@<Sub...@>=
int solve(int p) {
  register int e,m,n,q,r,z;
  mems+=suboverhead;
  o,q=snode[p].child;
  if (q==0) {
    for (e=0;e<emax;e++) o,sol[p][e]=1;
    return emax;
  }
  for (r=0;q;o,r++,q=snode[q].sib) {
    z=solve(q);
    if (z<=0) return (z? z: -q);
      /* if we can't embed a subtree, we can't embed $S$ */
  }
  /* now |sol[q][e]| is known for all children |q| of |p| and all arcs |e| */
  for (o,z=e=0;e<thresh[r+1];e++) o,sol[p][e]=0; /* degree too small */
  for (n=r+1;e<emax;e+=n) {
    @<Local variables for the HK algorithm@>;
    while (o,e==thresh[n+1]) n++; /* advance |n| to the degree of |vert[e]| */
    @<Set up Matula's bipartite matching problem for |p| and |e|@>;
    @<Solve that problem and update |sol[p]|$[e\dts e+n-1]$@>;
  }
  return z;
}

@*Bipartite matching chez Hopcroft and Karp.
Now we implement the classic HK algorithm for bipartite matching,
stealing most of the code from the program {\mc HOPCROFT-KARP}.
(The reader should consult that program for further remarks and proofs.)
The children of |p| play the role of ``boys'' in that algorithm,
and the arcs for neighbors of |v| play the role of ``girls.''
That algorithm is slightly simplified here, because we are interested only
in cases where all the boys can be matched. (There always are more
girls than boys, in our case.)

In Matula's matching problem, |p| is a vertex of~$S$ that has
children $q_1$, \dots,~$q_r$; |e| is an arc of~$T$ from |v=vert[e]| to
|u=uert[e]|, where |v| has $s+1$ neighbors $u_0$, \dots,~$u_s$.
The matching problem will have $m\le r$ boys and $n=s+1$ girls.

We use a simple data structure to represent the bipartite graph: The potential
partners for girl~|j| are in a linked list beginning at |glink[j]|,
linked in |next|, and terminated by a zero link. The partner
at link~|l| is stored in |tip[l]|.

@<Set up Matula's bipartite matching problem for |p| and |e|@>=
@<Initialize the tables needed for |n| girls@>;
for (o,t=m=0,b=snode[p].child;b;o,b=snode[b].sib)
  @<Record the potential matches for boy |b|@>;
if (m==0) goto yes_sol; /* every boy matches every girl */

@ If |b| is matched to every girl, we needn't include him in the
bipartite graph. (This situation happens rather often, for example
whenever |b| is a leaf, so it's wise to test for it.)
On the other hand, if some boy isn't matched to any girl, we
know in advance that there will be no bipartite matching.

The HK algorithm uses a |mate| table, to indicate the current
mate of every boy as it constructs tentative matchings. There's
also an inverse table, |imate|, for the girls.
If |b| has no mate, |mate[b]=0|; if |g| has no mate, |imate[g]=0|.
But if |b| is tentatively matched to~|g|, we have |mate[b]=g| and
|imate[g]=b|.

@<Record the potential matches for boy |b|@>=
{
  for (g=e;g<e+n;g++) if (oo,sol[b][dual[g]]==0) break;
  if (g==e+n) continue; /* boy |b| fits anywhere, so omit him */
  oo,m++,mate[b]=mark[b]=0;
  for (k=t,gg=e;gg<g;gg++)
    oooo,tip[++t]=b,next[t]=glink[gg],glink[gg]=t;
  for (g++;g<e+n;g++) if (oo,sol[b][dual[g]])
    oooo,tip[++t]=b,next[t]=glink[g],glink[g]=t;
  if (k==t) goto no_sol; /* boy |b| fits nowhere, so give up */
}

@ We've now created a bipartite graph with |m| boys, |n| girls,
and |t| edges. 

The HK algorithm proceeds in {\it rounds}, where each round finds a maximal
set of so-called SAPs, which are are vertex-disjoint augmenting paths of the
shortest possible length. If a round finds $k$ such paths, it reduces
the number of free boys (and free girls) by~$k$. Eventually, after
at most $2\sqrt n$ rounds, we reach a state where no more SAPs exist.
And then we have a solution, if and only if no boys are still free
(hence $n-m$ girls are still free).

Variable |f| in the algorithm denotes the current number of free girls.
They all appear in the first |f| positions of any array called~|queue|,
which governs a breadth-first search. This array has an inverse,~|iqueue|:
If |g| is free, we have |queue[iqueue[g]]=g|.

@<Initialize the tables needed for |n| girls@>=
for (g=e;g<e+n;g++) oooo,glink[g]=0,imate[g]=0,queue[g-e]=g,iqueue[g]=g-e;
f=n;

@ The key idea of the HK algorithm is to create a directed acyclic graph
in which the paths from a dummy node called $\top$ to a dummy node
called $\bot$ correspond one-to-one with
the augmenting paths of minimum length. Each of those paths
will contain |final_level| existing matches.

This dag has a representation something like our representation
of the girls' choices, but even sparser: The first arc from boy~$i$
to a suitable girl is in |blink[i]|, with |tip| and |next| as before.
Each girl, however, has exactly one outgoing arc in the dag, namely
her |imate|. An |imate| of~$0$ is a link to $\bot$.
The other dummy node, $\top$, has a list of free boys,
beginning at |dlink|.

An array called |mark| keeps track of the level (plus 1) at which
a boy has entered the dag. All marks must be zero when we begin.

The |next| and |tip| arrays must be able to accommodate $2t+m$ entries:
$t$ for the original graph, $t$ for the edges at round~$0$,
and $m$ for the edges from $\top$.

@d maxg (2*maxn) /* upper limit on the number of girls */
@d maxt (maxn*maxg) /* upper limit on the number of bipartite edges */

@<Global variables@>=
int blink[maxn],glink[maxg]; /* list heads for potential partners */
int next[maxt+maxt+maxn],tip[maxt+maxt+maxn]; /* links and suitable partners */
int mate[maxn],imate[maxg];
int queue[maxg]; /* girls seen during the breadth-first search */
int iqueue[maxg]; /* inverse permutation, for the first |f| entries */
int mark[maxn]; /* where boys appear in the dag */
int marked[maxn]; /* which boys have been marked */
int dlink; /* head of the list of free boys in the dag */

@ @<Build the dag of shortest augmenting paths (SAPs)@>=
final_level=-1,tt=t;
for (marks=l=i=0,q=f;;l++) {
  for (qq=q;i<qq;i++) {  
    o,g=queue[i];
    for (o,k=glink[g];k;o,k=next[k]) {
      oo,b=tip[k], pp=mark[b];
      if (pp==0) @<Enter |b| into the dag@>@;
      else if (pp<=l) continue;
      oooo,tip[++tt]=g,next[tt]=blink[b],blink[b]=tt;
    }
  }
  if (q==qq) break; /* nothing new on the queue for the next level */
}

@ @<Local variables for the HK algorithm@>=
register int b,f,g,i,j,k,l,t,gg,pp,qq,tt,final_level,marks;

@ Once we know we've reached the final level, we don't allow
any more boys at that level unless they're free. We also
reset |q| to~|qq|, so that the dag will not reach a greater level.

@<Enter |b| into the dag@>=
{
  if (final_level>=0 && (o,mate[b])) continue;
  else if (final_level<0 && (o,mate[b]==0)) final_level=l,dlink=0,q=qq;
  ooo,mark[b]=l+1,marked[marks++]=b,blink[b]=0;
  if (mate[b]) oo,queue[q++]=mate[b];
  else oo,tip[++tt]=b,next[tt]=dlink,dlink=tt;
}  
  
@ We have no SAPs if and only no free boys were found.

@<If there are no SAPs, |break|@>=
if (final_level<0) break;

@ @<Reset all marks to zero@>=
while (marks) oo,mark[marked[--marks]]=0;

@ We've just built the dag of shortest augmenting paths, by starting
from dummy node~$\bot$ at the bottom and proceeding breadth-first
until discovering |final_level| and essentially reaching the dummy node~$\top$.
Now we more or less reverse the process: We start at $\top$ and proceed
{\it depth\/}-first, harvesting a maximal set of
vertex-disjoint augmenting paths as we go.
(Any maximal set will be fine; we needn't bother to look for an especially
large one.)

The dag is gradually dismantled as SAPs are removed, so that
their boys and girls won't be reused. A subtle point arises here
when we look at a girl~|g| who was part of a previous SAP: In that
case her mate will have been changed to a boy whose |mark| is negative.
This is true even if |l=0| and |g| was previously free.

@<Find a maximal set of disjoint SAPs,
      and incorporate them into the current matching@>=
while (dlink) {
  oo,b=tip[dlink], dlink=next[dlink];
  l=final_level;
enter_level: o,boy[l]=b;
advance:@+if (o,blink[b]) {
    ooo,g=tip[blink[b]],blink[b]=next[blink[b]];
    if (o,imate[g]==0) @<Augment the current matching and |continue|@>;
    if (o,mark[imate[g]]<0) goto advance;
    b=imate[g],l--;
    goto enter_level;
  }
  if (++l>final_level) continue;
    o,b=boy[l];
    goto advance;
}
@<Reset all marks to zero@>;

@ At this point $|g|=g_0$ and $|b|=|boy[0]|=b_0$ in an augmenting path.
The other boys are |boy[1]|, |boy[2]|, and so on.

@<Augment the current matching and |continue|@>=
{
  if (l) fprintf(stderr,"I'm confused!\n");
          /* a free girl should occur only at level 0 */
  @<Remove |g| from the list of free girls@>;
  while (1) {
    o,mark[b]=-1;
    ooo,j=mate[b],mate[b]=g,imate[g]=b;
    if (j==0) break; /* |b| was free */
    o,g=j,b=boy[++l];
  }
  continue;
}

@ @<Glob...@>=
int boy[maxn]; /* the boys being explored during the depth-first search */

@ @<Remove |g| from the list of free girls@>=
f--; /* |f| is the number of free girls */
o,j=iqueue[g]; /* where is |g| in |queue|? */
ooo,i=queue[f], queue[j]=i, iqueue[i]=j; /* OK to clobber |queue[f]| */

@ Hey folks, we've now got all the infrastructure and machinery of the HK
algorithm in place. It only remains to actually perform the algorithm.

@<Solve that problem and update |sol[p]|$[e\dts e+n-1]$@>=
while (1) {
  @<Build the dag of shortest augmenting paths (SAPs)@>;
  @<If there are no SAPs, |break|@>;
  @<Find a maximal set of disjoint SAPs,
      and incorporate them into the current matching@>;
}
if (f==n-m) @<Store the solution in |sol[p]|@>@;
else no_sol:@+for (k=0;k<n;k++) o,sol[p][e+k]=0;
continue; /* resume the loop on |e| */
yes_sol:@+for (k=0;k<n;k++) o,sol[p][e+k]=1;
z+=n;

@*The climax.
But it's still necessary to don our thinking cap and figure out
exactly what we've got, when the HK algorithm has found a perfect matching of
$m$ boys to $n>m$ girls.

Our job is to update |n| entries of |sol|, one for each girl. 
That entry should be $0$ if and only if the girl has a mate in
{\it every\/} perfect match. (Because the subgraph isomorphism will
assign her to the parent of~$v$ in~$T$, while the mated girls will be
assigned to some of |v|'s children in the embedding.)

Suppose, for example, that the bipartite matching is unique. In that case
we'll want to set |sol[p][g]=0| if and only if |imate[g]!=0|.

Usually, however, there will be a number of perfect matchings,
involving different sets of girls. Matula noticed, in Theorem~3.4 of
his paper, that it's actually easy to distinguish the forcibly matched
girls from the others. Moreover --- fortunately for us --- the necessary
information is sitting conveniently in the dag, when the HK algorithm ends!

Indeed, it's not difficult to verify that every perfect matching
either includes~|g| or corresponds to a path from |g| to $\bot$ in the~dag.
Therefore --- ta da --- the freeable girls are precisely the girls in
the first~|q| positions of~|queue|!

@<Store the solution in |sol[p]|@>=
{
  for (k=0;k<n;k++) o,sol[p][e+k]=0;
  for (k=0;k<q;k++) ooo,z++,sol[p][queue[k]]=1;
  @<Store the mate information too@>;
}

@ If we're interested only in whether or not an embedding of $S$ into $T$
exists, the |sol| array tells us everything we need to know.

But if we want to actually see an embedding, we might wish to store
the solutions to the matching problems we've solved, so that
we don't need to repeat those calculations later.

In a way that's foolish: Only a small number of matching problems
will need to be redone. So we're wasting space by storing this
extra information --- which doesn't fit in |sol|. And we're
gaining only an insignificant amount of time.

Still, the details are interesting, so I'm plunging ahead.
Let |solx| and |soly| be arrays, such that the solution to
the bipartite matching problem in |sol[p]|$[e\dts e+n-1]$ is
recorded in |solx[p]|$[e\dts e+n-1]$ and
            |soly[p]|$[e\dts e+n-1]$. (Both |solx| and |soly| are
arrays of |int|, while |sol| itself could have been an array of single~bits.)

It suffices to store the final |imate| table in |solx|, and to
store links of a path from |g| to $\bot$ in |soly|.

@<Store the mate information too@>=
for (g=e;g<e+n;g++) oo,solx[p][g]=imate[g];
for (k=0;k<q;k++) {
  o,g=queue[k];
  if (o,imate[g]) oooo,soly[p][g]=tip[blink[imate[g]]];
}

@ @<Glob...@>=
int sol[maxn][maxg]; /* the master control matrix */
int solx[maxn][maxg]; /* |imate| info for bipartite solutions */
int soly[maxn][maxg]; /* final dag info for bipartite solutions */

@*The anticlimax.
When all has been done but not yet said, we want to tell the user
what happened.

At this point |z| holds the value of |solve(1)|.
It's negative, say |-d|, if the subtree of~$S$
rooted at node~|d| and its parent cannot be isomorphically embedded in~$T$.
Otherwise |z| is zero if $S$ itself cannot be embedded, although every
subtree of node~$1$ is embeddable.
Otherwise |z| is the number of arcs~|e| of~$T$ for which there's an
embedding with node~$0$ of~$S$ mapped into the root of subtree~|e|.

(In the latter case, notice that |z| is probably {\it not\/} the actual
total number of embeddings. It's just the number of places where we could
start an embedding and obtain at least one success.)

@<Report the solution@>=
if (z<0) fprintf(stderr,
         "Failure; We can't even embed node %d and its parent.\n",
                                    encode(-z));
else {
  fprintf(stderr,"There %s %d place%s to anchor an embedding of node 1.\n",
                            z==1?"is":"are", z, z==1?"":"s");
  if (z) @<Print a solution@>;
}

@ Our final task is to harvest the information in |sol|, |solx|, and |soly|,
in order to present the user with the images of nodes $0$, $1$, \dots\
of~$S$, in one of the possible embeddings found.

To do this, we assign an edge called |solarc[p]| to each nonroot vertex~|p|
of~$S$. If this arc runs from $v$ to~$u$, it means that the embedding
maps |p| to $v$ and |p|'s parent to~$u$. These arcs are assigned
top-down, starting with the rightmost~|e| such that |sol[1][e]=1|.

@ @<Print a solution@>=
{
  for (e=emax-1;o,sol[1][e]==0;e--) ;
  oo,solarc[1]=e;
  for (p=1;p<m;p++) if (o,snode[p].child) {
    for (q=snode[p].child;q;o,q=snode[q].sib) o,mate[q]=0;
    oo,z=solarc[p],v=vert[z];
    o,e=tnode[v].arc,n=tnode[v].deg;
    for (g=e;g<e+n;g++) ooo,q=imate[g]=solx[p][g],mate[q]=g;
    @<Find a matching in which |imate[z]=0|@>;
    for (o,g=e,q=snode[p].child;q;o,q=snode[q].sib) {
      if (o,mate[q]) oo,solarc[q]=dual[mate[q]];
      else { /* choose mate for a universally matchable boy */
        while (g==z || (o,imate[g])) g++;
        oo,solarc[q]=dual[g++];
      }
    }
  }
  oo,printf("%c",
           encode(uert[solarc[1]]));
  for (p=1;p<m;p++) oo,printf(" %c",
               encode(vert[solarc[p]]));
  printf("\n");
}

@ @<Glob...@>=
int solarc[maxn]; /* key arcs in the solution */

@ Here finally is a kind of cute way to end, using the theory of
{\it non\/}-augmenting paths. (That theory can be understood from
the construction of the final, incomplete dag in the HK algorithm,
whose critical structure we stored in |soly[p]|.)

@<Find a matching in which |imate[z]=0|@>=
for (k=0,g=z;o,q=imate[g];k=q) {
  o,imate[g]=k;
  o,g=soly[p][g];
  o,mate[q]=g;
}
o,imate[g]=k;

@ Did you solve the puzzle?
$$\vcenter{\epsfbox{matula.ST}}$$

@*Index.
