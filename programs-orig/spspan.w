\datethis
\input epsf
\def\adj{\mathrel{\!\mathrel-\mkern-8mu\mathrel-\mkern-8mu\mathrel-\!}}
   % adjacent vertices
@* Introduction. This program generates all spanning trees of a given
series-parallel graph, changing only one edge at a time, using an
interesting algorithm.

The given graph is specified using a simple right-Polish syntax
$$
G\,\to\,\.-\,\mid\,G\,G\,\,\.s\,\mid\,G\,G\,\,\.p
$$
so that, for example, the specifications
\.{----ps-sp--sp} and \.{----p-ss--spp} both denote the graph
$$
\epsfbox{spspan.1}
$$
which can also be represented as a tree:
$$
\epsfbox{spspan.2}
$$
Branch nodes of the tree are either $S$ nodes or $P$ nodes, alternating
from level to level.

As we do the computation, we count the total number of spanning trees that
were generated and the total number of memory references that were needed.

@d o mems++
@d oo mems+=2
@d ooo mems+=3
@d oooo mems+=4
@d call oo /* let's say that a subroutine call costs two mems */
@#
@d verbose (argc>2) /* show the edges of each spanning tree */
@d extraverbose (argc>3) /* show inner workings of the program */

@c
#include <stdio.h>
@<Type definitions@>@;
@<Global variables@>@;
unsigned int trees,mems;
@<Subroutines@>@;
main (int argc, char*argv[])
{
  register int j,k;
  if (argc==1) {
    fprintf(stderr,"Usage: %s SPformula [[gory] details]\n", argv[0]);@+
    exit(0);
  }
  @<Parse the formula |argv[1]| and set up the tree structure@>;
  @<Prepare the first spanning tree@>;
  printf(" (%u mems to get started)\n",mems);@+mems=0;
  @<Do the algorithm@>;
  printf("Altogether %u spanning trees, %u additional mems.\n",trees,mems);
}

@*Parsing and preparation. We begin by converting the Polish notation
into a binary tree.

In the following code, we have scanned $j$ binary operators and there are
$k$~items on the stack.

@d abort(mess) {@+fprintf(stderr,"Parsing error: %.*s|%s, %s!\n",
                 p-argv[1],argv[1],p,mess);@+exit(-1);@+}

@<Parse the formula |argv[1]| and set up the tree structure@>=
{
  register char*p=argv[1];
  for (j=k=0; *p; p++)
    if (*p=='-') @<Create a new leaf@>@;
    else if (*p=='s' || *p=='p') @<Create a new branch@>@;
    else abort("bad symbol");
  if (k!=1) abort("disconnected graph");
  @<Create the main tree@>;
}

@ @d maxn 1000 /* the maximum number of leaves; {\it not checked\/} */

@<Glob...@>=
int stack[maxn]; /* stack for parsing */
int llink[maxn],rlink[maxn]; /* binary subtrees */

@ Mems are not counted in this phase of the operation, because the
program is essentially assumed to begin with the graph represented as
a tree.

@<Create a new leaf@>=
stack[k++]=0;

@ @<Create a new branch@>=
{
  if (k<2) abort("missing operand");
  rlink[++j]=stack[--k];
  llink[j]=stack[k-1];
  stack[k-1]=(*p=='s'? 0x100: 0)+j;
}

@ Now we convert the binary tree to the desired working tree, whose branch
nodes appear in preorder.

@<Type...@>=
typedef struct node_struct {
  int typ; /* 1 for series nodes, otherwise 0 */
  struct node_struct *lchild; /* leftmost child; |NULL| for a leaf */
  struct node_struct *rchild; /* rightmost child; |NULL| for a leaf */
  struct node_struct *rsib; /* right sibling; wraps around cyclically */
  @<Additional fields of a \&{node}@>@;
} node;

@ The first half of |nodelist| contains up to |maxn| leaves;
the other half contains up to |maxn| branches.

@<Glob...@>=
node nodelist[maxn+maxn]; /* nodes of the tree */
node *curleaf; /* the leftmost not-yet-allocated leaf node */
node *curnode; /* the rightmost allocated branch node */
node *root, *topnode; /* root of the tree and its parent */

@ A recursive subroutine called |build| will govern the construction process.

