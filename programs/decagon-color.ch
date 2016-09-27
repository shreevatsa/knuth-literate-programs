changes to decagon.w for various shapes from colored pieces
(this variation isn't terribly elegant either: I couldn't see a good
way to keep all the color info in the polygon scheme, so I use ``excluded
colors'' only as a heuristic and then do brute force to be sure)
@x
@d big 25 /* this many big triangles must be placed */
@d small 5 /* and this many small ones */
@d total_req (big+small)
@y
@d total_req 16
@d types 4 /* this many different kinds of triangles are used */
@d colors 4 /* this many of each type */
@d typea(x,y) {2,x+y,x,1,x+y,x,2,x,y},
              {1,x+y,x,2,x,y,2,x+y,x},
              {2,x,y,2,x+y,x,1,x+y,x}
@d typeb(x,y) {1,x,y,3,x,y,1,x+y,x},
              {3,x,y,1,x+y,x,1,x,y},
              {1,x+y,x,1,x,y,3,x,y}
@z
@x
  int count=0, interval=1, eps_interval=1, big_need=big, small_need=small;
@y
  int count=0, interval=1, eps_interval=1, conflicts;
@z
@x
  int dir; /* direction to the next vertex (used only in angle nodes */
@y
  int dir; /* direction to the next vertex (used only in angle nodes */
  int exc; /* colors that must be excluded */
@z
@x
int triang[6][9]={
 {2,1,1,1,1,1,2,1,0},
 {1,1,1,2,1,0,2,1,1},
 {2,1,0,2,1,1,1,1,1},@|
 {1,0,1,3,0,1,1,1,0},
 {3,0,1,1,1,0,1,0,1},
 {1,1,0,1,0,1,3,0,1}};
@y
int need[types*colors];
int triang[3*types*colors][9]={
 typea(1,1),typeb(1,1),typea(1,0),typeb(1,0)};
