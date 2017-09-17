\datethis
@*Intro. Creating a graph for the distinct positions in all games
of tic-tac-toe.

@d rank z.I /* number of moves made */
@d link y.V /* next vertex of same rank */
@d head x.V /* first vertex of given rank */
@d winner w.I /* is this a winning position? */
@d bitcode v.I /* binary representation of this position */

@c
#include "gb_graph.h"
#include "gb_save.h"
Vertex *pos[1<<18];
int move[9];
int win[16]={ /* the board is now numbered 263/917/584 */
0x05040,
0x10011,
0x00504,
0x04101,
0x10044,
0x01410,
0x14400,
0x11100};
int place[18]={4,4,9,9,6,6,1,1,8,8,10,10,2,2,0,0,5,5};

main()
{
  register k,l,board;
  Vertex *u,*v;
  Graph *g=gb_new_graph(5478);
  strcpy(g->util_types,"ZIIVVIZZZZZZZZ");
  strcpy(g->id,"tictactoe");
  for (k=0;k<8;k++) win[k+8]=win[k]<<1;
  l=board=0;
  pos[0]=u=v=g->vertices;
  v->rank=v->winner=v->bitcode=0;
  v->link=NULL, (g->vertices+0)->head=v;
  v->name=gb_save_string("   /   /   ");
newlev: move[l]=3;
tryit: if (!(board&move[l])) {
  board+=move[l]&(l&1? 0x55555: 0xaaaaa);
  if (pos[board]) {
    gb_new_arc(v,pos[board],1);
    goto unmove;
  }
  pos[board]=++u;
  u->rank=l+1, u->winner=0, u->bitcode=board;
  u->name=gb_save_string("   /   /   ");
  for (k=0;k<18;k++) if (board&(1<<k))
    u->name[place[k]]=((l^k)&1? 'O': 'X');
  u->link=(g->vertices+l+1)->head, (g->vertices+l+1)->head=u;
  gb_new_arc(v,u,1);
  for (k=0;k<16;k++)
    if ((board&win[k])==win[k]) {
      u->winner=1;
      goto unmove;
    }
  if (l==8) goto unmove;
  l++, v=u;
  goto newlev;
}
tryagain: move[l]<<=2;
  if (move[l]<(1<<18)) goto tryit;
  if (l>0) {
    l--, v=pos[board&~move[l]];
unmove: board&=~move[l];
    goto tryagain;
  }
  save_graph(g,"/tmp/tictactoe.gb");
}

@*Index.