@d isleaf(p) ((p)<nodelist+maxn)

@<Create the main tree@>=
curleaf=nodelist;
topnode=curnode=nodelist+maxn;
curnode->typ=2; /* special |typ| code for the outer level */
root=build(stack[0],curnode);
root->rsib=root; /* unnecessary but tidy */

@ When we |build| a leaf node, we simply allocate it. When we
|build| a branch node, we link its children together via their
sibling links.

Only one complication arises: We must prevent serial nodes
from having serial children and parallel nodes from having parallel
children. In such cases the child's family is merged with that of
the parent, and the child goes away.

@<Sub...@>=
node* build(int stackitem, node* par)
{
  register node *p,*l,*r,*lc,*rc;
  register int t,j;
  if (stackitem==0) return curleaf++;
  t=stackitem>>8, j=stackitem&0xff; /* type and location of a binary op */
  if (t!=par->typ) p=++curnode, p->typ=t;
  else p=par;
  l=build(llink[j],p), lc=l->lchild, rc=l->rchild, r=build(rlink[j],p);
  if (l==p) @<Incorporate left child into node |p|@>@;
  else if (r==p) @<Incorporate right child into node |p|@>@;
  else p->lchild=l, p->rchild=r, l->rsib=r, r->rsib=l;
  return p;
}

@ @<Incorporate right child into node |p|@>=
r=p->lchild, p->lchild=l, l->rsib=r, p->rchild->rsib=l;

@ @<Incorporate left child into node |p|@>=
if (r==p) @<Incorporate both children into node |p|@>@;
else p->rchild=r, rc->rsib=r, r->rsib=lc;

@ @<Incorporate both children into node |p|@>=
rc->rsib=p->lchild, p->lchild=lc, p->rchild->rsib=lc;

@ OK, the tree has been set up; our next goal is to decorate it.
First let's take a closer look at the problem we're trying to solve.

Each node of the tree corresponds to a series-parallel graph between
two vertices $u$ and~$v$, in a straightforward way: A leaf is a
single edge $u\adj v$. A nonleaf node~|p| corresponds to a ``superedge''
formed from the edges or superedges $u_1\adj v_1$, \dots, $u_k\adj v_k$
of its $k\ge2$ children. If |p| is a series node, its children are
joined so that $v_j=u_{j+1}$ for $1\le j<k$; if |p| is a parallel
node, its children are joined together so that $u_1=\cdots=u_k$ and
$v_1=\cdots=v_k$. In both cases |p| is then considered to be a
superedge between $u_1$ and $v_k$.

Let us say that a {\it near-spanning tree\/} of a series-parallel graph
between $u$ and~$v$ is a spanning forest that has exactly two components,
where $u$ and $v$ lie in different components.

If |p| is a series superedge, its spanning trees are spanning trees of all
its children; its near-spanning trees are obtained by designating some child,
then constructing a near-spanning tree for that child and a spanning tree
for each of the other children.

If |p| is a parallel superedge, the roles are reversed: Its near-spanning
trees are near-spanning trees of all its children; its spanning trees are
obtained by designating some child, then constructing a spanning tree for
that child and a near-spanning tree for each of the other children.

We shall assign a Boolean value |p->val| to each leaf node~|p|,
specifying whether the corresponding edge is present or absent in
the current spanning tree being considered.
The |p->val| field of a branch node, similarly, will specify whether
the corresponding superedge currently has
a spanning tree or a near-spanning tree.

In the following algorithm every branch node |p| has a designated child,
|p->des|, with the property that |p->val=p->des->val|.

Only certain combinations of values are legal; the legal ones, according
to the discussion above, are characterized by two rules:

\indent\indent All non-designated children of a series node have value 1;

\indent\indent All non-designated children of a parallel node have value 0.

\noindent In other words, if |q| is the parent of node |p|,
$$\hbox{|p->val|}=\cases{\hbox{|q->val|},&if |p=q->des|;\cr
\noalign{\smallskip}
\hbox{|q->typ|},&if |p!=q->des|.\cr}
$$
For any choice of the designated children, we obtain a unique
spanning tree or near-spanning tree for node~|p| by setting |p->val|
to 1 or~0, respectively, and using this equation to propagate values down
to the leaves.

