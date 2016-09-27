\datethis
@*Intro. This simple program calculates Schensted's Y function.
Consider the array
$$\let\\=\null\catcode`\ =\active\def {\ }\vcenter{\halign{\tt#\hfil\cr
\\    x\cr
\\   x x        x     \cr
\\  x o o      x o      x\cr
\\ o o x x    o o x    o o    o\cr
\\x o x x x  o o x x  o o x  o o  o\cr
}}.$$
The first nine columns of these five rows were given as standard input;
this array shows the standard output.

In general the standard input should consist of $n+1$ lines of $2n+1$
characters, for some $n$, using only spaces and \.x's and \.o's.
(Otherwise who knows what might occur. I wrote this in a terrific hurry.)

@d maxn 100

@c
#include <stdio.h>
char a[maxn+1][maxn+1][maxn+maxn+1];
main() {
  register int i,j,k,n,s;
  @<Read the input into a[0], determining |n|@>;
  for (k=1;k<=n;k++) @<Compute |a[k]| from |a[k-1]|@>;
  @<Print the results@>;
}

@ @<Read the input into a[0], determining |n|@>=
fgets(a[0][0],maxn+2,stdin);
for (n=0;a[0][0][n]==' ';n++);
a[0][0][n+n+1]='\0';
for (k=1;k<=n;k++) {
  fgets(a[0][k],maxn+2,stdin);
  a[0][k][n+n+1]=0;
}

@ @<Compute |a[k]| from |a[k-1]|@>=
for (j=0;j<=n-k;j++) {
  for (i=0;i<=n+n-k-k;i++) a[k][j][i]=' ';
  for (i=n-k-j;i<=n-k+j;i+=2) {
    s=0;
    if (a[k-1][j][i+1]=='o') s++;
    if (a[k-1][j+1][i]=='o') s++;
    if (a[k-1][j+1][i+2]=='o') s++;
    a[k][j][i]=(s>1? 'o': 'x');
  }
}

@ @<Print the results@>=
for (k=0;k<=n;k++) {
  printf(a[0][k]);
  for (j=1;j<=k;j++) printf("  %s",a[j][k-j]);
  printf("\n");
}

@*Index.
