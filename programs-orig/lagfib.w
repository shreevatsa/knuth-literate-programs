\datethis
@*Introduction. This is a quick-and-dirty program related to
exercise 3.6--14. I'm finding how many terms appear in the representation of
$z^n$ with respect to bases of the form $z^0$, \dots,~$z^{t-1}$,
$z^{n-r+t}$, \dots,~$z^{n-1}$, modulo $z^r+z^{r-s}+1$ and mod~2,
where $1\le t\le r$.

@d r 100 /* the longer lag */
@d s 37 /* the shorter lag */
@d n 400 /* the number of elements generated simultaneously by |ran_array| */

@c
#include <stdio.h>
@<Global variables@>

main()
{
  register int i,j,k,m,t;
  @<Initialize for the case $t=r$@>;
  while (t) {
    @<Gather statistics for case $t$@>;
    t--;
    @<Change the basis to eliminate $z^t$@>;
  }
  @<Print the statistics@>;
}

@ The representation of $z^k=a_{k0}z^{b_0}+\cdots+a_{k(r-1)}z^{b_{r-1}}$
appears in arrays |a| and~|b|. The largest power of~$z$ less than $z^n$ that
is not in the basis is $z^m$.

@<Glob...@>=
int a[n+1][r]; /* I could make this |char|, but |int| aids debugging */
int b[r]; /* identifies the basis */
int c[r],d[n+2]; /* for working storage */
int p[n]; /* is this power of $z$ in the basis? */

@ @<Initialize for the case $t=r$@>=
for (k=0;k<r;k++) {
  a[k][k]=1;
  b[k]=k;
  p[k]=1;
}
for (;k<=n;k++) {
  for (j=1;j<r;j++) a[k][j]=a[k-1][j-1]; /* $z^k=z\cdot z^{k-1}$ */
  if (a[k-1][r-1]) {
    a[k][0]=1;
    a[k][r-s]^=1;
  }
}
m=n-1;
t=r;

@ @<Change the basis to eliminate $z^t$@>=
for (k=m;a[k][t]==0;k--) ;
b[t]=k;
for (j=0;j<r;j++) c[j]=a[k][j];
c[t]=0;
p[t]=0; p[k]=1;
for (;k>=t;k--)
  if (a[k][t])
    for (j=0;j<r;j++) a[k][j] ^= c[j];
if (a[n][t])
  for (j=0;j<r;j++) a[n][j] ^= c[j];
while (p[m]==1) m--;

@ We are interested in the number of nonzero coefficients in the
representation of~$z^n$. However, if this representation depends on
any of the ``forbidden'' powers $z^t$, \dots,~$z^{n-r+t-1}$, we want
rather to exhibit the representation of~$z^m$.

@<Gather statistics for case $t$@>=
{
  register int forbidden=0;
  for (j=0,i=0;j<r;j++) if (a[n][j]) {
    if (b[j]<n-r+t && b[j]>=t) forbidden=1;
    else i++;
  }
  if (forbidden) @<Print out an interesting linear dependency@>@;
  else stat[i]++;
}

@ @<Glob...@>=
int stat[r+1]; /* the number of cases with a given number of nonzero terms */

@ @<Print out an interesting linear dependency@>=
{
  for (i=0;i<n;i++) d[i]=0;
  for (j=0;j<r;j++) if (a[m][j]) d[b[j]]=1;
  d[m]=1; d[n]=1;
  printf("%d:",t);
  for (i=0;;) {
    while (d[i]==0) i++;
    if (i==n) break;
    printf(" %d",i);
    while (d[i]==1) i++;
    if (i>n) i=n;
    printf("..%d",i-1);
  }
  printf("\n");
}

@ @<Print the statistics@>=
for (j=0;j<=r;j++) printf(" %3d: %d\n",j,stat[j]);

@* Index.