Thus we can generate all the spanning trees of the graph (namely the
spanning trees corresponding to the |root| node) by setting |root->val=1|
and considering all possible settings of designated children |p->des|
throughout the tree.

However, many settings of the |p->des| pointers will produce the same
result: The value of |p->des| is irrelevant for serial nodes of value~1
and for parallel nodes of value~0. We will return to this problem later;
meanwhile let's put the necessary information into our data structure.

@<Additional fields of a \&{node}@>=
int val; /* 0 = off, open, near-spanning; 1 = on, closed, spanning */
struct node_struct *des; /* the designated child */

@ To start things off, we might as well designate each node's leftmost child.

Mems are computed under the assumption that a node's |typ| and |val| can
be fetched and stored in a single operation.

@<Prepare the first spanning tree@>=
o,topnode->typ=1;
call,init_tree(root,topnode);
trees=1;
if (verbose) @<Print the first tree@>;

@ A few amendments to the data structure will be desirable later, but we're
ready now to write most of the tree-initializing routine.

@<Sub...@>=
void init_tree(node* p,node* par) /* |par| is the parent of |p| */
{
  register node*q;
  ooo,p->val=(par->des==p? par->val: par->typ);
  if (isleaf(p)) @<Further initialization of a leaf node@>@;
  else {
    oo,p->des=p->lchild;
    for (q=p->lchild;;q=q->rsib) {
      call, init_tree(q,p);
      if (o,q->rsib==p->lchild) break;
    }
    @<Further initialization of a branch node@>;
  }
}

@* Diagnostic routines. Several simple subroutines are used to
print all or part of our data structure, as aids to debugging and/or
when the user wants to examine all the spanning trees.

We name the leaves \.a, \.b, \.c, etc., and the branches \.A, \.B, \.C,
etc., as in the example at the beginning of this program.

When I'm debugging this program I plan to save keystrokes and mental energy
by typing, say, |xx('A')| when I want a pointer to node \.A.

@d leafname(p) ('a'+((p)-nodelist))
@d branchname(p) ('A'+((p)-root))
@d nodename(p) (isleaf(p)? leafname(p): branchname(p))

@<Sub...@>=
node*xx(char c)
{
  if (c>='a') return nodelist+(c-'a');
  return nodelist+maxn+(c-'@@');
}

@ @<Sub...@>=
void printleaf(node* p)
{
  printf("%c:%c rsib=%c\n",
    leafname(p),p->val+'0',nodename(p->rsib));
}
@#
void printbranch(node* p)
{
  printf("%c:%c rsib=%c lchild=%c des=%c rchild=%c",
     branchname(p),p->val+'0',nodename(p->rsib),
     nodename(p->lchild),nodename(p->des),nodename(p->rchild));
  @<Print additional fields of a branch node@>;
  printf("\n");
}
@#
void printnode(node* p)
{
  if (isleaf(p)) printleaf(p);
  else printbranch(p);
}

@ @<Sub...@>=
void printtree(node* p,int indent)
{
  register node* q;
  register int k;
  for (k=0;k<indent;k++) printf(" ");
  printnode(p);
  if (!isleaf(p)) for (q=p->lchild;;q=q->rsib) {
    printtree(q,indent+1);
    if (q->rsib==p->lchild) break;
  }
}

@ @<Sub...@>=
void printedges(node*p) /* print the leaves whose value is 1 */
{
  register node* q;
  if (isleaf(p)) {
    if (p->val) printf("%c",leafname(p));
  }@+else@+ for (q=p->lchild;;q=q->rsib) {
    printedges(q);
    if (q->rsib==p->lchild) break;
  }
}

@ @<Print the first tree@>=
{
  if (extraverbose) printtree(root,0);
  printf("The first spanning tree is ");
  printedges(root);
  printf(".\n");
}

@*Overview of the algorithm. A branch node |p| will be called {\it easy\/}
if |p->val=p->typ|. In such cases the designated child |p->des| has
no effect on the spanning tree or near-spanning tree, because all
children have the same value.

Let's say for convenience that the {\it configs\/} of |p| are its
spanning trees if |p->val=1|, its near-spanning trees if |p->val=0|.
Our problem is to generate all configs of the root.

If |p| is easy, its configs are the Cartesian product of the configs
of its children. But if |p| is uneasy, its configs are the union of
such Cartesian products, taken over all possible choices of |p->des|.

