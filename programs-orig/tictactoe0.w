\datethis
@*Intro. Counting the number of distinct positions in all games
of tic-tac-toe.

@c
#include <stdio.h>
char pos[1<<18];
int move[9],count[9],nonwin[9];
int win[16]={
 0x15000,
 0x00540,
 0x00015,
 0x10410,
 0x04104,
 0x01041,
 0x10101,
 0x01110}; 

main()
{
  register k,l,board;
  for (k=0;k<8;k++) win[k+8]=win[k]<<1;
  l=board=0;
newlev: move[l]=3;
tryit: if (!(board&move[l])) {
  board+=move[l]&(l&1? 0x55555: 0xaaaaa);
  if (pos[board]) goto unmove;
  pos[board]=1, count[l]++;
  for (k=0;k<16;k++)
    if ((board&win[k])==win[k]) goto unmove;
  nonwin[l]++;
  if (l==8) goto unmove;
  l++;
  goto newlev;
}
tryagain: move[l]<<=2;
  if (move[l]<(1<<18)) goto tryit;
  if (l>0) {
    l--;
unmove: board&=~move[l];
    goto tryagain;
  }
  for (k=0;k<=8;k++) printf("(%d,%d) at level %d\n",
      count[k],count[k]-nonwin[k],k);
}

@*Index.
