@i gb_types.w

@*Intro. We output an Eulerian trail of the (undirected) graph named on the
command line. (Each edge is considered to be two directed arcs; thus it
is traversed in both directions.)

If the graph isn't connected, we consider only the vertices that are
reachable from the first one, |g->vertices|.

@c
#include <stdio.h>
#include <stdlib.h>
#include "gb_graph.h"
#include "gb_save.h"
@<Subroutine@>@;

main(int argc,char*argv[]) {
  register int k;
  Graph *g;
  Vertex *u,*v;
  Arc *a;
  @<Input the graph@>;
  @<Traverse depth first@>;
  @<Output the trail@>;
  printf("\n");
}

@ @<Input the graph@>=
if (argc!=2 || !(g=restore_graph(argv[1]))) {
  fprintf(stderr,"Usage: %s foo.gb\n",argv[0]);
  exit(-1);
}
fprintf(stderr,"OK, I've input `%s'.\n",argv[1]);
gb_new_edge(g->vertices,g->vertices+g->n,0); /* dummy edge */

@ Subroutine |dfs(u,v)| sets |v->parent=u| and |v->nav| to the vertex
that follows |u| in |v|'s adjacency list. It also explores all
vertices reachable from |v| that haven't already been seen.

@d parent v.V
@d nav w.A

@<Subroutine@>=
void dfs(register Vertex *u,register Vertex *v) {
  register Vertex *w;
  register Arc *a;
  v->parent=u;
  for (a=v->arcs;a;a=a->next) {
    w=a->tip;
    if (w==u) v->nav=a->next;
    else if (w->parent==NULL) dfs(v,w);
  }
}

@ @<Traverse depth first@>=
dfs(g->vertices+g->n,g->vertices);

@ Now the Eulerian traversal is beautifully simple.

@<Output the trail@>=
for (v=g->vertices;v!=g->vertices+g->n;) {
  printf(" %s",v->name);
  a=v->nav;
  if (!a) a=v->arcs;
  v->nav=a->next;
  v=a->tip;
}

@*Index.
  
