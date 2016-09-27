\datethis
@* Data for dancing. This program creates data suitable for the {\mc DANCE}
routine, solving the famous ``$n$ queens problem.'' The value of~$n$
is a command-line parameter.

@c
#include <stdio.h>
@<Global variables@>@;
@<Subroutines@>;
@#
main(argc,argv)
  int argc;
  char *argv[];
{
  register int j,k,n,nn,t;
  @<Read the command line@>;
  @<Output the column names@>;
  @<Output the possible queen moves@>;
}

@ @<Read the command line@>=
if (argc!=2 || sscanf(argv[1],"%d",&param)!=1) {
  fprintf(stderr,"Usage: %s n\n",argv[0]);
  exit(-1);
}
n=param;
nn=n+n-2;

@ @<Glob...@>=
int param;

@ We proces the cells of the board in ``organ pipe order,'' on the assumption
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
  return 'a'-10+x;
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
