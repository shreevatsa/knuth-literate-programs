@x
    sprintf(tet[q].aux,""O"c"O"c"O"c",encode(i+1),encode(j+1),encode(k+1));
@y
    optloc[i][j][k]=q;
    sprintf(tet[q].aux,""O"c"O"c"O"c",encode(i+1),encode(j+1),encode(k+1));
@z
@x
  o,trail[trailptr++]=opt;
@y
  o,trail[trailptr++]=opt;
  @<Check for swap prevention@>;
@z
@x
  active+=3; /* hooray for the sparse-set technique */
@y
  @<Check for swap unprevention@>;
  active+=3; /* hooray for the sparse-set technique */
@z
@x
@*Miscellaneous loose ends. In a long run, it's nice to know
@y
@*A hoped-for speedup. We might perhaps be able to cut the running time
approximately in half, if it turns out that every solution contains
a $2\times2$ latin square in rows $(i,i')$ and columns $(j,j')$.
The entries in that $2\times2$ square can then be swapped, and we
can obtain all solutions by looking at only half of them.

For example, consider the $4\times4$ problem
$$\def\\#1/#2/#3/#4/{\vcenter{\offinterlineskip
       \halign{\vphantom(\tt##\cr#1\cr#2\cr#3\cr#4\cr}}\,}
\\12../21../..../..../,\quad
\hbox{ which has 8 solutions }\quad
\\1234/2143/3412/4321/,\quad
\\1234/2143/3421/4312/,\quad
\\1234/2143/4312/3421/,\quad
\\1234/2143/4321/3412/,\quad
\\1243/2134/3412/4321/,\quad
\\1243/2134/3421/4312/,\quad
\\1243/2134/4312/3421/,\quad
\\1243/2134/4321/3412/.
$$
Since this one has three independent $2\times2$ subsquares, we can
reduce all eight solutions to a single one.

The general idea is to find sets of six indices
$i$, $j$, $k$, $i'$, $j'$, $k'$ such that $i<i'$, $j<j'$, $k<k'$,
and to forbid all solutions that contain all four of the options
$$ijk,\qquad ij'k',\qquad i'jk',\qquad i'j'k.$$
(That would rule out all but the last solution above.)

The situation gets more complicated when the $2\times2$ subsquares overlap.
Consider the $5\times5$ problem
$$\def\\#1/#2/#3/#4/#5/{\vcenter{\offinterlineskip
       \halign{\vphantom(\tt##\cr#1\cr#2\cr#3\cr#4\cr#5\cr}}\,}
\\...../..453/.5.24/.35.2/.423./,
\hbox{ which has 5 solutions }\quad
\\12345/21453/35124/43512/54231/,\quad
\\21345/12453/35124/43512/54231/,\quad
\\32145/21453/15324/43512/54231/,\quad
\\42315/21453/35124/13542/54231/,\quad
\\52341/21453/35124/43512/14235/.$$
The first one was five swappable subsquares, but all five of them
are ruled out. The other four solutions each have one swappable
subsquare, and that subsquare is perfectly legal. So in this case
the number of solutions goes down only from 5 to~4.

On the other hand, if we change the order of the digits in that example,
by complementing them with respect to 6, we get
$$\def\\#1/#2/#3/#4/#5/{\vcenter{\offinterlineskip
       \halign{\vphantom(\tt##\cr#1\cr#2\cr#3\cr#4\cr#5\cr}}\,}
\\...../..213/.1.42/.31.4/.243./,
\hbox{ which has 5 solutions }\quad
\\54321/45213/31542/23154/12435/,\quad
\\45321/54213/31542/23154/12435/,\quad
\\34521/45213/51342/23154/12435/,\quad
\\24351/45213/31542/53124/12435/,\quad
\\14325/45213/31542/23154/52431/.$$
In this example only the first case is legal; the other four cases are
omitted.

@ In general, let's say that two latin squares are ``swap-equivalent''
if we can transform one to the other by some sequence of $2\times2$ swaps.
All five of the solutions in our $5\times5$ example are swap-equivalent;
in fact, the first one gives any of the other four after just one swap.

If we replace an illegal $2\times2$ subsquare by a legal one,
we increase the entries of the overall square lexicographically.
Therefore we don't paint ourselves into a corner:
every swap-equivalence class is represented by at least one solution.

(This idea is a special case of the general principle of reducing
solutions by endomorphisms, as discussed on pages 107--111 of
{\sl The Art of Computer Programming}, Volume~4, Fascicle~6.)


@ To implement these ideas, we must start by discovering all of the potential
places for swapping.

@<Init...@>=
{
  register ii,jj,kk;
  if (showprunes) fprintf(stderr,"potential swaps:\n");
  for (i=0;i<n;i++) for (j=0;j<n;j++) if (o,P[i][j]) {
    for (k=0;k<n;k++) if (o,optloc[i][j][k]) {
      for (jj=j+1;jj<n;jj++) if (o,P[i][jj]) {
        for (kk=k+1;kk<n;kk++) if (o,optloc[i][jj][kk]) {
          for (ii=i+1;ii<n;ii++) if (o,optloc[ii][j][kk]) {
            if (o,optloc[ii][jj][k]) {
              @<Create the swap record for $(i,j,k,i',j',k')$@>;
              if (showprunes) print_swap_quad(swapptr-swapitemsize+4);
            }
          }
        }
      }
    }
  }
}
fprintf(stderr,"(I found "O"d potential swaps)\n",swapcount);

@ Each possible swap record will occupy 17 positions of the |swap| array.
The first four of these point respectively to options $ijk$, $ij'k'$,
$i'jk'$, and $i'j'k$. The next is a counter, which will trigger the
appropriate action when it gets large enough. Then come four entries
of the form $(\\{count},\\{inc}.\\{next})$, which are commands linked to
the four options; they mean ``add \\{inc} to \\swap(\\count), then go to
\\swap(\\next) for the next such command.''

The |down| field of an option links to the quadruples containing
that option.

@d swapitemsize 17
@d maxswaps 100000

@<Create the swap record for $(i,j,k,i',j',k')$@>=
{
  if (++swapcount>=maxswaps) {
    fprintf(stderr,"Too many swaps! (max="O"d)\n",maxswaps);
    exit(-668);
  }
  oo,swap[swapptr]=optloc[i][j][k];
  oo,swap[swapptr+1]=optloc[i][jj][kk];
  oo,swap[swapptr+2]=optloc[ii][j][kk];
  oo,swap[swapptr+3]=optloc[ii][jj][k];
  o,swap[swapptr+5]=swapptr+4;
  o,swap[swapptr+6]=0x10;
  oo,swap[swapptr+7]=tet[optloc[i][j][k]].down;
  o,tet[optloc[i][j][k]].down=swapptr+5;
  o,swap[swapptr+8]=swapptr+4;
  o,swap[swapptr+9]=0x11;
  oo,swap[swapptr+10]=tet[optloc[i][jj][kk]].down;
  o,tet[optloc[i][jj][kk]].down=swapptr+8;
  o,swap[swapptr+11]=swapptr+4;
  o,swap[swapptr+12]=0x12;
  oo,swap[swapptr+13]=tet[optloc[ii][j][kk]].down;
  o,tet[optloc[ii][j][kk]].down=swapptr+11;
  o,swap[swapptr+14]=swapptr+4;
  o,swap[swapptr+15]=0x13;
  oo,swap[swapptr+16]=tet[optloc[ii][jj][k]].down;
  o,tet[optloc[ii][jj][k]].down=swapptr+14;
  swapptr+=swapitemsize;
}
  
@ @<Sub...@>=
void print_swap_quad(int p) {
  fprintf(stderr," "O"s "O"s "O"s "O"s "O"02x\n",
     tet[swap[p-4]].aux,tet[swap[p-3]].aux,
     tet[swap[p-2]].aux,tet[swap[p-1]].aux,swap[p]);
}
@#
void print_swap_list(int t) {
  register int q;
  fprintf(stderr,"swap quads for "O"s:\n",tet[t].aux);
  for (q=tet[t].down;q;q=swap[q+2])
    print_swap_quad(swap[q]);
}

@ The mechanism for avoiding forbidden quadruples of options is
similar to what we've done before: Whenever an option is forced,
we add to the counter for each of the quadruples that contain it.
And if that counter reaches~three, we'll hide the fourth option.
(Each option is well separated from the options that participate
in other parts of the forcing operation.)

The |up| field of an option is set nonzero when that option
has been hidden although its variables may be active.

When we fetch three consecutive items in the |swap| array,
the cost is only two mems.

I hope the reader enjoys looking into the code in this step!

@<Check for swap prevention@>=
stack=0;
for (o,q=tet[opt].down;q;o,q=swap[q+2]) {
  oo,p=swap[q],swap[p]+=swap[q+1]; /* see the note about mems above */
  if (swap[p]>=0x30) { /* we've chosen three options of a quad */
    o,t=swap[p+0x32-swap[p]]; /* the unchosen option(!) */
    o,tip[stack++]=t;
  }
}
while (stack) {
  o,t=tip[--stack];
  oo,tet[t].up++;
  if (tet[t].up>1) continue; /* option |t| was already hidden */
  ooo,pij=tet[t+1].itm,rik=tet[t+2].itm,cjk=tet[t+3].itm;
  if ((o,var[pij].pos>=active) ||
      (o,var[rik].pos>=active) ||
      (o,var[cjk].pos>=active)) continue; /* option |t| isn't active */  
  if (showprunes) fprintf(stderr,"swap disables "O"s\n",tet[t].aux);
  t++;@<Hide the tetrad |t|@>;
  t++;@<Hide the tetrad |t|@>;
  t++;@<Hide the tetrad |t|@>;
}        

@ @<Check for swap unprevention@>=
stack=0;
for (o,q=tet[opt].down;q;o,q=swap[q+2]) {
  o,p=swap[q];
  if (swap[p]>=0x30) { /* we've chosen three options of a quad */
    o,t=swap[p+0x32-swap[p]]; /* the unchosen option(!) */
    o,tip[stack++]=t;
  }
  o,swap[p]-=swap[q+1]; /* see the note about mems above */
}
for (s=0;s<stack;s++) { /* unhide in the opposite order */
  o,t=tip[s];
  oo,tet[t].up--;
  if (tet[t].up) continue; /* option |t| had already been hidden */
  ooo,pij=tet[t+1].itm,rik=tet[t+2].itm,cjk=tet[t+3].itm;
  if ((o,var[pij].pos>=active) ||
      (o,var[rik].pos>=active) ||
      (o,var[cjk].pos>=active)) continue; /* option |t| wasn't active */  
  t+=3;@<Unhide the tetrad |t|@>;
  t--;@<Unhide the tetrad |t|@>;
  t--;@<Unhide the tetrad |t|@>;
}        

@ @<Glob...@>=
int optloc[maxn][maxn][maxn];
int swapcount,swapptr;
int swap[swapitemsize*maxswaps];
int tip[maxn*maxn*maxn];

@*Miscellaneous loose ends. In a long run, it's nice to know
@z