Easy nodes are relatively rare: At most one child of an uneasy node
(namely the designated child) can be easy, and all children of easy nodes
are uneasy unless they are leaves.

@d easy(p) o,p->typ==p->val

@ Cartesian products of configurations are easily generated in Gray-code
order, using essentially a mixed-radix Gray code for $n$-tuples.
(See Section 7.2.1.1 of {\sl The Art of Computer Programming}.) In this
program I'm using a ``modular'' code instead of a ``reflected'' one, because
the modular code requires only |rsib| links to cycle through the
possible choices of |p->des|.

Let's include a new field |p->leaf| in each node, pointing to the leaf
that lies at the end of the path from |p| to its designated
descendants |p->des|, |p->des->des|, etc. All the |val| fields
on this path are the same as |p->val|.

When |p->des| is changed from one child to another, say from |q| to |r|,
only two edge values of the overall spanning tree are affected.
Namely, we have |q->typ!=p->typ| and |r->typ=p->typ|, so
|q->leaf->val| becomes |r->typ| and |r->leaf->val|
becomes |q->typ|. Therefore such a change is pleasantly ``Gray.''

@<Additional fields...@>=
struct node_struct *leaf; /* the end of the designated path */
struct node_struct *parent; /* parent of this node */

@ These considerations lead us to the following algorithm to generate
all spanning trees: Begin with all uneasy branch nodes active. Then
repeatedly
\smallskip\itemitem{1)} Select the rightmost active node, |p|, in preorder.
\smallskip\itemitem{2)} Change |p->des| to |p->des->rsib|, update all values
of the tree, and visit the new spanning tree.
\smallskip\itemitem{3)} Activate all uneasy nodes to the right of |p|.
\smallskip\itemitem{4)} If |p->des| has run through all children of |p|
since |p| last became active, make node~|p| passive.
\smallskip\noindent
A field |p->done| is introduced in order to implement step (4): Node~|p|
becomes passive when |p->des=p->done|, and at such a time we reset
|p->done| to the previous value of |p->des|.

Actually |p->done| is initially equal to |p->rchild|, and the |rchild|
pointers are not needed by the main algorithm. So we can equate
|p->done| with |p->rchild|.

@d done rchild /* the new meaning of the |rchild| field */

