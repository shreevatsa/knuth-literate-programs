\datethis
@*Intro. Given the specification of a fillomino puzzle in |stdin|,
this program outputs {\mc DLX} data for the problem of finding
all solutions.

The specification consists of $m$ lines of $n$ entries each.
An entry is either `\..' or a digit from \.1 to~\.9 or \.a to~\.f.

A solution means that all `\..' entries are replaced by digits.
Every maximal rookwise connected set of cells labeled $d$ must
be a $d$-omino.

The maximum digit in the solution will be the maximum digit
specified. (For example, the program will make no attempt to
fit pentominoes into the blank cells, if all of the specified
digits are less than~\.5.)

N.B.: The assumption in the previous paragraph can be a serious
deviation from the standard rules for fillomino. Use the
change file {\mc FILLOMINO-DLX-LIMITS} if you want fine control
over which labels~$d$ are considered to be allowed in solutions.

The main interest in this program is its method for finding all
feasible $d$-ominoes $P$ that cover a given cell, when that cell
has lexicographically smallest coordinates in that $d$-omino;
$P$ is infeasible if it includes a non-$d$ label, or if
it's adjacent to a $d$ in a cell $\notin P$.
The algorithm used here is an instructive generalization of
Algorithm~R in exercise 7.2.2--75 of {\sl The Art of Computer
Programming}.

@d maxn 16 /* at most 16 (or I'll have to go beyond hex) */
@d maxd 16 /* digits of the solution must be less than this */
@d bufsize 80
@d pack(i,j) ((((i)+1)<<8)+(j)+1)
@d unpack(ij) icoord=((ij)>>8)-1,jcoord=((ij)&0xff)-1
@d board(i,j) brd[pack(i,j)]
@d panic(message) {@+fprintf(stderr,"%s: %s",message,buf);@+exit(-1);@+}

@c
#include <stdio.h>
#include <stdlib.h>
char buf[bufsize];
int brd[pack(maxn,maxn)]; /* the given pattern */
int dmax; /* the maximum digit seen */
@<Global data structures for Algorithm R@>;
@<Subroutines@>;
main() {
  register int a,d,i,j,k,l,m,n,p,q,s,t,u,v,di,dj,icoord,jcoord;
  printf("| fillomino-dlx:\n");
  @<Read the input into |board|@>;
  @<Print the item-name line@>;
  for (d=1;d<=dmax;d++) @<Print all the options for $d$-ominoes@>;
}

@ @<Read the input...@>=
for (i=n=t=0;i<=maxn;i++) {
  if (!fgets(buf,bufsize,stdin)) break;
  printf("| %s",
                 buf);
  for (j=k=0;;j++,k++) {
    if (buf[k]=='\n') break;
    if (buf[k]=='.') continue;
    if (buf[k]>='1' && buf[k]<='9')
      board(i,j)=buf[k]-'0',t++;
    else if (buf[k]>='a' && buf[k]<='f')
      board(i,j)=buf[k]-'a'+10,t++;
    else panic("illegal entry");
    if (board(i,j)>dmax) {
      if (board(i,j)>=maxd) {
        fprintf(stderr,"Sorry, all digits in the spec must be less than %d!\n",
                           maxd);
        exit(-5);
      }
      dmax=board(i,j);
    }
  }
  if (j>n) n=j; /* short rows are extended with `\..'s */
}
if (i>maxn) panic("too many rows");
m=i;
for (i=0;i<m;i++) board(i,-1)=board(i,n)=-1; /* frame the board */
for (j=0;j<n;j++) board(-1,j)=board(m,j)=-1; 
fprintf(stderr,"OK, I've read %d clues <= %d, for a %dx%d board.\n",
                          t,dmax,m,n);
mm=m,nn=n;

@ There are primary items $ij$ for $0\le i<m$ and $0\le j<n$.
They represent the cells to be filled.

There are secondary items \.{v$ijd$} for each vertical boundary edge of a
$d$-omino between $(i,j-1)$ and $(i,j)$, for $0\le i<m$ and
$1\le j< n$. Similarly, secondary items \.{h$ijd$} for
$1\le i<m$ and $0\le j<n$ are for horizontal boundary edges between
$(i-1,j)$ and $(i,j)$. These are needed only for edges between
blank cells.

@<Print the item-name line@>=
for (i=0;i<m;i++) for (j=0;j<n;j++) printf("%x%x ",
                i,j);
