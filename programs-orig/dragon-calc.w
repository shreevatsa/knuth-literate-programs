\datethis
\font\logo=logo10

@*Intro. This is an interactive program to do calculations
associated with Dekking's generalized dragon curves and the associated
calculus of tiles, as described in my notes on ``diamonds and dragons.''

When prompted, the user can do the following things:

\def\thing#1#2\par{\smallskip\item{$\bullet$}#1\hfil\break#2\par}
\def\<#1>{\hbox{$\langle\,$#1$\,\rangle$}}

\thing{\.p\<path>}
  Set the current zigzag path to the sequence
  of directions specifed by \<path>. (Directions are the digits
  \.0, \.1, \.2, \.3, meaning ``right,'' ``up,'' ``left,'' and ``down,''
  respectively; they must begin with \.0 and alternate in parity.)
  The computer responds with the value of $z$, which is the point reached
  at the end of the path in the complex plane that starts at 0 and
  moves by $i^k$ when taking direction~$k$. For example, \.{p01012}
  yields $z=1+2i$. At the beginning of computation the current path
  is simply \.0, and $z=1$.

\thing{\<folding sequence>}
  Set the current zigzag path to the specified
  \<folding sequence>, which is a sequence of \.D's and \.U's.
  A folding sequence of length $s-1$ corresponds to the path of
  length~$s$ that starts in direction~0 and then changes the
  direction by $+1$ (mod~4) for each \.D and $-1$ (mod~4) for each \.U.
  For example, the command \.{DUDD} is equivalent to the
  command \.{p01012}. (I~apologize for the historical baggage of this
  notation, according to which the {\it down\/}-fold \.D corresponds
  to making the actual direction go {\it up}.)

\thing{\.*\<path> or \.*\<folding sequence>}
  Multiply the current path by the specified path or folding sequence,
  using Dekking's folding product. For example, if the current path
  is \.{01012}, the command \.{*03} or \.{*U} will change it to
  \.{0101210303} and set $z\gets3+i$.

\thing{\<tile>\.*\<tile>}
  Compute the folding product of two tiles with respect to the
  current value of~$z$. Here \<tile> is a list of two integers
  separated by a comma. For example, \.{3,2*-2,3} will yield
  the result \.{-8,1} when $z=1+2i$, because $(3+2i)*(-2+3i)=
  i(3+2i)+z(-2+2i)=-8+i$.

\thing{\.{a*}\<tile>}
  Compute the folding product $v*w$ of all tiles $v$ in the polyomino of the
  current path with the specified tile~$w$. In particular, if the specified
  tile is the unit tile \.{1,0},
  the effect is simply to list all of the current polyomino tiles~$v$.

\thing{\.c\<tile> or \.c}
  Show the congruence class and type of the specified tile.
  Or, if no tile is specified, show the congruence classes and types
  of all tiles in the current polynomino.  

\thing{\.f\<tile> or \.F\<tile>}
  ``Factor'' the given tile $u$ to obtain $v$ and $w$ such that $u=v*w$
  with respect to the current path, where $v$ is a tile in the current
  polyomino. With \.F instead of \.f, proceed to factor $w$ in the same
  way, until cycling. These commands are allowed only when the current path is
  plane-filling.

\thing{\.m}
  Output {\logo METAPOST} commands to draw the current path.

\thing{\.v\<integer>}
  Specify the level of verbosity,
  where \.{v0} gives the minimum amount of output
  and \.{v-1} gives the maximum.

\thing{\.q}
  Quit the program.

