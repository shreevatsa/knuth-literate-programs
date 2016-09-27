\datethis
@i gb_types.w

@*Introduction. This program inputs a directed graph.
It outputs a not-necessarily-reduced binary decision diagram
for the family of all simple oriented cycles in that graph.

The format of the output is described in another program,
{\mc SIMPATH-REDUCE}. Let me just say here that it is intended
only for computational convenience, not for human readability.

I've tried to make this program simple, whenever I had to
choose between simplicity and efficiency. But I haven't gone
out of my way to be inefficient.

(I hacked this code by extending {\mc SIMPATH}, the undirected version.)

@d maxn 90 /* maximum number of vertices; at most 126 */
@d maxm 2000 /* maximum number of arcs */
@d logmemsize 27
@d memsize (1<<logmemsize) /* warning: we need $|maxn|*|memsize|\le2^{32}$ */
@d loghtsize 24
@d htsize (1<<loghtsize)

@c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "gb_graph.h"
#include "gb_save.h"
char mem[memsize]; /* the big workspace */
unsigned long long tail,boundary,head; /* queue pointers */
unsigned int htable[htsize]; /* hash table */
unsigned int htid; /* ``time stamp'' for hash entries */
int htcount; /* number of entries in the hash table */
Vertex *vert[maxn+1];
int arcto[maxm]; /* destination number of each arc */
int firstarc[maxn+2]; /* where arcs from a vertex start in |arcto| */
char mate[maxn+3]; /* encoded state */
int serial,newserial; /* state numbers */
@<Subroutines@>@;
@#
main(int argc, char* argv[]) {
  register int i,j,jj,jm,k,km,l,ll,m,n,t;
  register Graph *g;
  register Arc *a,*b;
  register Vertex *u,*v;
  @<Input the graph@>;
  @<Renumber the vertices@>;
  @<Reformat the arcs@>;
  @<Do the algorithm@>;
}

@ @<Input the graph@>=
if (argc!=2) {
  fprintf(stderr,"Usage: %s foo.gb\n",argv[0]);
  exit(-1);
}
g=restore_graph(argv[1]);
if (!g) {
  fprintf(stderr,"I can't input the graph %s (panic code %ld)!\n",
    argv[1],panic_code);
  exit(-2);
}
n=g->n;
if (n>maxn) {
  fprintf(stderr,"Sorry, that graph has %d vertices; ",n);
  fprintf(stderr,"I can't handle more than %d!\n",maxn);
  exit(-3);
}
if (g->m>maxm) {  
  fprintf(stderr,"Sorry, that graph has %d arcs; ",(g->m+1)/2);
  fprintf(stderr,"I can't handle more than %d!\n",maxm);
  exit(-3);
}

@ We create the inverse-arc list for each vertex~|v| (the list of all
vertices that point to~|v|). Then we use a breadth-first numbering scheme
to attach a serial number |v->num|.

@d num z.I
@d invarcs y.A

@<Renumber the vertices@>=
for (v=g->vertices;v<g->vertices+n;v++) v->num=0,v->invarcs=NULL;
for (v=g->vertices;v<g->vertices+n;v++) {
  for (a=v->arcs;a;a=a->next) {
    register Arc *b=gb_virgin_arc();
    u=a->tip;
    b->tip=v;
    b->next=u->invarcs;
    u->invarcs=b;
  }
}
vert[1]=g->vertices, g->vertices->num=1;
for (j=0,k=1;j<k;j++) {
  v=vert[j+1];
  for (a=v->arcs;a;a=a->next) {
    u=a->tip;
    if (u->num==0) u->num=++k,vert[k]=u;
  }
  for (a=v->invarcs;a;a=a->next) {
    u=a->tip;
    if (u->num==0) u->num=++k,vert[k]=u;
  }
}    

@ The arcs will be either $j\to k$ or $j\gets k$ between vertex number~$j$
and vertex number~$k$, when $j<k$ and those vertices are adjacent in
the graph. We process them in order of increasing~$j$; but for fixed~$j$,
the values of~$k$ aren't necessarily increasing.

The $k$ values appear in the |arcto| array, with $-k$ used for the arcs
that emanate from~$k$. The arcs for fixed~$j$
occur in positions |firstarc[j]| through |firstarc[j+1]-1| of that array.

After this step, we forget the GraphBase data structures and just work
with our homegrown integer-only representation.