printf("|");
for (i=0;i<m;i++) for (j=1;j<n;j++) if (!board(i,j) && !board(i,j-1))
    for (d=1;d<=dmax;d++) printf(" v%x%x%x",
                i,j,d);
for (i=1;i<m;i++) for (j=0;j<n;j++) if (!board(i,j) && !board(i-1,j))
    for (d=1;d<=dmax;d++) printf(" h%x%x%x",
                i,j,d);
printf("\n");

@ @<Print all the options for $d$-ominoes@>=
{
  for (di=0;di<m;di++) for (dj=0;dj<n;dj++)
    @<Print the options for $d$-ominoes starting at $(di,dj)$@>;
}

@ Now comes the interesting part. I assume the reader is familiar
with Algorithm R in the solution to exercise 7.2.2--75. But we add
a new twist: A {\it forced move\/} is made to a $d$-cell if we've
chosen a vertex adjacent to~it. The first vertex ($v_0$) is also
considered to be forced.

Since I'm not operating with a general graph, the \.{ARCS} and \.{NEXT}
aspects of Algorithm~R are replaced with a simple scheme: Codes 1, 2, 3, 4
are used respectively for north, west, east, and south.
In other words, the operation `$a\gets\.{ARCS($v$)}$' is changed to
`$a\gets1$'; `$a\gets\.{NEXT($a$)}$' is changed to `$a\gets a+1$';
`$a=\Lambda$?' becomes `$a=5$?'. The vertex \.{TIP($a$)} is the
cell north, west, east, or south of~$v$, depending on~$a$.

A forced move at level $l$ is indicated by $a_l=0$.

If cell $(di,dj)$ is not already filled, we fill it with a $d$-omino
that uses only unfilled cells and doesn't come next to a $d$-cell.

@<Print the options for $d$-ominoes...@>=
{
  u=pack(di,dj);
  if (!board(di,dj)) {
    for (q=1;q<=4;q++) if (brd[u+dir[q]]==d) break; /* next to $d$ */
    if (q<=4) continue;
    forcing=0;
  }@+else if (board(di,dj)!=d) continue;
  else forcing=1;
  @<Do step R1@>;
  @<Do step R2@>;
  @<Do step R3@>;
  @<Do step R4@>;
  @<Do step R5@>;
  @<Do step R6@>;
  @<Do step R7@>;
done: checktags();
}

@ @<Do step R1@>=
r1: /* initialize */
for (i=0;i<m;i++) for (j=0;j<n;j++) tag[pack(i,j)]=0;
v=vv[0]=u,tag[v]=1;
i=ii[0]=0,a=aa[0]=0,l=1;

@ At the beginning of step R2, we've just chosen the vertex |u|,
which is |vv[l-1]|. If |l>1|, it's a vertex adjacent to |v=vv[i]|
in direction~|a|, where |i=ii[l-1]| and |a=aa[l-1]|.

@<Do step R2@>=
r2: /* enter level $l$ */
if (forcing) @<Make forced choices of all |d|-cells adjacent to~|u|;
  but |goto r7| if there's a problem@>;
if (l==d) {
  @<Print an option for the current |d|-omino@>;
  @<Undo the latest forced moves@>;
}

@ Ye olde depth-first search.

If forcing, we backtrack if the |d|-omino gets too big, or if
we're forced to choose a |d|-cell whose options have already been considered.

If not forcing, we backtrack if we're next to a |d|-cell, or if
solutions for this cell have already been considered.

@<Make forced choices of all |d|-cells adjacent to~|u|...@>=
for (stack[0]=u,s=1;s;) {
  u=stack[--s];
  for (q=1;q<=4;q++) {
    t=u+dir[q];
    if (brd[t]!=d) continue; /* not a |d|-cell */
    if (tag[t]) continue; /* we've already chosen this |d|-cell */
    if (t<vv[0]) goto r7; /* it came earlier than |(di,dj)| */
    if (l==d) goto r7; /* we've already got |d| vertices */
    aa[l]=0,vv[l++]=t,tag[t]=1,stack[s++]=t; /* forced move to |t| */
  }
}

@ OK, we've got a viable |d|-omino to pass to the output.