\thing{\.{\char`\%}\<comment>}
  Do nothing, but politely think about whatever comment has been given.

\thing{\.i\<filename>}
  Take commands from the specified file, then come back for more
  (unless the file included a ``quit'' command). The file may
  contain any command except another \.i command, because I don't
  want to bother maintaining a stack of included files.

\smallskip\noindent
Please realize that I had to write this program in an awful hurry,
because of many other commitments.

@ Here we go.

@d maxm (1<<15) /* length of longest path allowed */
@d maxd (1<<8) /* anything $\ge\sqrt{2|maxm|}$ is safe here */
@d maxp 100 /* how much memory is allowed for cycle detection? */
@d bufsize 1024 /* maximum length of commands */
@d verbose_echo (1<<0) /* should commands of included files be echoed? */
@d verbose_folds (1<<1) /* should folds be printed when directions given? */
@d verbose_dirs (1<<2) /* should directions be printed when folds given? */
@d metapost_name "/tmp/dragon-calc.mp" /* file name for {\logo METAPOST} output */

@c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int vbose;
FILE *infile,*outfile;
char buf[bufsize];
char dir[maxm],fold[maxm]; /* directions and folds of current path */
int s; /* length of current path */
typedef struct pair_struct {
   long x,y;
} pair;
pair e,u,v,w,z,uu,vv;
pair ipower[4]={{1,0},{0,1},{-1,0},{0,-1}};
pair sqrt8i={2,2};
pair poly[maxm]; /* polyomino of current path (i.e., its tiles) */
int congclass[maxd][4*maxm]; /* congruence class table */
int fill[maxm]; /* mapping from classes to tiles of a plane-filling path */
pair cyc[maxp]; /* elements to check for cycling in \.F commands */
int cycptr; /* number of relevant elements in |cyc| */
int count; /* this many paths have been output */
@<Subroutines@>;
@#
main() {
  register int c,d,j,k,neg;
  register char *p,*q;
  long qq;
  int including=0;
  @<Reset the current path to the unit path@>;
  while (1) {
    if (including) @<Read a new command from |infile|@>@;
    else @<Prompt the user for a new command@>;
    @<Do the command in |buf|@>;
    while (*p==' ') p++;
    if (*p!='\n')
      printf("Junk at end of command has been ignored: %s",p);
  }
done: @<Make sure that |outfile| is closed@>
}

@ @<Reset the current path to the unit path@>=
s=1, z.x=1, z.y=0;
@<Clear the current auxiliary tables@>;

@ We compute the |poly| table only when it's needed. After it has
been computed, |poly[0]| will be |{1,0}|. Similarly, we compute
the |congclass| and |fill| tables only when necessary.

@<Clear the current...@>=
poly[0].x=0, congclass[0][0]=-1; fill[0]=-1;

@ @<Prompt the user for a new command@>=
{
  printf("> ");@+fflush(stdout);
  fgets(buf,bufsize,stdin);
}

@ @<Read a new command from |infile|@>=
{
  if (!fgets(buf,bufsize,infile)) {
    including=0;
    continue;
  }
}

@ @<Do the command in |buf|@>=
for (p=buf;*p==' ';p++);
if (*p=='\n') {
  if (!including) printf("Please type a command, or say q to quit.\n");
  continue;
}
if (including && (vbose&verbose_echo)) printf("%s",buf);
switch (*p) {
case 'q': goto done;
case 'i': if (!including) {
    for (p=buf+1;*p==' ';p++);
    for (q=p+1;*q!='\n';q++);
    *q='\0';
    if (infile=fopen(p,"r")) including=1;
    else printf("Sorry --- I couldn't open file `%s' for reading!\n",p);
  }@+else printf("Sorry; you can't include one file in another.\n");
case '%': continue;
case 'v': p++;
    @<Scan an integer to |k|@>;
    vbose=k;@+break;
@#
@<Cases for nontrivial commands@>;
}

@ @<Scan an integer to |k|@>=
{
  while (*p==' ') p++;
  if (*p=='-') neg=1,p++;
  else neg=0;
  for (k=0;*p>='0'&&*p<='9';p++) k=10*k+*p-'0';
  if (neg) k=-k;
}

@ @<Cases...@>=
case 'p':@+for (s=0,z.x=z.y=0,p++;*p>='0'&&*p<='3';s++,p++) {
    if (s==0 && *p!='0') {
      printf("A path must start in direction 0!\n");
      goto bad_path;
    }@+else if ((*p^s)&0x1) {
      printf("Direction %c in this path has bad parity!\n",*p);
  bad_path: @<Reset the current path...@>;
      @+break;
    }
    @<Set |dir[s]| and update |z|@>;
  }
  if (s>maxm) {
  too_long:
    printf("Sorry, I can't deal with paths longer than %d; recompile me!\n",
          maxm);
    goto bad_path;
  }
  @<Convert the directions to folds@>;
finish_dirs: @<Print the current folds@>;
  print_path_params:
  printf(" s=%d, z=",s);
  @<Print the complex number |z|@>;
  printf("\n");
  @<Clear the current...@>;
  break;

@ @<Print the current folds@>=
if (vbose&verbose_folds) printf(" %s,",fold);

@ @<Set |dir[s]| and update |z|@>=
if (s<maxm) dir[s]=*p-'0';
  switch (*p) {
case '0': z.x++;@+break;
case '1': z.y++;@+break;
case '2': z.x--;@+break;
case '3': z.y--;@+break;
  }

@ @<Print the complex number |z|@>=
if (z.x) printf("%ld",z.x);
else if (!z.y) printf("0");
if (z.y) {
  if (z.y==1) printf("+i");
  else if (z.y>0) printf("+%ldi",z.y);
  else if (z.y==-1) printf("-i");
  else printf("-%ldi",-z.y);
}

