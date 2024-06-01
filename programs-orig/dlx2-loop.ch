@x \S1
@ After this program finds all solutions, it normally prints their total
@y
This version is a special extension that adds a {\it loop constraint\/}:
Certain primary items encode ``vertices'' and certain secondary
items encode ``edges,'' which are pairs of vertices, using an even-odd
coordinate system. The edges whose
color is~1 must form a {\it single cycle\/}.
(We assume that other constraints require every vertex to have
degree 0~or~2.) I wrote this in order to solve puzzles like
slitherlink and masyu. It incorporates some ideas of Rory Molinari,
who greatly simplified the algorithm I had originally used.

@ After this program finds all solutions, it normally prints their total
@z
@x \S6
@ Each \&{item} struct contains three fields:
The |name| is the user-specified identifier;
|next| and |prev| point to adjacent items, when this
item is part of a doubly linked list.
@y
@ Each \&{item} struct contains five fields:
The |name| is the user-specified identifier;
|next| and |prev| point to adjacent items, when this
item is part of a doubly linked list.
And there are two fields |left|, |right|, 
for this special loop extension.

If a secondary item represents an edge, its |left| and |right| fields
point to the primary items for the vertices linked by this edge.

The |left| and |right| field of such primary items are used for
different purposes entirely; so we call them |mate| and |inner|
when used in that context.
Both |mate| and |inner| are initially zero. Then |mate| becomes nonzero when
the vertex first becomes the endpoint of a partial path, in which case
|mate| points to the vertex at the other end of that path. The |inner|
field is nonzero when the vertex is internal to such a path fragment.
@z
@x
  int prev,next; /* neighbors of this item */
@y
  int prev,next; /* neighbors of this item in the active list */
  int left,right; /* vertex references */
@z
@x \S15
last_itm++;
@y
@<Handle edge and vertex names@>;
last_itm++;
@z
@x \S22
level=0;
forward: nodes++;
@y
for (k=second;k<last_itm;k++) nd[k].color=0; /* see |print_uncolored| */
level=0;
forward: nodes++;
/* if debugging, may want to say |count_frags();| */
@z
@x \S27
    else if (nd[pp].color>0) purify(pp);
@y
    else if (nd[pp].color>0) {
      if (purify(pp)<0) goto dangerous_recovery;
    }
@z
@x \S28
    pp--;
@y
dangerous_recovery: pp--; /* yes, I jumped into the middle of this loop */
@z
@x \S29
void purify(int p) {
  register int cc,rr,nn,uu,dd,t,x;
  o,cc=nd[p].itm,x=nd[p].color;
@y
int purify(int p) {
  register int cc,rr,nn,uu,dd,t,x;
  o,cc=nd[p].itm,x=nd[p].color;
  if (x=='1' && (o,cl[cc].left))
    @<Add this edge to the current fragments@>;
@z
@x
}
@y
  return 0;
}
@z
@x \S30
  o,cc=nd[p].itm,x=nd[p].color; /* there's no need to clear |nd[cc].color| */
@y
  o,cc=nd[p].itm,x=nd[p].color; /* there's no need to clear |nd[cc].color| */
  nd[cc].color=0; /* but I do it anyway for tidiness (see |print_uncolored|) */
  if (x=='1' && (o,cl[cc].left))
    @<Delete this edge from the current fragments@>;
