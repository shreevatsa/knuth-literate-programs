\datethis
@*Intro. This program is a revision of {\mc ACHAIN0}, which you should
read first. I'm thinking that a few changes will speed that program up,
but as usual the proof of the pudding is in the eating.

The main changes here are: (i) Instead of a simple array |a| containing
the addition chain, I have two arrays |a| and |b|, which contain
lower and upper bounds on the current status. This idea should
speed up the process of placing tentative entries, because the
logic in the previous program was rather tortuous. (ii)~I try first to
find a chain satisfying the lower bound, and work upward until
succeeding, instead of trying first to beat the upper bound and
continue until failing. This idea, analogous to ``iterative deepening,''
gives me a chance to improve the bounds, because empty slots cannot
occur. (iii)~I consider ranges for placing both |p| and |q|
before trying either one of them, because it's often possible
to anticipate failure sooner that way.
(iv)~When trying possibilities for |a[s]=p+q| and |p!=q|, we
needn't consider any cases with |q>b[s-2]| or |p>b[s-1]|.
This~observation makes a huge improvement; shame on me for not
thinking of it in the 60s.
(v)~And it gets even better: Suppose |a[k]=b[k]| for $k\ge r$.
Then as soon as $p>b[r-1]$, we have at most $s-r$ possibilities
for~$p$. (My old program ran through $a[s]-a[r]$ possibilities!)

@d nmax 10000000 /* should be less than $2^{24}$ on a 32-bit machine */

@c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
char l[nmax];
int a[128],b[128];
unsigned int undo[128*128];
int ptr; /* this many items of the |undo| stack are in use */
struct {
 int lbp,ubp,lbq,ubq,p,r,ptrp,ptrq;
} stack[128];
FILE *infile, *outfile;
int prime[1000]; /* 1000 primes will take us past 60 million */
int pr; /* the number of primes known so far */
char x[64]; /* exponents of the binary representation of $n$ */
int main(int argc, char* argv[])
{
  register int i,j,n,p,q,r,s,ubp,ubq,lbp,lbq,ptrp,ptrq;
  int lb,ub,timer=0;
  @<Process the command line@>;
  prime[0]=2, pr=1;
  a[0]=b[0]=1, a[1]=b[1]=2; /* an addition chain always begins like this */
  for (n=1;n<nmax;n++) {
    @<Input the next lower bound, |lb|@>;
    @<Find an upper bound; or in simple cases, set $l(n)$ and |goto done|@>;
    @<Backtrack until $l(n)$ is known@>;
done: @<Output the value of $l(n)$@>;
    if (n%1000==0) {
      j=clock();      
      printf("%d..%d done in %.5g minutes\n",
         n-999,n,(double)(j-timer)/(60*CLOCKS_PER_SEC));
      timer=j;    
    }
  }
}

@ @<Process the command line@>=
if (argc!=3) {
  fprintf(stderr,"Usage: %s infile outfile\n",argv[0]);
  exit(-1);
}
infile=fopen(argv[1],"r");
if (!infile) {
  fprintf(stderr,"I couldn't open `%s' for reading!\n",argv[1]);
  exit(-2);
}
outfile=fopen(argv[2],"w");
if (!outfile) {
  fprintf(stderr,"I couldn't open `%s' for writing!\n",argv[2]);
  exit(-3);
}

@ @<Output the value of $l(n)$@>=
fprintf(outfile,"%c",l[n]+' ');
fflush(outfile); /* make sure the result is viewable immediately */

@ At this point I compute the ``lower bound'' $\lfloor\lg n\rfloor+3$,
which is valid if $\nu n>4$. Simple cases where $\nu n\le 4$ will be
handled separately below.

@<Input the next lower bound, |lb|@>=
for (q=n,i=-1,j=0;q;q>>=1,i++)
  if (q&1) x[j++]=i;
/* now $i=\lfloor\lg n\rfloor$ and $j=\nu n$ */
lb=fgetc(infile)-' '; /* |fgetc| will return a negative value after EOF */
if (lb<i+3) lb=i+3;

@ Three elementary and well-known upper bounds are considered:
(i)~$l(n)\le\lfloor\lg n\rfloor+\nu n-1$;
(ii)~$l(n)\le l(n-1)+1$;
(iii)~$l(n)\le l(p)+l(q)$ if $n=pq$.

Furthermore, there are four special cases
when Theorem 4.6.3C tells us we can save a step.
In this regard, I had to learn (the hard way) to avoid a
curious bug: Three of the four cases in Theorem 4.6.3C arise
when we factor $n$, so I thought I needed to test only the
other case here. But I got a surprise when $n=165$: Then
$n=3\cdot55$, so the factor method gave the upper bound
$l(3)+l(55)=10$; but another factorization, $n=5\cdot33$,
gives the better bound $l(5)+l(33)=9$.

