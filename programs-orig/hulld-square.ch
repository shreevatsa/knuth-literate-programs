% change file to test deletions in hull algorithms
@x
\nocon
@y
\nocon
\let\maybe=\iffalse
\def\title{\expandafter\uppercase\expandafter{\jobname\ (nonrandom deletions)}}
@z
@x
#include "gb_graph.h"
@y
#include "gb_rand.h"
#include "gb_graph.h"
@z
@x
main()
{
  @<Local variables@>@;
  Graph *g=miles(128,0,0,0,0,0,0);
@#
@y
main(argc,argv)
  int argc;
  char **argv;
{
  @<Local variables@>@;
  Graph *g;
  int kk,kkk,xrnd,yrnd;
  char str[10];
@#
  if (argc!=2) n=100;
  else if (sscanf(argv[1],"%d",&n)!=1) {
    printf("Usage: %s [n]\n",argv[0]);@+exit(1);
  }
  else if (n<20) {
    printf("n should be at least 20!\n");@+exit(1);
  }
  g=gb_new_graph(n);
  gb_init_rand(0);
  for (kk=0,v=g->vertices; kk<n; kk++,v++) {
    sprintf(str,"%d",kk);
    v->name=gb_save_string(str);
    kkk=kk/(n/10)+1;
    kkk=kkk*kkk*100;
    xrnd=gb_next_rand();
    if (xrnd&0x1000000) xrnd=xrnd %100;
    else xrnd=kkk-(xrnd % 100);
    yrnd=gb_next_rand();
    if (yrnd&0x1000000) {
      v->x.i=xrnd-kkk/2;
      v->y.i=(yrnd%kkk)-kkk/2;
    } else {
      v->x.i=(yrnd%kkk)-kkk/2;
      v->y.i=xrnd-kkk/2;
    }
    if (n<150) printf("point %s=(%d,%d)\n",v->name,v->x.i,v->y.i);
  }
@z