int tmap[3*types*colors];
int cmap[3*types*colors];
int cnxt[3*types*colors];
@z
@x
int top; /* index to the topmost one */
@y
int top; /* index to the topmost one */
int init_dat[5][3]={{3,2,2},{3,2,2},{3,2,2},{3,2,2},{3,2,2}};
@z
@x
@d init_pts 10
@y
@d init_pts 5
@z
@x
for (j=0;j<init_pts;j++) {
  q=get_avail();
  p->s=4; p->t=vert++; p->dir=j; p->next=q; q->prev=p;
  p=(j<init_pts-1? get_avail(): poly[0]);
  q->s=1; q->t=1; q->next=p; p->prev=q;
@y
for (k=0;k<types;k++) for (j=0;j<colors;j++) {
  tmap[3*k+3*types*j]=tmap[3*k+1+3*types*j]=tmap[3*k+2+3*types*j]=k+types*j;
  cmap[3*k+3*types*j]=cmap[3*k+1+3*types*j]=cmap[3*k+2+3*types*j]=j;
  cnxt[3*k+3*types*j]=cnxt[3*k+1+3*types*j]=cnxt[3*k+2+3*types*j]=3*types*(j+1);
}
for (k=0;k<types*colors;k++) need[k]=1;
for (k=0,j=3*types;j<3*types*colors;k++,j++)
  for (i=0;i<9;i++) triang[j][i]=triang[k][i];
for (j=0,k=init_dat[0][0]+5;j<init_pts;j++) {
  q=get_avail();
  p->s=init_dat[j][0]; p->t=vert++;
  k+=15-init_dat[j][0]; p->dir=k%10;
  p->next=q; q->prev=p;
  p=(j<init_pts-1? get_avail(): poly[0]);
  q->s=init_dat[j][1]; q->t=init_dat[j][2];
  q->next=p; p->prev=q;
@z
@x
unsigned int x[init_pts+2*total_req]; /* the coordinates */
@y
unsigned int x[init_pts+2*total_req]; /* the coordinates */
float xxx[init_pts+2*total_req],yyy[init_pts+2*total_req]; /* Cartesian form */
@z
@x
for (j=0; j<6; j++) {
  thresh1[j]=13*triang[j][1]+8*triang[j][2];
  thresh3[j]=13*triang[j][7]+8*triang[j][8];
}

@ @<Glob...@>=
int thresh1[6]; /* encoded version of the first length */
int thresh3[6]; /* encoded version of the third length */
@y
for (j=0;j<init_pts;j++) { register unsigned b;
  for (k=0,b=x[j],xxx[j]=yyy[j]=0.0;k<4;k++,b>>=8) {
    xxx[j]+=((int)(b&0xff)-128)*cos[k];
    yyy[j]+=((int)(b&0xff)-128)*sin[k];
  }
}
for (j=0; j<3*types*colors; j++) {
  thresh1[j]=13*triang[j][1]+8*triang[j][2];
  thresh3[j]=13*triang[j][7]+8*triang[j][8];
}

@ @<Glob...@>=
int thresh1[3*types*colors]; /* encoded version of the first length */
int thresh3[3*types*colors]; /* encoded version of the third length */
@z
@x
lb[l]=(big_need==0? 3: 0);
ub[l]=(small_need==0? 3: 6);
@<Find corner to branch on@>;
way[l]=lb[l];
tryit: j=way[l];
p=choice[l];
@y
@<Find corner to branch on@>;
for (k=0;k<types*colors;k++) if (need[k] && cmap[3*k]<=l
  && ((pp->exc&(1<<cmap[3*k]))==0)) {
  lb[l]=3*k; break;
}
for (k=types*colors;k>0;k--) if (need[k-1] && cmap[3*(k-1)]<=l
  && ((pp->exc&(1<<cmap[3*(k-1)]))==0)) {
  ub[l]=3*k; break;
}
way[l]=lb[l];
tryit: temp2(); j=way[l];
if (need[tmap[j]]==0) {
  way[l]+=3;
  if (way[l]<ub[l]) goto tryit;
  goto backup;
}
p=choice[l];
if ((p->exc &(1<<cmap[j]))!=0) {
  way[l]=cnxt[j];
  if (way[l]<ub[l]) goto tryit;
  goto backup;
}
@z
@x
@<Install triangle |j| at position |choice[l]|@>;
@y
@<Install triangle |j| at position |choice[l]|@>;
if (conflicts) {
confl: @<Undo the changes...@>;
  goto nogood;
}
for (i=init_pts+l+l;i<init_pts+2+l+l;i++) { register unsigned b;
  for (k=0,b=x[i],xxx[i]=yyy[i]=0.0;k<4;k++,b>>=8) {
    xxx[i]+=((int)(b&0xff)-128)*cos[k];
    yyy[i]+=((int)(b&0xff)-128)*sin[k];
  }
}
for (k=0;k<l;k++) if (cmap[way[k]]==cmap[j]) {
if (l==10 && choice[l]->t==5 && k==5) temp1();
  if (conv(choice[l]->t,choice[k]->t,init_pts+k+k)) goto confl;
  if (conv(choice[l]->t,init_pts+k+k,init_pts+1+k+k)) goto confl;
  if (conv(choice[l]->t,init_pts+1+k+k,choice[k]->t)) goto confl;
  if (conv(init_pts+l+l,choice[k]->t,init_pts+k+k)) goto confl;
  if (conv(init_pts+l+l,init_pts+k+k,init_pts+1+k+k)) goto confl;
  if (conv(init_pts+l+l,init_pts+1+k+k,choice[k]->t)) goto confl;
  if (conv(init_pts+1+l+l,choice[k]->t,init_pts+k+k)) goto confl;
  if (conv(init_pts+1+l+l,init_pts+k+k,init_pts+1+k+k)) goto confl;
  if (conv(init_pts+1+l+l,init_pts+1+k+k,choice[k]->t)) goto confl;
  if (conv(choice[k]->t,choice[l]->t,init_pts+l+l)) goto confl;
  if (conv(choice[k]->t,init_pts+l+l,init_pts+1+l+l)) goto confl;
  if (conv(choice[k]->t,init_pts+1+l+l,choice[l]->t)) goto confl;
  if (conv(init_pts+k+k,choice[l]->t,init_pts+l+l)) goto confl;
  if (conv(init_pts+k+k,init_pts+l+l,init_pts+1+l+l)) goto confl;
  if (conv(init_pts+k+k,init_pts+1+l+l,choice[l]->t)) goto confl;
  if (conv(init_pts+1+k+k,choice[l]->t,init_pts+l+l)) goto confl;
  if (conv(init_pts+1+k+k,init_pts+l+l,init_pts+1+l+l)) goto confl;
  if (conv(init_pts+1+k+k,init_pts+1+l+l,choice[l]->t)) goto confl;
}
@z
@x
if (way[l]<3) big_need--;@+ else small_need--;
@y
need[tmap[way[l]]]--;
@z
@x
if (way[l]<3) big_need++;@+ else small_need++;
@y
need[tmap[way[l]]]++;
@z
@x
    for (j=lb[l],k=0;j<ub[l];j++)
      if (p->s>=triang[j][0] &&
       (r->s>5 || (13*(q->s)+8*(q->t))>=thresh3[j]) &&
       (p->s>triang[j][0] || rr->s>5
          || 13*p->prev->s+8*p->prev->t>=thresh1[j])) k++;
    if (k<i) i=k,pp=p;
@y
    for (j=0,k=0;j<3*types*colors;j++) {
      while ((p->exc&(1<<cmap[j]))) {
        j=cnxt[j]; /* bypass excluded colors */
        if (j==3*types*colors) goto dun;
      }
      while (need[tmap[j]]==0) {
        j+=3;
        if (j==3*types*colors) goto dun;
      }
      if (cmap[j]>l) goto dun;
      if (p->s>=triang[j][0] &&
       (r->s>5 || (13*(q->s)+8*(q->t))>=thresh3[j]) &&
       (p->s>triang[j][0] || rr->s>5
          || 13*p->prev->s+8*p->prev->t>=thresh1[j])) k++;
    }
  dun: if (k<i) i=k,pp=p;
@z
@x
  pp->s=p->s; pp->t=p->t; pp->dir=p->dir;
  qq=get_avail(); pp->next=qq; qq->prev=pp; p=p->next;
  qq->s=p->s; qq->t=p->t;
@y
  pp->s=p->s; pp->t=p->t; pp->dir=p->dir; pp->exc=p->exc;
  qq=get_avail(); pp->next=qq; qq->prev=pp; p=p->next;
  qq->s=p->s; qq->t=p->t; qq->exc=p->exc;
@z
@x
r=get_avail(); r->s=triang[j][4]; r->t=triang[j][5];
@y
r=get_avail(); r->s=triang[j][4]; r->t=triang[j][5];
pp->exc=qq->exc=r->exc=1<<cmap[j]; rr->exc |= 1<<cmap[j];
conflicts=0;
@z
@x
   p->s -= 5; /* we know this is $>0$ */
@y
   cmerge(p);
   p->s -= 5; /* we know this is $>0$ */
@z
@x
@<Connect |pp| directly to existing vertex |p==qq|@>=
{
  r->next=p; p->prev=r;
@y
@d merge(p,q) {if (p->exc&q->exc) conflicts=1; p->exc |= q->exc;}
@d cmerge(p) {if (p->exc&(1<<cmap[j])) conflicts=1; p->exc |= 1<<cmap[j];}

@<Connect |pp| directly to existing vertex |p==qq|@>=
{
  r->next=p; p->prev=r;
  merge(p,qq);
@z
@x
@<Split off a polygon at position |qq==p|@>=
@y
@<Split off a polygon at position |qq==p|@>=
merge(p,qq); qq->exc=p->exc;
@z
@x
  if (k==thresh1[j]) {
@y
  if (k==thresh1[j]) {
    merge(p,pp);
@z
@x
    p->s -=5; /* we know this is $>0$ */
@y
    cmerge(p);
    p->s -=5; /* we know this is $>0$ */
@z
@x
@ @<Split off a polygon at position |pp==p|@>=
@y
@ @<Split off a polygon at position |pp==p|@>=
merge(p,pp); pp->exc=p->exc;
@z
@x
      if (verbose) printf(" %d(%d)",p->t,p->s);
@y
      if (verbose) printf(" %d(%d)%d",p->t,p->s,p->exc);
@z
@x
fprintf(eps_file,"/t { moveto lineto lineto closepath stroke } bind def\n");
@y
fprintf(eps_file,"/t { 0 setgray moveto lineto lineto closepath stroke } bind def\n");
fprintf(eps_file,
 "/f { %d div setgray moveto lineto lineto closepath fill } bind def\n",
 colors-1);
@z
@x
  fprintf(eps_file," t\n");
@y
  fprintf(eps_file," %d f\n",cmap[way[j]]);
  print_coord(choice[j]->t);
  print_coord(init_pts+j+j);
  print_coord(init_pts+1+j+j);
  fprintf(eps_file," t\n");
@z
@x
@* Index.
@y
@ In this subroutine I use the fact that the line from |x[j]| to |x[k]| is
never vertical in this application.

@<Sub...@>=
int conv(i,j,k)
  int i,j,k;  /* is |x[i]| a convex combination of |x[j]| and |x[k]|? */
{
  register float t=(xxx[i]-xxx[j])/(xxx[k]-xxx[j]);
  if (t<-0.001 || t>1.001) return 0;
  t=yyy[i]-yyy[j]-t*(yyy[k]-yyy[j]);
  if (t<-0.001 || t>0.001) return 0;
  return 1;
}

@* Index.
@z
