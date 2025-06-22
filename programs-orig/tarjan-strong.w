@i gb_types.w
\def\dadj{\mathrel{\!\mathrel-\mkern-8mu\mathrel-\mkern-12mu\to\!}}
\datethis

@*Intro. This is an implementation of Tarjan's algorithm for strong
components (Algorithm 7.4.1.2T), based on my current draft in
prefascicle 12a.

I've included all the bells and whistles regarding the output of
minimal links between and within strong components.
Extra memory references for these features are tallied separately
from the |mems| of the basic procedure.

The digraph to be analyzed should be named on the command line.
If you'd also like to delete some of its arcs, you can name
them on the command line too, by saying `\.{-$u$}~\.{--$v$}' to
delete $u\dadj v$.

@d o mems++ /* count one memory reference */
@d oo mems+=2
@d ooo mems+=3
@d ox xmems++ /* count one extra memory reference */
@d oox xmems+=2
@d O "%" /* used for percent signs in format strings */

@c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "gb_graph.h"
#include "gb_save.h"
unsigned long long mems;
unsigned long long xmems;
int comps;
int n;
Graph *gg;
@<Subroutines@>;
main(int argc,char*argv[]) {
  register int p,lowv;
  register Graph *g;
  register Vertex *t,*u,*v,*w,*root,*sink,*settled;
  register Arc *a,*b;
  @<Process the command line@>;
  @<Do the algorithm@>;
  @<Say farewell@>;
}

@ @<Process the command line@>=
if (argc&1) {
  fprintf(stderr,"Usage: "O"s foo.gb [-U --V]*\n",argv[0]);
  exit(-1);
}
gg=g=restore_graph(argv[1]);
if (!g) {
  fprintf(stderr,"I couldn't reconstruct graph "O"s!\n",argv[1]);
  exit(-2);
}
n=g->n;
@<Optionally delete arcs@>;
(g->vertices+n)->u.V=g->vertices;
if ((g->vertices+g->n)->u.I<=n) {
  fprintf(stderr,"Vertex pointers come too early in memory!!\n");
  exit(-666);
}
printf("Strong components of "O"s",g->id);
for (p=2;p<argc;p+=2) printf(" "O"s "O"s",argv[p],argv[p+1]);
printf(":\n");  

@ @<Optionally delete arcs@>=
for (p=2;p<argc;p+=2) {
  if (argv[p][0]!='-' || argv[p+1][0]!='-' || argv[p+1][1]!='-') {
    fprintf(stderr,"improper command-line arguments "O"s "O"s!\n",
            argv[p],argv[p+1]);
    exit(-3);
  }
  for (v=g->vertices;v<g->vertices+n;v++)
   if (strcmp(v->name,argv[p]+1)==0) {
    for (b=NULL,a=v->arcs;a;b=a,a=a->next) {
      if (strcmp(a->tip->name,argv[p+1]+2)==0) break;
    }
    if (!a) v=g->vertices+n;
    else if (b) b->next=a->next;@+else v->arcs=a->next;
    break;
  }
  if (v==g->vertices+n) {
    fprintf(stderr,"I don't see the arc "O"s->"O"s!\n",
        &argv[p][1],&argv[p+1][2]);
    exit(-4);
  }
}

@ I use the fact that GraphBase graphs provide |extra_n| vertices,
so that it's OK for me to store something in |g->vertices+g->n|,
which Algorithm T calls \.{SENT}. (The extra vertices show up in the
space for vertices that's allocated on the first line of `\.{.gb}' format;
the value of |g->n| on the second line is smaller.)

The \.{REP} field in Algorithm T has two forms, either a small
integer or an offset vertex. Here we simply use the vertex itself,
calling it `|rep|' in a field shared with the integer `|low|' field.
That is safe, because of the test on vertex pointers made above.

@d sent (g->vertices+g->n)
@d par u.V /* \.{PARENT} in the book */
@d low v.I /* \.{LOW} (when \.{REP} equals \.{LOW}) */
@d rep v.V /* $v'$ (when \.{REP} equals $\.{SENT}+v'$) */
@d link w.V /* \.{LINK} */
@d arc x.A /* \.{ARC} */
@d from y.V /* \.{FROM} */
@d symlink(u) ((u)==gg->vertices+n?"END":
    ((u)<gg->vertices+n) && ((u)>=gg->vertices)?(u)->name:"??")

@<Sub...@>=
void print_vert(Vertex *v) {
  register int k;
  register Vertex *u;
  register Arc *a;
  if (!v) fprintf(stderr,"NULL");
  else if (v==gg->vertices+n) fprintf(stderr,"SENT");
  else if (v<gg->vertices || v>gg->vertices+n)
    fprintf(stderr," (out of range)");
  else {
    fprintf(stderr,""O"s:",v->name);
    u=v->par;
    if (!u) fprintf(stderr," (unseen)");
    else {
      fprintf(stderr," parent="O"s",symlink(u));
      k=v->low,u=v->rep;
      if (k<=n) fprintf(stderr," low="O"d",k);
      else fprintf(stderr," rep="O"s",u->name);
      if (v->link) fprintf(stderr," link="O"s",symlink(v->link));
      if (v->arc) fprintf(stderr," arc="O"s",symlink(v->arc->tip));
      if (v->from) fprintf(stderr," from="O"s",symlink(v->from));
    }
  }
  fprintf(stderr,"\n");
} 
  
