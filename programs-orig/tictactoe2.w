\datethis
@*Intro. Analyzing the graph created by {\mc TIC-TAC-TOE1}.

I'm experimenting with a scoring system that includes ``difficulty''
as part of the desirability of a position. If you have to think
harder to win, the position isn't quite as good as one in which
no-brainer moves will take you home. Thus, one tries to move
to positions that require the opponent to keep alert.

Furthermore, I consider it more desirable to win with lots of marks on the
board than with fewer (because you have kindly refrained from
humiliating your opponent).

@d rank z.I /* number of moves made */
@d link y.V /* next vertex of same rank */
@d head x.V /* first vertex of given rank */
@d winner w.I /* is this a winning position? */
@d bitcode v.I /* binary representation of this position */
@d follower u.V /* an optimal move goes here */
@d score w.I /* the primary value of this position */
@d nobrainer u.I /* immediate or threatened win */

@c
#include "gb_graph.h"
#include "gb_save.h"
Vertex *pos[1<<18];
unsigned int diff[1<<18]; /* the difficulty factor */
int count[9],win[9];

main()
{
  register j,k,s,t,tt,auts;
  register unsigned int d;
  Vertex *u,*v;
  Arc *a;
  Graph *g=restore_graph("/tmp/tictactoe.gb");
  @<Fill in the |nobrainer| fields@>;
  for (k=9;k>=0;k--)
    for (v=(g->vertices+k)->head;v;v=v->link) {
      pos[v->bitcode]=v;
      @<Compute the |score| and difficulty of |v|@>;
  }
  for (k=9;k>=0;k--)
    for (v=(g->vertices+k)->head;v;v=v->link) {
      @<Determine the equivalence class of |v|@>;
    }
  for (k=0;k<=9;k++)
    printf("(%d,%d) classes after %d moves\n",count[k],win[k],k);
}

@ The |nobrainer| field is set to $+1$ if there's a one-move win,
and to $-1$ if the opponent has a one-move win that should be blocked.

@<Fill in the |nobrainer| fields@>=
for (k=9;k>=0;k--)
  for (v=(g->vertices+k)->head;v;v=v->link) {
    for (a=v->arcs;a;a=a->next) {
      u=a->tip;
      if (u->winner) {
        v->nobrainer=1;
        break;
      }
      if (u->nobrainer>0) v->nobrainer=-1; /* may be set $+1$ later */
    }
  }


@ The |score| field takes the place of what used to be called |winner|.
Scores are computed from the standpoint of the \.X player: A score of
$+6$ means that \.X can force a win at move six; a score of $-9$ means
that \.O can win (or has won) at move nine. A score of zero means
that a draw is the best possible outcome.

Positions with equal score are ranked secondarily by their |diff|,
which is a sequence of 8 hexadecimal digits. The most significant digit is
the number of nonoptimal moves facing the player at this position.
The next digit is the {\it complement\/} of the number of nonoptimal
moves facing the opponent, after the player has made an optimal move.
And so on; even-numbered digits are complemented with respect to~\.f.

@<Compute the |score| and difficulty of |v|@>=
if (v->winner) v->score=-v->rank, diff[v->bitcode]=0x0f0f0f0f;
else if (v->rank==9) v->score=0, diff[v->bitcode]=0x0f0f0f0f;
else {
  for (s=99,a=v->arcs;a;a=a->next) {
    u=a->tip;
    if (s>u->score || (s==u->score && d<diff[u->bitcode]))
      s=u->score, d=diff[u->bitcode];
  }
  t=v->nobrainer; /* the |nobrainer| field will become |follower| now */
  for (j=0,a=v->arcs;a;a=a->next) {
    u=a->tip;
    if (s!=u->score || d!=diff[u->bitcode]) j++;
    else v->follower=u;
  }
  if (t<0 || s==-k-1) j=0;
  v->score=-s, diff[v->bitcode]=(j<<28)+((0xffffffff-d)>>4);
}

@ The tic-tac-toe board has eight automorphisms. So I can save a
factor of roughly eight when I'm trying to understand this data.

@<Determine the equivalence class of |v|@>=
t=tt=v->bitcode, auts=1;
for (j=1;j<4;j++) {
  t=t^((t^(t>>2))&0x3f3f)^((t^(t<<6))&0xc0c0); /* rotate $90^\circ$ */
  if (t<tt) tt=t,auts=1;
  else if (t==tt) auts++;
}
t=t^((t^(t>>2))&0x3300)^((t^(t<<2))&0xcc00)
   ^((t^(t>>4))&0x3)^((t^(t<<4))&0x30); /* reflect */
if (t<tt) tt=t,auts=1;
else if (t==tt) auts++;
for (j=1;j<4;j++) {
  t=t^((t^(t>>2))&0x3f3f)^((t^(t<<6))&0xc0c0); /* rotate $90^\circ$ */
  if (t<tt) tt=t,auts=1;
  else if (t==tt) auts++;
}
if (tt==v->bitcode) @<Print the best move from |v|@>;
if (v->score!=pos[tt]->score || diff[v->bitcode]!=diff[pos[tt]->bitcode])
  printf("I goofed!\n");

@ Whenever |v| is the leader of an equivalence class, I print out its
characteristics.

@<Print the best move from |v|@>=
{
  count[v->rank]++;
  printf("%s has score %d(%08x), size %d",
     v->name,v->score,diff[v->bitcode]^0x0f0f0f0f,8/auts);
  if (v->follower) {
    printf(", -> ");
    for (j=0;j<=10;j++) printf("%c",
      v->follower->name[j]<'A'? v->follower->name[j]:
                               'X'+'O'-v->follower->name[j]);
  }@+ else win[k]++;
  printf("\n");
}
  
@*Index.
