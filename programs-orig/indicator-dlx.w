@*Intro. This program generates {\mc DLX} data that finds all polymorphisms
of given relations. I've tried to make it fairly general, so that I can
use it for experiments. But I haven't tried to make it especially efficient.

The first command-line parameter is $d$, the domain size.
It is followed by $k$, the arity of the polymorphism.
Then come the tuples of a relation. And the next parameter
might then be `\.{/}', in which case another relation (or sequence
of relations) follows.

@d maxk 7 /* maximum arity of the polymorphism */
@d maxm 10 /* maximum arity of the relations */
@d maxr 10 /* maximum number of relations */
@d maxt 16 /* maximum number of tuples per relation */

@c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int d,k; /* command-line parameters */
char tup[maxr][maxt][maxm]; /* tuples of the relations */
char siz[maxr]; /* the number of tuples in each relation */
char arity[maxr]; /* the arity of each relation */
char a[maxk]; /* controlling digits */
int nam[maxk]; /* hexadecimal names of arguments */
main(int argc,char*argv[]) {
  register i,j,l,m,p,r,s,t,v;
  @<Process the command line@>;
  @<Echo the command line@>;
  @<Print the item-name line@>;
  for (i=0;i<r;i++) @<Print the options for relation |i|@>;
}

@ @<Process the command line@>=
if (argc<3 || sscanf(argv[1],"%d",
                               &d)!=1 || sscanf(argv[2],"%d",
                               &k)!=1) {
  fprintf(stderr,"Usage: %s d k <tuples> [/ <tuples>]*\n",
               argv[0]);
  exit(-1);
}
if (k<=0 || k>maxk) {
  fprintf(stderr,"Sorry, k must be positive and at most %d!\n",
                   maxk);
  exit(-2);
}
for (r=0,p=3;r<maxr;r++) @<Input relation |r|@>;
if (r==maxr) {
  fprintf(stderr,"Too many relations (maxr=%d)!\n",
                              maxr@t)@>);
  exit(-9);
}
@<Report successful command line@>;

@ @<Input relation |r|@>=
{
  for (s=0;argv[p] && argv[p][0]!='/';p++,s++) {
    if (s==0) m=strlen(argv[p]);
    else if (m!=strlen(argv[p])) {
      fprintf(stderr,"tuple %s should have length %d, not %d!\n",
                                    argv[p],m,(int)strlen(argv[p]));
      exit(-3);
    }
    if (s==maxt) {
      fprintf(stderr,"too many tuples (maxt=%d)!\n",
                                   maxt@t)@>);
      exit(-4);
    }
    for (j=0;j<m;j++) {
      v=argv[p][j]-'0';
      if (v<0 || v>=d) {
        fprintf(stderr,"value in tuple %s is out of range!\n",
                                  argv[p]);
        exit(-4);
      }
      tup[r][s][j]=v;
    }
  }
  if (s==0) {
    fprintf(stderr,"Empty relation (no tuples)!\n");
    exit(-5);
  }
  siz[r]=s, arity[r]=m;
  if (!argv[p++]) break;
}

@ @<Report successful command line@>=
r++;
fprintf(stderr,"OK, I've input %d relation%s of size%s!arit%s",
   r,r==1?"":"s",r==1?"":"s",r==1?"y":"ies");
for (j=0;j<r;j++) fprintf(stderr," %d!%d",
                        siz[j],arity[j]);
fprintf(stderr,".\n");

@ @<Echo the command line@>=
printf("|");
for (j=0;j<argc;j++) printf(" %s",
              argv[j]);
printf("\n");

@ Each relation $r$ of size $s$ has $s^k$ primary items, \.{r$a_1\ldots a_k$},
one for each constraint between a particular combination of $m$-tuples in
that relation. (Relation $r$ is identified by its code letter |'a'+r|.)

There are $d^k$ secondary items $x_1\ldots x_k$, one for each combination
of arguments. The color of $x_1\dots x_k$ is the value of the polymorphism
at those arguments.

@<Print the item-name line@>=
for (i=0;i<r;i++) {
  for (j=0;j<k;j++) a[j]=0;
  while (1) {
    printf("%c",
               'a'+i);
    for (j=0;j<k;j++) printf("%x",
                              a[j]);
    printf(" ");
    for (j=k-1;j>=0 && a[j]==siz[i]-1;j--) a[j]=0;
    if (j<0) break;
    a[j]++;
  }
}
printf("|");
for (j=0;j<k;j++) a[j]=0;
while (1) {
  printf(" ");
  for (j=0;j<k;j++) printf("%x",
                             a[j]);
  for (j=k-1;j>=0 && a[j]==d-1;j--) a[j]=0;
  if (j<0) break;
  a[j]++;
}
printf("\n");

@ @<Print the options for relation |i|@>=
{
  for (j=0;j<k;j++) a[j]=0;
  while (1) {
    for (j=0;j<arity[i];j++) {
      for (v=p=0;p<k;p++) v=(v<<4)+tup[i][a[p]][j];
      nam[j]=v;
    }
    for (t=0;t<siz[i];t++) {
      for (j=0;j<arity[i];j++) for (l=0;l<j;l++)
        if (nam[l]==nam[j] && tup[i][t][l]!=tup[i][t][j]) goto next_t;
      printf("%c",
                   'a'+i);
      for (j=0;j<k;j++) printf("%x",
                             a[j]);
      for (j=0;j<arity[i];j++) {
        for (l=0;l<j;l++) if (nam[l]==nam[j]) break;
        if (l<j) continue;
        printf(" %0*x:%x",
                  k,nam[j],tup[i][t][j]);
      }
      printf("\n");
next_t:@+continue;
    }
    for (j=k-1;j>=0 && a[j]==siz[i]-1;j--) a[j]=0;
    if (j<0) break;
    a[j]++;
  }
}

@*Index.
