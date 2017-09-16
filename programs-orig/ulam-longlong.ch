@x
@d nmax (32*nsize) /* we will find all Ulam numbers less than |nmax| */

@c
#include <stdio.h>
unsigned int ubit[nsize+1], vbit[nsize+1];
@y
@d nmax (64*nsize) /* we will find all Ulam numbers less than |nmax| */

@c
#include <stdio.h>
unsigned long long ubit[nsize+1], vbit[nsize+1];
@z
@x
  register unsigned int j,jj,k,kk,kq,kr,del,c,n,u,prevu,gap;
@y
  register unsigned long long j,jj,k,kk,kq,kr,del,c,n,u,prevu,gap;
@z
@x
    k=kr+(kq<<5);
@y
    k=kr+(kq<<6);
@z
@x
        fprintf(stderr,"Unexpectedly large gap (%d)! Recompile me...\n",del);
@y
        fprintf(stderr,"Unexpectedly large gap (%lld)! Recompile me...\n",del);
@z
@x
      printf("New gap %d: U_%d=%d, U_%d=%d\n",gap,n-1,prevu,n,k);
      fflush(stdout);
    }
    prevu=k;
    if ((n%m)==0) {
      printf("U_%d=%d is about %.5g*%d\n",n,k,((double)k)/n,n);
@y
      printf("New gap %lld: U_%lld=%lld, U_%lld=%lld\n",gap,n-1,prevu,n,k);
      fflush(stdout);
    }
    prevu=k;
    if ((n%m)==0) {
      printf("U_%lld=%lld is about %.5g*%lld\n",n,k,((double)k)/n,n);
@z
@x
  printf("There are %d Ulam numbers less than %d.\n",n,nmax);
@y
  printf("There are %lld Ulam numbers less than %d.\n",n,nmax);
@z
@x
@ As we compute, we'll implicitly have $k=32|kq|+|kr|$, where $0\le|kr|<32$;
@y
@ As we compute, we'll implicitly have $k=64|kq|+|kr|$, where $0\le|kr|<64$;
@z
@x
  c=(ubit[j]>>(31-kr))>>1;
@y
  c=(ubit[j]>>(63-kr))>>1;
@z
@x
del=(u<<kr)+c, c=(u>>(31-kr))>>1;
@y
del=(u<<kr)+c, c=(u>>(63-kr))>>1;
@z
@x
kr=decode[(mhmartin*kk)>>27];
n++;

@ @d mhmartin 0x07dcd629

@<Set up the |decode| table@>=
for (k=0,j=1;j;k++,j<<=1) decode[(mhmartin*j)>>27]=k;
@y
kr=decode[(mhmartin*kk)>>58];
n++;

@ @d mhmartin 0x03f79d71b4ca8b09LL

@<Set up the |decode| table@>=
for (k=0,j=1;j;k++,j<<=1) decode[(mhmartin*j)>>58]=k;
@z
@x
  printf("gap %d occurred %d time%s, last was %d\n",
@y
  printf("gap %lld occurred %d time%s, last was %d\n",
@z
