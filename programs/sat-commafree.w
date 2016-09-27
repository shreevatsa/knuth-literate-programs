@*Intro. Find a comma-free block code of length $n$, having one code
in each cyclic equivalence class, if one exists.

Codewords are represented as hexadecimal numbers.

@d maxn 25 /* must be at most 32, to keep the variable names small */

@c
#include <stdio.h>
#include <stdlib.h>
int n; /* command-line parameter */
char a[maxn+1];
main(int argc,char*argv[]) {
  register int i,j,k;
  register unsigned int x,y,z;
  register unsigned long long m,acc,xy;
  @<Process the command line@>;
  @<Generate the positive clauses@>;
  @<Generate the negative clauses@>;
}

@ @<Process the command line@>=
if (argc!=2 || sscanf(argv[1],"%d",&n)!=1) {
  fprintf(stderr,"Usage: %s n\n",argv[0]);
  exit(-1);
}
if (n<2 || n>maxn) {
  fprintf(stderr,"n should be between 2 and %d, not %d!\n",maxn,n);
  exit(-2);
}
printf("~ sat-commafree %d\n",n);

@ Here I use Algorithm 7.2.1.1F to find the prime binary strings.

@<Generate the pos...@>=
f1: a[0]=-1, j=1;
f2:@+if (j==n) @<Visit the prime string $a_1\ldots a_n$@>;
f3:@+for (j=n;a[j]==1;j--);
f4:@+if (j) {
  a[j]=1;
f5:@+for (k=j+1;k<=n;k++) a[k]=a[k-j];
  goto f2;
}

@ @<Visit the prime string $a_1\ldots a_n$@>=
{
  for (i=0;i<n;i++) {
    for (x=0,k=0;k<n;k++)
      x=(x<<1)+a[1+((i+k)%n)];
    printf(" %x",x);
  }
  printf("\n");
}

@ @<Generate the neg...@>=
m=(1LL<<n)-1;
for (x=0;x<(1<<n);x++) {
  @<If |x| is cyclic, |continue|@>;
  for (y=0;y<(1<<n);y++) {
    @<If |y| is cyclic, |continue|@>;
    @<Generate the clauses for |x| followed by |y|@>;
  }
}

@ @<If |x| is cyclic, |continue|@>=
acc=(((unsigned long long)x)<<n)+x;
for (k=1;k<n;k++)
  if (((acc>>k)&m)==x) break;
if (k<n) continue;
      
@ @<If |y| is cyclic, |continue|@>=
acc=(((unsigned long long)y)<<n)+y;
for (k=1;k<n;k++)
  if (((acc>>k)&m)==y) break;
if (k<n) continue;
      
@ @<If |z| is cyclic, |continue|@>=
acc=(((unsigned long long)z)<<n)+z;
for (k=1;k<n;k++)
  if (((acc>>k)&m)==z) break;
if (k<n) continue;
      
@ @<Generate the clauses for |x| followed by |y|@>=
xy=(((unsigned long long)x)<<n)+y;
for (j=1;j<n;j++) {
  z=(xy>>j)&m;
  @<If |z| is cyclic, |continue|@>;
  printf("~%x ~%x ~%x\n",
            x,y,z);
}

@*Index.
