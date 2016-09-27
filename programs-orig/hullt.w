% This file is part of the Stanford GraphBase (c) Stanford University 1990
\nocon

@* Introduction. This is a hastily written implementation of the treehull
algorithm, using simple binary search trees and hoping that they
don't get too far out of balance.

@f Graph int /* |gb_graph| defines the |Graph| type and a few others */
@f Vertex int
@f Arc int
@f Area int

@p
#include "gb_graph.h"
#include "gb_miles.h"
#include "gb_rand.h"
@<Type declarations@>@;
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
@d ooo mems+=3

@<Glob...@>=
int mems; /* memory accesses */
int ccs; /* calls on |ccw| */

@*Data structures.
For now, each vertex is represented by two coordinates stored in the
utility fields |x.i| and |y.i|. I'm also putting a serial number into
|z.i|, so that I can check whether different algorithms generate
identical hulls.

We use separate nodes for the current convex hull. These nodes have
a bunch of fields: |p->vert| points to the vertex; |p->succ| and |p->pred|
point to next and previous nodes in a circular list; |p->left| and |p->right|
point to left and right children in a tree that's superimposed on the list;
|p->parent| is present too, it points to a field within the parent node;
|p->prio| is the priority if we are implementing the tree as a treap.

Actually I'm not doing much with |prio| until I've got the rest of
the program debugged. Then I'll have to change parent pointer because I'll
need to rotate upward in the tree.

The |head| node has the root of the tree in its |right| field, and
it represents the special vertex that isn't in the tree.

@<Type declarations@>=
typedef struct node_struct {
  struct vertex_struct *vert;
  struct node_struct *succ,*pred,*left,*right,**parent;
  long prio;
} node;

@ @<Initialize the array of nodes@>=
head=(node*)gb_alloc((g->n)*sizeof(node),working_storage);
if (head==NULL) return(1); /* fixthis */
next_node=head;

@ @<Glob...@>=
node *head; /* beginning of the hull data structure */
node *next_node; /* first unused slot in that array */
Area working_storage;
int serial_no=1; /* used to disambiguate entries with equal coordinates */

@ We assume that the vertices have been given to us in a GraphBase-type
graph. The algorithm begins with a trivial hull that contains
only the first two vertices.

@<Initialize the data structures@>=
init_area(working_storage);
@<Initialize the array of nodes@>;
o,u=g->vertices;
v=u+1;
u->z.i=0; v->z.i=1;
p=++next_node;
ooo,head->succ=head->pred=head->right=p;
oo,p->succ=p->pred=head;
o,p->parent=&(head->right);
oo,p->left=p->right=NULL;
gb_init_rand();
p->prio=gb_next_rand();
o,head->vert=u;
o,p->vert=v;
next_node++;
if (n<150) printf("Beginning with (%s; %s)\n",u->name,v->name);

@ We'll probably need a bunch of local variables to do elementary operations on
data structures.

@<Local...@>=
Vertex *u,*v,*vv,*w;
node *p,*pp,*q, *qq, *qqq, *r, *rr, *s, *ss, *tt, **par, **ppar;
int replaced; /* will be nonzero if we've just replaced a hull element */

@ Here's a routine I used when debugging (in fact I should have written
it sooner than I did).

@<Verify the integrity of the data structures@>=
p=head; count=0;
do {
  count++;
  p->prio=(p->prio&0xffff0000)+count;
  if (p->succ->pred!=p)
    printf("succ/pred failure at %s!\n",p->vert->name);
  if (p!=head && *(p->parent)!=p)
    printf("parent/child failure at %s!\n",p->vert->name);
  p=p->succ;
} while (p!=head);
count=1; inorder(head->right);

@ @<Proc...@>=
int count;
inorder(p)
  node *p;
{ if (p) {
    inorder(p->left);
    if ((p->prio&0xffff)!=++count) {
      printf("tree node %d is missing at %d: %s!\n",count,p->prio&0xffff,
                  p->vert->name);
      count=p->prio&0xffff;
    }
    inorder(p->right);
  }
}

@*Hull updating.
The main loop of the algorithm updates the data structure incrementally
by adding one new vertex at a time. If the new vertex lies outside the
current convex hull, we put it into the cycle and possibly delete some
vertices that were previously part of the hull.

@<Find convex hull of |g|@>=
@<Initialize the data structures@>;
for (oo,vv=g->vertices+2;vv<g->vertices+g->n;vv++) {
  vv->z.i=++serial_no;
  o,q=head->pred;
  replaced=0;
  o,u=head->vert;
  if (o,ccw(vv,u,q->vert)) @<Do Case 1@>@;
  else @<Do Case 2@>;  
  @<Verify the integrity of the data structures@>;
}
@<Print the convex hull@>;

