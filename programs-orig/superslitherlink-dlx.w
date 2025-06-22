\datethis
\input epsf
\def\adj{\mathrel{\!\mathrel-\mkern-8mu\mathrel-\mkern-8mu\mathrel-\!}}
   % adjacent vertices

@*Intro. Given the specification of a SuperSlitherlink puzzle in |stdin|,
this program outputs {\mc MCC} data for the problem of finding all solutions.
(It's based on {\mc SLITHERLINK-DLX}, which handles ordinary Slitherlink.)

SuperSlitherlink extends the former rules by allowing several cells to
participate in the same clue. Each superclue is identified by a letter,
and the relevant cells are marked with that letter. An edge that lies
between two cells with the same letter is called ``internal'' and it
cannot participate in the solution. An edge that lies between a cell
with a letter and a cell that either has a numeric clue or a blank clue
or lies off the board is a ``boundary edge'' for that letter. An edge
that lies between cells with different letters is a boundary edge for
both of those letters. The clue for a letter is the number of boundary edges
that should appear in the solution.

For reasons of speed and simplicity, this program does {\it not\/}
solve SuperSlitherlink puzzles in full
generality: In weird cases it can generate options that contain
two identical items. It does, however, always work when the
superclue groups are subrectangles, and in many other cases.
(The similar but more complex program {\mc SUPERSLITHERLINK-GENERAL-DLX}
can be used to handle arbitrarily weird superclues.)

No attempt is made to enforce the ``single loop'' condition; solutions
found by {\mc DLX3} will consist of disjoint loops. But {\mc DLX3-LOOP}
will weed out any disconnected solutions. In fact, it will nip most of
them in the bud.

The specification begins with $m$ lines of $n$ characters each;
those characters should be either
`\.0' or `\.1' or `\.2' or `\.3' or `\.4' or `\..' or a letter.
(Here `\..' means ``no clue.'')
Those opening lines should be followed by lines of the form
\.!$\langle\,\hbox{letter}\,\rangle\.=\langle\,\hbox{clue}\,\rangle$,
one for each letter in the opening lines.
For example, here's the specification for a simple SuperSlitherlink
puzzle that Johan de Ruiter designed for Pi Day 2025:
$$\vbox{\halign{\tt#\hfil\cr
aaa....\cr
aaabb..\cr
aaabb..\cr
.......\cr
..ccddd\cr
..ccddd\cr
....ddd\cr
!a=3\cr
!b=1\cr
!c=4\cr
!d=1\cr
}}$$
(See {\tt https://cs.stanford.edu/\char`\~knuth/news25.html}.)

@ Here now is the general outline.

@d maxn 30 /* |m| and |n| must be at most this */
@d bufsize 80
@d panic(message) {@+fprintf(stderr,"%s: %s",message,buf);@+exit(-1);@+}

@c
#include <stdio.h>
#include <stdlib.h>
char buf[bufsize];
int board[maxn][maxn]; /* the given clues */
char super[128]; /* did this letter appear? */
int clue[128]; /* numeric clues for letters that have appeared */
char code[]={0xc,0xa,0x5,0x3,0x9,0x6,0x0};
char edge[2*maxn+1][2*maxn+1]; /* is this a legal edge? */
void main() {
  register int d,i,j,k,m,n;
  @<Read the input into |board|@>;
  @<Determine the legal edges@>;
  @<Print the item-name line@>;
  for (i=0;i<=m;i++) for (j=0;j<=n;j++)
    @<Print the options for tile $(i,j)$@>;
}

@ @<Read the input into |board|@>=
printf("| slitherlink-dlx:\n");
for (i=0;i<maxn;) {
  if (!fgets(buf,bufsize,stdin)) break;
  printf("| %s",
               buf);
  if (buf[0]=='!') @<Record the clue for a letter and |continue|@>;
  for (j=0;j<maxn && buf[j]!='\n';j++) {
    k=buf[j];
    if (k=='|' || k==':' || k<0) panic("Illegal character");
    if (k!='.' && (k<'0' || k>'4'))
      super[k]=1,clue[k]=-1; /* we treat |k| as a letter */
    board[i][j]=k;
  }
  if (i++==0) n=j;
  else if (n!=j) panic("row has wrong number of clues");
}
m=i;
if (m<2 || n<2) panic("the board dimensions must be 2 or more");
for (k=0;k<128;k++) if (super[k] && clue[k]<0)
  fprintf(stderr,"No `!%c=...'!\n",
              k);
fprintf(stderr,"OK, I've read a %dx%d array of clues.\n",
                          m,n);

@ @<Record the clue for a letter...@>=
{
  if (buf[2]!='=') panic("no = sign");
  k=buf[1];
  if (!super[k]) fprintf(stderr,"letter `%c' never occurred!\n",
                                                  k);
  else {
    for (d=0,j=3;buf[j]>='0' && buf[j]<='9';j++) d=10*d+buf[j]-'0';
    clue[k]=d;
  }
  continue;
}

