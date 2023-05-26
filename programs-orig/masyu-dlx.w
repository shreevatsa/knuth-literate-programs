@s edge int

@*Intro. Given the specification of a masyu puzzle in |stdin|,
this program outputs {\mc DLX} data for the problem of finding all solutions.
(I first hacked it from {\mc SLITHERLINK-DLX}; but a day later, I realized
that a far more efficient solution was possible, because masyu clues force
many of the secondary items to be identical or complementary.)

No attempt is made to enforce the ``single loop'' condition. Solutions
found by {\mc DLX2} will consist of disjoint loops. But {\mc DLX2-LOOP}
will weed out any disconnected solutions; in fact it will nip most of
them in the bud.

The specification begins with $m$ lines of $n$ characters each;
those characters should be either
`\.0' or `\.1' or~`\..', representing either a white circle, a black circle,
or no clue.

@d maxn 31 /* |m| and |n| must be at most this */
@d bufsize 80
@d debug 0x0 /* verbose printing? (each bit turns on a different case) */
@d panic(message) {@+fprintf(stderr,"%s: %s",message,buf);@+exit(-1);@+}

@c
#include <stdio.h>
#include <stdlib.h>
@<Type definitions@>;
char buf[bufsize];
int board[maxn][maxn]; /* the given clues */
int m,n; /* the given board dimensions */
edge ejj[((maxn+maxn)<<8)+(maxn+maxn)]; /* the union-find table */
char code[]={0xc,0xa,0x5,0x3,0x9,0x6,0x0};
int opt[4],optval[4];
int optcount;
@<Subroutines@>;
main() {
  register int i,j,k,ii,jj,v,t,e,p;
  @<Read the input into |board|@>;
  @<Reduce the secondary items to independent variables@>;
  @<Print the item-name line@>;
  @<Print options to make {\mc DLX2-LOOP} happy@>;
  for (i=0;i<m;i++) for (j=0;j<n;j++) if (board[i][j]=='.')
    @<Print the options for tile $(i,j)$@>@;
    else @<Print the options for circle $(i,j)$@>;
}

@ @<Read the input into |board|@>=
printf("| masyu-dlx:\n");
for (i=0;i<maxn;i++) {
  if (!fgets(buf,bufsize,stdin)) break;
  printf("| %s",
               buf);
  for (j=0;j<maxn && buf[j]!='\n';j++) {
    k=buf[j];
    if (k!='.' && (k<'0' || k>'4')) panic("illegal clue");
    board[i][j]=k;
  }
  if (i==0) n=j;
  else if (n!=j) panic("row has wrong number of clues");
}
m=i;
if (m<2 || n<2) panic("the board dimensions must be 2 or more");
fprintf(stderr,"OK, I've read a %dx%d array of clues.\n",
                          m,n);

@*Big reductions.
The original version of this program had one secondary item for each
edge of the grid. These secondary items essentially acted as
boolean variables, with their ``colors'' \.0 and~\.1.

Let the edges surrounding a clue be called $N$, $S$, $E$, and $W$.
A black clue tells us, among other things, that $N=\bar S$ and $E=\bar W$.
So it reduces the number of independent variables by two. A white clue
does even more: It tells us, among other things, that $N=S$ and $E=W$
and $N=\bar E$.

