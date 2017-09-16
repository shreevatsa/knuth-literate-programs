@x in search for best_col
    if (t<=score) {
      if (t<score || s<best_s || (s==best_s && nd[k].len>best_l))
        score=t,best_col=k,best_s=s,best_l=nd[k].len,p=1;
      else if (s==best_s && nd[k].len==best_l) {
@y
    if (score==infty || t<=1 || (t<=score && cl[k].name[0]=='#')) {
      if (t<score || s<best_s || (s==best_s && nd[k].len>best_l))
        score=t,best_col=k,best_s=s,best_l=nd[k].len,p=1;
      else if (score && s==best_s && nd[k].len==best_l) {
@z
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
    register cc,d,l=0,s,t,x,y,xy;
    for (k=0;k<level;k++) {
      for (r=choice[k]+1;;) {
        cc=nd[r].col;
        if (cc<=0) {
          r=nd[r].up;@+continue;
        }
        if (cl[cc].name[0]=='#') goto nextr;
        if (cl[cc].name[2]) goto nextr;
        x=cl[cc].name[0],y=cl[cc].name[1];
        if (x>='0' && x<='9') x=x-'0';
        else if (x>='a' && x<='z') x=x-'a'+10;
        else if (x>='A' && x<='Z') x=x-'A'+36;
        else panic("Bad x coordinate");
        if (y>='0' && y<='9') y=y-'0';
        else if (y>='a' && y<='z') y=y-'a'+10;
        else if (y>='A' && y<='Z') y=y-'A'+36;
        else panic("Bad y coordinate");
        if (x>xmax) xmax=x;
        if (y>ymax) ymax=y;
        d=nd[cc].color;
        if (!box[x+1][y+1] && d!='.')
          box[x+1][y+1]=d,l++,xy=(x<<8)+y;
nextr:@+  if (r==choice[k]) break;
        r++;
      }
    }
    @<If the solution is disconnected, |goto cleanup|@>;
    for (x=0;x<=xmax;x++) {
      if (x) printf("|");
      for (y=0;y<=ymax;y++)
        printf(""O"c",box[x+1][y+1]? box[x+1][y+1]-0x80:'.');
    }
    printf(" #"O"lld\n",count);
    fflush(stdout);
cleanup:@+for (x=0;x<=xmax;x++) 
    for (y=0;y<=ymax;y++)
       box[x+1][y+1]=0;
  }
@z
@x
@*Index.
@y
@ Ye olde depth-first search.

@d mark(xx,yy) {@+if (box[(xx)+1][(yy)+1] && box[(xx)+1][(yy)+1]<0x80)
      l--,stack[s++]=((xx)<<8)+(yy),box[(xx)+1][(yy)+1]+=0x80;@+}

@<If the solution is disconnected, |goto cleanup|@>=
s=0;
mark(xy>>8,xy&0xff);
@<Clear the stack@>;
if (l) goto cleanup;

@ @<Clear the stack@>=
while (s) {
  s--,x=stack[s]>>8,y=stack[s]&0xff;
  mark(x-1,y);
  mark(x+1,y);
  mark(x,y-1);
  mark(x,y+1);
}

@ @<Glob...@>=
unsigned char box[64][64]; /* allow space for margins in both coordinates */
int xmax,ymax;
int stack[62*62];

@*Index.
@z