@ Let me do the easy part first, since it's bedtime and I can worry about
the rest tomorrow.

@<Print the convex hull@>=
p=head;
printf("The convex hull is:\n");
do {
  printf("  %s\n",p->vert->name);
  p=p->succ;
} while (p!=head);

@ In Case 1 we don't need the tree structure since we've already found
that the new vertex is outside the hull at the tree root position.

@<Do Case 1@>=
{@+qqq=head;
  while (1) {
    o,r=qqq->succ;
    if (r==q) break; /* can't eliminate any more */
    if (oo,ccw(vv,qqq->vert,r->vert)) break;
    @<Delete or replace |qqq| from the hull@>;
    qqq=r;
  }
  qq=qqq; qqq=q;
  while (1) {
    o,r=qqq->pred;
    if (r==qq) break;
    if (oo,ccw(vv,r->vert,qqq->vert)) break;
    @<Delete or replace |qqq| from the hull@>;
    qqq=r;
  }
  q=qqq;
  if (!replaced) @<Insert |vv| at the right of the tree@>;
  if (n<150) printf("New hull sequence (%s; %s; %s)\n",
           q->vert->name,vv->name,qq->vert->name);
}

@ At this point |q==head->pred| is the tree's rightmost node.

@<Insert |vv| at the right of the tree@>=
{ 
  tt=next_node++;
  o,tt->vert=vv; o,tt->succ=head; o,tt->pred=q; o,head->pred=tt; o,q->succ=tt;
  oo,tt->left=tt->right=NULL; o,tt->parent=&(q->right); o,q->right=tt;
  tt->prio=gb_next_rand();
}

@ Nodes don't need to be recycled.

@<Delete or replace |qqq| from the hull@>=
if (replaced) {
  o,pp=qqq->pred; o,tt=qqq->succ; o,pp->succ=tt; o,tt->pred=pp;
  o,par=qqq->parent; o,pp=qqq->left;
  if (o,(ss=qqq->right)==NULL) {
    if (n<150) printf("(Deleting %s from tree, case 1)\n",qqq->vert->name);
    o,*par=pp;
    if (pp!=NULL) o,pp->parent=par;
  } else if (pp==NULL) {
    if (n<150) printf("(Deleting %s from tree, case 2)\n",qqq->vert->name);
    o,*par=ss; o,ss->parent=par;
  } else { /* |tt->left==NULL| */
    o,tt->left=pp; o,pp->parent=&(tt->left);
    if (ss!=tt) { /* have to delete |tt| from its present place */
      if (n<150) printf("(Deleting %s from tree, hard case)\n",qqq->vert->name);
      o,ppar=tt->parent;
      o,pp=tt->right;
      o,*ppar=pp;
      if (pp!=NULL) o,pp->parent=ppar;
      o,tt->right=ss; o,ss->parent=&(tt->right);
    } else if (n<150) printf("(Deleting %s from tree, case 3)\n",qqq->vert->name);
    o,*par=tt; o,tt->parent=par;
  }
} else {
  o,qqq->vert=vv;
  replaced=1;
}

@ @<Do Case 2@>=
{@+o,qq=head->right;
  while (1) {
    if (qq==q || (o,ccw(u,vv,qq->vert))) {
      o,r=qq->left;
      if (r==NULL) {
        o,ppar=&(qq->left);
        break;
      }
    } else {
      o,r=qq->right;
      if (r==NULL) {
        o,ppar=&(qq->right);
        o,qq=qq->succ;
        break;
      }
    }
    qq=r;
  }
  if (o,(r=qq->pred)==head || (oo,ccw(vv,qq->vert,r->vert))) {
    if (r!=head) {
      while (1) {
        qqq=r;
        o,r=qqq->pred;
        if (r==head) break;
        if (oo,ccw(vv,r->vert,qqq->vert)) break;
        @<Delete or replace |qqq| from the hull@>;
      }
      r=qqq;
    }
    qqq=qq;
    while (1) {
      if (qqq==q) break;
      oo,rr=qqq->succ;
      if (oo,ccw(vv,qqq->vert,rr->vert)) break;    
      @<Delete or replace |qqq|...@>;
      qqq=rr;
    }
    if (!replaced) @<Insert |vv| in tree, linked by |ppar|@>;
    if (n<150) printf("New hull sequence (%s; %s; %s)\n",
             r->vert->name,vv->name,qqq->vert->name);
  }
}

@ @<Insert |vv| in tree...@>=
{
  tt=next_node++;
  o,tt->vert=vv; o,tt->succ=qq; o,tt->pred=r; o,qq->pred=tt; o,r->succ=tt;
  oo,tt->left=tt->right=NULL; o,tt->parent=ppar; o,*ppar=tt;
  tt->prio=gb_next_rand();
}
 
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