@z
@x \S32
  count++;
  if (spacing && (count mod spacing==0)) {
    printf(""O"lld:\n",count);
    for (k=0;k<=level;k++) print_option(choice[k],stdout);
@y
  count++;
  if (spacing && (count mod spacing==0)) {
    register int x,y,x0,y0,prev;
    k=cl[last_edge].left;
    x=decode(cl[k].name[0]),y=decode(cl[k].name[1]);
    if (x<0 || y<0) fprintf(stderr,"This can't happen!\n");
    else {
      printf(""O"lld: "O".8s",count,cl[k].name);
      for (x0=x,y0=y,prev=-1;;) {
        if (prev!=0 && try(x-1,y)) x-=2,prev=3;
        else if (prev!=1 && try(x,y-1)) y-=2,prev=2;
        else if (prev!=2 && try(x,y+1)) y+=2,prev=1;
        else if (prev!=3 && try(x+1,y)) x+=2,prev=0;
        else {
          fprintf(stderr,"Lost in the cycle!\n");
          break;
        }
        printf(" "O"c"O"c",encode(x),encode(y));
        if (x==x0 && y==y0) break;
      }
      printf("\n");
    }
@z
@x
@*Index.
@y
@ @<Sub...@>=
void print_frags(void) {
  register int p;
  for (p=1;p<second;p++) if (cl[p].mate>p && cl[cl[p].mate].mate==p) {
    fprintf(stderr," "O".8s, mate "O".8s\n",cl[p].name,
                          cl[cl[p].mate].name);
  }
}               

@ @<Sub...@>=
void count_frags(void) {
  register int p,f;
  for (f=0,p=1;p<second;p++) if (cl[p].mate>p && cl[cl[p].mate].mate==p) f++;
  if (f!=frags)
    fprintf(stderr,"frags is wrong (%d should be %d)!\n",
                              frags,f);
}               

@ @<Sub...@>=
void print_verts() {
  register int c;
  for (c=1;c<second;c++) {
    if (((decode(cl[c].name[0])&1)==0) &&
        ((decode(cl[c].name[1])&1)==0) && cl[c].name[2]==0) {
      fprintf(stderr,""O".8s: mate "O".8s inner "O".8s\n",
             cl[c].name,cl[c].mate? cl[cl[c].mate].name: "null",
                        cl[c].inner? cl[cl[c].inner].name: "null");
    } /* maybe I should print |c| too? */
  }
}

@ @d decode(c) ((c)>='0' && (c)<='9'? (c)-'0':
                (c)>='a' && (c)<='z'? (c)-'a'+10:
                (c)>='A' && (c)<='Z'? (c)-'A'+36: -1)
@d encode(d) ((d)<10? (d)+'0': (d)<36? (d)-10+'a': (d)<62? (d)-36+'A': '?')

@<Handle edge and vertex names@>=
if (cl[last_itm].name[1]!=0 && cl[last_itm].name[2]==0) {
  register int x,y,u,v;
  x=decode(cl[last_itm].name[0]),y=decode(cl[last_itm].name[1]);
  if (x>=0 && y>=0) {
    o,itmloc[x][y]=last_itm;
    if ((x+y)&1) { /* edge item */
      if (second==max_cols) panic("Edge item isn't secondary");
      if (x&1) u=itmloc[x-1][y],v=itmloc[x+1][y];
      else u=itmloc[x][y-1],v=itmloc[x][y+1];
      if (u==0 || v==0) panic("Edge item for nonexistent vertex");
      o,cl[last_itm].left=u,cl[last_itm].right=v;
    }@+else if ((x&1)==0 && (y&1)==0) { /* vertex item */
      if (second!=max_cols) panic("Vertex item isn't primary");
    }
  }
}      

@ A new edge from $u$ to $v$ introduces two new endpoints to the fragment list,
if $u$ and $v$ aren't endpoints already. (We don't allow any
new edges after the loop has been closed; immediate backtracking
will be forced.) On the other hand, if $v$ is an existing endpoint but
$u$ isn't, we replace $v$ by $u$ in the fragment list. And if
both $u$ and $v$ are existing endpoints, we eliminate them both,
possibly closing the loop in the process. (We refuse to close the
loop unless $u$ and $v$ were the {\it only\/} endpoints present.)

This part of the program is therefore the heart of the loop-checking
mechanism. We are careful to do everything in such a way that it
can be conveniently undone, again adopting the philosophy
of dancing links for the doubly linked fragment list.

A global variable |last_edge| points to the edge that has closed a cycle,
if any. Another global variable, |frags|, counts the number of fragments that
are formed by existing edges. Several cases arise when an edge from $u$ to~$v$
receives color~`\.1': If |last_edge| is nonzero, this edge is rejected.
Otherwise,
\smallskip\noindent{\it Case 0.}
|mate(u)=0=mate(v)|. (The vertices were previously isolated.)
We create a new fragment.
\par\noindent{\it Case 1.}
|mate(u)=0!=mate(v)|. Extend the fragment that ends at |v|.
\par\noindent{\it Case 2.}
|mate(u)!=0=mate(v)|. Extend the fragment that ends at |u|.
\par\noindent{\it Case 3.}
|mate(u)!=0!=mat(v)|. If |mate(u)=v|
(and therefore |mate(v)=u|), we allow the
new edge (and set |last_edge|) only if |frags=1|.
If |mate(u)!=v|, we use the edge to join two fragments into one.

Note: When I first wrote this code, I believed that |u| and |v| must
necessarily be endpoints in case 3, because the options are designed to
assure that no vertex can have degree~3. (Therefore I didn't think
the |inner| field was needed.)

Unfortunately, that reasoning led to a serious bug that was hard
to track down! In rare cases a new edge {\it can\/} temporarily make
a vertex have degree~3. But that vertex will then have no remaining
options, and we will backtrack at the next level --- too late to
recover from an improper clobbering of |mate| fields.

@d mate left
@d inner right

@<Add this edge to the current fragments@>=
{
  register int u,v,mu,mv;
  if (last_edge) {
    if (vbose&show_choices)
      fprintf(stderr," (not adding "O".8s to a loop)\n",
                       cl[cc].name);
    return -1;
  }
  u=cl[cc].left,v=cl[cc].right;
  oo,mu=cl[u].mate,mv=cl[v].mate;
  if (mu && cl[u].inner) {
    if (vbose&show_choices) fprintf(stderr,"(not allowing "O".8s degree 3)\n",
                                      cl[u].name);
    return -1;
  }
  if (mv && cl[v].inner) {
    if (vbose&show_choices) fprintf(stderr,"(not allowing "O".8s degree 3)\n",
                                      cl[v].name);
    return -1;
  }
  if (!mu) { /* |u| not in any fragment */
    if (!mv) { /* |v| not in any fragment */
      oo,cl[u].mate=v,cl[v].mate=u,frags++;
    }@+else { /* |mv| is the endpoint opposite |v| */
      ooo,cl[u].mate=mv,cl[mv].mate=u,cl[v].inner=1;
    }
  }@+else if (!mv) { /* |mu| is the endpoint opposite |u| */
    ooo,cl[v].mate=mu,cl[mu].mate=v,cl[u].inner=1;
  }@+else { /* |u| and |v| are endpoints of fragments */
    if (mu==v) { /* also |mv==u|, loop is closing */
      if (frags!=1) {
        if (vbose&show_choices)
          fprintf(stderr," (not closing a short loop with "O".8s)\n",
                                       cl[cc].name);
        return -1;
      }
      last_edge=cc;
    }@+else { /* fragments are being joined */
      oo,oo,cl[mu].mate=mv,cl[mv].mate=mu,cl[u].inner=cl[v].inner=1,frags--;
    }
  }
}

@ @<Delete this edge from the current fragments@>=
{
  register int u,v,mu,mv;
  u=cl[cc].left,v=cl[cc].right;
  oo,mu=cl[u].mate,mv=cl[v].mate;
  if (mu==mv) {
    if (o,cl[mu].mate==v) ooo,cl[mu].mate=u,cl[v].mate=0,cl[u].inner=0;
    else if (cl[mu].mate==u) ooo,cl[mu].mate=v,cl[u].mate=0,cl[v].inner=0;
    else fprintf(stderr,"Confusion removing edge "O".8s!\n",
                                  cl[cc].name);
  }@+else if (mu==v) { /* also |mv==u| */
    if (last_edge==cc) last_edge=0;
    else oo,cl[u].mate=cl[v].mate=0, frags--;
  }@+else oo,oo,cl[mu].mate=u,cl[mv].mate=v,cl[u].inner=cl[v].inner=0, frags++;
}

@ @<Glob...@>=
int itmloc[62][62]; /* what item has a given pair of coordinates? */
int last_edge; /* the edge that completed the cycle */
int frags; /* the number of current fragments */

@ @<Sub...@>=
int try(int x,int y) {
  register int p;
  if (x<0 || x>=62 || y<0 || y>=62) return 0;
  p=itmloc[x][y];
  if (p>=second && cl[p].left && nd[p].color=='1') return 1;
  return 0;
}

@ Here's a subroutine that I might be able to use to discover
early cutoffs in new ways. It displays all the edges whose
fate is not yet decided (that is, the edges that are still uncolored).

@<Sub...@>=
void print_uncolored(void) {
  register int p;
  for (p=second;p<last_itm;p++) if (nd[p].color==0 && cl[p].left)
    fprintf(stderr," "O".8s",cl[p].name);
  printf("\n");
}

@*Index.
@z