@ The primary items are ``tiles,'' ``cells,'' and ``clues.''
Tiles control the loop path; the name of tile $(i,j)$ is
$(2i,2j)$. Cells represent numeric clues;
 the name of cell $(i,j)$ is $(2i{+}1,2j{+}1)$.
A cell item is present only if a numeric
clue has been given for that cell of the board.

The secondary items are ``edges'' of the path. Their names are
the midpoints of the tiles they connect.

An edge is illegal if it is internal to the clue of some letter.
A boundary edge for a zero clue is also illegal.

@<Determine the legal edges@>=
for (i=0;i<=m+m;i++) for (j=0;j<=n+n;j++)
  if ((i+j)&1) edge[i][j]=1;
for (i=0;i<m;i++) for (j=0;j<n;j++) {
  k=board[i][j];
  if (k=='0')
    edge[i+i][j+j+1]=edge[i+i+1][j+j]=edge[i+i+1][j+j+2]=edge[i+i+2][j+j+1]=0;
  else if (super[k]) {
    if (j<n-1 && board[i][j+1]==k) edge[i+i+1][j+j+2]=0;
    if (i<m-1 && board[i+1][j]==k) edge[i+i+2][j+j+1]=0;
    if (clue[k]==0)
      edge[i+i][j+j+1]=edge[i+i+1][j+j]=edge[i+i+1][j+j+2]=edge[i+i+2][j+j+1]=0;
  }
}
for (k=0;k<128;k++) if (super[k] && clue[k]==0) super[k]=0;

@ A two-coordinate ``name'' $(x,y)$ actually appears as two encoded digits
(in order to match the conventions of {\mc DLX3-LOOP}).

@d encode(x) ((x)<10? (x)+'0': (x)<36? (x)-10+'a': (x)<62? (x)-36+'A': '?')

@<Print the item-name line@>=
for (i=0;i<=m;i++) for (j=0;j<=n;j++)
  printf("%c%c ",
                encode(i+i),encode(j+j));
for (i=0;i<m;i++) for (j=0;j<n;j++) if (board[i][j]>='1' && board[i][j]<='4')
  printf("%d|%c%c ",
               board[i][j]-'0',encode(i+i+1),encode(j+j+1));
for (k=0;k<128;k++) if (super[k]) printf("%d|%c ",
                                       clue[k],k);
  
printf("|");
for (i=0;i<=m+m;i++) for (j=0;j<=n+n;j++)
  if (edge[i][j]) printf(" %c%c",
                               encode(i),encode(j));
printf("\n");

@ This program relies on a beautiful property of loop paths in a grid,
which can perhaps be best understood by looking at a concrete example.
Consider the loop $\.{24}\adj
\.{26}\adj
\.{28}\adj
\.{48}\adj
\.{4a}\adj
\.{6a}\adj
\.{68}\adj
\.{88}\adj
\.{a8}\adj
\.{a6}\adj
\.{a4}\adj
\.{84}\adj
\.{86}\adj
\.{66}\adj
\.{64}\adj
\.{62}\adj
\.{42}\adj
\.{44}\adj
\.{24}$, which passes through 18 tiles. (Coordinates are specified here in
hexadecimal notation.) It has, of course, 18 edges, namely
\.{25}, \.{27}, \.{38}, \.{49}, \.{5a}, \.{69}, \.{78}, \.{98}, \.{a7},
\.{a5}, \.{94}, \.{85}, \.{76}, \.{65}, \.{63}, \.{52}, \.{43}, \.{34}. 
Here's a picture, showing also the cells that are adjacent to the edges:
$$\vcenter{\epsfbox{superslitherlink-dlx.1}}$$

We assign two cells to each pair of adjacent edges in the loop,
using a ``counterclockwise rule'':
$$\vcenter{\halign{$#$\cr
\.{25},\.{27}\mapsto\.{35},\.{17}\cr
\.{27},\.{38}\mapsto\.{37},\.{39}\cr
\.{38},\.{49}\mapsto\.{39},\.{37}\cr
\.{49},\.{5a}\mapsto\.{59},\.{5b}\cr
\.{5a},\.{69}\mapsto\.{59},\.{79}\cr
\.{69},\.{78}\mapsto\.{79},\.{59}\cr
}}\qquad\vcenter{\halign{$#$\cr
\.{78},\.{98}\mapsto\.{99},\.{77}\cr
\.{98},\.{a7}\mapsto\.{97},\.{b7}\cr
\.{a7},\.{a5}\mapsto\.{b5},\.{97}\cr
\.{a5},\.{94}\mapsto\.{95},\.{93}\cr
\.{94},\.{85}\mapsto\.{95},\.{75}\cr
\.{85},\.{76}\mapsto\.{75},\.{95}\cr
}}\qquad\vcenter{\halign{$#$\cr
\.{76},\.{65}\mapsto\.{75},\.{77}\cr
\.{65},\.{63}\mapsto\.{73},\.{55}\cr
\.{63},\.{52}\mapsto\.{53},\.{51}\cr
\.{52},\.{43}\mapsto\.{53},\.{33}\cr
\.{43},\.{34}\mapsto\.{33},\.{53}\cr
\.{34},\.{25}\mapsto\.{35},\.{15}\cr
}}$$ 
(When the edges take a $90^\circ$ turn, they frame the first cell,
and the second cell is obtained by rotating counterclockwise.
A similar rule applies when the edges are parallel.)

