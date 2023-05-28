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
are constrained to remain in this grid, and the configuration at time~$r$
is constrained to be exactly the same as it was at time~$r-1$. (Thus
the final state is a ``still life.'')

Furthermore the live cells at time~0 are exactly equal to those of the
still life, plus the five cells of a glider. The glider is located
in the lower right $3\times3$ cells of the grid, and it is traveling
northeast. The still life is dead in the lower right $4\times4$ cells,
and it doesn't interact with previous generations of the glider.
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
    for (x=xmin-1;x<=xmax+1;x++) for (y=ymin-1;y<=ymax+1;y++) {
      @<If cell $(x,y)$ is obviously dead at time $t+1$, |continue|@>;
      a(x,y);
      zprime(x,y);
      if (pp(x,y)==0) printf("~%d%c%d\n",
                x,timecode[tt+1],y); /* keep the configuration caged */
    }
  }
  @<Enforce the eater scenario@>;
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
printf("~ sat-life-grid-eater %d %d %d\n",mm,nn,r);
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
  if (k==0 && (x<xmin || x>xmax || y<ymin || y>ymax || p[x][y]==0))
@y
  if (k==0 && pp(x,y)==0)
@z
@x
@*Index.
@y
@ @<Enforce the eater scenario@>=
@<Make $X_{r-1}=X_r$ be still@>;
@<Make $X_r$ dead and quiescent at lower left@>;
@<Make $X_0=X_r+{}$glider@>;

@ @<Make $X_{r-1}=X_r$ be still@>=
for (x=1;x<=mm;x++) for (y=1;y<=nn;y++) {
  printf("~%d%c%d %d%c%d\n",x,timecode[r-1],y,x,timecode[r],y);
  printf("%d%c%d ~%d%c%d\n",x,timecode[r-1],y,x,timecode[r],y);
}

@ The ``quiescent'' condition means that the glider won't interact
from its positions at negative time.

Let the first four elements
of row |mm-4| be $(a,b,c,d)$; then we want
$a+b\ne1$, $a+b+c\ne1$, $b+c+d\ne2$. In clause form this becomes
$\bar a\lor b$, $a\lor\bar b$, $b\lor\bar c$, $\bar c\lor d$,
$\bar b\lor c\lor\bar d$.

Similarly, let the last four elements of column 5 be $(f,g,h,i)$; then we
want $f+g+h\ne2$, $g+h+i\ne2$, $h+i\ne2$. These conditions simplify to
$\bar f\lor\bar g$, $\bar f\lor\bar h$, $\bar g\lor\bar\imath$,
$\bar h\lor\bar\imath$.

@<Make $X_r$ dead and quiescent at lower left@>=
for (x=mm-3;x<=mm;x++) for (y=1;y<=4;y++)
  printf("~%d%c%d\n",x,timecode[r],y);
printf("~%da1 %da2\n",mm-4,mm-4);
printf("%da1 ~%da2\n",mm-4,mm-4);
printf("%da2 ~%da3\n",mm-4,mm-4);
printf("~%da3 %da4\n",mm-4,mm-4);
printf("~%da2 %da3 ~%da4\n",mm-4,mm-4,mm-4);
printf("~%da5 ~%da5\n",mm-3,mm-2);
printf("~%da5 ~%da5\n",mm-3,mm-1);
printf("~%da5 ~%da5\n",mm-2,mm);
printf("~%da5 ~%da5\n",mm-1,mm);

@ @<Make $X_0=X_r+{}$glider@>=
for (x=1;x<=mm;x++) for (y=1;y<=nn;y++) if (x<=mm-3 || y>=4) {
  printf("~%da%d %d%c%d\n",x,y,x,timecode[r],y);
  printf("%da%d ~%d%c%d\n",x,y,x,timecode[r],y);
}
printf("%da1\n",mm-2);
printf("%da2\n",mm-2);
printf("%da3\n",mm-2);
printf("~%da1\n",mm-1);
printf("~%da2\n",mm-1);
printf("%da3\n",mm-1);
printf("~%da1\n",mm);
printf("%da2\n",mm);
printf("~%da3\n",mm);

@*Index.
@z
