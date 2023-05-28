@x
from time $t$ to time $t+1$ in Conway's Game of Life, assuming that
all of the potentially live cells at time $t$ belong to a pattern
that's specified in |stdin|. The pattern is defined by one or more
lines representing rows of cells, where each line has `\..' in a
cell that's guaranteed to be dead at time~$t$, otherwise it has `\.*'.
The time is specified separately as a command-line parameter.
@y
from time $t$ to time $t+1$ in Conway's Game of Life, for various
values of $t$, as I'm trying to prove or disprove a certain conjecture.

Namely, it may be possible to set cells $(x,y)$ for $x\le0$ and $y\le0$
(i.e., in the lower left quadrant) in such a way that cell $(x,y)$ is
reachable in $x+2y$ steps when $0\le-x\le y$, and in $2y+2x$ steps
when $x\ge0$ and $y\ge0$.
Hopefully by seeing examples for small $x$ and $y$ I will
have a handle on that conjecture.

The conjectured bounds agree with lower bounds that are readily proved.
Hence the problem is to find matching upper bounds, if possible.

The command line should contain the coordinates $x_0$ and $y_0$ being tested.

When the conjectured bound is $r$, this program uses nested boards
of sizes $(2r+1)\times(2r+1)$, $(2r-1)\times(2r-1)$, \dots, $3\times3$,
$1\times1$, centered on the cell $(x,y)$ that we're trying to turn on.
Many of the cells are known to be zero, because of the lower bounds;
therefore we don't include them in the computation.
@z
@x
int tt; /* time as given on the command line */
@y
int tt; /* the time being considered */
int x0,y0; /* the command-line parameters */
int r; /* the conjectured bound */
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
    xmin=ymin=1+tt, xmax=ymax=r+r+1-tt;
    for (x=xmin+1;x<xmax;x++) for (y=ymin+1;y<ymax;y++) {
      if (bound(x,y)>tt+1) continue;
      a(x,y);
      zprime(x,y);
    }
  }
  printf("%d%c%d\n",r+1,timecode[tt],r+1); /* middle variable must be alive */
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
if (argc!=3 || sscanf(argv[1],"%d",&x0)!=1 ||
               sscanf(argv[2],"%d",&y0)!=1) {
  fprintf(stderr,"Usage: %s x0 y0\n",argv[0]);
  exit(-1);
}
if (y0<=0) {
  fprintf(stderr,"The value of y0 should be positive!\n");
  exit(-2);
}
if (x0<-y0) {
  fprintf(stderr,"The value of x0 should be at least -y0!\n");
  exit(-3);
}
r=(x0>0?2*(x0+y0):x0+2*y0);
printf("~ sat-life-upper %d %d\n",x0,y0);
@z
@x
  if (k==0 && (x<xmin || x>xmax || y<ymin || y>ymax || p[x][y]==0))
@y
  if (k==0 && bound(x,y)>tt)
@z
@x
@*Index.
@y
@ In this variation of the program, I compute the known lower bounds.
At time $t$, only the entries of |p| that are $\le t$ are considered
potentially alive.

I've been thinking ``rows and columns'' instead of Cartesian coordinates,
so the notation is a bit schizophrenic here. An $x$ value in the
user interface corresponds to column $x+c$, where $c=1+r-x_0$;
and a $y$ value corresponds to row $d-y$, where $d=1+r+y_0$.
(Hence in particular, cell $(0,0)$ corresponds to column $c$ of
row $d$. Since $r\ge 2y_0-x_0$, we have $c\ge3$.)

@<Sub...@>=
int ff(int x,int y) {
  if (x<=0 && y<=0) return 0;
  if (y<0) return ff(y,x);
  if (x<=-y) return y;
  if (x<=0) return x+y+y;
  return x+x+y+y;
}
@#
int bound(int xx,int yy) {
  return ff(yy-(1+r-x0),(1+r+y0)-xx);
}

@*Index.
@z