Internally, we represent the edge between cell $(i,j)$ and cell $(i',j)'$
by the packed value $256(i+i')+(j+j')$. A standard union-find algorithm
is used to determine which edges are dependent, and to provide a
canonical form for any edge in terms of an independent basis.

Edges off the board have the constant value~\.0. We often can deduce a
constant value for other edges. The ``constant'' edge is denoted
internally by zero.

@d N(v) ((v)-(1<<8))
@d S(v) ((v)+(1<<8))
@d E(v) ((v)+1)
@d W(v) ((v)-1)

@<Type def...@>=
typedef struct {
  int ldr; /* the representative of this equivalence class */
  int cmp; /* are we the same as the leader, or the same as its complement? */
  int nxt; /* next member of this class, in a cyclic list */
  int siz; /* the size of this class (if we're the leader) */
} edge;

@ @<Initialize all edges to independent@>=
for (ii=0;ii<=m+m-2;ii++) for (jj=0;jj<=n+n-2;jj++) if ((ii+jj)&1) {
  e=(ii<<8)+jj;
  ejj[e].ldr=ejj[e].nxt=e,ejj[e].siz=1;
}

@ @<Sub...@>=
int normalize(int e) {
  if (e<0) return 0; /* $i$ negative */
  if ((e&0xff)>n+n-2) return 0; /* $j$ negative or too large */
  if ((e>>8)>m+m-2) return 0; /* $i$ too large */
  return e; /* this edge not obviously constant */
}  

@ @<Sub...@>=
int yewnion(int e,int ee,int comp) {
  register int p,q,pp,qq,s,t;
  e=normalize(e),ee=normalize(ee);
  if (debug&1) fprintf(stderr," %c%c is %s%c%c\n",
               encode(e>>8),encode(e&0xff),
               comp?"~":"",encode(ee>>8),encode(ee&0xff));
  p=ejj[e].ldr,s=comp^ejj[e].cmp;
  pp=ejj[ee].ldr,s^=ejj[ee].cmp; /* now we want to set |p| to |pp^s| */
  if (p==pp) @<Check for consistency and exit@>;
  if (p==0 || (pp!=0 && ejj[p].siz>ejj[pp].siz)) t=p,p=pp,pp=t,t=e,e=ee,ee=t;
  @<Merge classes |p| and |pp|@>;
  return 0; /* ``no problem'' */
}

@ @<Merge...@>=
ejj[pp].siz+=ejj[p].siz;
if (debug&2) fprintf(stderr," (size of %c%c now %d)\n",
                             encode(pp>>8),encode(pp&0xff),ejj[pp].siz)@q)@>;
for (q=ejj[p].nxt;;q=ejj[q].nxt) {
  ejj[q].ldr=pp, ejj[q].cmp^=s;
  if (q==p) break;
}
t=ejj[p].nxt,ejj[p].nxt=ejj[pp].nxt,ejj[pp].nxt=t;

@ @<Check for consistency and exit@>=
{
  if (s==0) return 0; /* the new relation is consistent (and redundant) */
  fprintf(stderr,"Inconsistency found when equating %c%c to %s%c%c!\n",
               encode(e>>8),encode(e&0xff),
               comp?"~":"",encode(ee>>8),encode(ee&0xff));
  return 1; /* ``one problem'' */
}  

@ @<Reduce the secondary items to independent variables@>=
@<Initialize all edges to independent@>;
for (i=0;i<m;i++) for (j=0;j<n;j++) if (board[i][j]!='.') {
  v=((i+i)<<8)+(j+j);
  if (board[i][j]=='1') 
    t=yewnion(N(v),S(v),1)+yewnion(E(v),W(v),1);
  else
    t=yewnion(N(v),S(v),0)+yewnion(E(v),W(v),0)+yewnion(S(v),W(v),1);
  if (t) {
    printf("abort\n"); /* abort with an unsolvable problem */
    exit(0);
  }
}

@ @*Items.
The primary items are ``tiles'' and ``circles.'' Tiles control the
loop path; the name of tile $(i,j)$ is $(2i,2j)$. Circles represent
the clues; the name of circle $(i,j)$ is $(2i+1,2j+1)$. A circle item
is present only if a clue has been given for the corresponding tile
of the board.

The secondary items are ``edges'' of the path. Their names are
the midpoints of the tiles they connect.

We don't really need a tile item when a clue has been given;
the tile constraints have been guaranteed by our reduction process.
However, {\mc DLX2-LOOP} requires a tile item for every vertex,
as an essential part of its data structures! So we create ``dummy''
tile items, and put them into a special option, to make that program happy.