@<Find an upper bound...@>=
ub=i+j-1;
if (ub>l[n-1]+1) ub=l[n-1]+1;
@<Try reducing |ub| with the factor method@>;
l[n]=ub;
if (j<=3) goto done;
if (j==4) {
  p=x[3]-x[2], q=x[1]-x[0];
  if (p==q || p==q+1 || (q==1 && (p==3 || (p==5 && x[2]==x[1]+1)))) l[n]=i+2;
  goto done;
}

@ It's important to try the factor method even when |j<=4|, because
of the way prime numbers are recognized here: We would miss the
prime~3, for example.

On the other hand, we don't need to remember large primes that will
never arise as factors of any future~$n$.

@<Try reducing |ub| with the factor method@>=
if (n>2) for (s=0;;s++) {
  p=prime[s];
  q=n/p;
  if (n==p*q) {
    if (l[p]+l[q]<ub) ub=l[p]+l[q];
    break;
  }
  if (q<=p) { /* $n$ is prime */
    if (pr<1000) prime[pr++]=n;
    break;
  }
}

@*The interesting part. 
If |lb<ub|, we will try to build an addition chain of length |lb|.
If that fails, we increase |lb| and try again. Finally we will
have established the fact that $l(n)=|lb|$.

Throughout the computation we'll have $a[j]<a[j+1]\le2a[j]$ and
                                      $b[j]<b[j+1]\le2b[j]$.
Element |a[j]| of the chain is ``fixed'' if and only if |a[j]=b[j]|.
Those local conditions have the nice property that, if |a[j]<b[j]|,
we can increase |a[j]| and/or decrease |b[j]| to any value in between,
causing a corresponding increase and/or decrease in neighboring
values but always in a way that preserves the local inequalities
without forcing |a[i]>b[i]| anywhere. (Go figure.)

@<Backtrack until $l(n)$ is known@>=
l[n]=lb;
while (lb<ub) {
  a[lb]=b[lb]=n;
  for (i=2;i<lb;i++) a[i]=a[i-1]+1, b[i]=b[i-1]<<1;
  for (i=lb-1;i>=2;i--) {
    if ((a[i]<<1)<a[i+1]) a[i]=(a[i+1]+1)>>1;
    if (b[i]>=b[i+1]) b[i]=b[i+1]-1;
  }
  @<Try to fix the rest of the chain; |goto done| if it's possible@>;
  l[n]=++lb;
}

@ We maintain a stack of subproblems, as usual when backtracking.
Suppose |a[t]| is the sum of two items already present, for all
$t>s$; we want to make sure that |a[s]| is legitimate too.
For this purpose we try all combinations |a[s]=p+q| where
$p\ge a[s]/2$, trying to make both $p$ and $q$ present.
(By the nature of the algorithm, we'll have |a[s]=b[s]| at
the time we choose |p| and~|q|, because shorter addition
chains have been ruled out.)

As elements of |a| and |b| are changed, we record their previous
values on the |undo| stack, so that we can easily restore them
later. Pointers |ptrp| and |ptrq| contain the limiting indexes
for undo information.

@<Try to fix...@>=
ptr=0; /* clear the |undo| stack */
for (r=s=lb;s>2;s--) { /* |a[k]=b[k]| for all |k>=r| */
  for (;r>1&&a[r-1]==b[r-1];r--);
  for (q=a[s]>>1, p=a[s]-q; p<=b[s-1];) {
    if (p>b[r-1]) {
      while (p>a[r]) r++; /* this step keeps |r<s| */
      p=a[r], q=a[s]-p, r++; 
    }
    @<Find bounds $(|lbp|,|ubp|)$ and $(|lbq|,|ubq|)$ on where |p| and |q|
       can be inserted; but go to |failpq| if they can't both
       be accommodated@>;
    ptrp=ptr;
    for (; ubp>=lbp; ubp--) {
      @<Put |p| into the chain at location |ubp|;
         |goto failp| if there's a problem@>;
      if (p==q) goto happiness;
      if (ubq>=ubp) ubq=ubp-1;
      ptrq=ptr;
      for (; ubq>=lbq; ubq--) {
        @<Put |q| into the chain at location |ubq|;
           |goto failq| if there's a problem@>;
 happiness: stack[s].p=p, stack[s].r=r;
        stack[s].lbp=lbp,stack[s].ubp=ubp;
        stack[s].lbq=lbq,stack[s].ubq=ubq;
        stack[s].ptrp=ptrp,stack[s].ptrq=ptrq;
        goto onward; /* now |a[s]| is covered; try to fill in |a[s-1]| */
 backup: s++;
        if (s>lb) goto impossible;
        ptrq=stack[s].ptrq,ptrp=stack[s].ptrp;
        lbq=stack[s].lbq,ubq=stack[s].ubq;
        lbp=stack[s].lbp,ubp=stack[s].ubp;
        p=stack[s].p, q=a[s]-p, r=stack[s].r;
        if (p==q) goto failp;
 failq:@+ while (ptr>ptrq) @<Undo a change@>;
      }
 failp:@+ while (ptr>ptrp) @<Undo a change@>;
    }
 failpq:@+ if (p==q && q>b[s-2]) q=b[s-2],p=a[s]-q;@+else p++,q--;
  }
  goto backup;
onward: continue;
}
goto done;
impossible:@;
  
