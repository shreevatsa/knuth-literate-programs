% This file is part of the Stanford GraphBase (c) Stanford University 1990
\nocon

@* Introduction. This is a hastily written implementation of the daghull
algorithm.

@f Graph int /* |gb_graph| defines the |Graph| type and a few others */
@f Vertex int
@f Arc int
@f Area int

@p
#include "gb_graph.h"
#include "gb_miles.h"
int n=128;
@<Global variables@>@;
@<Procedures@>@;
@#
main()
{
  @<Local variables@>@;
  Graph *g=miles(128,0,0,0,0,0,0);
@#
  mems=ccs=0;
  @<Find convex hull of |g|@>;
  printf("Total of %d mems and %d calls on ccw.\n",mems,ccs);
}

@ I'm instrumenting this in a simple way.

@d o mems++
@d oo mems+=2

@<Glob...@>=
int mems; /* memory accesses */
int ccs; /* calls on |ccw| */

@*Data structures.
For now, each vertex is represented by two coordinates stored in the
utility fields |x.i| and |y.i|. I'm also putting a serial number into
|z.i|, so that I can check whether different algorithms generate
identical hulls.

A vertex |v| in the convex hull also has a successor |v->succ| and
and predecessor |v->pred|, stored in utility fields |u| and |v|.
There's also a pointer to an ``instruction,'' |v->inst|, for which I'm
using an arc record although I need only two fields; that one goes in
utility field |w|.

An instruction has two parts. Its |tip| is a vertex to be used in
counterclockwise testing. Its |next| is another instruction to be followed;
or, if |NULL|, there's no next instruction; or, if a pointer to the
smallest possible instruction, we will do something special to update
the current convex hull.

@d succ u.v
@d pred v.v
@d inst w.a

@ @<Initialize the array of instructions@>=
first_inst=(Arc*)gb_alloc((4*g->n-2)*sizeof(Arc),working_storage);
if (first_inst==NULL) return(1); /* fixthis */
next_inst=first_inst;

@ @<Glob...@>=
Arc *first_inst; /* beginning of the array of instructions */
Arc *next_inst; /* first unused slot in that array */
Vertex *rover; /* one of the vertices in the convex hull */
Area working_storage;
int serial_no=1; /* used to disambiguate entries with equal coordinates */

@ We assume that the vertices have been given to us in a GraphBase-type
graph. The algorithm begins with a trivial hull that contains
only the first two vertices.

@<Initialize the data structures@>=
init_area(working_storage);
@<Initialize the array of instructions@>;
o,u=g->vertices;
v=u+1;
u->z.i=0; v->z.i=1;
oo,u->succ=u->pred=v;
oo,v->succ=v->pred=u;
oo,first_inst->tip=u;@+first_inst->next=first_inst;
oo,(++next_inst)->tip=v;@+next_inst->next=first_inst;
o,u->inst=first_inst;
o,v->inst=next_inst++;
rover=u;
if (n<150) printf("Beginning with (%s; %s)\n",u->name,v->name);

@ We'll probably need a bunch of local variables to do elementary operations on
data structures.

@<Local...@>=
Vertex *u,*v,*vv,*w;
Arc *p,*q,*r,*s;

@*Hull updating.
The main loop of the algorithm updates the data structure incrementally
by adding one new vertex at a time. If the new vertex lies outside the
current convex hull, we put it into the cycle and possibly delete some
vertices that were previously part of the hull.

@<Find convex hull of |g|@>=
@<Initialize the data structures@>;
for (oo,vv=g->vertices+2;vv<g->vertices+g->n;vv++) {
  vv->z.i=++serial_no;
  @<Follow the instructions; |continue| if |vv| is inside the current hull@>;
  @<Update the convex hull, knowing that |vv| lies outside the consecutive
     hull vertices |u| and |v|@>;
}
@<Print the convex hull@>;

@ Let me do the easy part first, since it's bedtime and I can worry about
the rest tomorrow.

@<Print the convex hull@>=
u=rover;
printf("The convex hull is:\n");
do {
  printf("  %s\n",u->name);
  u=u->succ;
} while (u!=rover);

@ @<Follow the instructions...@>=
p=first_inst;
do {
  if (oo,ccw(p->tip,vv,(p+1)->tip)) p++;
  q=p;
  o,p=p->next;
} while (p>first_inst);
if (p==NULL) continue;
o,v=q->tip;
o,u=v->pred;

@ @<Update the convex hull, knowing that |vv| lies outside the consecutive
     hull vertices |u| and |v|@>=
o,q->next=next_inst;
while (1) {
  o,w=u->pred;
  if (w==v) break;
  if (ccw(vv,w,u)) break;
  o,u->inst->next=next_inst;
  if (rover==u) rover=w;
  u=w;
}
while (1) {
  o,w=v->succ;
  if (w==u) break;
  if (ccw(w,vv,v)) break;
  if (rover==v) rover=w;
  v=w;
  o,v->inst->next=next_inst;
}
oo,u->succ=v->pred=vv;
oo,vv->pred=u;@+vv->succ=v;
@<Compile two new instructions, for |(u,vv)| and |(vv,v)|@>;

@ @<Compile two new instructions, for |(u,vv)| and |(vv,v)|@>=
o,next_inst->tip=vv;
o,next_inst->next=first_inst;
o,vv->inst=next_inst;
next_inst++;
o,next_inst->tip=u;
o,next_inst->next=next_inst+1;
next_inst++;
o,next_inst->tip=v;
o,next_inst->next=first_inst;
o,v->inst=next_inst;
next_inst++;
o,next_inst->tip=vv;
o,next_inst->next=NULL;
next_inst++;
if (n<150) printf("New hull sequence (%s; %s; %s)\n",u->name,vv->name,v->name);
 
@*Determinants. I need code for the primitive function |ccw|.
Floating-point arithmetic suffices for my purposes.

We want to evaluate the determinant
$$ccw(u,v,w)=\left\vert\matrix{u(x)&u(y)&1\cr v(x)&v(y)&1\cr w(x)&w(y)&1\cr}
 \right\vert=\left\vert\matrix{u(x)-w(x)&u(y)-w(y)\cr v(x)-w(x)&v(y)-w(y)\cr}
 \right\vert\,.$$

@<Proc...@>=
int ccw(u,v,w)
  Vertex *u,*v,*w;
{@+register double wx=(double)w->x.i, wy=(double)w->y.i;
  register double det=((double)u->x.i-wx)*((double)v->y.i-wy)
         -((double)u->y.i-wy)*((double)v->x.i-wx);
  Vertex *uu=u,*vv=v,*ww=w,*t;
  if (det==0) {
    det=1;
    if (u->x.i>v->x.i || (u->x.i==v->x.i && (u->y.i>v->y.i ||
         (u->y.i==v->y.i && u->z.i>v->z.i)))) {
           t=u;@+u=v;@+v=t;@+det=-det;
    }
    if (v->x.i>w->x.i || (v->x.i==w->x.i && (v->y.i>w->y.i ||
         (v->y.i==w->y.i && v->z.i>w->z.i)))) {
           t=v;@+v=w;@+w=t;@+det=-det;
    }
    if (u->x.i>v->x.i || (u->x.i==v->x.i && (u->y.i>v->y.i ||
         (u->y.i==v->y.i && u->z.i<v->z.i)))) {
           det=-det;
    }
  }
  if (n<150) printf("cc(%s; %s; %s) is %s\n",uu->name,vv->name,ww->name,
    det>0? "true": "false");
  ccs++;
  return (det>0);
}