This rule has the magic property that each cell occurs precisely as
often as it is adjacent to a edge of the loop. For example, cell \.{15}
occurs once, cell \.{35} occurs twice, and cell \.{75} occurs thrice.

The magic property can be proved by induction on the length of the
loop, considering all ways that a cell
can be surrounded by 1, 2, 3, or 4 edges of a loop.

@ Each tile `$2i$\.,$2j$' controls the destiny of up to four edges that
touch its central point $(i,j)$.
It is filled with either zero or two edges, and each edge potentially
contributes to one or two clue counts.
If there are two edges, we include the names of the adjacent cells,
whenever a clue has been given for such cells.

The adjacent cells will never correspond to the same primary item,
if the edges specify a right-angle turn, or if the clue groups
are subrectangles.

@d N(i,j) (i>0 && edge[i+i-1][j+j])
@d W(i,j) (j>0 && edge[i+i][j+j-1])
@d E(i,j) (j<n && edge[i+i][j+j+1])
@d S(i,j) (i<m && edge[i+i+1][j+j])

@<Print the options for tile $(i,j)$@>=
{
  for (k=0;k<7;k++) {
    if ((code[k]&8)&&!N(i,j)) continue; /* can't go north */
    if ((code[k]&4)&&!W(i,j)) continue; /* can't go west  */
    if ((code[k]&2)&&!E(i,j)) continue; /* can't go east  */
    if ((code[k]&1)&&!S(i,j)) continue; /* can't go south */
    printf("%c%c",
              encode(i+i),encode(j+j));
    if (N(i,j)) printf(" %c%c:%d",
                  encode(i+i-1), encode(j+j), code[k]>>3);
    if (W(i,j)) printf(" %c%c:%d",
                  encode(i+i), encode(j+j-1), (code[k]>>2)&1);
    if (E(i,j)) printf(" %c%c:%d",
                  encode(i+i), encode(j+j+1), (code[k]>>1)&1);
    if (S(i,j)) printf(" %c%c:%d",
                  encode(i+i+1), encode(j+j), code[k]&1);
    switch (k) {
case 0: @<Show NW clue@>;@+@<Show SW clue@>;@+break; /* NW */
case 1: @<Show NE clue@>;@+@<Show NW clue@>;@+break; /* NE */
case 2: @<Show SW clue@>;@+@<Show SE clue@>;@+break; /* SW */
case 3: @<Show SE clue@>;@+@<Show NE clue@>;@+break; /* SE */
case 4: @<Show SE clue@>;@+@<Show NW clue@>;@+break; /* NS */
case 5: @<Show SW clue@>;@+@<Show NE clue@>;@+break; /* EW */
case 6: break; /* untouched */
    }
    printf("\n");
  }
}    

@ Finally we need to identify the clues, if any, that are
relevant in each of the four quadrants of tile $(i,j)$.

@<Show NW clue@>=
if (i>0 && j>0) {
  register int k=board[i-1][j-1];
  if (k!='.') {
    if (k>='1' && k<='4') printf(" %c%c",
                                     encode(i+i-1),encode(j+j-1));
    else printf(" %c",
                     k);
  }
}

@ @<Show NE clue@>=
if (i>0 && j<n) {
  register int k=board[i-1][j];
  if (k!='.') {
    if (k>='1' && k<='4') printf(" %c%c",
                                     encode(i+i-1),encode(j+j+1));
    else printf(" %c",
                     k);
  }
}

@ @<Show SE clue@>=
if (i<m && j<n) {
  register int k=board[i][j];
  if (k!='.') {
    if (k>='1' && k<='4') printf(" %c%c",
                                     encode(i+i+1),encode(j+j+1));
    else printf(" %c",
                     k);
  }
}

@ @<Show SW clue@>=
if (i<m && j>0) {
  register int k=board[i][j-1];
  if (k!='.') {
    if (k>='1' && k<='4') printf(" %c%c",
                                     encode(i+i+1),encode(j+j-1));
    else printf(" %c",
                     k);
  }
}

@*Index.
