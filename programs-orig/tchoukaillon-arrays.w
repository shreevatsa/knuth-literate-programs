\font\rus=lhwnr8 \def\cha{\hbox{\rus Ch}}%

@*Intro. Testing a formula in exercise 7.5.1--12.

@d maxn 32
@d maxm 32

@c
#include <stdio.h>
#include <stdlib.h>
int cha[maxn][maxm][maxn];
@<Subroutine@>;
main() {
  register i,j,k;
  for (i=0;i<maxm;i++) for (j=0;j<maxn;j++) compute(maxn-1,i,j);
  for (k=2;k<maxn;k++) {
    printf("Tchoukaillon array of order %d:\n",
                           k+1);
    for (i=0;i<maxm;i++) {
      for (j=0;j<=k;j++) printf("%4d",
                             cha[k][i][j]);
      printf("\n");
    }
  }
}

@ @<Sub...@>=
int compute(int n,int i, int j) { /* computes $\cha^{(n+1)}_{i,j}$ */
  register int q,r,v;
  if (n==0) return i+1;
  q=i/n, r=i-q*n;
  if (j+r<n) v=compute(n-1,q*(n+1)+r,j);
  else v=compute(n-1,q*(n+1)+r+1,j-1);  
  if (i<maxm) cha[n][i][j]=v;
  return v;
}  

@*Index.
