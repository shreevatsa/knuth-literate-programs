@x
  if (spacing && (count mod spacing==0)) {
    printf(""O"lld:\n",count);
    for (k=0;k<level;k++) {
      pp=choice[k];
      cc=pp<last_itm? pp: nd[pp].itm;
      if (!first_tweak[k]) print_option(pp,stdout,nd[cc].down,scor[k]);
      else print_option(pp,stdout,first_tweak[k],scor[k]);
    }
    fflush(stdout);
  }
@y
  if (spacing && (count mod spacing==0)) {
    register c,h,i,j,m=0,n=0,p,q,t,xa,xb,yc,yd,sum=0,x,y;
    printf(""O"lld:",count);
    for (k=0;k<level;k++) {
      p=choice[k];
      c=p<last_itm? p: nd[p].itm;
      h=first_tweak[k]? first_tweak[k]: nd[c].down;
      if (p==nd[h].itm) continue; /* null choice */
      c=nd[p].itm;
      if (cl[c].name[2]) {
        if (cl[c].name[0]=='x') p--; /* don't start at \.{x$ab$} */
        else if (cl[c].name[0]=='y') p-=2; /* or at \.{y$cd$} */
      }
      for (q=p+1;q!=p;q++) {
        c=nd[q].itm;
        if (c<=0) {
          q=nd[q].up-1;
          continue;
        }
        if (cl[c].name[0]=='x' && cl[c].name[2]) {
          xa=decode(cl[c].name[1]);
          xb=decode(cl[c].name[2]);
          q++;
          c=nd[q].itm;
          if (cl[c].name[0]!='y') confusion("xab not followed by ycd");
          yc=decode(cl[c].name[1]);
          yd=decode(cl[c].name[2]);
          for (i=xa;i<xb;i++) for (j=yc;j<yd;j++)
            board[i][j]=(sum<10? sum+'0': sum-10+'a');
          sum++;
        }
      }
    }
    for (i=0;board[i][0];i++) {
      if (i) printf("|");
      for (j=0;board[i][j];j++) printf("%c",
                                            board[i][j]);
      n=j;
    }
    m=i;
    printf("(%d)",
                    sum);
    @<Check for symmetries@>;
    printf("\n");
    fflush(stdout);
  }
@z
@x
@*Index.
@y
@ @<Glob...@>=
char board[64][64];

@ There are 8 possible symmetries, either $xy$ or (if $m=n$) $yx$, with
optional bars in each coordinate.

@d xbar t&2? m-1-x: x /* complement |x| if |t| has its 2-bit on */
@d xbr  t&2? m-x: x-1 /* complement |x-1| if |t| has its 2-bit on */
@d ybar t&1? n-1-y: y /* complement |y| if |t| has its 1-bit on */
@d ybr  t&1? n-y: y-1 /* complement |y-1| if |t| has its 1-bit on */

@<Check for symmetries@>=
for (t=1;t<(m==n? 8: 4);t++) {
  for (x=1;x<m;x++) for (y=0;y<n;y++)
    if ((board[x][y]==board[x-1][y]) !=
          (t&4? board[ybar][xbar]==board[ybar][xbr]:
                board[xbar][ybar]==board[xbr][ybar]))
      goto unsym;
  for (x=0;x<m;x++) for (y=1;y<n;y++)
    if ((board[x][y]==board[x][y-1]) !=
          (t&4? board[ybar][xbar]==board[ybr][xbar]:
                board[xbar][ybar]==board[xbar][ybr]))
      goto unsym;
  printf("!%x",
                   t); /* a symmetry is found! */
unsym:continue;
}


@ @<Sub...@>=
void confusion(char *s) {
  fprintf(stderr,"I'm confused: %s!\n",
                                 s);
}

@ @<Sub...@>=
int decode(char c) {
  if (c<='9') {
    if (c>='0') return c-'0';
  }@+else if (c>='a') {
    if (c<='z') return c+10-'a';
  }@+else if (c>='A' && c<='Z') return c+36-'A';
  else confusion("bad code");
}

@*Index.
@z