@ @<Convert the directions to folds@>=
for (j=k=0;j<s-1;j++)
  fold[j]=((dir[j+1]-dir[j])&0x2? 'U': 'D');
fold[j]='\0';
  
@ @<Cases...@>=
case 'D': case 'U':@+for (s=0;*p=='D'||*p=='U';s++,p++) if (s<maxm) fold[s]=*p;
  if (++s>maxm) goto too_long;
finish_folds: @<Convert the folds to directions@>;  
  @<Print the current directions@>;
  goto print_path_params;

@ @<Print the current directions@>=
if (vbose&verbose_dirs) {
  printf(" ");
  for (k=0;k<s;k++) printf("%d",dir[k]);
}

@ @<Convert the folds to directions@>=
for (j=k=0,z.x=z.y=0;k<s;k++) {
  dir[k]=j;
  switch (j) {
case 0: z.x++;@+break;
case 1: z.y++;@+break;
case 2: z.x--;@+break;
case 3: z.y--;@+break;
  }
  j=(j+(fold[k]=='D'? 1: -1))&0x3;
}

@ @<Cases...@>=
case '*': p++;
  if (*p=='D' || *p=='U') @<Multiply by a folding sequence@>@;
  else if (*p=='0') @<Multiply by a direction sequence@>@;
  else {
    printf("Improper multiplication!\n");
    break;
  }

@ @<Multiply by a folding sequence@>=
{
  for (k=j=s-1;*p=='D'||*p=='U';p++) {
    if (k+s>=maxm) goto too_long;
    fold[k++]=*p;
    if (j) for (;j;j--) fold[k++]='U'+'D'-fold[j-1];
    else for (;j<s-1;j++) fold[k++]=fold[j];
  }
  fold[k]='\0', s=k+1;
  @<Print the current folds@>;
  goto finish_folds;
}

@ @<Multiply by a direction sequence@>=
{
  for (k=j=s-1,p++;*p>='0'&&*p<='3'&&((*p^*(p-1))&0x1);p++) {
    if (k+s>=maxm) goto too_long;
    fold[k++]=(*p-*(p-1))&0x2? 'U': 'D';
    if (j) for (;j;j--) fold[k++]='U'+'D'-fold[j-1];
    else for (;j<s-1;j++) fold[k++]=fold[j];
  }
  fold[k]='\0', s=k+1;
  @<Convert the folds to directions@>;  
  @<Print the current directions@>;
  goto finish_dirs;
}

@ @d must_see(c) while (*p==' ') p++;@+if (*p++!=c) goto bad_command
@d check_tile(v) if (((v.x+v.y)&0x1)==0) {
                   printf("Bad tile (%ld,%ld)!\n",v.x,v.y);@+break;@+}

@<Cases...@>=
default: @<Scan an integer to |k|@>;
  v.x=k;
  while (*p==' ') p++;
  if (*p++!=',') {
bad_command: p--;
  if (including && !(vbose&verbose_echo))
     printf("Sorry, I don't understand the command %s",buf);
  else printf("Sorry, I don't understand that command!\n");
  break;
  }
  @<Scan an integer to |k|@>;
  v.y=k;
  check_tile(v);
  must_see('*');
  @<Scan an integer to |k|@>;
  w.x=k;
  must_see(',');
  @<Scan an integer to |k|@>;
  w.y=k;
  check_tile(w);
  @<Compute $u=v*w$@>;
  printf(" %ld,%ld\n",u.x,u.y);
  break;

@ @<Compute $u=v*w$@>=
@<Set |d| to the type of |w| and |e| to the triply even neighbor@>;
u=sum(prod(ipower[(-d)&0x3],v),prod(z,e));

@ @d typ(w) (((w.x&0x1)+((w.x+w.y)&0x2)+3)&0x3) /* yes it works! */

@<Set |d| to the type of |w|...@>=
d=typ(w);
e=sum(w,ipower[(2-d)&0x3]);

@ Complex addition, subtraction, and multiplication are easy.

@<Sub...@>=
pair sum(pair a,pair b) {
  pair res;
  res.x=a.x+b.x;
  res.y=a.y+b.y;
  return res;
}
@#
pair diff(pair a,pair b) {
  pair res;
  res.x=a.x-b.x;
  res.y=a.y-b.y;
  return res;
}
@#
pair prod(pair a,pair b) {
  pair res;
  res.x=a.x*b.x-a.y*b.y;
  res.y=a.x*b.y+a.y*b.x;
  return res;
}

