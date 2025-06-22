@*Intro. On 07 June 2024, Jim Propp told me about an interesting bijective
mapping on (ordered) trees that have more than node: ``The rightmost
child of the old root becomes the new root, and the old root becomes its
leftmost child.'' (If the old children are $c_1$, \dots, $c_k$, the new children
are the children of $c_k$ preceded by a subtree whose children are
$c_1$, \dots, $c_{k-1}$.) This mapping preserves the order of leaves.
The main point is that {\sl every node previously on an even level
is now on an odd level, and vice versa.}

While playing with this transformation, I noticed that the number
of trees that have $m$ nodes on odd levels and $n$ nodes on even levels,
for $m,n>0$, is the Narayana number
$$T(m,n)={(m+n-1)!\,(m+n-2)!\over m!\,(m-1)!\,n!\,(n-1)!},$$
which is well known to be the number of binary trees that have
$m$ null left links and $n$ null right links.
(The tree has $m+n$ nodes; the binary tree has $m+n-1$ nodes,
$n-1$ nonnull left links, and $m-1$ nonnull right links.
See, for example, exercise 2.3.4.6--3 in
{\sl The Art of Computer Programming}.)

So I looked for a bijection between such trees and such binary trees.

This program implements the bijection that I came up with. In a sense, it's
a sequel to my ``Three Catalan bijections,''
{\sl Institut Mittag-Leffler Reports}, No.~04, 2004/2005, Spring (2005), 19~pp.

Unfortunately, I don't have time to provide extensive comments.
Let the code speak for itself.

@d nodes 17 /* nodes in the tree; must be at least 2 */
@d vbose 0 /* set this nonzero to see details */

@c
#include <stdio.h>
int llink[nodes+1],rlink[nodes];
  /* links of the binary tree */
int lchild[nodes+1],rsib[nodes+1];
  /* leftmost child and right sibling in the tree */
int count[nodes];
@<Subroutines@>;
main() {
  register j,k,y;
  printf("Checking all trees with %d nodes...\n",
                                       nodes);
  @<Initialize Skarbek's algorithm@>;
  while (1) {
    @<Find the tree |(lchild,rsib)| that corresponds to
       the binary tree |(llink,rlink)|@>;
    if (vbose) @<Print the trees@>;
    @<Check the null link counts and the level parity counts@>;
    @<Move to the next binary tree |(llink,rlink)|, or |break|@>;
  }
  for (k=1;count[k];k++)
    printf("Altogether %d case%s with %d node%s at odd levels.\n",
           count[k],count[k]==1?"":"s",k,k==1?"":"s");
}

@ @<Print the trees@>=
{
  print_binary_tree();
  printf(" -> ");
  print_tree();
  printf("\n");
}

@ @d encode(x) ((x)<10? '0'+(x): 'a'+(x)-10)

@<Sub...@>=
void print_binary_tree(void) {
  register int k;
  for (k=1;k<nodes;k++) printf("%c",
                              encode(llink[k]));
  printf("|");
  for (k=1;k<nodes;k++) printf("%c",
                              encode(rlink[k]));
}
@#
void print_tree(void) {
  register int k;
  for (k=1;k<=nodes;k++) printf("%c",
                              encode(lchild[k]));
  printf("|");
  for (k=1;k<=nodes;k++) printf("%c",
                              encode(rsib[k]));
}

@ Skarbek's elegant algorithm (Algorithm 7.2.1.6B in {\sl The Art of
Computer Programming}, Volume~4A) is used to run through
all linked binary trees with |nodes-1| nodes.

@<Initialize Skarbek's algorithm@>=
for (k=1;k<nodes-1;k++) llink[k]=k+1,rlink[k]=0;
llink[nodes-1]=rlink[nodes-1]=0;
llink[nodes]=1;

@ @<Move to the next binary tree |(llink,rlink)|, or |break|@>=
for (j=1;!llink[j];j++) rlink[j]=0, llink[j]=j+1;
if (j==nodes) break;
for (k=0,y=llink[j];rlink[y];k=y,y=rlink[y]) ;
if (k) rlink[k]=0;@+else llink[j]=0;
rlink[y]=rlink[j], rlink[j]=y;

@ The bijection is implemented by a recursive procedure, which
has three parameters: |p| is the index of the first node not
already created; |r| is the root of the binary tree to be
converted to a tree; |parity| is 1 if we are interchanging
|llink| with |rlink|.

This procedure returns the index of the root node of the constructed tree.

@<Subroutines@>=
int propp(int p,int r,int parity) {
  register lam,rho;
  if (r==0) {
    lchild[p]=rsib[p]=0;
    return p;
  }
  if (parity==0) {
    lam=propp(p,llink[r],1);
    rho=propp(lam+1,rlink[r],0);
  }@+else {
    lam=propp(p,rlink[r],0);
    rho=propp(lam+1,llink[r],1);
  }
  rsib[lam]=lchild[rho], lchild[rho]=lam;
  return rho; /* note that |rsib[rho]=0| */
}

@ @<Find the tree |(lchild,rsib)| that corresponds to
       the binary tree |(llink,rlink)|@>=
if (propp(1,1,0)!=nodes)
  fprintf(stderr,"I'm confused!\n");

@ The |lcount| routine determines how many nodes of a given
nonempty tree, rooted at |r|, are at a level with a given parity.
(The root is at level zero.)

@<Sub...@>=
int lcount(int r,int parity) {
  register int c,p;
  for (c=1-parity,p=lchild[r];p;p=rsib[p]) c+=lcount(p,1-parity);
  return c;
}

@ @<Check the null link counts and the level parity counts@>=
for (j=0,k=1;k<nodes;k++) if (llink[k]==0) j++;
if (j!=lcount(nodes,1)) {
  printf("Mismatch! ");
  @<Print the trees@>;
}
count[j]++;

@*Index.