We don't really need an edge item unless it's the root of its union-find tree.
But once again we must pander to the whims of {\mc DLX2-LOOP}.
So we create special primary items \.{\char`\#$e$}, for each equivalence
class of size 2~or~more.

@d encode(x) ((x)<10? (x)+'0': (x)<36? (x)-10+'a': (x)<62? (x)-36+'A': '?')

@<Print the item-name line@>=
for (i=0;i<m;i++) for (j=0;j<n;j++) printf("%c%c ",
                                       encode(i+i),encode(j+j));
for (i=0;i<m;i++) for (j=0;j<n;j++) if (board[i][j]!='.') printf("%c%c ",
                                       encode(i+i+1),encode(j+j+1));
for (ii=0;ii<=m+m-2;ii++) for (jj=0;jj<=n+n-2;jj++) if ((ii+jj)&1) {
  e=(ii<<8)+jj;
  if (ejj[e].ldr==e && ejj[e].siz>1) printf("#%c%c ",
                                           encode(ii),encode(jj));
}
printf("|");
for (i=0;i<m+m-1;i++) for (j=0;j<n+n-1;j++) if ((i+j)&1)
  printf(" %c%c",
                               encode(i),encode(j));
printf("\n");

@*Options.
Each option to be output is either of special one (designed to
make {\mc DLX2-LOOP} happy) or consists of a primary item together with
constraints on four edges. Those edges might be dependent,
or off the board, in which case
fewer than four constraints are involved.

In fact, all four edges might turn out to be constant, in which case the
option is always true or always false. An option might also turn out to
be just plain foolish,
if it tries to make some boolean variable both true and false.
Such options, and the always-false ones, should not be output.

Therefore we gather the constraints one by one, before outputting any
option. Pending constraints are accumulated in a sorted array called |opt|.

@<Sub...@>=
void begin_opt(int ii,int jj) {
  if (debug&4) fprintf(stderr," beginning an option for %c%c:\n",
                             encode(ii),encode(jj));
  optcount=0;
}

@ @<Sub...@>=
void append_opt(int e,int val) {
  register int q,p,s,t;
  if (optcount<0) return; /* option has already been cancelled */
  e=normalize(e),val=val&1;
  if (debug&4) fprintf(stderr,"  %c%c:%d\n",
                             encode(e>>8),encode(e&0xff),val);
  p=ejj[e].ldr, val^=ejj[e].cmp;
  if (p==0) @<Handle a constant constraint and exit@>;
  for (t=0;t<optcount;t++) if (opt[t]>=p) break;
  if (t<optcount && opt[t]==p) @<Handle a matching constraint and exit@>;
  for (s=optcount++;s>t;s--) opt[s]=opt[s-1],optval[s]=optval[s-1];
  opt[s]=p,optval[s]=val;
  if (debug&8) fprintf(stderr,"  (%c%c:%d)\n",
                             encode(p>>8),encode(p&0xff),val);@q)@>
  return;
}

@ The constant 0 is false.

@<Handle a constant constraint and exit@>=
{
  if (val==1) {
    if (debug&8) fprintf(stderr,"  (false)\n");
    optcount=-1;
  }@+else if (debug&8) fprintf(stderr,"  (true)\n");
  return;
}

@ @<Handle a matching constraint and exit@>=
{
  if (val!=optval[t]) {
    if (debug&8) fprintf(stderr,"  (%c%c:%d!)\n",
                             encode(p>>8),encode(p&0xff),val)@q)@>;
    optcount=-1;
  }
  if (debug&8) fprintf(stderr,"  (%c%c:%d)\n",
                             encode(p>>8),encode(p&0xff),val)@q)@>;
  return;
}

@ @<Sub...@>=
void finish_opt(int ii,int jj) {
  register int t;
  if (optcount>=0) {
    printf("%c%c",
                encode(ii),encode(jj));
    for (t=0;t<optcount;t++) printf(" %c%c:%d",
                encode(opt[t]>>8),encode(opt[t]&0xff),optval[t]);
    printf("\n");
  }
}
 
@*Generating the special options.
Just after making the item-name line, we generate a catchall option that
names all tiles for which a clue has been given, as well as all edges
whose boolean value is known in advance. This option will get
{\mc DLX2-LOOP} off to a good start.

@<Print options to make {\mc DLX2-LOOP} happy@>=
for (i=0;i<m;i++) for (j=0;j<n;j++) if (board[i][j]!='.') printf("%c%c ",
                                       encode(i+i),encode(j+j));
for (p=ejj[0].nxt;p;p=ejj[p].nxt) printf("%c%c:%d ",
                   encode(p>>8),encode(p&0xff),ejj[p].cmp);
printf("\n");

@ @<Print options to make {\mc DLX2-LOOP} happy@>=
for (ii=0;ii<=m+m-2;ii++) for (jj=0;jj<=n+n-2;jj++) if ((ii+jj)&1) {
  e=(ii<<8)+jj;
  if (ejj[e].ldr==e && ejj[e].siz>1) {
    printf("#%c%c",
                               encode(ii),encode(jj));
    for (p=ejj[e].nxt;;p=ejj[p].nxt) {
      printf(" %c%c:%d",
                   encode(p>>8),encode(p&0xff),ejj[p].cmp);
      if (p==e) break;
    }
    printf("\n");
    printf("#%c%c",
                               encode(ii),encode(jj));
    for (p=ejj[e].nxt;;p=ejj[p].nxt) {
      printf(" %c%c:%d",
                   encode(p>>8),encode(p&0xff),ejj[p].cmp^1);
      if (p==e) break;
    }
    printf("\n");
  }
}

@*Generating the normal options.
The four constraints for a tile say that the $N$, $S$, $E$, $W$
neighbors of $(i,j)$ include exactly 0 or 2 true edges.

@<Print the options for tile $(i,j)$@>=
{
  e=((i+i)<<8)+(j+j);
  for (k=0;k<7;k++) {
    begin_opt(i+i,j+j);
    append_opt(N(e),code[k]>>3);
    append_opt(W(e),code[k]>>2);
    append_opt(E(e),code[k]>>1);
    append_opt(S(e),code[k]);
    finish_opt(i+i,j+j);
  }
}    
    
@ @<Print the options for circle $(i,j)$@>=
{
  e=((i+i)<<8)+(j+j);
  if (board[i][j]=='1') @<Print the options for a black circle at $(i,j)$@>@;
  else @<Print the options for a white circle at $(i,j)$@>;
}

@ The four constraints for circles look further, at neighbors that are
two steps away.

@d NN(v) ((v)-(3<<8))
@d SS(v) ((v)+(3<<8))
@d EE(v) ((v)+3)
@d WW(v) ((v)-3)

@<Print the options for a black circle at $(i,j)$@>=
{
  for (k=0;k<4;k++) {
    begin_opt(i+i+1,j+j+1);
    if (code[k]&8) append_opt(N(e),1),append_opt(NN(e),1);
    if (code[k]&4) append_opt(W(e),1),append_opt(WW(e),1);
    if (code[k]&2) append_opt(E(e),1),append_opt(EE(e),1);
    if (code[k]&1) append_opt(S(e),1),append_opt(SS(e),1);
    finish_opt(i+i+1,j+j+1);
  }
}

@ @<Print the options for a white circle at $(i,j)$@>=
{
  for (k=4;k<6;k++) for (ii=0;ii<2;ii++) for (jj=0;jj<2;jj++) if (ii*jj==0) {
    begin_opt(i+i+1,j+j+1);
    if (code[k]&8) {
      append_opt(N(e),1);
      append_opt(NN(e),ii),append_opt(SS(e),jj);
    }@+else {
      append_opt(W(e),1);
      append_opt(WW(e),ii),append_opt(EE(e),jj);
    }
    finish_opt(i+i+1,j+j+1);
  }
}

@*Index.
