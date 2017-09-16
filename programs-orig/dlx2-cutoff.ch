@x
@s column int
@y
\let\maybe=\iffalse
@s column int
@z
@x
@ After this program finds all solutions, it normally prints their total
@y
@ This version of the program keeps removing rows at the bottom, thereby
finding all solutions that have minimax row number. (And it usually also
finds a few more, before it has found the best cutoff point.)

We assume that the columns contain rows in their original order;
the |up| and |down| links actually point upwards and downwards.
Therefore we disable the ``randomizing'' feature by which columns
could be linked randomly. (Randomization still does apply, however,
when choosing a column for branching.)

After this program finds all the desired solutions,
it normally prints their total
@z
@x
@d show_details 4 /* |vbose| code for further commentary */
@y
@d show_details 4 /* |vbose| code for further commentary */
@d show_cutoffs 8 /* |vbose| code to report improvements in the cutoff point */
@z
@x
int last_col; /* the first column in |cl| that's not yet used */
@y
int last_col; /* the first column in |cl| that's not yet used */
int cutoff=max_nodes; /* nodes after this point have essentially disappeared */
@z
@x
@d sanity_checking 0 /* set this to 1 if you suspect a bug */
@y
@d sanity_checking 0 /* set this to 1 if you suspect a bug */
@z
@x
@ I used to think that it was important to uncover a column by
processing its rows from bottom to top, since covering was done
from top to bottom. But while writing this
program I realized that, amazingly, no harm is done if the
rows are processed again in the same order. So I'll go downward again,
just to prove the point. Whether we go up or down, the pointers
execute an exquisitely choreo\-graphed dance that returns them almost
magically to their former state.
@y
@ A subtle point should be noted: As we uncover column $c$, and
run across a row `$c$~$x$~\dots' that should be restored to column~$x$,
the original successors `$x$~$a$~\dots', `$x$~$b$~\dots', etc., of
that row in column~$x$ may now be cut off. In such a case we can be
sure that those successor rows have disappeared from column~$x$, and
they have {\it not\/} been restored.

The reason is that each of those rows must have a primary column;
and every primary column was covered before we changed the cutoff.
The rows were therefore not restored to column~$x$ when we uncovered
those primary columns.
@z
@x
void uncover(int c) {
  register int cc,l,r,rr,nn,uu,dd,t;
  for (o,rr=nd[c].down;rr>=last_col;o,rr=nd[rr].down)
    for (nn=rr+1;nn!=rr;) {
      if (o,nd[nn].color>=0) {
        o,uu=nd[nn].up,dd=nd[nn].down;
        cc=nd[nn].col;
        if (cc<=0) {
          nn=uu;
          continue;
        }
@y
void uncover(int c) {
  register int cc,l,r,rr,nn,uu,dd,t;
  for (o,t=0,rr=nd[c].up;rr>=cutoff;o,rr=nd[rr].up) t++;
  if (t) { /* |t| rows that we covered have been cut off */
    oo,nd[c].len-=t;
    if (c>=second) lmems+=2;
    oo,nd[c].up=rr,nd[rr].down=c;
  }
  for (;rr>=last_col;o,rr=nd[rr].up)
    for (nn=rr+1;nn!=rr;) {
      if (o,nd[nn].color>=0) {
        o,uu=nd[nn].up,dd=nd[nn].down;
        cc=nd[nn].col;
        if (cc<=0) {
          nn=uu;
          continue;
        }
        if (dd>=cutoff)
          o,nd[nn].down=dd=cc; /* see the ``subtle point'' above */
@z
@x
void unpurify(int p) {
  register int cc,rr,nn,uu,dd,t,x;
  o,cc=nd[p].col,x=nd[p].color; /* there's no need to clear |nd[cc].color| */
  for (o,rr=nd[cc].up;rr>=last_col;o,rr=nd[rr].up) {  
    if (o,nd[rr].color<0) o,nd[rr].color=x;
    else if (rr!=p) {
      for (nn=rr-1;nn!=rr;) {
        o,uu=nd[nn].up,dd=nd[nn].down;
        o,cc=nd[nn].col;
        if (cc<=0) {
          nn=dd;@+continue;
        }
        if (nd[nn].color>=0) {
@y
void unpurify(int p) {
  register int cc,rr,nn,uu,dd,t,x;
  o,cc=nd[p].col,x=nd[p].color; /* there's no need to clear |nd[cc].color| */
  for (o,t=0,rr=nd[cc].up;rr>=cutoff;o,rr=nd[rr].up) t++;
  if (t) { /* |t| rows that we covered have been cut off */
    oo,nd[cc].len-=t;
    lmems+=2;
    oo,nd[cc].up=rr,nd[rr].down=cc;
  }
  for (;rr>=last_col;o,rr=nd[rr].up) {  
    if (o,nd[rr].color<0) o,nd[rr].color=x;
    else if (rr!=p) {
      for (nn=rr-1;nn!=rr;) {
        o,uu=nd[nn].up,dd=nd[nn].down;
        o,cc=nd[nn].col;
        if (cc<=0) {
          nn=dd;@+continue;
        }
        if (nd[nn].color>=0) {
          if (dd>=cutoff)
            o,nd[nn].down=dd=cc; /* see the ``subtle point'' above */
@z
@x
  count++;
@y
  count++;
  for (k=0,pp=0;k<=level;k++) if (choice[k]>pp) pp=choice[k];
  for (pp++;o,nd[pp].col>0;pp++); /* move to end of largest chosen row */
  if (pp!=cutoff) {
    cutoff=pp;
    if (vbose&show_cutoffs) {
      fprintf(stderr," new cutoff after row "O"d:\n",-nd[pp].col);
      prow(nd[pp].up);
    }
    for (k=0;k<=level;k++) {
      o,cc=nd[choice[k]].col; /* |cc| will stay covered until we backtrack */
      for (o,t=0,pp=nd[cc].up;pp>=cutoff;o,pp=nd[pp].up) t++;
      if (t) { /* need to prune unneeded options from column |cc| */
        oo,nd[pp].down=cc,nd[cc].up=pp;
        oo,nd[cc].len-=t;
      }
    }
  }
@z
