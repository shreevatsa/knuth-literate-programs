@x
from time $t$ to time $t+1$ in Conway's Game of Life, assuming that
all of the potentially live cells at time $t$ belong to a pattern
that's specified in |stdin|. The pattern is defined by one or more
lines representing rows of cells, where each line has `\..' in a
cell that's guaranteed to be dead at time~$t$, otherwise it has `\.*'.
The time is specified separately as a command-line parameter.
@y
from time $0$ to time $r$ in Conway's Game of Life (thus simulating
$r$ steps), on an $m\times n$ grid, given $m$, $n$, and~$r$. The live cells
are constrained to remain in this grid, except perhaps at time~$r$.

This version also adds spaceship constraints: The final state should
be the original state shifted up $s$ places (except perhaps for some
debris at the very bottom).

Furthermore the spaceship is supposed to have left-right symmetry.
@z
@x
int tt; /* time as given on the command line */
@y
int tt; /* the time being considered */
int mm,nn,r,s; /* the command-line parameters */
@z
@x
  @<Input the pattern@>;
  for (x=xmin-1;x<=xmax+1;x++) for (y=ymin-1;y<=ymax+1;y++) {
    @<If cell $(x,y)$ is obviously dead at time $t+1$, |continue|@>;
    a(x,y);
    zprime(x,y);
  }
@y
  for (tt=0;tt<r;tt++) {
    ymax=nn,ymin=1;
    xmax=mm,xmin=1;
    for (x=xmin-1;x<=xmax+1;x++) for (y=ymin-1;y+y<=ymax+1;y++) {
      @<If cell $(x,y)$ is obviously dead at time $t+1$, |continue|@>;
      a(x,y);
      zprime(x,y);
      if (pp(x,y)==0 && tt<r-1) printf("~%d%c%d\n",
                x,timecode[tt+1],y); /* keep the configuration caged */
    }
  }
  @<Enforce the spaceship constraints@>;
@z    
@x
if (argc!=2 || sscanf(argv[1],"%d",&tt)!=1) {
  fprintf(stderr,"Usage: %s t\n",argv[0]);
  exit(-1);
}
if (tt<0 || tt>82) {
  fprintf(stderr,"The time should be between 0 and 82 (not %d)!\n",tt);
  exit(-2);
}
@y
if (argc!=5 || sscanf(argv[1],"%d",&mm)!=1 ||
               sscanf(argv[2],"%d",&nn)!=1 ||
               sscanf(argv[3],"%d",&r)!=1 ||
               sscanf(argv[4],"%d",&s)!=1) {
  fprintf(stderr,"Usage: %s m n r s\n",argv[0]);
  exit(-1);
}
printf("~ sat-life-grid-spaceships-sym %d %d %d %d\n",mm,nn,r,s);
@z
@x
@ @d pp(xx,yy) ((xx)>=0 && (yy)>=0? p[xx][yy]: 0)

@<If cell $(x,y)$ is obviously dead at time $t+1$, |continue|@>=
if (pp(x-1,y-1)+pp(x-1,y)+pp(x-1,y+1)+
    pp(x,y-1)+p[x][y]+p[x][y+1]+
    pp(x+1,y-1)+p[x+1][y]+p[x+1][y+1]<3) continue;
@y
@ @d pp(xx,yy) (((xx)<xmin || (yy)<ymin || (xx)>xmax || (yy)>ymax)? 0: 1)

@<If cell $(x,y)$ is obviously dead at time $t+1$, |continue|@>=
if (pp(x-1,y-1)+pp(x-1,y)+pp(x-1,y+1)+
    pp(x,y-1)+pp(x,y)+pp(x,y+1)+
    pp(x+1,y-1)+pp(x+1,y)+pp(x+1,y+1)<3) continue;
@z
@x
    y=clause[p]&0xfff;
@y
    y=clause[p]&0xfff;
    if (c==0 && y+y>nn+1) y=nn+1-y;
@z
@x
  if (k==0 && (x<xmin || x>xmax || y<ymin || y>ymax || p[x][y]==0))
@y
  if (k==0 && pp(x,y)==0)
@z
@x
@*Index.
@y
@ I can use the theorem that the spaceship can be assumed to gain a
new row on the very last round.

@<Enforce the spaceship constraints@>=
for (tt=0;tt<r;tt++) for (y=1;y+y<=nn+1;y++) printf("~1%c%d\n",timecode[tt],y);
for (y=1;y+y<=nn+1;y++) printf(" 1%c%d",timecode[r],y);
printf("\n"); /* top row is empty before time $r$, but then nonempty */
for (x=2;x<=s;x++) for (y=1;y+y<=nn+1;y++) printf("~%da%d\n",x,y);
for (x=s+1;x<=mm;x++) for (y=1;y+y<=nn+1;y++) {
  printf("~%da%d %d%c%d\n",x,y,x-s,timecode[r],y);
  printf("%da%d ~%d%c%d\n",x,y,x-s,timecode[r],y);
}
for (x=1;x<=mm+1-s;x++) {
  printf("~%d%c0\n",x,timecode[r]);
}
for (y=1;y+y<=nn+1;y++) printf("~0%c%d\n",timecode[r],y);
for (x=1;x<=s;x++) for (y=1;y+y<=nn+1;y++)
  printf("~%d%c%d\n",mm+1-x,timecode[r],y);

@*Index.
@z