@ We also need complex division, but only when it is known to be exact.

@d norm(z) (z.x*z.x+z.y*z.y)

@<Sub...@>=
pair quot(pair a,pair b) {
  pair res;
  long n=norm(b);
  res.x=(a.x*b.x+a.y*b.y)/n;
  res.y=(-a.x*b.y+a.y*b.x)/n;
  return res;
}  

@ @<Cases...@>=
case 'a': @<Make sure |poly| is uptodate@>;
  p++;
  must_see('*');
  @<Scan an integer to |k|@>;
  w.x=k;
  must_see(',');
  @<Scan an integer to |k|@>;
  w.y=k;
  check_tile(w);
  for (k=0;k<s;k++) {
    v=poly[k];
    @<Compute $u=v*w$@>;
    printf(" %ld,%ld",u.x,u.y);
  }
  printf("\n");
  break;

@ @<Make sure |poly| is uptodate@>=
if (!poly[0].x) {
  for (k=0,u.x=u.y=0;k<s;k++) {
    v=u;
    switch (dir[k]) {
  case 0: u.x++;@+break;
  case 1: u.y++;@+break;
  case 2: u.x--;@+break;
  case 3: u.y--;@+break;
    }
    poly[k]=sum(u,v);
  }
}

@*Congruence classes. Finally we get to the most interesting part of the
program, which determines whether tiles are congruent.

Let $Z=(2+2i)z=A+Bi$, and let $D=\gcd(A,B)$. The first task, when we
want to find the congruence class of a given tile $w$, is to
reduce $w$ modulo $Z$. To do this, we set up the |congclass| table as follows:
We essentially find $p$ and $q$ such that
$pA+qB=D$. Then we let $U=(A-Bi)Z/D=(A^2+B^2)/D$ and
$V=(pi+q)Z=(qA-pB)+Di$. By subtracting an appropriate multiple of~$V$
from $w$, we reduce its imaginary part, mod~$D$. Then we can reduce the
real part, mod~$u$. If the result is $w'=x+yi$, the class of~$w$
is stored in |congclass[y>>1][x]|. It's OK to shift |y| right in this
formula (saving a factor of 2 in space) because $x+y$ is always odd.

@d classof(w) congclass[w.y>>1][w.x]

@<Make sure |congclass| is uptodate@>=
if (congclass[0][0]<0) {
  @<Compute |U| and |V|@>;
  for (j=0;j<vv.y>>1;j++) for (k=0;k<uu.x;k++) congclass[j][k]=-1;
  for (c=j=0;j<vv.y>>1;j++) for (k=0;k<uu.x;k++) if (congclass[j][k]<0) {
    congclass[j][k]=c;
    v.x=k, v.y=2*j+1-(k&0x1);
    for (d=1;d<4;d++) {
      w=prod(v,ipower[d]);
      @<Reduce |w| mod $Z$@>;
      classof(w)=c;
    }
    c++;
  }
}

@ We essentially do Euclid's algorithm on the imaginary parts here.
The roles of $D$ and $(A^2+B^2)/D$ in the formulas above are played by
|vv.y| and |uu.x|, respectively.

@<Compute |U| and |V|@>=
uu=prod(z,sqrt8i), vv.x=-uu.y, vv.y=uu.x;
if (uu.y<0) uu.x=-uu.x, uu.y=-uu.y;
if (vv.y<0) vv.x=-vv.x, vv.y=-vv.y;
while (uu.y) {
  while (vv.y>=uu.y) vv=diff(vv,uu);
  w=vv, vv=uu, uu=w;
}
if (uu.x<0) uu.x=-uu.x;

@ @<Reduce |w| mod $Z$@>=
{
  if (w.y<0) {
    qq=(vv.y-1-w.y)/vv.y;
    w.x+=qq*vv.x, w.y+=qq*vv.y;
  }@+else {
    qq=w.y/vv.y;
    w.x-=qq*vv.x, w.y-=qq*vv.y;
  }
  if (w.x<0) {
    qq=(uu.x-1-w.x)/uu.x;
    w.x+=qq*uu.x;
  }@+else {
    qq=w.x/uu.x;
    w.x-=qq*uu.x;
  }
}

@ @<Cases...@>=
case 'c': @<Make sure |congclass| is uptodate@>;
  p++;
  while (*p==' ') p++;
  if (*p=='\n') @<Show congruence classes for all of |poly|@>@;
  else {
    @<Scan an integer to |k|@>;
    w.x=k;
    must_see(',');
    @<Scan an integer to |k|@>;
    w.y=k;
    @<Show the congruence class and type of |w|@>;
  }
  break;

