@x
This basic {\mc SAT11} program, like the earliest versions of {\mc MARCH},
is intended for {\mc 3SAT} problems only: All clauses must have size
3 or less. However, a changefile converts this program to {\mc SAT11K},
which has no such restriction. A good understanding of the {\mc 3SAT}
version presented below will make it easier to understand the modifications by
which the algorithms can be adapted to handle clauses of any length.
@y
Actually this program is not {\mc SAT11} but {\mc SAT11K}, an extension
that handles general clauses; the original {\mc SAT11} limited itself to
clauses of length three or less. You might want to read that program first,
before getting into the extra complications of this one. (On the other hand,
some aspects of this version are simpler. So take heart: You can handle
{\mc SAT11K} just fine.) Asterisks indicate differences between
{\mc SAT11} and {\mc SAT11K}.
@z
@x
  register int au,av,aw,h,i,j,jj,k,kk,l,ll,p,pp,q,qq,r,s;
@y
  register int au,av,aw,h,i,j,jj,k,kk,l,ll,p,pp,q,qq,r,s,cia,cis,ci;
@z
@x
@ The default values of parameters below have been tuned for
random {\mc 3SAT} instances, based on tests by Holger Hoos in 2015.
@y
@ The default values of parameters below have been tuned for a broad
spectrum of {\mc SAT} instances, based on tests by Holger Hoos in 2015.
@z
@x
@d show_unused_vars 32 /* |verbose| code to list variables not in solution */
@y
@d show_unused_vars 32 /* |verbose| code to list variables not in solution */
@d show_big_clauses 64 /* |verbose| code to print all big guys at beginning */
@z
@x
float alpha=3.5; /* magic constant for heuristic scores */
float max_score=20.0; /* heuristic scores will be at most this */
int hlevel_max=50; /* saved levels of heuristic scores */
int levelcand=600; /* preselected candidates times levels */
int mincutoff=30; /* don't cut off fewer than this many candidates */
int max_prelook_arcs=1000; /* space available for arcs re strong components */
int dl_max_iter=32; /* maximum iterations of double-look */
float dl_rho=0.9995; /* damping factor for the double-look trigger */
@y
float alpha=0.001; /* magic constant for heuristic scores */
float gamm=0.20; /* magic ratio for the clause reduction heuristic */
int theta64=25; /* the optimization parameter $theta$, times 64 */
int levelcand=600; /* preselected candidates times levels */
int mincutoff=30; /* don't cut off fewer than this many candidates */
int max_prelook_arcs=5000; /* space available for arcs re strong components */
int dl_max_iter=1; /* maximum iterations of double-look */
float dl_rho=0.9998; /* damping factor for the double-look trigger */
@z
@x
`\.t$\langle\,$positive float$\,\rangle$' to adjust the maximum permissible
heuristic score.
\item{$\bullet$}
`\.l$\langle\,$positive integer$\,\rangle$' to adjust the number of levels
of heuristic scores that are remembered.
\item{$\bullet$}
@y
`\.g$\langle\,$positive float$\,\rangle$' to adjust the magic ratio
$\gamma$ in the clause reduction heuristic scores |clause_weight[k]|.
\item{$\bullet$}
`\.t$\langle\,$positive integer$\,\rangle$' to adjust the fraction
$\theta=n/64$ that triggers clause rearrangement.
\item{$\bullet$}
@z
@x
case 't': k|=(sscanf(argv[j]+1,""O"f",&max_score)-1);@+break;
case 'l': k|=(sscanf(argv[j]+1,""O"d",&hlevel_max)-1);@+break;
@y
case 'g': k|=(sscanf(argv[j]+1,""O"f",&gamm)-1);@+break;
case 't': k|=(sscanf(argv[j]+1,""O"d",&theta64)-1);@+break;
@z
@x
if (k || hbits<0 || hbits>30 || buf_size<=0 || memk_max<2 || memk_max>31 ||
       alpha<=0.0 || max_score<=0.0 || hlevel_max<3 || levelcand<=0 ||
       mincutoff<=0 || max_prelook_arcs<=0 || dl_max_iter<=0) {
  fprintf(stderr,
     "Usage: "O"s [v<n>] [c<n>] [h<n>] [b<n>] [s<n>] [d<n>] [m<n>]",argv[0]);
  fprintf(stderr," [H<n>] [a<f>] [t<f>] [l<n>] [p<n>] [q<n] [z<n>]");
  fprintf(stderr," [i<n>] [r<f>] [x<foo>] [V<foo>] [T<n>] < foo.sat\n");
@y
if (k || hbits<0 || hbits>30 || buf_size<=0 || memk_max<2 || memk_max>31 ||
       alpha<=0.0 || gamm<=0 || theta64<0 || levelcand<=0 ||
       mincutoff<=0 || max_prelook_arcs<=0 || dl_max_iter<=0) {
  fprintf(stderr,
     "Usage: "O"s [v<n>] [c<n>] [h<n>] [b<n>] [s<n>] [d<n>] [m<n>] ",argv[0]);
  fprintf(stderr," [H<n>] [g<f>] [a<f>] [t<n>] [p<n>] [q<n] [z<n>]");
  fprintf(stderr," [i<n>] [r<f>] [x<foo>] [V<foo>] [T<n>] < foo.sat\n");
@z
@x
int ternaries; /* how many were ternary? */
ullng cells; /* how many occurrences of literals in clauses? */
@y
ullng cells; /* how many occurrences of literals in clauses? */
ullng bclauses; /* how many clauses are big (have more than two literals)? */
ullng bcells; /* how many occurrences of literals in big clauses? */
@z
@x
  if (k>3) {
    fprintf(stderr,
      "Sorry: This program accepts unary, binary, and ternary clauses only!");
    fprintf(stderr," (line "O"lld)\n",clauses);
    exit(-1);
  }
  if (k==3) ternaries++;
@y
  if (k>=3) bclauses++,bcells+=k;
  if (k>max_clause) max_clause=k;
@z
@x
Third, there's also a |timp| data structure. Each ternary clause
$l\lor l'\lor l''$ means that $\bar l\to l'\lor l''$, $\bar l'\to l''\lor l$,
$\bar l''\to l\lor l'$; and |timp| records the binary clauses implied by any
given literal. (Preprocessing has ensured that each ternary clause appears in a
canonical order $l<l'<l''$; thus we won't have both $\bar l\to l'\lor l''$
and $\bar l\to l''\lor l'$ within |timp|.) New ternary implications are
{\it not\/} added to |timp| during the computation; therefore the |timp|
structure is allocated once and for all at the beginning.
When a ternary clause becomes satisfied, it is swapped to an inactive
part of |timp| so that it will not slow down the analysis
of active clauses.
@y
Third, we need a good way to manipulate the ``big clauses,'' namely the
clauses that contain three or more literals. Two arrays called
|cinx| and~|kinx|, which are indexes into two larger arrays called
|cmem| and~|kmem|,  govern this aspect of the problem: |cinx[c]| tells where
the literals of clause~$c$ are listed in~|cmem|, while |kinx[l]| tells where
the clauses that contain a given literal~$l$ are listed in~|kmem|.
All four of these arrays are allocated once and for all before the main
computation begins.
@z
@x
tpair *tmem; /* master array of blocks for |timp| lists */
tdata *timp; /* indexes into |tmem| for lists of ternary implications */
@y
uint *cmem,*kmem; /* master arrays for |cinx| and |kinx| data */
tdata *cinx,*kinx; /* indexes into |cmem| and |kmem| for the big clause info
*/
tpair *bstack; /* holding place for big clauses that become binary or unary */
int bptr; /* the number of elements used in |bstack| */
int max_use; /* the maximum number of times any literal occurs */
tpair *tmem; /* master array of blocks for |timp| lists */
tdata *timp; /* indexes into |tmem| for lists of ternary implications */
@z
@x
while others (like |bimp| and |timp|) are indexed by literal numbers. In order
@y
while others (like |bimp| and |kinx|) are indexed by literal numbers. In order
@z
@x
@ An entry in |timp| has two parts: |addr| is the address in |tmem| where
the list of implication pairs begins; |size| is the current length
of that list.

An entry in |tmem| has two parts, |u| and |v|, for the two literals
$l'$ and $l''$ whose {\mc OR} is implied by a given literal~$l$.
It also has a |link| field, which points to the next |tmem| entry in the triad
that corresponds to an original ternary clause.

(Each original clause $l\lor l'\lor l''$ leads to |timp| entries for $\bar l$,
$\bar l'$, and $\bar l''$. These three entries are circularly linked.)
@y
@ An entry in |cinx| has two parts: |addr| is the address in |cmem| where the
list of literals for a given clause begins; |size| is initially the length of
that list. When literals of a clause become true or false, the |size| field
is adjusted in a somewhat tricky way, explained below within the |sanity|
routine. The literals of the input clauses are loaded backwards into~|cmem|,
so that we have |cinx[c].addr+cinx[c].size=cinx[c-1].addr| when
computation begins.

An entry in |kinx| is, likewise, bipartite: |addr| is the address in |kmem|
where the list of clauses numbers for a given literal begins, and |size| is
the current length of that list. If |l| is a free literal (namely a literal
whose value has not been assigned true or false), |kinx[l].size| will be the
number of clauses that contain~|l| and are not yet satisfied.

When a big clause is reduced to binary, because all but two of its literals
have become false while none have become true, we will place it briefly on the
|bstack|, whose entries are pairs of literals.
@z
@x
typedef struct tpair_struct {
  uint u,v; /* a pair of literals */
  uint link; /* the successor pair of a triad */
  uint spare; /* used only when reading the initial data */
} tpair; /* two octabytes */
@y
typedef struct tpair_struct {
  uint u,v; /* a pair of literals */
} tpair; /* one octabyte */
@z
@x
@ Similarly, the current ternary implicant data gives useful diagnostic info.

@<Sub...@>=
void print_timp(int l) {
  register uint la,ls;
  printf(""O"s"O".8s ->",litname(l));
  for (la=timp[l].addr,ls=timp[l].size;ls;la++,ls--)
   printf(" "O"s"O".8s|"O"s"O".8s",litname(tmem[la].u),litname(tmem[la].v));
  printf("\n");
}
@#
void print_full_timp(int l) {
  register uint la,k;
  printf(""O"s"O".8s ->",litname(l));
  for (la=timp[l].addr,k=0;k<timp[l].size;k++)
    printf(" "O"s"O".8s|"O"s"O".8s",litname(tmem[la+k].u),litname(tmem[la+k].v));
  if (la+k!=timp[l-1].addr) {
    printf(" #"); /* show also the inactive implicants */
    for (;la+k<timp[l-1].addr;k++)
      printf(" "O"s"O".8s|"O"s"O".8s",litname(tmem[la+k].u),litname(tmem[la+k].v));
  }
  printf("\n");
}
@y
@ Similarly, the current data for big clauses gives useful diagnostic info.

@<Sub...@>=
void print_clause(int c) {
  register uint la,ls;
  printf(""O"d:",c);
  for (la=cinx[c].addr;la<cinx[c-1].addr;la++)
   printf(" "O"s"O".8s"O"s",litname(cmem[la]),
      isfree(cmem[la])?"":iscontrary(cmem[la])?"-":"+");
  printf(" ("O"d)\n",cinx[c].size);
}
@#
void print_kinx(int l) {
  register uint la,ls;
  printf("kinx["O"s"O".8s]:",litname(l));
  for (la=kinx[l].addr,ls=kinx[l].size;ls;la++,ls--)
   printf(" "O"d",kmem[la]);
  printf("\n");
}
@#
void print_full_kinx(int l) {
  register uint la,k;
  printf("kinx["O"s"O".8s]:",litname(l));
  for (la=kinx[l].addr,k=0;k<kinx[l].size;k++)
    printf(" "O"d",kmem[la+k]);
  if (la+k!=kinx[l-1].addr) {
    printf(" #"); /* show also the inactive clauses */
    for (;la+k<kinx[l-1].addr;k++)
      printf(" "O"d",kmem[la+k]);
  }
  printf("\n");
}
@z
@x
  register int j,k,l,la,ls,los,p,q,u,v;
@y
  register int c,j,k,l,la,ls,p,q,u,v;
@z
@x
  @<Check the sanity of |timp| and |tmem|@>;
}

@ @<Check the sanity of |timp| and |tmem|@>=
for (l=2;l<badlit;l++) {
  la=timp[l].addr, ls=timp[l].size, los=timp[l-1].addr-la;
  for (k=0;k<los;k++) {
    if (tmem[tmem[tmem[la+k].link].link].link!=la+k)
      fprintf(stderr,"links clobbered in tmem[0x"O"x]!\n",
               la+k);     
    u=tmem[la+k].u, v=tmem[la+k].v;
    if (k<ls) { /* active area, shouldn't contain assigned variables */
      if (stamp[thevar(l)]<real_truth) { /* unless |l| itself is assigned */
        if (stamp[thevar(u)]>=real_truth)
          fprintf(stderr,"active timp u for free lit "O"d has assigned lit "O"d!\n",
                             l,u);
        if (stamp[thevar(v)]>=real_truth)
          fprintf(stderr,"active timp v for free lit "O"d has assigned lit "O"d!\n",
                             l,v);
      }
    }@+else if (stamp[thevar(u)]<real_truth && stamp[thevar(v)]<real_truth)
      fprintf(stderr,"inactive timp entry for "O"d has unassigned "O"d and "O"d!\n",
                           l,u,v);
  }
}
@y
  @<Check the sanity of |cinx| and |cmem|, |kinx| and |kmem|@>;
}

@ A big clause $c=l_1\lor\cdots\lor l_k$ for $k\ge3$ begins unsatisfied,
and its initial size is~$k$. Later, after $j$ of its literals have become
false but none of them have yet become true, the size will be $k-j$,
as long as $k-j\ge2$. (The nonfalse literals needn't be adjacent in memory
at such times; we only need to know that the residual clause is still big.)
But when $j$ reaches~$k-2$, or when one of the literals becomes true,
clause $c$ becomes inactive: It disappears from the |kinx| tables of
all free literals. Henceforth the elements of~$c$ will not be examined
again in~|cmem| until we undo the setting of the literal that inactivated~|c|.

Thus a clause is inactive if and only if it has been satisfied (contains a
true literal) or has become binary (has at most two nonfalse literals). The
program here marks inactive clauses by temporarily complementing their
|size| fields, so that we can validate the |kinx| data.

@<Check the sanity of |cinx| and |cmem|...@>=
for (c=bclauses;c;c--) {
  for (la=cinx[c].addr,k=ls=cinx[c-1].addr-la,j=0;ls;la++,ls--) {
    l=cmem[la];
    if (isfree(l)) continue; /* neither true nor false */
    if (iscontrary(l)) j++; /* false */
    else goto inactive; /* true */
  }
  if (j>=k-2) {
    if (cinx[c].size!=2)
      fprintf(stderr,"ex-big clause "O"d has size "O"d!\n",c,cinx[c].size);
    goto inactive;
  }
  if (cinx[c].size!=k-j)
    fprintf(stderr,"big clause "O"d has size "O"d not "O"d\n",c,cinx[c].size,k-j);
  continue;
inactive: cinx[c].size=~cinx[c].size;
}
for (l=2;l<badlit;l++) if (isfree(l)) {
  for (la=kinx[l].addr, ls=kinx[l].size;ls;la++,ls--) {
    c=kmem[la];
    if ((int)cinx[c].size<0)
      fprintf(stderr,"kinx["O"s"O".8s] includes active clause "O"d!\n",
                     litname(l),c);
  }
  for (;la<kinx[l-1].addr;la++) {
    c=kmem[la];
    if ((int)cinx[c].size>=0)
      fprintf(stderr,"kinx["O"s"O".8s] omits active clause "O"d!\n",
                     litname(l),c);
  }
}
for (c=bclauses;c;c--) if ((int)cinx[c].size<0) cinx[c].size=~cinx[c].size;
@z
@x
timp=(tdata*)malloc(badlit*sizeof(tdata));
if (!timp) {
  fprintf(stderr,"Oops, I can't allocate the timp array!\n");
  exit(-10);
}
bytes+=badlit*sizeof(tdata);
tmem=(tpair*)malloc(3*ternaries*sizeof(tpair));
if (!tmem) {
  fprintf(stderr,"Oops, I can't allocate the tmem array!\n");
  exit(-10);
}
bytes+=3*ternaries*sizeof(tpair);
@y
cinx=(tdata*)malloc((bclauses+1)*sizeof(tdata));
if (!cinx) {
  fprintf(stderr,"Oops, I can't allocate the cinx array!\n");
  exit(-10);
}
bytes+=(bclauses+1)*sizeof(tdata);
cmem=(uint*)malloc(bcells*sizeof(uint));
if (!cmem) {
  fprintf(stderr,"Oops, I can't allocate the cmem array!\n");
  exit(-10);
}
kinx=(tdata*)malloc(badlit*sizeof(tdata));
if (!kinx) {
  fprintf(stderr,"Oops, I can't allocate the cmem array!\n");
  exit(-10);
}
bytes+=badlit*sizeof(tdata);
kmem=(uint*)malloc(bcells*sizeof(uint));
if (!kmem) {
  fprintf(stderr,"Oops, I can't allocate the kmem array!\n");
  exit(-10);
}
bytes+=bcells*sizeof(uint);
@z
@x
@ @<Copy all the temporary cells to the |bimp|, |mem|, |timp|, and |tmem| arrays
   in proper format@>=
forcedlits=0; /* prepare for possible unary clauses */
for (l=2;l<badlit;l++) o,timp[l].addr=timp[l].size=0; /* clear the counts */
for (c=clauses,k=0; c; c--) {
  @<Insert the cells for the literals of clause |c|@>;
}
@<Build |timp| and |tmem| from the stored ternary clauses@>;
@y
@ @<Copy all the temporary cells to the |bimp|, |mem|, |cinx|, |cmem|,
  |kinx|, and |kmem| arrays in proper format@>=
forcedlits=0, cs=proto_truth; /* prepare for possible unary clauses */
for (l=2;l<badlit;l++) o,kinx[l].addr=kinx[l].size=0; /* clear the counts */
for (c=clauses,k=0,cc=bclauses; c; c--) {
  la=k;
  @<Insert the cells for the literals of clause |c|@>;
}
cinx[0].addr=k;
if (k!=bcells || cc) confusion("cmem");
@<Build |kinx| and |kmem| from the stored big clauses@>;
@z
@x
  rstack[j++]=p+2; /* the clause is first assembled in |rstack| */
    /* but no mems are charged, because three registers could be used */
}
u=rstack[0],v=rstack[1],w=rstack[2]; /* see? */
if (out_file) {
  for (jj=0;jj<j;jj++) fprintf(out_file," "O"s"O".8s",litname(rstack[jj]));
  fprintf(out_file,"\n");
}
if (j==1) @<Store a unary clause in |forcedlit|@>@;
else if (j==2) @<Store a binary clause in |bimp|@>@;
else @<Store a ternary clause in |tmem|@>;
@y
  o,cmem[k++]=p+2,j++;
  oo,kinx[p+2].size++;
}
if (out_file) {
  for (jj=0;jj<j;jj++) fprintf(out_file," "O"s"O".8s",litname(cmem[la+jj]));
  fprintf(out_file,"\n");
}
if (j<3) { /* not big */
  k=la,u=cmem[la];
  oo,kinx[u].size--;
  if (j==2) {
    oo,v=cmem[la+1],kinx[v].size--;
    @<Store a binary clause in |bimp|@>;
  }@+else @<Store a unary clause in |forcedlit|@>;
}@+else o,cinx[cc].addr=la,cinx[cc].size=k-la,cc--;
@z
@x
The |addr| fields in |timp| are borrowed here, temporarily, so that no variable
is forced twice.

