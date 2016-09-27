\datethis
@*Intro. I'm hurriedly experimenting with a new(?) way to explore the
complexity of 4-variable Boolean functions. Namely, I calculate the
``footprint'' of each function, the set of all first steps by which I
know how to evaluate the function in $k$ steps. Then, if the footprints
of $f$ and $g$ overlap, I can compute $f\circ g$ in
${\rm cost}(f)+{\rm cost}(g)$ steps.

I can restrict consideration to the $2^{15}$ functions that take
$(0,0,0,0)\mapsto0$.

This program extends {\mc FCHAINS4} by allowing several additional
functions to be precomputed. Those functions appear on the command line,
in hexadecimal form.

@d footsize 100

@c
#include <stdio.h>
#include <stdlib.h>
typedef struct node_struct {
  unsigned int footprint[footsize];
  int parent;
  int cost;
  struct node_struct *prev, *next;
} node;
node func[1<<15];
node head[9];
int x[100];
char buf[100]; /* lines of input */
char name[32*footsize][16];
unsigned int ttt; /* truth table found in input line */
main(int argc,char *argv[])
{
  register int c,j,k,r,t,m,mm,s;
  register unsigned int u;
  register node *p,*q,*pp;
  @<Read the initial functions@>;
  @<Initialize the tables@>;
  for (r=2;c;r++)
    for (k=(r-1)>>1;k>=0;k--)
      @<Combine all functions of costs |k| and |r-1-k|@>;
  @<Answer queries@>;
}

@ @<Read the initial functions@>=
m=argc+3;
for (k=1;k<=m;k++) {
  if (k<=4) x[k]=0xffff/((1<<(1<<(4-k)))+1);
  else if (sscanf(argv[k-4],"%x",&x[k])!=1) {
    fprintf(stderr,"Parameter %s should have been hexadecimal!\n",argv[k-4]);
    exit(-1);
  }
  if (x[k]>0xffff) {
    fprintf(stderr,"Parameter %s is too big!\n",argv[k-4]);
    exit(-1);
  }
  if (x[k]>=0x8000) x[k]^=0xffff;
}

@ @<Combine all functions of costs |k| and |r-1-k|@>=
for (p=head[k].next;p->parent>=0;p=p->next)
  for (q=head[r-1-k].next;q->parent>=0;q=q->next) {
    for (j=0;j<mm;j++)
      if (p->footprint[j] & q->footprint[j])
        @<Try for breakthru and |goto pqdone|@>@;
    @<Try for new function@>;
pqdone: continue;
  }

@ @d fun(p) ((p)-func)

@<Try for new function@>=
{
  t=fun(p)&fun(q);
  if (func[t].cost>=r) @<Update the table for cost |r|@>;
  t=fun(p)&(~fun(q));
  if (func[t].cost>=r) @<Update the table for cost |r|@>;
  t=(~fun(p))&fun(q);
  if (func[t].cost>=r) @<Update the table for cost |r|@>;
  t=fun(p)|fun(q);
  if (func[t].cost>=r) @<Update the table for cost |r|@>;
  t=fun(p)^fun(q);
  if (func[t].cost>=r) @<Update the table for cost |r|@>;
}

@ @<Update the table for cost |r|@>=
{
  pp=&func[t];
  if (pp->cost>r) {
    if (pp->cost==8) c--;
    pp->next->prev=pp->prev, pp->prev->next=pp->next;
    pp->cost=r, pp->parent=(fun(p)<<16)+fun(q);
    for (j=0;j<mm;j++) pp->footprint[j]=0;
    pp->next=head[r].next, pp->prev=&head[r];
    pp->next->prev=pp, pp->prev->next=pp;
  }
  for (j=0;j<mm;j++) pp->footprint[j]|=p->footprint[j]|q->footprint[j];
}

@ @<Try for breakthru...@>=
{
  t=fun(p)&fun(q);
  if (func[t].cost>=r-1) @<Update the table for cost |r-1|@>;
  t=fun(p)&(~fun(q));
  if (func[t].cost>=r-1) @<Update the table for cost |r-1|@>;
  t=(~fun(p))&fun(q);
  if (func[t].cost>=r-1) @<Update the table for cost |r-1|@>;
  t=fun(p)|fun(q);
  if (func[t].cost>=r-1) @<Update the table for cost |r-1|@>;
  t=fun(p)^fun(q);
  if (func[t].cost>=r-1) @<Update the table for cost |r-1|@>;
  goto pqdone;
}