@ @<Show the congruence class and type of |w|@>=
v=w;
@<Reduce |w| mod $Z$@>;
printf(" %ld,%ld is %d_%d\n",v.x,v.y,classof(w),typ(v));

@ @<Show congruence classes for all of |poly|@>=
{
  @<Make sure |poly| is uptodate@>;
  for (k=0;k<s;k++) {
    w=poly[k];
    @<Show the congruence class and type of |w|@>;
  }
}
   
@ A plane-filling path has the property that $s=\vert z\vert^2$
and all of its tiles are incongruent. In such cases
we set |fill[j]=k| when |poly[k]| has class |j|.

@<Make sure |fill| is uptodate@>=
if (fill[0]<0 && (norm(z)==s)) {
  @<Make sure |poly| is uptodate@>;
  @<Make sure |congclass| is uptodate@>;
  for (j=1;j<s;j++) fill[j]=-1;
  for (k=0;k<s;k++) {
    w=poly[k];
    @<Reduce |w| mod $Z$@>;
    if (fill[classof(w)]>=0) {
      fill[0]=-1; break; /* abort, since it's not plane-filling */
    }
    fill[classof(w)]=k;
  }
}

@ @<Cases...@>=
case 'f': case 'F': q=p++;
  @<Make sure |fill| is uptodate@>;
  if (fill[0]<0) {
    printf("Sorry, the current path isn't plane-filling!\n");
    break;
  }
  @<Scan an integer to |k|@>;
  u.x=k;
  must_see(',');
  @<Scan an integer to |k|@>;
  u.y=k;
  check_tile(u);
  cyc[0]=u, cycptr=1;
  while (1) {
    @<Factor |u|@>;
    if (*q=='f') break;
    @<If we're in a cycle, |break|@>;
    u=w;
  }       
  break;

@ See my diamonds-and-dragons notes for the theory used here.

@<Factor |u|@>=
w=u;
@<Reduce |w| mod $Z$@>;
v=poly[fill[classof(w)]];
k=(typ(u)-typ(v))&0x3;
e=quot(diff(u,prod(v,ipower[(-k)&0x3])),z);
w=sum(e,ipower[(-k)&0x3]);
printf(" %ld,%ld = %ld,%ld * %ld,%ld\n",u.x,u.y,v.x,v.y,w.x,w.y);

@ The element in |cyc[0]| always has the smallest magnitude we've seen so far.
If $\vert w\vert=1$, we're done, because $1*w=w$ in that case.

@<If we're in a cycle, |break|@>=
if (norm(w)==1) break;
if (norm(w)<norm(cyc[0])) cyc[0]=w,cycptr=1;
else {
  for (k=0,cyc[cycptr]=w;w.x!=cyc[k].x || w.y!=cyc[k].y;k++);
  if (k<cycptr) break;
  cycptr++;
}

@*Graphic output. Finally, we have a rudimentary way to visualize
general dragon curves, via {\logo METAPOST}.

@<Cases...@>=
case 'm': @<Make sure that |outfile| is open@>;
  count++,p++;
  fprintf(outfile,"\nbeginfig(%d)\n O",count);
  for (k=0;k<s-1;k++) {
    if (k%32==31) fprintf(outfile,"\n");
    fprintf(outfile," %c",fold[k]);
  }
  fprintf(outfile,";\nendfig;\n");
  break;

@ @<Make sure that |outfile| is open@>=
if (!outfile) {
  outfile=fopen(metapost_name,"w");
  if (!outfile) {
    fprintf(stderr,"Oops, I can't open %s for output! Have to quit...\n",
                   metapost_name);
    exit(-99);
  }
  fprintf(outfile,"%% Output from DRAGON-CALC\n");
  fprintf(outfile,
    "numeric dd; pair rr,ww,zz; rr=(10bp,0); %% adjust rr if desired!\n");
  fprintf(outfile,
    "def D = dd:=dd+90; ww:=zz; zz:=ww+rr rotated dd; draw ww--zz; enddef;\n");
  fprintf(outfile,
    "def U = dd:=dd-90; ww:=zz; zz:=ww+rr rotated dd; draw ww--zz; enddef;\n");
  fprintf(outfile,
    "def O = zz:=origin; dd:=-90; D; enddef;\n");
}

@ @<Make sure that |outfile| is closed@>=
if (outfile) {
  fprintf(outfile,"\nbye.\n");
  fclose(outfile);
  fprintf(stderr,"METAPOST output for %d paths written on %s.\n",
           count,metapost_name);
  outfile=NULL;
}

@*Index.

