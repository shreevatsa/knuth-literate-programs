\datethis
@*Intro. I'm trying to calculate a few million Ulam numbers.
This sequence 
$$(U_1,U_2,\ldots{})=(1,2,3,4,6,8,11,13,16,18,26,\ldots{})$$
is defined by setting $U_1=1$, $U_2=2$, and thereafter letting
$U_{n+1}$ be the smallest number greater than $U_n$ that can be
writtin $U_j+U_k$ for exactly one pair $(j,k)$ with $1\le j<k\le n$.
(Such a number must exist; otherwise the pair $(j,k)=(n-1,n)$ would
qualify and lead to a contradiction.)

This program uses a sieve method inspired by M. C. Wunderlich
[{\sl BIT\/ \bf11} (1971), 217--224]. The basic idea is to
form infinite binary sequences $u=u_0u_1u_2\ldots{}$ and $v=v_0v_1v_2\ldots{}$
where $u_k=[k$ is an Ulam number] and $v_k=[k$ has more than one
representation as a sum of distinct Ulam numbers].
To build this sequence we start with $u=0110\ldots{}$ and $v=000\ldots{}$;
then we do the bitwise calculation
$w_k\ldots w_{2k-1}\gets w_k\ldots w_{2k-1}\circ u_0\ldots u_{k-1}$
for $k=U_2$, $U_3$, \dots, where $w_k=(u_k,v_k)$ and
$$(u,v)\circ u'=((u\oplus u')\wedge\bar v,(u\wedge u')\vee v).$$
The method works because,
when $k=U_n$, the current settings of $u$ and $v$ satisfy the
following invariant relations for $2<j<2k$:
$$\vcenter{\halign{#\hfil\cr
$u_j=[j$ is a sum of distinct Ulam numbers $<k$ in exactly one way];\cr
\noalign{\smallskip}
$v_j=[j$ is a sum of distinct Ulam numbers $<k$ in more than one way].\cr}}$$

In other words this program is basically an exercise in doing the requisite
shifting and masking when the bits of $u$ and~$v$ are packed as unsigned
integers.

Besides computing $U_n$, I also report the value of $U_n/n$ whenever
$n$ is a multiple of $m$. This ratio is reported to be about 13.5 when
$n\le 10^6$ [see Wolfram's {\sl NKS}, page 908].

And I keep some rudimentary statistics about gaps, based on ideas
of Jud McCranie.

@d gsize 1000
@d m 10000
@d nsize 10000000
@d nmax (32*nsize) /* we will find all Ulam numbers less than |nmax| */

@c
#include <stdio.h>
unsigned int ubit[nsize+1], vbit[nsize+1];
char table[256];
int count[gsize],example[gsize];

main()
{
  register unsigned int j,jj,k,kk,kq,kr,del,c,n,u,prevu,gap;
  @<Set up the |table|@>;
  gap=1, count[1]=1, example[1]=2;
  ubit[0]=0x6, kr=n=prevu=2, kq=0, kk=4; /* $U_1=1$, $U_2=2$ */
  while (1) {
    @<Update $w_k\ldots w_{2k-1}$ from $u_0\ldots u_{k-1}$@>;
    @<Advance $k$ to $U_{n+1}$ and advance $n$@>;
    k=kr+(kq<<5);
    del=k-prevu;
    count[del]++, example[del]=k;
    if (del>gap) {
      if (del>=gsize) {
        fprintf(stderr,"Unexpectedly large gap (%d)! Recompile me...\n",del);
        return;
      }
      gap=del;
      printf("New gap %d: U_%d=%d, U_%d=%d\n",gap,n-1,prevu,n,k);
      fflush(stdout);
    }
    prevu=k;
    if ((n%m)==0) {
      printf("U_%d=%d is about %.5g*%d\n",n,k,((double)k)/n,n);
      fflush(stdout);
    }
  }
done: @<Print gap stats@>;
  printf("There are %d Ulam numbers less than %d.\n",n,nmax);
}

@ As we compute, we'll implicitly have $k=32|kq|+|kr|$, where $0\le|kr|<32$;
also |kk=1<<kr|. Bit~$k$ of~$u$ is |(ubit[kq]>>kr)&1|, etc.

@<Update $w_k\ldots w_{2k-1}$ from $u_0\ldots u_{k-1}$@>=
for (j=c=0,jj=j+kq;j<kq;j++,jj++) {
  if (jj>=nsize) goto update_done;
  del=(ubit[j]<<kr)+c; /* |c| is a ``carry'' */
  c=(ubit[j]>>(31-kr))>>1;
  @<Set |(ubit[jj],vbit[jj])| to |(ubit[jj],vbit[jj])|${}\circ|del|$@>;
}
if (jj>=nsize) goto update_done;
u=ubit[kq]&(kk-1);
del=(u<<kr)+c, c=(u>>(31-kr))>>1;
@<Set |(ubit[jj],vbit[jj])| to |(ubit[jj],vbit[jj])|${}\circ|del|$@>;
if (c!=0) {
  jj++,del=c;
  @<Set |(ubit[jj],vbit[jj])| to |(ubit[jj],vbit[jj])|${}\circ|del|$@>;
}
update_done:@;

@ @<Set |(ubit[jj],vbit[jj])| to |(ubit[jj],vbit[jj])|${}\circ|del|$@>=
u=(ubit[jj]^del)&~vbit[jj];
vbit[jj]|=ubit[jj]&del;
ubit[jj]=u;

@ @<Advance $k$ to $U_{n+1}$ and advance $n$@>=
u=ubit[kq]&-(kk+kk); /* erase bits $\le k$ */
while (!u) {
  if (++kq>=nsize) goto done;
  u=ubit[kq];
}
kk=u&-u; /* now we must calculate $|kr|=\lg|kk|$ */
if (kk&0xffff0000) kr=16,u=kk>>16;@+else kr=0,u=kk;
if (u&0xff00) kr+=8, u>>=8;
if (u&0xf0) kr+=4, u>>=4;
kr+=table[u];
n++;

@ @<Set up the |table|@>=
for (j=2;j<256;j<<=1) table[j]=1+table[j>>1];

@ @<Print gap stats@>=
for (j=1;j<=gap;j++) if (count[j])
  printf("gap %d occurred %d time%s, last was %d\n",
     j,count[j],count[j]==1?"":"s",example[j]);

@*Index.