@ @<Do the algorithm@>=
sent->low=0;
t1:@+for (w=g->vertices;w<sent;w++) o,w->par=NULL;
  p=0; /* at this point |w=sent| */
  sink=sent, settled=NULL;
t2:@+if (w==g->vertices) goto done;
  if (o,(--w)->par!=NULL) goto t2;
  v=w,v->par=sent,root=v;
t3:@+o,a=v->arcs;
  oo,lowv=v->low=++p,v->link=sent;
t4:@+if (a==NULL) goto t7;
t5:@+o,u=a->tip,a=a->next;
t6:@+if (o,u->par==NULL) {
    oo,u->par=v, v->arc=a, v=u;
    goto t3;
  }
  if (u==root && p==g->n) @<Prepare to terminate early, and |goto t8|@>;
  if (o,u->low<lowv) oo,lowv=v->low=u->low,v->link=u;
  goto t4;
t7:@+o,u=v->par;
  if (o,v->link==sent) goto t8;
  if (v->link!=NULL) printf(" inner "O"s->"O"s\n",v->name,v->link->name);
  @<Adjust |u->low| with respect to its tree child |v|@>;
  o,v->link=sink,sink=v;
  goto t9;
t8:@+@<Produce a new strong component whose leader is |v|@>;
t9:@+if (u==sent) goto t2;
  oo,v=u,a=v->arc,lowv=v->low;
  goto t4;
done:@+@<Print links between components@>;

@ @<Prepare to terminate early, and |goto t8|@>=
{
  if (v!=root) printf(" inner "O"s->"O"s\n",v->name,root->name);
  while (v!=root) oo,v->link=sink,sink=v,v=v->par;
  o,u=sent,lowv=1;
  goto t8;
}

@ At this point |lowv| is \.{LOW($v$)}; it might or might not
have been stored in |v->low|. If |u->link!=sent|, step |t6| may have
set |u->link| to a vertex that's a nontree child of~|u|
responsible for |u->low|.

Three cases arise:
If |lowv>u->low|, we do nothing.
If |lowv<u->low|, we set |u->low=lowv|; we also set
|u->link=NULL|, because this will avoid printing a redundant
inner link. (The value of \.{LOW($u$)} is inherited from~|v|.)

In the remaining case, |lowv=u->low|, I thought at first that
it was legitimate to set |u->link=NULL| if |u->link!=sent|,
reasoning that there was no reason for |u| to publish an
inner arc to |u->link| because |v| already had provided a
sufficient inner arc. That was fallacious, because |v| might
have copied |u|'s low pointer, and was relying on it by simply
giving an inner link to |u|. (Consider $1\dadj2$, $2\dadj 1$,
$2\dadj3$, $3\dadj2$, $3\dadj1$.)

@<Adjust |u->low| with respect to its tree child |v|@>=
if (o,lowv<u->low) oo,u->low=lowv,u->link=NULL;

@ The |settled| stack retains the links of the items removed
from the |sink| stack, followed by~|v|, followed by its former contents.

@<Produce a new strong component whose leader is |v|@>=
comps++;
printf("strong component "O"s:\n",v->name);
if (sink->low<lowv) oo,v->rep=v,ox,v->link=settled,settled=v;
                                             /* singleton component */
else {
  ox,v->link=settled,settled=sink;
  while (o,sink->low>=lowv) {
    ox,printf(" tree "O"s->"O"s\n",sink->par->name,sink->name);
    o,sink->rep=v,t=sink;
    o,sink=sink->link;
  }
  o,v->rep=v;
  ox,t->link=v;
}

@ I've basically copied this from {\mc ROGET\_COMPONENTS} \S17.

@<Print links between components@>=
for (v=g->vertices;v<sent;v++) v->from=NULL;
for (v=settled;v;ox,v=v->link) {
  oox,u=v->rep,u->from=u;
  for (ox,a=v->arcs;a;ox,a=a->next) {
    oox,w=a->tip->rep;
    if (ox,w->from!=u) {
      ox,w->from=u;
      printf(" link "O"s to "O"s: "O"s->"O"s\n",u->name,w->name,
                 v->name,a->tip->name);
    }
  }
}

@ Here's a subroutine that might be useful when debugging.
(For example, I can say `|print_stack(sink)|' or `|print_stack(settled)|'.)

@<Sub...@>=
void print_stack(Vertex *top) {
  register Vertex *v;
  for (v=top;v>=gg->vertices && v<gg->vertices+n;v=v->link)
    fprintf(stderr," "O"s",v->name);
  if (v!=NULL && v!=gg->vertices+n) fprintf(stderr," (bad link!)\n");
  else fprintf(stderr,"\n");
}

@ @<Say farewell@>=
fprintf(stderr,"Altogether "O"d strong component"O"s; "O"llu+"O"llu mems.\n",
                     comps,comps==1?"":"s",mems,xmems);

@*Index.
