@*Intro. This program solves exercise 6.2.2--50 of {\sl The Art of
Computer Programming\/} (which was added to Volume 3 in September, 2021,
just in time for the 43rd printing!). Here's the statement of that exercise:
\medskip
{\narrower
\noindent{\bf50.}
 [30] Let $p_1p_2\ldots p_n$ be a permutation of $\{1,2,\ldots,n\}$.
Suppose the values $p_1$, $p_2$, \dots,~$p_n$ have been inserted successively
into an initially empty binary tree using Algorithm~T, but with $\.Q\gets K$
in step~T5 when storing key~$K$. Explain how to compute all of
the resulting links
\.{LLINK($k$)} and \.{RLINK($k$)} for $1\le k\le n$ in just $O(n)$ steps.
$\bigl($For example, the permutation 3142 would yield
$(\.{LLINK($1$)},\ldots,\.{LLINK($4$)})=(\Lambda,\Lambda,1,\Lambda) $ and
$(\.{RLINK($1$)},\ldots,\.{RLINK($4$)})=(2,\Lambda,4,\Lambda)$.$\bigr)$
\par
}
\medskip
\noindent
The following solution, suggested by Robert E. Tarjan, implicitly uses the
one-to-one correspondence between binary search trees and binary
tournaments in \S3 of Jean Vuillemin's classic paper ``Cartesian trees,''
{\sl Communications of the ACM\/ \bf23} (1980), 229--239. (Stating this
another way, it implicitly uses the fact that the binary search tree
defined by a permutation has the same shape as the ``increasing binary tree''
defined by the {\it inverse\/} of that permutation. The increasing
binary tree defined by a permutation retains symmetric order, but
forces all paths from the root to be increasing.)

@ The given permutation should appear on |stdin|, as the sequence of
numbers $p_1$ $p_2$ \dots~$p_n$, separated by whitespace.
The output on |stdout| will show the root, followed on separate lines
by the links of 1, 2, \dots, $n$.

@d maxn 1024
@d panic(m,k) {@+fprintf(stderr,"%s! (%d)\n",
                   m,k);@+exit(-666);@+}
@d pan(m) {@+fprintf(stderr,"%s!\n",
                     m);@+exit(-66);@+}

@c
#include <stdio.h>
#include <stdlib.h>
int p[maxn+2]; /* the given permutation */
int q[maxn+2]; /* its inverse */
int stack[maxn+1]; /* the working stack */
int stackx[maxn+1]; /* indexes associated with the working stack */
int llink[maxn+2],rlink[maxn+1]; /* the answers */
int inx; /* a place for input data from |fscanf| */
void main(void) {
  register int i,j,k,m,n,s;
  @<Input the permutation@>;
  @<Compute the links@>;
  @<Output the links@>;
}

@*Input.
Let's get the boring stuff out of the way. Our first task is to
input the permutation, and check that it makes sense.

@<Input the permutation@>=
for (m=n=0;fscanf(stdin,"%d",
                          &inx)==1;n++) {
  if (inx<=0 || inx>maxn) panic("element out of range",inx);
  if (inx>m) m=inx;
  p[n+1]=inx;
}
if (n==0) pan("the permutation must have at least one element");
if (m>n) panic("too few elements",m-n);
if (m>n) panic("too many elements",n-m);
for (k=1;k<=n;k++) q[p[k]]=k; /* compute the inverse */
for (k=1;k<=n;k++) if (q[k]==0) panic("missing element",k);

@*Doin' it.
During this algorithm, which is amazingly short and sweet,
we'll have $0=|stack|[0]<|stack|[1]<\cdots<|stack|[s]$, where
the stack elements will be a subsequence of $q[1]$, $q[2]$, \dots,~$q[n]$.
If |stack[t]| came from |q[k]|, |stackx[t]| will be~|k|.

The basic idea is that every element will be pointed to by one link.
As soon as we know that some node~$i$ will point to another node~$j$, we
store that link and essentially remove~$j$ from the system.
(In other words, we compute the tree bottom-up.)

We assume that the |llink| and |rlink| arrays are initially zero,
and that zero represents a null link.

@<Compute the links@>=
stack[0]=stackx[0]=0;
stack[1]=q[1],stackx[1]=1,s=1;
q[n+1]=0;
for (k=2;s>0 || k<=n;) {
  if (stack[s]<q[k]) s++,stack[s]=q[k],stackx[s]=k++;
  else if (stack[s-1]>q[k]) s--,rlink[stackx[s]]=stackx[s+1];
  else s--,llink[k]=stackx[s+1];
}

@ Curiously, the very same algorithm (in slight disguise) was published
on page 317 of a paper by Johnson~M. Hart
[``Fast recognition of Baxter permutations using syntactical and
complete bipartite composite dag's,'' % 's sic
{\sl International Journal of Computer and Information Sciences\/ \bf9}
(1980), 307--321] ---
but not in the context of binary trees. His context was ``complete
bipartite composite digraphs,'' which are a convoluted way of
formalizing floorplans(!).

@*Output.
Finally |s| will become zero when |k=n+1|, because |q[n+1]=0|.

@<Output the links@>=
printf("The root is %d.\n",
                   llink[n+1]);
for (k=1;k<=n;k++) {
  printf("%5d:",
               k);
  if (llink[k]) printf("%5d,",
                           llink[k]);
  else printf("   /\\,");
  if (rlink[k]) printf("%5d.\n",
                           rlink[k]);
  else printf("   /\\.\n");
}

@*Index.