@<Reformat the arcs@>=
for (m=0,k=1;k<=n;k++) {
  firstarc[k]=m;
  v=vert[k];
  printf("%d(%s)\n",k,v->name);
  for (a=v->arcs;a;a=a->next) {
    u=a->tip;
    if (u->num>k) {
      arcto[m++]=u->num;
      if (a->len==1) printf(" -> %d(%s) #%d\n",u->num,u->name,m);
      else printf(" -> %d(%s,%d) #%d\n",u->num,u->name,a->len,m);
    }
  }
  for (a=v->invarcs;a;a=a->next) {
    u=a->tip;
    if (u->num>k) {
      arcto[m++]=-u->num;
      if (a->len==1) printf(" <- %d(%s) #%d\n",u->num,u->name,m);
      else printf(" <- %d(%s,%d) #%d\n",u->num,u->name,a->len,m);
    }
  }
}
firstarc[k]=m;

@*The algorithm.        
Now comes the fun part. We systematically construct a binary decision
diagram for all simple paths by working top-down, considering the
arcs in |arcto|, one by one.

When we're dealing with arc |i|, we've already constructed a table of
all possible states that might arise when each of the previous arcs has
been chosen-or-not, except for states that obviously cannot be
part of a simple path.

Arc |i| runs from vertex |j| to vertex |k=arcto[i]|,
or from |k=-arcto[i]| to~|j|.
Let |l| be the maximum vertex number in arcs less than~|i|.

The state before we decide whether or not to include arc~|i| is
represented by a table of values |mate[t]|, for $j\le t\le l$,
with the following significance:
If |mate[t]=t|, the previous arcs haven't touched vertex |t|.
If |mate[t]=u| and |u!=t|, the previous arcs have made a simple directed
path from |t| to |u|.
If |mate[t]=-u|, the previous arcs have made a simple directed
path from |u| to |t|.
If |mate[t]=0|, the previous arcs have ``saturated'' vertex~|t|; we can't
touch it again.

The |mate| information is all that we need to know about the behavior of
previous arcs. And it's easily updated when we add the |i|th arc (or not).
So each ``state'' is equivalent to a |mate| table, consisting of
|l+1-j| numbers.

The states are stored in a queue, indexed by 64-bit numbers
|tail|, |boundary|, and |head|, where |tail<=boundary<=head|.
Between |tail| and |boundary| are the pre-arc-|i| states that haven't yet
been processed; between |boundary| and |head| are the post-arc-|i| states
that will be considered later. The states before |boundary|
are sequences of |s=l+1-j| bytes each, and the states after |boundary|
are sequences of |ss=ll+1-jj| bytes each, where |ll| and |jj| are the values of
|l| and |j| for arc |i+1|.

Bytes of the queue are stored in |mem|, which wraps around modulo |memsize|.
We ensure that |head-tail| never exceeds |memsize|.


@<Do the algorithm@>=
for (t=1;t<=n;t++) mate[t]=t;
@<Initialize the queue@>;
for (i=0;i<m;i++) {
  printf("#%d:\n",i+1); /* announce that we're beginning a new arc */
  fprintf(stderr,"Beginning arc %d (serial=%d,head-tail=%ld)\n",
                 i+1,serial,head-tail);
  fflush(stderr);
  @<Process arc |i|@>;
}

@ @<Initialize the queue@>=
jj=ll=1;
mem[0]=mate[1];
tail=0,head=1;
serial=2;

@ Each state for a particular arc gets a distinguishing number.
Two states are special: 0 means the losing state, when a simple path
is impossible; 1 means the winning state, when a simple path has been
completed. The other states are 2 or more.

The output format on |stdout| simply shows the identifying numbers of a state
and its two succesors, in hexadecimal.

@d trunc(addr) ((addr)&(memsize-1))

@<Process arc |i|@>=
boundary=head,htcount=0,htid=(i+1)<<logmemsize;
newserial=serial+((head-tail)/(ll+1-jj));
j=jj,k=arcto[i],l=ll;
while (jj<=n && firstarc[jj+1]==i+1) jj++;
ll=(k>l? k: -k>l? -k: l);
while (tail<boundary) {
  printf("%x:",serial);
  serial++;
  @<Unpack a state, and move |tail| up@>;
  @<Print the successor if arc |i| is not chosen@>;
  printf(",");
  @<Print the successor if arc |i| is chosen@>;
  printf("\n");
}

@ If the target vertex hasn't entered the action yet (that is, if it
exceeds~|l|), we must update its |mate| entry at this point.

@<Unpack a state, and move |tail| up@>=
for (t=j;t<=l;t++,tail++) {
  mate[t]=mem[trunc(tail)];
}

