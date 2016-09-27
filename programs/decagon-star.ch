changes to decagon.w for star shape
@x
@d big 25 /* this many big triangles must be placed */
@d small 5 /* and this many small ones */
@y
@d big 6 /* this many big triangles must be placed */
@d small 8 /* and this many small ones */
@z
@x
 {2,1,1,1,1,1,2,1,0},
 {1,1,1,2,1,0,2,1,1},
 {2,1,0,2,1,1,1,1,1},@|
 {1,0,1,3,0,1,1,1,0},
 {3,0,1,1,1,0,1,0,1},
 {1,1,0,1,0,1,3,0,1}};
@y
 {2,1,0,1,1,0,2,0,1},
 {1,1,0,2,0,1,2,1,0},
 {2,0,1,2,1,0,1,1,0},@|
 {1,1,0,3,1,0,1,1,1},
 {3,1,0,1,1,1,1,1,0},
 {1,1,1,1,1,0,3,1,0}};
@z
@x
int top; /* index to the topmost one */
@y
int top; /* index to the topmost one */
int init_dat[10][3]={{7,1,1},{1,1,1},{7,1,1},{1,1,1},{7,1,1},{1,1,1},
      {7,1,1},{1,1,1},{7,1,1},{1,1,1}};
@z
@x
@d init_pts 10
@y
@d init_pts 10
@z
@x
for (j=0;j<init_pts;j++) {
  q=get_avail();
  p->s=4; p->t=vert++; p->dir=j; p->next=q; q->prev=p;
  p=(j<init_pts-1? get_avail(): poly[0]);
  q->s=1; q->t=1; q->next=p; p->prev=q;
@y
for (j=0,k=init_dat[0][0]+5;j<init_pts;j++) {
  q=get_avail();
  p->s=init_dat[j][0]; p->t=vert++;
  k+=15-init_dat[j][0]; p->dir=k%10;
  p->next=q; q->prev=p;
  p=(j<init_pts-1? get_avail(): poly[0]);
  q->s=init_dat[j][1]; q->t=init_dat[j][2];
  q->next=p; p->prev=q;
@z
