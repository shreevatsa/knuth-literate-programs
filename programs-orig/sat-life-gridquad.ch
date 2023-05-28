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

Moreover, this version assumes that the configurations
all have symmetry under both horizontal and vertical reflection.
(The situation at
$(x,y)$ is identical to the situation at $(m+1-x,y)$ and
$(x,n+1-y)$.) Thus the
number of independent variables is essentially reduced by a factor of~4.
@z
@x
int tt; /* time as given on the command line */
@y
int tt; /* the time being considered */
int mm,nn,r; /* the command-line parameters */
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
    for (x=0;x+x<=mm+1;x++) for (y=0;y+y<=nn+1;y++) {
      @<If cell $(x,y)$ is obviously dead at time $t+1$, |continue|@>;
      a(x,y);
      zprime(x,y);
      if (pp(x,y)==0 && tt<r-1)
        applit(x,y,1,1),outclause(); /* keep the configuration caged */
    }
  }
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
if (argc!=4 || sscanf(argv[1],"%d",&mm)!=1 ||
               sscanf(argv[2],"%d",&nn)!=1 ||
               sscanf(argv[3],"%d",&r)!=1) {
  fprintf(stderr,"Usage: %s m n r\n",argv[0]);
  exit(-1);
}
printf("~ sat-life-gridquad %d %d %d\n",mm,nn,r);
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
  register int c,k,x,y,p;
@y
  register int c,k,x,y,p,t;
@z
@x
    y=clause[p]&0xfff;
@y
    y=clause[p]&0xfff;
    if (c==0) {
      if (x+x>mm+1) x=mm+1-x;
      if (y+y>nn+1) y=nn+1-y;
    }
@z
@x
  if (k==0 && (x<xmin || x>xmax || y<ymin || y>ymax || p[x][y]==0))
@y
  if (k==0 && pp(x,y)==0)
@z