@<Print an option for the current |d|-omino@>=
{
  curstamp++;
  for (p=0;p<d;p++) {
    unpack(vv[p]);
    printf(" %x%x",
             icoord,jcoord);
    stamp[vv[p]]=curstamp;
  }
  for (p=0;p<d;p++) {
    unpack(vv[p]);
    if (!board(icoord,jcoord)) for (q=1;q<=4;q++)
      if (stamp[vv[p]+dir[q]]!=curstamp) { /* boundary edge detected */
        switch (q) {
case 1:@+if (icoord && !board(icoord-1,jcoord)) printf(" h%x%x%x",
            icoord,jcoord,d);@+break;
case 2:@+if (jcoord && !board(icoord,jcoord-1)) printf(" v%x%x%x",
            icoord,jcoord,d);@+break;
case 3:@+if (jcoord<n-1 && !board(icoord,jcoord+1)) printf(" v%x%x%x",
            icoord,jcoord+1,d);@+break;
case 4:@+if (icoord<m-1 && !board(icoord+1,jcoord)) printf(" h%x%x%x",
            icoord+1,jcoord,d);@+break;
      }
    }
  }
  printf("\n");
}

@ @<Undo the latest forced moves@>=
for (l--;aa[l]==0;l--) {
  if (l==0) goto done;
  tag[vv[l]]=0;
}

@ @<Do step R3@>=
r3: /* advance |a| */
a++;

@ @<Do step R4@>=
r4: /* done with level? */
if (a!=5) goto r5;
if (i==l-1) goto r6;
v=vv[++i],a=1;

@ @<Do step R5@>=
r5: /* try |a| */
u=v+dir[a];
if (brd[u]) goto r3; /* not really a neighbor of |v| */
tag[u]++;
if (tag[u]>1) goto r3; /* already chosen */
if (!forcing)
  @<If |u| was already handled, or if it's adjacent to a |d|-cell,
        |goto r3|@>;
ii[l]=i,aa[l]=a,vv[l]=u,l++;
goto r2;

@ @<If |u| was already...@>=
{
  if (u<vv[0]) goto r3; /* it's earlier than |(di,dj)| */
  for (q=1;q<=4;q++) if (brd[u+dir[q]]==d) goto r3;
}

@ @<Do step R6@>=
r6: /* backtrack */
@<Undo previous forced moves@>;
for (i=ii[l],k=i+1;k<=l;k++) {
  t=vv[k];
  for (q=1;q<=4;q++)
    if (brd[t+dir[q]]==0) tag[t+dir[q]]--; /* untag the neighbors of |vv[k]| */
}
for (a=aa[l]+1,v=vv[i];a<=4;a++)
  if (brd[v+dir[a]]==0) tag[v+dir[a]]--; /* untag late neighbors of |vv[i]| */
a=aa[l];
goto r3;

@ @<Undo previous forced moves@>=
for (l--;aa[l]==0;l--) {
  if (l==0) goto done;
  t=vv[l];
  for (q=1;q<=4;q++)
    if (brd[t+dir[q]]==0) tag[t+dir[q]]--; /* untag the neighbors of |vv[l]| */
  tag[t]=0;
}

@ @<Do step R7@>=
r7: /* recover from bad forcing */
@<Undo the latest forced moves@>;
i=ii[l],v=vv[i],a=aa[l];
goto r3;

@ @<Global data structures for Algorithm R@>=
int forcing;
int dir[5]={0,-(1<<8),-1,1,1<<8}; 
int tag[pack(maxn,maxn)];
int vv[maxd],aa[maxd],ii[maxd],stack[maxd]; /* state variables */
int curstamp;
int stamp[pack(maxn,maxn)];
int mm,nn;

@ @<Sub...@>=
void debug(char*message) {
   fprintf(stderr,"%s!\n",
                       message);
}

@ Here's a handy routine for debugging the tricky parts.

@<Sub...@>=
void showtags(void) {
  register int i,j;
  for (i=0;i<mm;i++) for (j=0;j<nn;j++) if (tag[pack(i,j)])
    printf("%x%x:%d\n",
                i,j,tag[pack(i,j)]);
}

@ @<Sub...@>=
void checktags(void) {
  register int i,j,q;
  for (i=0;i<mm;i++) for (j=0;j<nn;j++) if (tag[pack(i,j)]) {
    if (pack(i,j)==vv[0]) continue;
    for (q=1;q<=4;q++) if (pack(i,j)==vv[0]+dir[q]) break;
    if (q<=4) continue;
    debug("bad tag");
  }
}

@*Index.