@ This code is not executed when $k=0$, because |q|'s footprint is zero
in that case.

@<Update the table for cost |r-1|@>=
{
  pp=&func[t];
  if (pp->cost>r-1) {
    if (pp->cost==8) c--;
    pp->next->prev=pp->prev, pp->prev->next=pp->next;
    pp->cost=r-1, pp->parent=(fun(p)<<16)+fun(q);
    for (j=0;j<mm;j++) pp->footprint[j]=0;
    pp->next=head[r-1].next, pp->prev=&head[r-1];
    pp->next->prev=pp, pp->prev->next=pp;
  }
  for (j=0;j<mm;j++) pp->footprint[j]|=p->footprint[j]&q->footprint[j];
}

@ @<Initialize the tables@>=
for (p=&func[2];p<&func[0x8000];p++)
  (p-1)->next=p, p->prev=p-1, p->cost=8;
func[1].cost=8;
for (k=0;k<=8;k++)
  head[k].parent=-1, head[k].next=head[k].prev=&head[k];
head[0].next=head[0].prev=&func[0];
func[0].next=func[0].prev=&head[0];
head[8].next=&func[1], func[1].prev=&head[8];
head[8].prev=&func[0x7fff], func[0x7fff].next=&head[8];
@<Initialize the functions of cost 0@>;
@<Initialize the functions of cost 1@>;

@ @<Initialize the functions of cost 0@>=
for (k=1;k<=m;k++) {
  p=&func[x[k]];
  if (p->cost==0) continue;
  p->next->prev=p->prev, p->prev->next=p->next;
  p->cost=0;
  p->next=head[0].next, p->prev=&head[0];
  p->next->prev=p, p->prev->next=p;
}  
c=(1<<15)-1-m;

@ @<Initialize the functions of cost 1@>=
s=0;
for (r=2;r<=m;r++) for (k=1;k<r;k++) {
  t=x[k]&x[r], sprintf(name[s],"%d&%d(%04x)",k,r,t); @<Update for cost 1@>;
  t=x[k]&(~x[r]), sprintf(name[s],"%d>%d(%04x)",k,r,t); @<Update for cost 1@>;
  t=(~x[k])&x[r], sprintf(name[s],"%d<%d(%04x)",k,r,t); @<Update for cost 1@>;
  t=x[k]|x[r], sprintf(name[s],"%d|%d(%04x)",k,r,t); @<Update for cost 1@>;
  t=x[k]^x[r], sprintf(name[s],"%d^%d(%04x)",k,r,t); @<Update for cost 1@>;
}
mm=(s+31)/32;

@ @<Update for cost 1@>=
p=&func[t];
if (p->cost>1) {
  if (s>=32*footsize) {
    fprintf(stderr,"Too many special functions (footsize=%d)!\n",footsize);
    exit(-3);
  }
  p->next->prev=p->prev, p->prev->next=p->next;
  p->cost=1, p->parent=(x[k]<<16)+x[r];
  p->footprint[s>>5]=1<<(s&0x1f);
  p->next=head[1].next, p->prev=&head[1];
  p->next->prev=p, p->prev->next=p;
  s++;
  c--;
}

@ @<Answer queries@>=
while (1) {
  printf("Truth table (hex): ");
  fflush(stdout);
  if (!fgets(buf,100,stdin)) break;
  if (sscanf(buf,"%x",&ttt)!=1) break;
  printf("%04x has cost ",ttt);
  if (ttt&0x8000) ttt^=0xffff;
  printf("%d, parents (%04x,%04x), and footprint",
    func[ttt].cost,func[ttt].parent>>16,func[ttt].parent&0xffff);
  for (j=0;j<mm;j++) if (func[ttt].footprint[j]) {
    s=32*j;
    for (u=func[ttt].footprint[j]; u; u>>=1, s++)
      if (u&1) printf(" %s",name[s]);
  }
  printf("\n");    
}

@*Index.