@ Here's where we update the mates. The order of doing this is carefully
chosen so that it works fine when |mate[j]=j| and/or |mate[k]=k|.

@<Print the successor if arc |i| is chosen@>=
if (k>0) {
  jm=mate[j],km=mate[k];
  if (jm==j) jm=-j;
  if (jm>=0 || km<=0) printf("0"); /* we mustn't touch a saturated vertex */
  else if (jm==-k)
    @<Print 1 or 0, depending on whether this arc wins or loses@>@;
  else {
    mate[j]=0,mate[k]=0;
    mate[-jm]=km,mate[km]=jm;
    printstate(j,jj,ll);
    mate[-jm]=j,mate[km]=k,mate[j]=jm,mate[k]=km; /* restore original state */
    if (mate[j]==-j) mate[j]=j;
  }
}@+else {
  jm=mate[j],km=mate[-k];
  if (km==-k) km=k;
  if (jm<=0 || km>=0) printf("0"); /* we mustn't touch a saturated vertex */
  else if (km==-j)
    @<Print 1 or 0, depending on whether this arc wins or loses@>@;
  else {
    mate[j]=0,mate[-k]=0;
    mate[jm]=km,mate[-km]=jm;
    printstate(j,jj,ll);
    mate[jm]=j,mate[km]=-k,mate[j]=jm,mate[-k]=km; /* restore original state */
    if (mate[-k]==k) mate[-k]=-k;
  }
}

@ @<Print the successor if arc |i| is not chosen@>=
printstate(j,jj,ll);

@ See the note below regarding a change that will restrict consideration
to Hamiltonian paths. A similar change is needed here.

@<Print 1 or 0, depending on whether this arc wins or loses@>=
{
  for (t=j+1;t<=ll;t++) if (t!=(k>0? k: -k)) {
    if (mate[t] && mate[t]!=t) break;
  }
  if (t>ll) printf("1"); /* we win: this cycle is all by itself */
  else printf("0"); /* we lose: there's junk outside this cycle */
}

@ The |printstate| subroutine does the rest of the work. It makes sure
that no incomplete paths linger in positions |j| through |jj-1|, which
are about to disappear; and it puts the contents of |mate[jj]| through
|mate[ll]| into the queue, checking to see if it was already there.

If `|mate[t]!=t|' is removed from the condition below, we get
Hamiltonian paths only (I mean, simple paths that include every vertex).

@<Sub...@>=
void printstate(int j,int jj,int ll) {
  register int h,hh,ss,t,tt,hash;
  for (t=j;t<jj;t++)
    if (mate[t] && mate[t]!=t) break;
  if (t<jj) printf("0"); /* incomplete junk mustn't be left hanging */
  else if (ll<jj) printf("0"); /* nothing is viable */
  else {
    ss=ll+1-jj;
    if (head+ss-tail>memsize) {
      fprintf(stderr,"Oops, I'm out of memory (memsize=%d, serial=%d)!\n",
             memsize,serial);
      exit(-69);
    }
    @<Move the current state into position after |head|, and compute |hash|@>;
    @<Find the first match, |hh|, for the current state after |boundary|@>;
    h=trunc(hh-boundary)/ss;
    printf("%x",newserial+h);
  }
}
    
@ @<Move the current state into position after |head|...@>=
for (t=jj,h=trunc(head),hash=0;t<=ll;t++,h=trunc(h+1)) {
  mem[h]=mate[t];
  hash=hash*31415926525+mate[t];
}

@ The hash table is automatically cleared whenever |htid| is increased,
because we store |htid| with each relevant table entry.

@<Find the first match, |hh|, for the current state after |boundary|@>=
for (hash=hash&(htsize-1);;hash=(hash+1)&(htsize-1)) {
  hh=htable[hash];
  if ((hh^htid)>=memsize) @<Insert new entry and |goto found|@>;
  hh=trunc(hh);
  for (t=hh,h=trunc(head),tt=trunc(t+ss-1);;t=trunc(t+1),h=trunc(h+1)) {
    if (mem[t]!=mem[h]) break;
    if (t==tt) goto found;
  }
}
found:

@ @<Insert new entry...@>=
{
  if (++htcount>(htsize>>1)) {
    fprintf(stderr,"Sorry, the hash table is full (htsize=%d, serial=%d)!\n",
              htsize,serial);
    exit(-96);
  }
  hh=trunc(head);
  htable[hash]=htid+hh;
  head+=ss;
  goto found;
}

@*Index.