@<Store a unary clause in |forcedlit|@>=
{
  if (o,timp[u].addr==0) {
    if (o,timp[bar(u)].addr) {
      if (verbose&show_choices)
        fprintf(stderr,"Unary clause "O"d contradicts unary clause "O"d\n",
                     c,timp[bar(u)].addr);
      goto unsat;
    }
    o,timp[u].addr=c;
@y
The |addr| fields in |kinx| are borrowed here, temporarily, so that no variable
is forced twice.

@<Store a unary clause in |forcedlit|@>=
{
  if (o,kinx[u].addr==0) {
    if (o,kinx[bar(u)].addr) {
      if (verbose&show_choices)
        fprintf(stderr,"Unary clause "O"d contradicts unary clause "O"d\n",
                     c,kinx[bar(u)].addr);
      goto unsat;
    }
    o,kinx[u].addr=c;
@z
@x
@ During the preliminary ``counting'' pass,
 we put ternary clauses sequentially into the spare slots of |tmem|.

@<Store a ternary clause in |tmem|@>=
{
  oo,timp[bar(u)].size++;
  oo,timp[bar(v)].size++;
  oo,timp[bar(w)].size++;
  ooo,tmem[k].spare=u,tmem[k+1].spare=v,tmem[k+2].spare=w;
  k+=3;
}

@ @<Build |timp| and |tmem| from the stored ternary clauses@>=
for (j=0,l=badlit-1;l>=2;l--) {
  oo,timp[l].addr=j,j+=timp[l].size,timp[l].size=0;
}
o,timp[l].addr=j; /* we'll have |timp[l].addr+timp[l].size=timp[l-1].addr| */
if (k!=j || k!=3*ternaries) confusion("ternaries");
while (k) {
  k-=3;
  ooo,u=tmem[k].spare,v=tmem[k+1].spare,w=tmem[k+2].spare;
  o,la=timp[bar(u)].addr,ls=timp[bar(u)].size,uu=la+ls;
  o,timp[bar(u)].size=ls+1;
  o,tmem[uu].u=v,tmem[uu].v=w;
  o,la=timp[bar(v)].addr,ls=timp[bar(v)].size,vv=la+ls;
  o,tmem[uu].link=vv;
  o,timp[bar(v)].size=ls+1;
  o,tmem[vv].u=w,tmem[vv].v=u;
  o,la=timp[bar(w)].addr,ls=timp[bar(w)].size,ww=la+ls;
  o,tmem[vv].link=ww;
  o,timp[bar(w)].size=ls+1;
  o,tmem[ww].u=u,tmem[ww].v=v;
  o,tmem[ww].link=uu;
}
@y
@ @<Build |kinx| and |kmem|...@>=
max_use=0;
for (j=0,l=badlit-1;l>=2;l--) {
  oo,kinx[l].addr=j,jj=kinx[l].size,j+=jj,kinx[l].size=0;
  if (jj>max_use) max_use=jj;
}
o,kinx[l].addr=j; /* we'll have |kinx[l].addr+kinx[l].size=kinx[l-1].addr| */
if (j!=bcells) confusion("kinx1");
for (c=bclauses,j=0;c;c--) {
  for (o,k=cinx[c].size;k;k--) {
    o,u=cmem[j++];
    o,la=kinx[u].addr,ls=kinx[u].size;
    o,kmem[la+ls]=c;
    o,kinx[u].size=ls+1;
  }
}
if (j!=bcells) confusion("kinx2");
@<Allocate |bstack|@>;

@ @<Allocate |bstack|@>=
bstack=(tpair*)malloc(max_use*sizeof(tpair));
if (!bstack) {
  fprintf(stderr,"Oops, I can't allocate the bstack array!\n");
  exit(-10);
}
bytes+=max_use*sizeof(tpair);
@z
@x
binary implications and ternary implications. We examine only
@y
binary implications and $k$-ary implications for $k\ge3$. We examine only
@z
@x
becomes fully assigned to truth or falsity at the highest possible level.
@y
becomes fully assigned to truth or falsity at the highest possible level.
Every active big clause that contains |ll| or its complement is affected:
Those with |ll| itself become satisfied, while those with |bar(ll)| become
shorter.

Many details of that transformation are described in the special ``big
clauses'' addendum at the end of this program. Here we introduce only
a few of them.
@z
@x
tll=ll&-2;@+@<Swap out inactive ternaries implied by |tll|@>;
tll++;@+@<Swap out inactive ternaries implied by |tll|@>;
for (o,tla=timp[ll].addr,tls=timp[ll].size;tls;tla++,tls--) {
  o,u=tmem[tla].u, v=tmem[tla].v;
  if (verbose&show_details)
    fprintf(stderr,"  "O"s"O".8s->"O"s"O".8s|"O"s"O".8s\n",
          litname(ll),litname(u),litname(v));
  @<Record |thevar(u)| and |thevar(v)| as participants@>;
  @<Update for a potentially new binary clause $u\lor v$@>;
}
@y
@<Swap out all big clauses that contain |ll|@>;
tll=bar(ll), bptr=0; /* clear the |bstack| */
@<Reduce all big clauses that contain |tll|; if any become binary,
  swap them out and put them on |bstack|@>;
while (bptr) {
  o,bptr--,u=bstack[bptr].u,v=bstack[bptr].v;
  @<Update for a potentially new binary clause $u\lor v$@>;
}
@z
@x
@ The pairs in |timp| become inactive when any of their variables
become ``really'' fixed (whether true or false). Here we run through all
active occurrences of |tll| or its complement, moving them to the inactive
parts of their |timp| lists and putting active pairs in their place.

(Hint for decoding this code: If |u| and |v| are an active pair in |timp[tll]|,
then |v| and |bar(tll)| are an active pair in |timp[bar(u)]|;
also |bar(tll)| and |u| are an active pair in |timp[bar(v)]|.)

When |tll| becomes fixed, we do not, however, make the pairs in
|timp[tll]| and |timp[bar(tll)]| inactive. We keep those lists
intact, because we won't be referring to them again until
it's time to undo the operations of the present step.

Subtle point: Inactive |timp| entries for positive literals are swapped out
before the inactive |timp| entries for negative literals. This tends to
increase the likelihood that swapping won't be needed on subsequent branches.

@<Swap out inactive ternaries implied by |tll|@>=
for (o,la=timp[tll].addr,ls=timp[tll].size;ls;la++,ls--) {
  o,u=tmem[la].u, v=tmem[la].v;
  o,pu=tmem[la].link; /* pointer to a pair in |timp[bar(u)]| */
  o,pv=tmem[pu].link; /* pointer to a pair in |timp[bar(v)]| */
  o,aa=timp[bar(u)].addr,ss=timp[bar(u)].size-1;
  o,timp[bar(u)].size=ss;
  if (pu!=aa+ss) { /* need to swap */
    o,uu=tmem[aa+ss].u, vv=tmem[aa+ss].v;
    oo,q=tmem[aa+ss].link, qq=tmem[q].link; /* |qq| links to |aa+ss| */
    oo,tmem[qq].link=pu, tmem[la].link=aa+ss;
    oo,tmem[pu].u=uu, tmem[pu].v=vv, tmem[pu].link=q;
    pu=aa+ss;
    oo,tmem[pu].u=v, tmem[pu].v=bar(tll),tmem[pu].link=pv;
  }
  o,aa=timp[bar(v)].addr,ss=timp[bar(v)].size-1;
  o,timp[bar(v)].size=ss;
  if (pv!=aa+ss) { /* need to swap */
    o,uu=tmem[aa+ss].u, vv=tmem[aa+ss].v;
    oo,q=tmem[aa+ss].link, qq=tmem[q].link; /* |qq| links to |aa+ss| */
    oo,tmem[qq].link=pv, tmem[pu].link=aa+ss;
    oo,tmem[pv].u=uu, tmem[pv].v=vv, tmem[pv].link=q;
    pv=aa+ss;
    oo,tmem[pv].u=bar(tll), tmem[pv].v=u, tmem[pv].link=la;
  }
}

@ When a ternary clause reduces to the binary clause $u\lor v$,
@y
@ When |tll| becomes false in clause |c|, we simply decrease the size of~|c|
by~1, without taking time to move |tll| to a different place in~|cmem|. The
first time this happens to~|c| is, however, special: Then we also want to mark
all of |c|'s other literals as ``participants,'' as explained in the
preselection process below. That case can be recognized by the condition
|cinx[c].addr+cinx[c].size=cinx[c-1].addr|. While we're examining those
other literals, we might as well move |tll| to the end of the clause.

Interesting things start to happen when all but two of |c|'s literals
have been falsified, before any of them have become true. At that point
|c|~becomes inactive and its remaining literals yield a new binary clause.

@<Reduce all big clauses that contain |tll|...@>=
if (verbose&show_details)
  fprintf(stderr," ("O"s"O".8s out)\n",litname(tll));
for (o,tla=kinx[tll].addr,tls=kinx[tll].size;tls;tla++,tls--) {
  oo,c=kmem[tla],cia=cinx[c].addr,cis=cinx[c].size;
  if (o,cia+cis==cinx[c-1].addr) { /* |c| is reduced for the first time */
    for (ua=cia,su=cis;su;ua++,su--) {
      o,u=cmem[ua];
      if (u==tll) au=ua;
      else @<Record |thevar(u)| as a participant@>;
    }
    if (u!=tll) oo,cmem[ua-1]=tll,cmem[au]=u;
  }
  o,cinx[c].size=cis-1;
  if (cis==3) { /* exactly two literals of |c| are now free */
    for (ci=cia,v=cmem[ci];;ci++) {
      o,u=cmem[ci];
      if (isfree(u)) break;
    }
    if (ci!=cia) oo,cmem[cia]=u,cmem[ci]=v;
    for (ci++;;ci++) {
      o,v=cmem[ci];
      if (isfree(v)) break;
    }
    if (ci!=cia+1) ooo,cmem[ci]=cmem[cia+1],cmem[cia+1]=v;
    o,bstack[bptr].u=u,bstack[bptr].v=v,bptr++;
    if (verbose&show_details)
      fprintf(stderr,"  "O"s"O".8s->"O"s"O".8s|"O"s"O".8s\n",
            litname(bar(tll)),litname(u),litname(v));
    @<Swap |c| out of |u|'s clause list@>;
    u=v;@+@<Swap |c| out of |u|'s clause list@>;
  }
}

@ When a big clause reduces to the binary clause $u\lor v$,
@z
@x
@ The literals on |rstack[j]| for |rptr<=j<fptr| have become really true,
and the ripple effects of those settings require more attention.
Of principal importance is the fact that the ternary clauses in which
those literals or their complements appear have become inactive,
and they've been swapped to the ``invisible'' part of the relevant
|timp| lists.

There's good news here: We don't need to unswap any of the |timp| entries while
we're backtracking! The order of those entries isn't important; only
the state, active versus inactive, matters. The active entries are
those that appear among the first |size| entries, beginning at |addr|.
The inactive ones follow, in precisely the order in which they were
swapped out, because a pair never participates in swaps after it
has become inactive. Therefore we can reactivate the most-recently-swapped-out
item in any particular list by simply increasing |size| by~1.

Two or three literals of the same clause may have all become really
true or really false. The hocus pocus in the preceding paragraph works
correctly only if we are careful to do the virtual unswapping in
precisely the reverse order from which we've done the swapping.
@y
@ The literals on |rstack[j]| for |rptr<=j<fptr| have become really true,
and the ripple effects of those settings require more attention.
Of principal importance is the fact that the big clauses in which
those literals or their complements appear may have become inactive,
in which case they've been swapped to the ``invisible'' part of the relevant
|kinx| lists.

There's good news here: We don't need to unswap any of the |kinx| entries while
we're backtracking! The order of those entries isn't important; only
the state, active versus inactive, matters. The active entries are
those that appear among the first |size| entries, beginning at |addr|.
The inactive ones follow, in precisely the order in which they were
swapped out, because a pair never participates in swaps after it
has become inactive. Therefore we can reactivate the most-recently-swapped-out
item in any particular list by simply increasing |size| by~1.

Two or more literals of the same clause may have all become really
true or really false. We can be sure that the hocus pocus in the preceding
paragraph works correctly if we are careful to do the virtual unswapping in
precisely the reverse order from which we've done the swapping.
@z
@x
  tll=ll|1;@+@<Reactivate the inactive ternaries implied by |tll|@>;
  tll--;@+@<Reactivate the inactive ternaries implied by |tll|@>;
@y
  tll=bar(ll);
  @<Unreduce all big clauses that contain |tll|; if they had become
     binary, swap them back in@>;
  @<Swap in all big clauses that contain |ll|@>;
@z
@x
@ @<Reactivate the inactive ternaries implied by |tll|@>=
for (o,ls=timp[tll].size,la=timp[tll].addr+ls-1;ls;ls--,la--) {
  o,u=tmem[la].u, v=tmem[la].v;
  oo,timp[bar(u)].size++;
  oo,timp[bar(v)].size++;
}
@y
@ @<Unreduce all big clauses that contain |tll|...@>=
if (verbose&show_details)
  fprintf(stderr," ("O"s"O".8s in)\n",litname(tll));
for (o,tls=kinx[tll].size,tla=kinx[tll].addr+tls-1;tls;tla--,tls--) {
  o,c=kmem[tla];
  o,cia=cinx[c].addr,cis=cinx[c].size+1;
  o,cinx[c].size=cis;
  if (cis==3) {
    o,u=cmem[cia];@+@<Swap |c| back in to |u|'s clause list@>;
    o,u=cmem[cia+1];@+@<Swap |c| back in to |u|'s clause list@>;
  }
}
@z
@x
@<Record |thevar(u)| and |thevar(v)| as participants@>=
x=thevar(u);
o,p=vmem[x].pfx,q=vmem[x].len;
if (q<plevel) {
  t=prefix;
  if (q<32) t&=-(1LL<<(32-q)); /* zero out irrelevant bits */
  if (p!=t) o,vmem[x].pfx=prefix,vmem[x].len=plevel;
}@+else     o,vmem[x].pfx=prefix,vmem[x].len=plevel;
x=thevar(v);
o,p=vmem[x].pfx,q=vmem[x].len;
if (q<plevel) {
  t=prefix;
  if (q<32) t&=-(1LL<<(32-q)); /* zero out irrelevant bits */
  if (p!=t) o,vmem[x].pfx=prefix,vmem[x].len=plevel;
}@+else     o,vmem[x].pfx=prefix,vmem[x].len=plevel;
@y
@<Record |thevar(u)| as a participant@>=
{
  x=thevar(u);
  o,p=vmem[x].pfx,q=vmem[x].len;
  if (q<plevel) {
    t=prefix;
    if (q<32) t&=-(1LL<<(32-q)); /* zero out irrelevant bits */
    if (p!=t) o,vmem[x].pfx=prefix,vmem[x].len=plevel;
  }@+else     o,vmem[x].pfx=prefix,vmem[x].len=plevel;
}
@z
@x
Suppose there are $n$ free variables. Then there are $2n$ free literals,
and $2n$ scores $h(l)$ to compute. Experiments have shown that we tend
to get good estimates if these scores approximately satisfy the
nonlinear equations
$$h(l)=0.1+\alpha\sum_{l\to l'}\hat h(l')+
\sum_{l\to l'\lor l''}\hat h(l')\,\hat h(l''),$$
where $\alpha$ is a magic constant and where $\hat h(l)$ is a
multiple of~$h(l)$ such that $\sum_l\hat h(l)=2n$. (In other
words, we ``normalize'' the $h$'s so that the average score is~1.)
The default value $\alpha=3.5$ is recommended, but of course other
magic values can be tried by using the command-line parameter~`\.a'
to change~$\alpha$.

Given a set of $h(l)$ scores, we can get a refined set $h'(l)$ by
computing
$$h'(l)=0.1+\alpha\sum_{l\to l'}{h(l')\over\overline h}+
\sum_{l\to l'\lor l''}{h(l')\over\overline h}\,{h(l'')\over\overline h},
\qquad \overline h={1\over2n}\sum_l h(l).$$
At the root of the tree, we start with $h(l)=1$ for all $l$ and
then refine it several times. At deeper levels, we start with
the $h(l)$ values from the parent node and refine them (once).

A large array |hmem| holds all these values for the first |hlevel_max| levels
of the search tree. When |level>=hlevel_max|, we revert to
the most recent information that was saved. Inaccurate scores are
obviously most troublesome near the root, so we prefer expediency to
accuracy when |level| gets large. If the problem has $n$ variables,
the score $h(l)$ for level $j$ is stored in |hmem[2*n*j+l-2]|.

@<Glob...@>=
float *hmem; /* heuristic scores on the first levels of the search tree */
int hmem_alloc_level; /* how much of |hmem| have we gotten into? */
float *heur; /* the currently relevant block within |hmem| */

@ @<Allocate special arrays@>=
hmem=(float*)malloc(lits*(hlevel_max+1)*sizeof(float));
if (!hmem) {
  fprintf(stderr,"Oops, I can't allocate the hmem array!\n");
  exit(-10);
}
hmem_alloc_level=2;
bytes+=lits*3*sizeof(float);
for (k=0;k<lits;k++) o,hmem[k]=1.0;
@y
@ An elaborate method is used in {\mc SAT11} for the case when all big clauses
are ternary. But in the general $k$-ary case we will content ourselves with a
very simple formula:
$$h(l)\;=\;\alpha+s(l)+\sum_{l\to l'}s(l'),$$
where $s(l)$ is the number of occurrences of $\bar l$ in big clauses that are
currently active. This quantity $h(l)$ estimates the potential number of
big-clause reductions that occur when $l$ becomes true.
The default value $\alpha=0.001$ is recommended, but of course other
magic values can be tried by using the command-line parameter~`\.a'.
@z
@x
@ The subroutine |hscores| converts $h$ values to $h'$ values according
to the equation above. It also makes sure that $h'(l)$ doesn't
exceed |max_score| (which is 20.0 by default). Furthermore, it computes
|rating[thevar(l)]=hp(l)*hp(bar(l))|, a number that will be used to select
the final list of candidates.

@d htable(lev) &hmem[(lev)*(int)lits-2]

@<Sub...@>=
void hscores(float *h,float *hp) {
  register int j,l,la,ls,u,v;
  register float sum,tsum,factor,sqfactor,afactor,pos,neg;
  for (sum=0.0,j=0;j<freevars;j++) {
    o,l=poslit(freevar[j]);
    o,sum+=h[l]+h[bar(l)];
  }
  factor=2.0*freevars/sum;
  sqfactor=factor*factor;
  afactor=alpha*factor;
  for (j=0;j<freevars;j++) {
    o,l=poslit(freevar[j]);
    @<Compute |sum|, the score of |l|@>;
    pos=sum, l++;
    @<Compute |sum|, the score of |l|@>;
    neg=sum;
    if (verbose&show_scores)
      fprintf(stderr,"("O".8s: pos "O".2f neg "O".2f r="O".4g)\n",
           vmem[l>>1].name.ch8,pos,neg,
                (pos<max_score?pos:max_score)*(neg<max_score?neg:max_score));
    if (pos>max_score) pos=max_score;
    if (neg>max_score) neg=max_score;
    o,hp[l-1]=pos,hp[l]=neg;          
    o,rating[thevar(l)]=pos*neg;
  }
}

@ @<Compute |sum|, the score of |l|@>=
for (o,la=bimp[l].addr,ls=bimp[l].size,sum=0.0;ls;la++,ls--) {
  o,u=mem[la];
  if (isfree(u)) o,sum+=h[u];
}
for (o,la=timp[l].addr,ls=timp[l].size,tsum=0.0;ls;la++,ls--) {
  o,u=tmem[la].u, v=tmem[la].v;
  oo,tsum+=h[u]*h[v];
}
sum=0.1+sum*afactor+tsum*sqfactor;  
@y
@ @<Compute |sum|, the score of |l|@>=
{
  ullng acc; /* an accumulator */
  o,acc=kinx[bar(l)].size;
  for (o,la=bimp[l].addr,ls=bimp[l].size;ls;la++,ls--) {
    o,u=mem[la];
    if (isfree(u)) acc+=kinx[bar(u)].size;
  }
  sum=alpha+(float)acc;
}

@ We don't actually need the individual scores $h(l)$ for each free
literal~$l$: Only the product $h(l)\mskip1mu h(\bar l)$ is used, as
our rating for each free variable~$x$.

@<Compute |rating[x]|@>=
{
  float s;
  l=poslit(x);
  @<Compute |sum|, the score of |l|@>;
  s=sum;
  l++;
  @<Compute |sum|, the score of |l|@>;
  rating[x]=s*sum;
  if (verbose&show_scores)
    fprintf(stderr,"("O".8s: pos "O".2f neg "O".2f r="O".4g)\n",
           vmem[x].name.ch8,s,sum,s*sum);
}
@z
@x
@ Here we compute the relevant scores, and set the global variable |heur|
to point within |hmem| in such a way that |heur[l]| will be the
appropriate $h(l)$ for the lookahead we're about to do.

@<Put the scores in |heur|@>=
if (level<=1) {
  hscores(htable(0),htable(1)); /* refine the all-1 heuristic */
  hscores(htable(1),htable(2)); /* and refine that one */
  hscores(htable(2),htable(1)); /* and refine that one */
  hscores(htable(1),htable(2)); /* and refine that one */
  hscores(htable(2),htable(1)); /* and refine that one */
  heur=htable(1); /* use the fifth refinement */
}@+else if (level<hlevel_max) {
  if (level>hmem_alloc_level) hmem_alloc_level++, bytes+=lits*sizeof(float);
  hscores(htable(level-1),htable(level)); /* refine the parent's heuristic */
  heur=htable(level); /* and use it */
}@+else {
  if (hlevel_max>hmem_alloc_level) hmem_alloc_level++,bytes+=lits*sizeof(float);
  hscores(htable(hlevel_max-1),htable(hlevel_max));
    /* refine ancestral heuristic */
  heur=htable(hlevel_max); /* and use it */
}
@y
@ @<Put the ratings in |rating|@>=
for (k=0;k<freevars;k++) {
  o,x=freevar[k];
  @<Compute |rating[x]|@>;
}
@z
@x
@<Preselect a set of candidate variables for lookahead@>=
@<Put the scores in |heur|@>;
@y
@ @<Preselect a set of candidate variables for lookahead@>=
@<Put the ratings in |rating|@>;
@z
@x
if (o,timp[l].size) goto nogood; /* all active timps are unsatisfied */
@y
if (o,kinx[bar(l)].size) goto nogood; /* all active kinxs are unsatisfied */
@z
@x
fl=forcedlits, last_change=-1;
@y
fl=forcedlits, last_change=-1, fptr=rptr;
@z
@x
look_done:
@y
look_done: cs=near_truth;
@<Reset |fptr|...@>;
@z
@x
both literals are equivalent in this case.
@y
both literals are equivalent in this case.

We aren't allowed to upgrade the stamp value of |looklit| to
the stamp value of |ll|, because that would violate an important
invariant relation: Our mechanism for undoing virtual changes to large clauses
requires that the literals in~|rstack| have monotonically decreasing
levels of truth.
@z
@x
  oo,stamp[thevar(looklit)]=stamp[thevar(ll)]^((looklit^ll)&1);
@y
@z
@x
  goto look_on;
}
@y
  goto look_on;
}
cs=near_truth;
@<Reset |fptr|...@>;
@z
@x
The consequences of |looklit| might include ``windfalls,'' which
@y
@ We've implicitly removed |bar(looklit)| from all of the active clauses.
Now we must put it back, if its truth value was set at a lower level
than~|cs|.

The consequences of |looklit| might include ``windfalls,'' which
@z
@x
wptr=0;@+ fptr=eptr=rptr;
@y
@<Reset |fptr|...@>;
wptr=0;@+ eptr=fptr;
@z
@x
@ @<Update lookahead data structures for the truth of |ll|; but
     |goto contra| if a contradiction arises@>=
for (o,tla=timp[ll].addr,tls=timp[ll].size;tls;tla++,tls--) {
  o,u=tmem[tla].u, v=tmem[tla].v;
  if (verbose&show_gory_details)
    fprintf(stderr,"  looking "O"s"O".8s->"O"s"O".8s|"O"s"O".8s\n",
          litname(ll),litname(u),litname(v));
  @<Update lookahead structures for a potentially new binary clause $u\lor v$@>;
}

@ Windfalls and the weighted potentials of new binaries are discovered here.

@<Update lookahead structures for a potentially new binary clause...@>=
if (isfixed(u)) { /* equivalently, |if (o,stamp[thevar(u)]>=cs| */
  if (iscontrary(u)) { /* |u| is stamped false */
    if (isfixed(v)) {
      if (iscontrary(v)) goto contra;
    }@+else { /* |v| is unknown */
      l=v;
      wstack[wptr++]=l;
      @<Propagate binary lookahead...@>;
    }
  }
}@+else { /* |u| is unknown */
  if (isfixed(v)) {
    if (iscontrary(v)) {
      l=u;
      wstack[wptr++]=l;
      @<Propagate binary lookahead...@>;
    }
  }@+else weighted_new_binaries+=heur[u]*heur[v];
}
@y
@ Windfalls and the weighted potentials for new binaries are discovered here,
as we ``virtually remove'' |bar(ll)| from the active clauses in which it
appears.

If all but one of the literals in such a clause has now been fixed false
at the current level, we put the remaining one on |bstack| for subsequent
analysis.

A conflict arises if all literals are fixed false. In such cases we set
|bptr=-1| instead of going immediately to |contra|; otherwise
backtracking would be more complicated.

@<Update lookahead data structures for the truth of |ll|; but
     |goto contra| if a contradiction arises@>=
bptr=0;
if (verbose&show_gory_details)
  fprintf(stderr," ("O"s"O".8s lookout)\n",litname(bar(ll)));
for (o,tla=kinx[bar(ll)].addr,tls=kinx[bar(ll)].size;tls;tla++,tls--) {
  o,c=kmem[tla];
  o,la=cinx[c].addr,ls=cinx[c].size-1;
  o,cinx[c].size=ls;
  if (ls>=2) weighted_new_binaries+=clause_weight[ls];
  else if (bptr>=0) @<Put the remaining literal of |c| into |bstack|@>;
}
if (bptr<0) goto contra;
while (bptr) {
  o,u=bstack[--bptr].u;
  if (isfixed(u)) {
    if (iscontrary(u)) goto contra;
  }@+else {
    wstack[wptr++]=l=u;
    @<Propagate binary lookahead...@>;
  }
}

@ The remaining literal may have become fixed, but not yet virtually removed
(because it lies between |fptr| and |eptr| on |rstack|).

@<Put the remaining literal of |c| into |bstack|@>=
{
  for (o,ua=cinx[c-1].addr;la<ua;la++) {
    o,u=cmem[la];
    if (!isfixed(u)) break;
    if (iscontrary(u)) continue;
    u=0;@+break; /* |c| is satisfied */
  }
  if (la==ua) {
    bptr=-1;
    if (verbose&show_gory_details)
      fprintf(stderr,"  looking "O"s"O".8s-> ["O"d]\n",
                            litname(ll),c);
  }@+else if (u) {
    o,bstack[bptr++].u=u;
    if (verbose&show_gory_details)
        fprintf(stderr,"  looking "O"s"O".8s->"O"s"O".8s ["O"d]\n",
                              litname(ll),litname(u),c);
  }
}
@z
@x
cs=dl_truth, l=looklit;
wptr=0;@+eptr=rptr;
@<Propagate binary doublelookahead implications of |l|;
   |goto dl_contra| if a contradiction arises@>;
@y
cs=dl_truth, l=looklit, dlooklit=l;
wptr=0;
@<Update dlookahead data structures for consequences...@>;
@z
@x
dlook_done: base=last_base, cs=dl_truth; /* retain only |dl_truth| data */
@y
dlook_done: base=last_base, cs=dl_truth; /* retain only |dl_truth| data */
@<Reset the doublelook |fptr|...@>;
@z
@x
@ @<Update dlookahead data structures for consequences of |dlooklit|...@>=
fptr=eptr=rptr;
@y
@ @<Update dlookahead data structures for consequences of |dlooklit|...@>=
@<Reset the doublelook |fptr|...@>;
eptr=fptr;
@z
@x
@ @<Update dlookahead data structures for the truth of |ll|; but
     |goto dl_contra| if a contradiction arises@>=
for (o,tla=timp[ll].addr,tls=timp[ll].size;tls;tla++,tls--) {
  o,u=tmem[tla].u, v=tmem[tla].v;
  if (verbose&show_doubly_gory_details)
    fprintf(stderr,"  dlooking "O"s"O".8s->"O"s"O".8s|"O"s"O".8s\n",
          litname(ll),litname(u),litname(v));
  @<Update dlookahead structures for a potentially
            new binary clause $u\lor v$@>;
}

@ @<Update dlookahead structures for a potentially new binary clause...@>=
if (isfixed(u)) { /* equivalently, |if (o,stamp[thevar(u)]>=cs| */
  if (iscontrary(u)) { /* |u| is stamped false */
    if (isfixed(v)) {
      if (iscontrary(v)) goto dl_contra;
    }@+else { /* |v| is unknown */
      l=v;
      @<Propagate binary doublelookahead...@>;
    }
  }
}@+else { /* |u| is unknown */
  if (isfixed(v)) {
    if (iscontrary(v)) {
      l=u;
      @<Propagate binary doublelookahead...@>;
    }
  }
}
@y
@ @<Update dlookahead data structures for the truth of |ll|; but
     |goto dl_contra| if a contradiction arises@>=
bptr=0;
if (verbose&show_doubly_gory_details)
  fprintf(stderr," ("O"s"O".8s dlookout)\n",litname(bar(ll)));
for (o,tla=kinx[bar(ll)].addr,tls=kinx[bar(ll)].size;tls;tla++,tls--) {
  o,c=kmem[tla];
  o,la=cinx[c].addr,ls=cinx[c].size-1;
  o,cinx[c].size=ls;
  if (ls<2 && bptr>=0) @<Put the remaining doublelook literal...@>;
}
if (bptr<0) goto dl_contra;
while (bptr) {
  o,u=bstack[--bptr].u;
  if (isfixed(u)) {
    if (iscontrary(u)) goto dl_contra;
  }@+else {
    l=u;
    @<Propagate binary doublelookahead...@>;
  }
}

@ @<Put the remaining doublelook literal of |c| into |bstack|@>=
{
  for (o,ua=cinx[c-1].addr;la<ua;la++) {
    o,u=cmem[la];
    if (!isfixed(u)) break;
    if (iscontrary(u)) continue;
    u=0;@+break; /* |c| is satisfied */
  }
  if (la==ua) {
    bptr=-1;
    if (verbose&show_doubly_gory_details)
      fprintf(stderr,"  dlooking "O"s"O".8s-> ["O"d]\n",
                            litname(ll),c);
  }@+else if (u) {
    o,bstack[bptr++].u=u;
    if (verbose&show_doubly_gory_details)
        fprintf(stderr,"  dlooking "O"s"O".8s->"O"s"O".8s ["O"d]\n",
                              litname(ll),litname(u),c);
  }
}
@z
@x
@<Solve the problem@>=
@y
@<Solve the problem@>=
if (verbose&show_big_clauses) @<Print all the big clauses to |stderr|@>;
@z
@x
@*Index.
@y
@*New material for big clauses.
Some of the details about big-clause processing have been postponed to this
addendum, in order to keep the section numbering of {\mc SAT11} and {\mc
SAT11K} essentially identical.

@<Print all the big clauses to |stderr|@>=
for (c=1;c<=bclauses;c++) {
  fprintf(stderr,""O"d:",c); /* show the reference number to the user */
  for (la=cinx[c].addr;la<cinx[c-1].addr;la++)
   fprintf(stderr," "O"s"O".8s",litname(cmem[la]));
  fprintf(stderr,"\n");
}

@ Here I move the remaining free literals to the left of their clauses, if at
most $\theta k$ of the original $k$ literals are now free. This
parameter~$\theta$ can be tuned by the user, as an integer multiple of~1/64;
I'm trying $\theta=25/64$ as a default.

@<Swap out all big clauses that contain |ll|@>=
for (o,tla=kinx[ll].addr,tls=kinx[ll].size;tls;tla++,tls--) {
  o,c=kmem[tla];
  o,cia=cinx[c].addr,cis=cinx[c].size;
  o,kk=cinx[c-1].addr-cia; /* the original size of clause |c| */
  cis--; /* this many free literals remain */
  if (cis<=(theta64*kk)>>6)
    @<Swap |c| out while gathering its free literals@>@;
  else for (;cis;cia++) {
    o,u=cmem[cia];
    if (isfree(u)) {
      @<Swap |c| out of |u|'s clause list@>;
      cis--;
    }
  }
}

@ @<Swap |c| out while gathering its free literals@>=
{
  for (ci=cia;cis;cia++) {
    o,u=cmem[cia];
    if (isfree(u)) {
      if (ci!=cia) ooo,v=cmem[ci],cmem[ci]=u,cmem[cia]=v;
      @<Swap |c| out of |u|'s clause list@>;
      ci++,cis--;
    }
  }
}

@ @<Swap |c| out of |u|'s clause list@>=
{
  for (o,su=kinx[u].size-1,au=ua=kinx[u].addr+su;o,kmem[au]!=c;au--);
  if (au!=ua) oo,kmem[au]=kmem[ua],kmem[ua]=c;
  o,kinx[u].size=su;
}

@ @<Swap in all big clauses that contain |ll|@>=
for (o,tls=kinx[ll].size,tla=kinx[ll].addr+tls-1;tls;tla--,tls--) {
  o,c=kmem[tla];
  for (o,cia=cinx[c].addr,cis=cinx[c].size-1;cis;cia++) {
    o,u=cmem[cia];
    if (isfree(u)) {
      @<Swap |c| back in to |u|'s clause list@>;
      cis--;
    }
  }
}
   
@ @<Swap |c| back in to |u|'s clause list@>=
oo,kinx[u].size++;

@ The lookahead processes need to take back all updates to big clauses
involving literals that lose their tentative values when |cs| increases.

Fortunately all literals are ordered on |rstack| by their
truth levels, with the lowest levels nearest the top.

This is the place where the partial ordering of the ``lookahead forest''
must indeed be a forest, not a general permutation poset.

@<Reset |fptr| by removing unfixed literals from |rstack|@>=
while (fptr>rptr) {
  o,u=rstack[fptr-1];
  if (isfixed(u)) break;
  fptr--;
  if (verbose&show_gory_details)
    fprintf(stderr," ("O"s"O".8s lookin)\n",litname(bar(u)));
  @<Unreduce all big clauses that contained |bar(u)| during lookahead@>;
}

@ @<Reset the doublelook |fptr| by removing unfixed literals from |rstack|@>=
while (fptr>rptr) {
  o,u=rstack[fptr-1];
  if (isfixed(u)) break;
  fptr--;
  if (verbose&show_doubly_gory_details)
    fprintf(stderr," ("O"s"O".8s dlookin)\n",litname(bar(u)));
  @<Unreduce all big clauses that contained |bar(u)| during lookahead@>;
}

@ @<Unreduce all big clauses that contained |bar(u)|...@>=
for (o,tls=kinx[bar(u)].size,tla=kinx[bar(u)].addr+tls-1;tls;tla--,tls--) {
  o,c=kmem[tla];
  o,cis=cinx[c].size+1;
  o,cinx[c].size=cis;
}

@ This program uses the |clause_weight| table to estimate a clause's
potential for further reduction, based solely on its length: A~clause of
length~$k\ge2$ gets the weight $\gamma^{k-2}$, where the parameter~$\gamma$
is controllable by `\.g' on the command line. The default
$\gamma=0.21$ agrees roughly with the recommendations of Oliver Kullmann.

@<Glob...@>=
int max_clause; /* length of the longest clause */
float *clause_weight; /* weights given to each length, for $k\ge2$ */

@ We dare not let the |clause_weight| entries become zero, because
that would defeat the logic by which autarkies are recognized.

@<Allocate special arrays@>=
clause_weight=(float*)malloc(max_clause*sizeof(float));
if (!clause_weight) {
  fprintf(stderr,"Oops, I can't allocate the clause_weight array!\n");
  exit(-10);
}
bytes+=max_clause*sizeof(float);
clause_weight[2]=1.0;
for (k=3;k<max_clause;k++) o,clause_weight[k]=clause_weight[k-1]*gamm+0.01;

@*Index.
@z
