% change file to test polygon data in hull algorithms
@x
\nocon
@y
\nocon
\let\maybe=\iffalse
\def\title{\expandafter\uppercase\expandafter{\jobname\ (n-gon)}}
@z
@x
#include "gb_graph.h"
@y
#include "gb_graph.h"
#include "gb_rand.h"
@z
@x
int n=128;
@y
int n=128;
int mapping[10000];
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
    printf("Usage: %s [n]\n",argv[0]);
    exit(1);
  }
  else if (n<20 || n>10000) {
    printf("n should be at least 20 and at most 10000!\n");
    exit(1);
  }
  g=gb_new_graph(n);
  gb_init_rand(0);
  for (kk=0;kk<n; kk++) mapping[kk]=kk;
  for (kk=0,v=g->vertices; kk<n; kk++,v++) {
    kkk=gb_next_rand() % (n-kk);
    v->x.I=mapping[kkk];
    mapping[kkk]=mapping[n-kk-1];
    sprintf(str,"%d",v->x.I);
    v->name=gb_save_string(str);
  }
@z
@x
int ccw(u,v,w)
  Vertex *u,*v,*w;
{@+register double wx=(double)w->x.I, wy=(double)w->y.I;
  register double det=((double)u->x.I-wx)*((double)v->y.I-wy)
         -((double)u->y.I-wy)*((double)v->x.I-wx);
  Vertex *uu=u,*vv=v,*ww=w,*t;
  if (det==0) {
    det=1;
    if (u->x.I>v->x.I || (u->x.I==v->x.I && (u->y.I>v->y.I ||
         (u->y.I==v->y.I && u->z.I>v->z.I)))) {
           t=u;@+u=v;@+v=t;@+det=-det;
    }
    if (v->x.I>w->x.I || (v->x.I==w->x.I && (v->y.I>w->y.I ||
         (v->y.I==w->y.I && v->z.I>w->z.I)))) {
           t=v;@+v=w;@+w=t;@+det=-det;
    }
    if (u->x.I>v->x.I || (u->x.I==v->x.I && (u->y.I>v->y.I ||
         (u->y.I==v->y.I && u->z.I<v->z.I)))) {
           det=-det;
    }
  }
  if (n<150) printf("cc(%s; %s; %s) is %s\n",uu->name,vv->name,ww->name,
    det>0? "true": "false");
  ccs++;
  return (det>0);
}
@y
int ccw(u,v,w)
  Vertex *u,*v,*w;
{@+register det=1,ux=u->x.I,vx=v->x.I,wx=w->x.I,t;
  if (ux>vx) {
    t=ux;@+ux=vx;@+vx=t;@+det=-det;
    }
  if (vx>wx) {
    t=vx;@+vx=wx;@+wx=t;@+det=-det;
  }
  if (ux>vx) {
    det=-det;
  }
  if (n<150) printf("cc(%s; %s; %s) is %s\n",u->name,v->name,w->name,
    det>0? "true": "false");
  ccs++;
  return (det>0);
}

@*Index.
@z
