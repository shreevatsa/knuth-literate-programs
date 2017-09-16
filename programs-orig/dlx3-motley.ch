@x
  if (spacing && (count mod spacing==0)) {
    printf(""O"lld:\n",count);
    for (k=0;k<level;k++) {
      pp=choice[k];
      cc=pp<last_col? pp: nd[pp].col;
      if (!first_tweak[k]) print_row(pp,stdout,nd[cc].down,scor[k]);
      else print_row(pp,stdout,first_tweak[k],scor[k]);
    }
    if (p) @<Print the free rows@>;
    fflush(stdout);
  }
@y
  if (spacing && (count mod spacing==0)) {
    register c,h,i,j,m=0,n=0,p,q,t,xa,xb,yc,yd,sum=0;
    printf(""O"lld:",count);
    for (k=0;k<level;k++) {
      p=choice[k];
      c=p<last_col? p: nd[p].col;
      h=first_tweak[k]? first_tweak[k]: nd[c].down;
      if (p==nd[h].col) continue; /* null choice */
      for (q=p;;q++) {
        c=nd[q].col;
        if (c<=0) {
          q=nd[q].up-1;
          continue;
        }
        if (cl[c].name[0]=='x' && cl[c].name[2]) {
          xa=decode(cl[c].name[1]);
          xb=decode(cl[c].name[2]);
          q++;
          c=nd[q].col;
          if (cl[c].name[0]!='y') confusion("xab not followed by ycd");
          yc=decode(cl[c].name[1]);
          yd=decode(cl[c].name[2]);
          for (i=xa;i<xb;i++) for (j=yc;j<yd;j++)
            board[i][j]=(sum<10? sum+'0': sum-10+'a');
          sum++;
          break;
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
    if (m==n) {
      @<Check for transposition symmetries@>;
      @<Check for 90-degree rotation symmetry@>;
    }
    @<Check for 180-degree rotation symmetry@>;
    printf("\n");
    fflush(stdout);
  }
@z
@x
@*Index.
@y
@ @<Glob...@>=
char board[64][64];

@ @<Check for transposition symmetries@>=
for (i=0;i<n;i++) for (j=1;j<n;j++)
  if ((board[i][j]==board[i][j-1])!=(board[j][i]==board[j-1][i]))
     goto no_T;
printf("\\"); /* symmetric about main diagonal */
no_T:
for (i=0;i<n;i++) for (j=1;j<n;j++)
  if ((board[i][j]==board[i][j-1])!=(board[n-1-j][n-1-i]==board[n-j][n-1-i]))
     goto no_U;
printf("/"); /* symmetric about other diagonal */
no_U:;

@ @<Check for 90-degree rotation symmetry@>=
for (i=0;i<n;i++) for (j=1;j<n;j++)
  if ((board[i][j]==board[i][j-1])!=(board[j][n-1-i]==board[j-1][n-1-i]))
     goto no_Q;
printf("!"); /* symmetric under a quarter turn */
no_Q:;

@ @<Check for 180-degree rotation symmetry@>=
for (i=0;i<m;i++) for (j=1;j<n;j++)
  if ((board[i][j]==board[i][j-1])!=(board[m-1-i][n-1-j]==board[m-1-i][n-j]))
    goto no_S;
for (i=1;i<m;i++) for (j=0;j<n;j++)
  if ((board[i][j]==board[i-1][j])!=(board[m-1-i][n-1-j]==board[m-i][n-1-j]))
    goto no_S;
printf("#"); /* symmetric under 180-degree rotation */
no_S:;

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