@ For example, let's apply the algorithm to the series-parallel graph
illustrated in the introduction. Since |A| is a parallel node and since
each leftmost child is initially designated, |init_tree| sets
|A->val=1|, |B->val=0|, |C->val=1|, |D->val=0|, and the first spanning
tree consists of edges $\it aceg$. All four branch nodes are initiallly
uneasy. (That's just a coincidence, not a general rule.)

The current state of the algorithm can be indicated by writing each
designated child as a subscript, by enclosing easy nodes in parentheses,
and by placing a hat over passive nodes. With these conventions,
the algorithm proceeds as follows:
$$\vcenter{\halign{\hbox to2.1em{\hfil$#$\hfil}&
                   \hbox to2.1em{\hfil$#$\hfil}&
                   \hbox to2.1em{\hfil$#$\hfil}&
                   \hbox to2.1em{\hfil$#$\hfil}&
\hskip5em          \hbox to.6em{\hfil$#$\hfil}&
                   \hbox to.6em{\hfil$#$\hfil}&
                   \hbox to.6em{\hfil$#$\hfil}&
                   \hbox to.6em{\hfil$#$\hfil}\cr
\multispan4\hidewidth branch node states\hidewidth&
\multispan4\qquad\qquad spanning tree\cr
\noalign{\smallskip}
A_a&B_b&C_c&D_f&a&c&e&g\cr
A_a&B_b&C_c&\widehat D_g&a&c&e&f\cr
A_a&B_b&\widehat C_d&D_g&a&d&e&f\cr
A_a&B_b&\widehat C_d&\widehat D_f&a&d&e&g\cr
A_a&B_C&(C_d)&D_f&a&b&e&g\cr
A_a&B_C&(C_d)&\widehat D_g&a&b&e&f\cr
A_a&\widehat B_e&C_d&D_g&a&b&d&f\cr
A_a&\widehat B_e&C_d&\widehat D_f&a&b&d&g\cr
A_a&\widehat B_e&\widehat C_c&D_f&a&b&c&g\cr
A_a&\widehat B_e&\widehat C_c&\widehat D_g&a&b&c&f\cr
A_B&(B_e)&C_c&D_g&b&c&e&f\cr
A_B&(B_e)&C_c&\widehat D_f&b&c&e&g\cr
A_B&(B_e)&\widehat C_d&D_f&b&d&e&g\cr
A_B&(B_e)&\widehat C_d&\widehat D_g&b&d&e&f\cr
\widehat A_D&B_e&C_d&(D_g)&b&d&f&g\cr
\widehat A_D&B_e&\widehat C_c&(D_g)&b&c&f&g\cr
\widehat A_D&B_b&C_c&(D_g)&c&e&f&g\cr
\widehat A_D&B_b&\widehat C_d&(D_g)&d&e&f&g\cr
\widehat A_D&\widehat B_C&(C_d)&(D_g)&b&e&f&g\cr
}}$$
Thus, we first change |D->des| from |f| to |g| and passivate~|D|; then we
change |C->des| from |c| to |d| and passivate~|C|. After four steps we
change |B->des| from |b| to |C|, making |C| easy; and so on.

@ So-called ``focus pointers'' can be used to implement steps (1) and (3)
very efficiently, as discussed in Algorithm 7.2.1.1L. We set |p->focus=p|
except when |p| is an uneasy node such that the nearest uneasy node to
its right is active. We also imagine that an artificial uneasy active
node appears to the right of |curnode|, which is the rightmost
branch node of the entire tree in preorder. Then the simple operations
$$\hbox{|p=r->focus|, \  |r->focus=r|}$$
implement (1) and (3), when |r| is the rightmost uneasy node---in spite
of the fact that step (2) changes some nodes from easy to uneasy
and vice versa(!).

Furthermore, we can passivate node |p| in step (4) by the simple operations
$$\hbox{|p->focus=l->focus|, \ |l->focus=l|}$$
when |l| is the rightmost uneasy node to the left of |p|. We imagine
that |topnode|, which lies to the left of everything in preorder,
is always uneasy and active; therefore |l| always exists. Step~(1)
stops if |p=topnode|, since we have then generated all the spanning trees.

@<Additional fields...@>=
struct node_struct *focus; /* the magical Gray-oriented focus pointer */

@ We can easily incorporate the new fields into our initialization
routine. It will turn out that the algorithm doesn't really have to
look at |leaf| or |parent| pointers, so no mems are charged for the cost of
computing them.

@<Further initialization of a leaf node@>=
p->leaf=p, p->parent=par;

@ @<Further initialization of a branch node@>=
p->leaf=p->des->leaf, p->parent=par;
o,p->focus=p;

@ @<Print additional fields of a branch node@>=
printf(" leaf=%c",leafname(p->leaf));
if (p->focus!=p) printf(" focus=%c",branchname(p->focus));

@*Doing it. Let's go ahead now and implement the algorithm just sketched.

@<Do the algorithm@>=
topnode->focus=topnode;
while (1) {
  register node *p, *q, *l, *r;
  for (r=curnode;easy(r);r--); /* find the rightmost uneasy node */
  oo,p=r->focus, r->focus=r; /* steps (1) and (3) */
  if (p==topnode) break;
  @<Change |p->des| and visit a new spanning tree@>;
  if (o,p->des==p->done) @<Passivate |p|@>;
}

@ All uneasy nodes to the right of |p| are now active, and |l| is the
former |p->des|.

@<Passivate |p|@>=
{
  o,p->done=l;
  for (l=p-1;easy(l);l--); /* find the first uneasy node to the left */
  ooo,p->focus=l->focus, l->focus=l;
}

@ If the user has asked for |verbose| output, we print only the
edge that has entered the spanning tree and the edge that has left.

@<Change |p->des| and visit a new spanning tree@>=
oo,l=p->des, r=l->rsib;
o,k=p->val; /* |k=l->val!=r->val| */
for (q=l;;o,q=q->des) {
  o,q->val=k^1;
  if (isleaf(q)) break;
}
if (verbose) printf(" %c%c",k? '-': '+',leafname(q));
for (q=r;;o,q=q->des) {
  o,q->val=k;
  if (isleaf(q)) break;
}
if (verbose) printf("%c%c\n",k? '+': '-',leafname(q));
o,p->des=r, trees++; /* ``visiting'' */
for (q=p; q->des==r; r=q,q=q->parent) q->leaf=r->leaf;
/* that loop was optional, so it costs no mems */
if (extraverbose) {
  printedges(root);
  printf("; now %c->leaf=%c\n",branchname(r),leafname(r->leaf));
}

@* A loopless version. The algorithm implemented here contains four
loops. Two of them skip over easy nodes when finding |r| and |l|
in the list of branches; two of them go down from branches to leaves
when changing the |val| fields.

The amortized cost of those loops is constant per new spanning tree.
But it can be instructive to search for an algorithm that is entirely
loopfree, in the sense that the number of operations per new tree
is bounded (once the algorithm has initialized itself in linear time).

Loopless algorithms tend to run slower than their loopy counterparts,
especially in cases like the present where the additional overhead
needed to avoid looping appears to be substantial. So the search
for a loopless implementation is strictly academic. Yet it still
was fascinating enough to keep me working on it for three days
during my recent vacation.

I believe I see how to do it. But I don't have time to carry through
the details, so I've decided just to sketch them here. Maybe somebody
else will be inspired to work them out and to compare the
loopless mem-counts with those of the present implementation.

The first two loops can be avoided by changing the tree dynamically,
so that the designated child is always the leftmost. In such cases
it's easy to see that no two easy nodes can be consecutive in preorder.
My planned implementation swaps the rightmost child into the leftmost
position when |p->des| is supposed to change. This swapping causes two
adjacent substrings of the preordered node list to change places.
The node list should be doubly linked;
to do the swap, we need a new field |p->scope| that points to the
rightmost branch that is descended from |p| in the current list.

The other two loops can be avoided if we update the |val| fields lazily,
starting at the bottom.  But then the pointer |p->leaf| becomes
crucial, not optional, because the leaf nodes are encountered first,
and because we need to know both |p->leaf| and |p->rchild->leaf| when
reporting the edges that enter and leave the spanning tree.

Of course the introduction of two required fields |p->scope| and
|p->leaf| means that we must maintain them, and that seems to require
additional loops that were not needed in the present implementation.
Fortunately we don't have to update them instantly; they only have
to be valid when |p| is the critical node in step~(2) of the
algorithm.

My solution is to introduce two additional fields for ``registration.''
Consider a sequence of nodes $p_1$, $p_2$, \dots, $p_k$ where
$p_{j+1}$ is the rightmost child of $p_j$ for $1\le j<k$, and where
$p_1$ and $p_k$ are active but the others are either easy or passive.
The easy ones among $p_2$, \dots, $p_{k-1}$ are not consecutive;
the uneasy ones most recently went passive in order, from left to right.
When $p=p_k$
is the critical node, we're going to rearrange the tree below $p$;
and if |p| is then going to become passive, we have reached
our last chance to update the scope link of $p_1$.

Node $p$ can find $p_1$ using focus pointers,
because $p_1$ is the rightmost active node to its left.
But we need to verify that there really is a path from $p_1$ to $p_k$
as described, because we mustn't screw up the |scope| links of random nodes.
Let |p| be the critical node, and let |q| be the first active node to its left.
Go up one or two levels from |p| via |parent| pointers until reaching
an uneasy node, say |u|; but stop if this upward motion is
not from the rightmost branch-child to a parent. Otherwise,
if |q=u|, great; we update |q->scope| and
we're done. Or if |q=u->registry|, where |registry| is a new field
to be discussed further, again we update |q->scope|. Otherwise we
conclude that |q| is not the top of the food chain to |p|.

When the critical node |p| becomes passive, after a case where |q->scope|
has been updated, we set |p->registry=q|, and |u->registry=NULL| in the
case that |q=u->registry|. This handshaking passes the required information
down the tree, and doesn't leave spurious non-null |registry| values
that could lead to false diagnoses.

A similar method works to maintain the |leaf| pointers, which are
similar but based on leftmost instead of rightmost children. Instead
of |p->registry|, I should have spoken of |p->scope_registry| and
|p->leaf_registry|.

(Whew.)

@*Index.
