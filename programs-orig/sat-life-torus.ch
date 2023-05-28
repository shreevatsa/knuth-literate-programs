@x
from time $t$ to time $t+1$ in Conway's Game of Life, assuming that
all of the potentially live cells at time $t$ belong to a pattern
that's specified in |stdin|. The pattern is defined by one or more
lines representing rows of cells, where each line has `\..' in a
cell that's guaranteed to be dead at time~$t$, otherwise it has `\.*'.
The time is specified separately as a command-line parameter.
@y
from time $0$ to time $r$ in Conway's Game of Life (thus simulating
$r$ steps), on an $m\times n$ torus, given $m$, $n$, and~$r$.
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
    for (x=xmin;x<=xmax;x++) for (y=ymin;y<=ymax;y++) {
      a(x,y);
      zprime(x,y);
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
printf("~ sat-life-torus %d %d %d\n",mm,nn,r);
@z
@x
    if (c) printf("%d%c%d%c%d",
             x,timecode[tt],y,c+'@@',k);
    else if (k==7) printf("%d%c%dx",
             x,timecode[tt],y);
    else printf("%d%c%d",
             x,timecode[tt+k],y);
@y
    if (c) printf("%d%c%d%c%d",
             1+((x+mm-1)%mm),timecode[tt],1+((y+nn-1)%nn),c+'@@',k);
    else if (k==7) printf("%d%c%dx",
             1+((x+mm-1)%mm),timecode[tt],1+((y+nn-1)%nn));
    else printf("%d%c%d",
             1+((x+mm-1)%mm),timecode[tt+k],1+((y+nn-1)%nn));
@z
@x
  if (k==0 && (x<xmin || x>xmax || y<ymin || y>ymax || p[x][y]==0))
    clause[clauseptr++]=(bar? 0: sign)+taut;
  else clause[clauseptr++]=(bar? sign:0)+(k<<25)+(x<<12)+y;
@y
  clause[clauseptr++]=(bar? sign:0)+(k<<25)+(x<<12)+y;
@z
@x
  if (have_d[x][y]!=tt+1) {
@y
  if (have_d[x%mm][y%nn]!=tt+1) {
@z
@x
    if (yy>=ymin && yy<=ymax)
@y
@z
@x
    have_d[x][y]=tt+1;
@y
    have_d[x%mm][y%nn]=tt+1;
@z
@x
  if (have_e[x][y]!=tt+1) {
@y
  if (have_e[x%mm][y%nn]!=tt+1) {
@z
@x
    if (yy>=ymin && yy<=ymax)
@y
@z
@x
    have_e[x][y]=tt+1;
@y
    have_e[x%mm][y%nn]=tt+1;
@z
@x
  if (have_f[x][y]!=tt+1) {
@y
  if (have_f[x%mm][y%nn]!=tt+1) {
@z
@x
    if (xx>=xmin && xx<=xmax)
@y
@z
@x
    have_f[x][y]=tt+1;
@y
    have_f[x%mm][y%nn]=tt+1;
@z
@x
  if (have_b[x][y]!=tt+1) {
@y
  if (have_b[x%mm][y%nn]!=tt+1) {
@z
@x
    have_b[x][y]=tt+1;
@y
    have_b[x%mm][y%nn]=tt+1;
@z
@x
  if (x1-1<xmin || x1-1>xmax || y1+1<ymin || y1>ymax)
@y
  if (0)
@z