@ After the test in this step is passed, we'll have |ubp>ubq| and |lbp>lbq|.

@<Find bounds...@>=
lbp=l[p];
if (lbp>=lb) goto failpq;
while (b[lbp]<p) lbp++;
if (a[lbp]>p) goto failpq;
for (ubp=lbp;a[ubp+1]<=p;ubp++);
if (ubp==s-1) lbp=ubp;
if (p==q) lbq=lbp,ubq=ubp;
else {
  lbq=l[q];
  if (lbq>=ubp) goto failpq;
  while (b[lbq]<q) lbq++;
  if (lbq>=ubp) goto failpq;
  if (a[lbq]>q) goto failpq;
  for (ubq=lbq;a[ubq+1]<=q && ubq+1<ubp;ubq++);
  if (lbp==lbq) lbp++;
}

@ The undoing mechanism is very simple: When changing |a[j]|, we
put |(j<<24)+x| on the |undo| stack, where |x| was the former value.
Similarly, when changing |b[j]|, we stack the value |(1<<31)+(j<<24)+x|.

@d newa(j,y) undo[ptr++]=(j<<24)+a[j], a[j]=y
@d newb(j,y) undo[ptr++]=(1<<31)+(j<<24)+b[j], b[j]=y

@<Undo a change@>=
{
  i=undo[--ptr];
  if (i>=0) a[i>>24]=i&0xffffff;
  else b[(i&0x3fffffff)>>24]=i&0xffffff;
}

@ At this point we know that $a[ubp]\le p\le b[ubp]$.

@<Put |p| into the chain at location |ubp|...@>=
if (a[ubp]!=p) {
  newa(ubp,p);
  for (j=ubp-1;(a[j]<<1)<a[j+1];j--) {
    i=(a[j+1]+1)>>1;
    if (i>b[j]) goto failp;
    newa(j,i);
  }
  for (j=ubp+1;a[j]<=a[j-1];j++) {
    i=a[j-1]+1;
    if (i>b[j]) goto failp;
    newa(j,i);
  }
}
if (b[ubp]!=p) {
  newb(ubp,p);
  for (j=ubp-1;b[j]>=b[j+1];j--) {
    i=b[j+1]-1;
    if (i<a[j]) goto failp;
    newb(j,i);
  }
  for (j=ubp+1;b[j]>b[j-1]<<1;j++) {
    i=b[j-1]<<1;
    if (i<a[j]) goto failp;
    newb(j,i);
  }
}

@ At this point we had better not assume that $a[ubq]\le q\le b[ubq]$,
because |p| has just been inserted. That insertion can mess up the
bounds that we looked at when |lbq| and |ubq| were computed.

@<Put |q| into the chain at location |ubq|...@>=
if (a[ubq]!=q) {
  if (a[ubq]>q) goto failq;
  newa(ubq,q);
  for (j=ubq-1;(a[j]<<1)<a[j+1];j--) {
    i=(a[j+1]+1)>>1;
    if (i>b[j]) goto failq;
    newa(j,i);
  }
  for (j=ubq+1;a[j]<=a[j-1];j++) {
    i=a[j-1]+1;
    if (i>b[j]) goto failq;
    newa(j,i);
  }
}
if (b[ubq]!=q) {
  if (b[ubq]<q) goto failq;
  newb(ubq,q);
  for (j=ubq-1;b[j]>=b[j+1];j--) {
    i=b[j+1]-1;
    if (i<a[j]) goto failq;
    newb(j,i);
  }
  for (j=ubq+1;b[j]>b[j-1]<<1;j++) {
    i=b[j-1]<<1;
    if (i<a[j]) goto failq;
    newb(j,i);
  }
}

@*Index.


