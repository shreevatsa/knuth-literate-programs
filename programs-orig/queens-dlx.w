\datethis
@* Data for dancing. This program creates data in {\mc DLX} format,
solving the famous ``$n$ queens problem.'' The value of~$n$
is a command-line parameter. (I hacked it from the old program {\mc QUEENS}.)

@c
#include <stdio.h>
#include <stdlib.h>
int pn;
@<Subroutines@>;
@#
main(int argc,char*argv[])
{
  register int j,k,n,nn,t;
  @<Read the command line@>;
  @<Output the column names@>;
  @<Output the possible queen moves@>;
}

@ @<Read the command line@>=
if (argc!=2 || sscanf(argv[1],"%d",&pn)!=1) {
  fprintf(stderr,"Usage: %s n\n",argv[0]);
  exit(-1);
}
n=pn,nn=n+n-2;
if (nn>62) {
  fprintf(stderr,"Sorry, I can't currently handle n>32!\n");
  exit(-2);
}
printf("| This data produced by %s %d\n",
                       argv[0],n);

@ We process the cells of the board in ``organ pipe order,'' on the assumption
that---all other things being equal---a move near the center yields more
constraints on the subsequent search.

@<Output the column names@>=
for (j=0;j<n;j++) {
  t=(j&1? n-1-j: n+j)>>1;
  printf("r%c c%c ",encode(t),encode(t));
}
printf("|");
for (j=1;j<nn;j++) printf(" a%c b%c",encode(j),encode(j));
printf("\n");

@ @<Sub...@>=
char encode(x)
  int x;
{
  if (x<10) return '0'+x;
  else if (x<36) return 'a'+x-10;
  else return 'A'+x-36;
}

@ @<Output the possible queen moves@>=
for (j=0;j<n;j++) for (k=0;k<n;k++) {
    printf("r%c c%c",encode(j),encode(k));
    t=j+k;
    if (t && (t<nn)) printf(" a%c",encode(t));
    t=n-1-j+k;
    if (t && (t<nn)) printf(" b%c",encode(t));
    printf("\n");
}

@*Index.
