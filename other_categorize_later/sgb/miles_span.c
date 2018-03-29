/*2:*/
#line 90 "./miles_span.w"

#include "gb_graph.h" 
#include "gb_save.h" 
#include "gb_miles.h" 
#define INFINITY (unsigned long) -1 \
 \

#define o mems++
#define oo mems+= 2
#define ooo mems+= 3
#define oooo mems+= 4 \

#define from a.V
#define klink b.A \

#define clink z.V
#define comp y.V
#define csize x.I \

#define dist z.I
#define backlink y.V \

#define KNOWN (Vertex*) 1 \

#define heap_elt(i) (gv+i) ->u.V
#define heap_index v.I \
 \

#define newarc u.A
#define parent newarc->tip
#define child newarc->a.V
#define lsib v.V
#define rsib w.V
#define rank_tag x.I \

#define qchild a.A
#define qsib b.A \

#define qcount a.I \

#define pq newarc \

#define findex csize
#define matx(j,k) (gv+((j) *lo_sqrt+(k) ) ) ->z.I \

#define matx_arc(j,k) (gv+((j) *lo_sqrt+(k) ) ) ->v.A \

#define INF 30000 \


#line 94 "./miles_span.w"

/*3:*/
#line 127 "./miles_span.w"

Graph*g;

/*:3*//*6:*/
#line 190 "./miles_span.w"

unsigned long sp_length;

/*:6*//*10:*/
#line 288 "./miles_span.w"

long mems;

/*:10*//*13:*/
#line 372 "./miles_span.w"

Arc*aucket[64],*bucket[64];

/*:13*//*19:*/
#line 497 "./miles_span.w"

void(*init_queue)();
void(*enqueue)();
void(*requeue)();
Vertex*(*del_min)();

/*:19*//*23:*/
#line 595 "./miles_span.w"

Vertex*gv;
long hsize;

/*:23*//*31:*/
#line 801 "./miles_span.w"

Vertex*F_heap;

/*:31*//*37:*/
#line 966 "./miles_span.w"

Vertex*new_roots[46];

/*:37*//*57:*/
#line 1427 "./miles_span.w"

long lo_sqrt,hi_sqrt;

/*:57*//*68:*/
#line 1632 "./miles_span.w"

long kk;
long distance[100];
Arc*dist_arc[100];

/*:68*/
#line 95 "./miles_span.w"

/*67:*/
#line 1613 "./miles_span.w"

void note_edge(a)
Arc*a;
{register long k;
oo,k= a->tip->findex;
if(k==kk)return;
if(oo,a->len<matx(kk,k)){
o,matx(kk,k)= a->len;
o,matx(k,kk)= a->len;
matx_arc(kk,k)= matx_arc(k,kk)= a;
}
}

/*:67*/
#line 96 "./miles_span.w"

/*24:*/
#line 609 "./miles_span.w"

void init_heap(d)
long d;
{
gv= g->vertices;
hsize= 0;
}

/*:24*//*25:*/
#line 623 "./miles_span.w"

void enq_heap(v,d)
Vertex*v;
long d;
{register unsigned long k;
register unsigned long j;
register Vertex*u;
o,v->dist= d;
k= ++hsize;
j= k>>1;
while(j> 0&&(oo,(u= heap_elt(j))->dist> d)){
o,heap_elt(k)= u;
o,u->heap_index= k;
k= j;
j= k>>1;
}
o,heap_elt(k)= v;
o,v->heap_index= k;
}

/*:25*//*26:*/
#line 650 "./miles_span.w"

void req_heap(v,d)
Vertex*v;
long d;
{register unsigned long k;
register unsigned long j;
register Vertex*u;
o,v->dist= d;
o,k= v->heap_index;
j= k>>1;
if(j> 0&&(oo,(u= heap_elt(j))->dist> d)){
do{
o,heap_elt(k)= u;
o,u->heap_index= k;
k= j;
j= k>>1;
}while(j> 0&&(oo,(u= heap_elt(j))->dist> d));
o,heap_elt(k)= v;
o,v->heap_index= k;
}
}

/*:26*//*27:*/
#line 681 "./miles_span.w"

Vertex*del_heap()
{Vertex*v;
register Vertex*u;
register unsigned long k;
register unsigned long j;
register long d;
if(hsize==0)return NULL;
o,v= heap_elt(1);
o,u= heap_elt(hsize--);
o,d= u->dist;
k= 1;
j= 2;
while(j<=hsize){
if(oooo,heap_elt(j)->dist> heap_elt(j+1)->dist)j++;
if(heap_elt(j)->dist>=d)break;
o,heap_elt(k)= heap_elt(j);
o,heap_elt(k)->heap_index= k;
k= j;
j= k<<1;
}
o,heap_elt(k)= u;
o,u->heap_index= k;
return v;
}

/*:27*//*30:*/
#line 796 "./miles_span.w"

void init_F_heap(d)
long d;
{F_heap= NULL;}

/*:30*//*33:*/
#line 859 "./miles_span.w"

void enq_F_heap(v,d)
Vertex*v;
long d;
{
o,v->dist= d;
o,v->parent= NULL;
o,v->rank_tag= 0;
if(F_heap==NULL){
oo,F_heap= v->lsib= v->rsib= v;
}else{register Vertex*u;
o,u= F_heap->lsib;
o,v->lsib= u;
o,v->rsib= F_heap;
oo,F_heap->lsib= u->rsib= v;
if(F_heap->dist> d)F_heap= v;
}
}

/*:33*//*34:*/
#line 900 "./miles_span.w"

void req_F_heap(v,d)
Vertex*v;
long d;
{register Vertex*p,*pp;
register Vertex*u,*w;
register long r;
o,v->dist= d;
o,p= v->parent;
if(p==NULL){
if(F_heap->dist> d)F_heap= v;
}else if(o,p->dist> d)
while(1){
o,r= p->rank_tag;
if(r>=4)
/*35:*/
#line 928 "./miles_span.w"

{
o,u= v->lsib;
o,w= v->rsib;
o,u->rsib= w;
o,w->lsib= u;
if(o,p->child==v)o,p->child= w;
}

/*:35*/
#line 915 "./miles_span.w"
;
/*36:*/
#line 937 "./miles_span.w"

o,v->parent= NULL;
o,u= F_heap->lsib;
o,v->lsib= u;
o,v->rsib= F_heap;
oo,F_heap->lsib= u->rsib= v;
if(F_heap->dist> d)F_heap= v;

/*:36*/
#line 916 "./miles_span.w"
;
o,pp= p->parent;
if(pp==NULL){
o,p->rank_tag= r-2;break;
}
if((r&1)==0){
o,p->rank_tag= r-1;break;
}else o,p->rank_tag= r-2;
v= p;p= pp;
}
}

/*:34*//*38:*/
#line 969 "./miles_span.w"

Vertex*del_F_heap()
{Vertex*final_v= F_heap;
register Vertex*t,*u,*v,*w;
register long h= -1;
register long r;
if(F_heap){
if(o,F_heap->rank_tag<2)o,v= F_heap->rsib;
else{
o,w= F_heap->child;
o,v= w->rsib;
oo,w->rsib= F_heap->rsib;

for(w= v;w!=F_heap->rsib;o,w= w->rsib)
o,w->parent= NULL;
}
while(v!=F_heap){
o,w= v->rsib;
/*39:*/
#line 1000 "./miles_span.w"

o,r= v->rank_tag>>1;
while(1){
if(h<r){
do{
h++;
o,new_roots[h]= (h==r?v:NULL);
}while(h<r);
break;
}
if(o,new_roots[r]==NULL){
o,new_roots[r]= v;
break;
}
u= new_roots[r];
o,new_roots[r]= NULL;
if(oo,u->dist<v->dist){
o,v->rank_tag= r<<1;
t= u;u= v;v= t;
}
/*40:*/
#line 1028 "./miles_span.w"

if(r==0){
o,v->child= u;
oo,u->lsib= u->rsib= u;
}else{
o,t= v->child;
oo,u->rsib= t->rsib;
o,u->lsib= t;
oo,u->rsib->lsib= t->rsib= u;
}
o,u->parent= v;

/*:40*/
#line 1020 "./miles_span.w"
;
r++;
}
o,v->rank_tag= r<<1;

/*:39*/
#line 987 "./miles_span.w"
;
v= w;
}
/*41:*/
#line 1042 "./miles_span.w"

if(h<0)F_heap= NULL;
else{long d;
o,u= v= new_roots[h];

o,d= u->dist;
F_heap= u;
for(h--;h>=0;h--)
if(o,new_roots[h]){
w= new_roots[h];
o,w->lsib= v;
o,v->rsib= w;
if(o,w->dist<d){
F_heap= w;
d= w->dist;
}
v= w;
}
o,v->rsib= u;
o,u->lsib= v;
}

/*:41*/
#line 990 "./miles_span.w"
;
}
return final_v;
}

/*:38*//*45:*/
#line 1154 "./miles_span.w"

qunite(m,q,mm,qq,h)
register long m,mm;
register Arc*q,*qq;
Arc*h;
{register Arc*p;
register long k= 1;
p= h;
while(m){
if((m&k)==0){
if(mm&k){
o,p->qsib= qq;p= qq;mm-= k;
if(mm)o,qq= qq->qsib;
}
}else if((mm&k)==0){
o,p->qsib= q;p= q;m-= k;
if(m)o,q= q->qsib;
}else/*46:*/
#line 1186 "./miles_span.w"

{register Arc*c;
register long key;
register Arc*r,*rr;
m-= k;if(m)o,r= q->qsib;
mm-= k;if(mm)o,rr= qq->qsib;
/*47:*/
#line 1208 "./miles_span.w"

if(oo,q->len<qq->len){
c= q,key= q->len;
q= qq;
}else c= qq,key= qq->len;
if(k==1)o,c->qchild= q;
else{
o,qq= c->qchild;
o,c->qchild= q;
if(k==2)o,q->qsib= qq;
else oo,q->qsib= qq->qsib;
o,qq->qsib= q;
}

/*:47*/
#line 1192 "./miles_span.w"
;
k<<= 1;q= r;qq= rr;
while((m|mm)&k){
if((m&k)==0)/*49:*/
#line 1238 "./miles_span.w"

{
mm-= k;if(mm)o,rr= qq->qsib;
if(o,qq->len<key){
r= c;c= qq;key= qq->len;qq= r;
}
o,r= c->qchild;
o,c->qchild= qq;
if(k==2)o,qq->qsib= r;
else oo,qq->qsib= r->qsib;
o,r->qsib= qq;
qq= rr;
}

/*:49*/
#line 1195 "./miles_span.w"

else{
/*48:*/
#line 1224 "./miles_span.w"

{
m-= k;if(m)o,r= q->qsib;
if(o,q->len<key){
rr= c;c= q;key= q->len;q= rr;
}
o,rr= c->qchild;
o,c->qchild= q;
if(k==2)o,q->qsib= rr;
else oo,q->qsib= rr->qsib;
o,rr->qsib= q;
q= r;
}

/*:48*/
#line 1197 "./miles_span.w"
;
if(mm&k){
o,p->qsib= qq;p= qq;mm-= k;
if(mm)o,qq= qq->qsib;
}
}
k<<= 1;
}
o,p->qsib= c;p= c;
}

/*:46*/
#line 1172 "./miles_span.w"
;
k<<= 1;
}
if(mm)o,p->qsib= qq;
}

/*:45*//*50:*/
#line 1256 "./miles_span.w"

qenque(h,a)
Arc*h;
Arc*a;
{long m;
o,m= h->qcount;
o,h->qcount= m+1;
if(m==0)o,h->qsib= a;
else o,qunite(1L,a,m,h->qsib,h);
}

/*:50*//*51:*/
#line 1271 "./miles_span.w"

qmerge(h,hh)
Arc*h;
Arc*hh;
{long m,mm;
o,mm= hh->qcount;
if(mm){
o,m= h->qcount;
o,h->qcount= m+mm;
if(m>=mm)oo,qunite(mm,hh->qsib,m,h->qsib,h);
else if(m==0)oo,h->qsib= hh->qsib;
else oo,qunite(m,h->qsib,mm,hh->qsib,h);
}
}

/*:51*//*52:*/
#line 1290 "./miles_span.w"

Arc*qdel_min(h)
Arc*h;
{register Arc*p,*pp;
register Arc*q,*qq;
register long key;
long m;
long k;
register long mm;
o,m= h->qcount;
if(m==0)return NULL;
o,h->qcount= m-1;
/*53:*/
#line 1317 "./miles_span.w"

mm= m&(m-1);
o,q= h->qsib;
k= m-mm;
if(mm){
p= q;qq= h;
o,key= q->len;
do{long t= mm&(mm-1);
pp= p;o,p= p->qsib;
if(o,p->len<=key){
q= p;qq= pp;k= mm-t;key= p->len;
}
mm= t;
}while(mm);
if(k+k<=m)oo,qq->qsib= q->qsib;
}

/*:53*/
#line 1302 "./miles_span.w"
;
if(k> 2){
if(k+k<=m)oo,qunite(k-1,q->qchild->qsib,m-k,h->qsib,h);
else oo,qunite(m-k,h->qsib,k-1,q->qchild->qsib,h);
}else if(k==2)o,qunite(1L,q->qchild,m-k,h->qsib,h);
return q;
}

/*:52*//*54:*/
#line 1338 "./miles_span.w"

qtraverse(h,visit)
Arc*h;
void(*visit)();
{register long m;
register Arc*p,*q,*r;
o,m= h->qcount;
p= h;
while(m){
o,p= p->qsib;
(*visit)(p);
if(m&1)m--;
else{
o,q= p->qchild;
if(m&2)(*visit)(q);
else{
o,r= q->qsib;
if(m&(m-1))oo,q->qsib= p->qsib;
(*visit)(r);
p= r;
}
m-= 2;
}
}
}

/*:54*/
#line 97 "./miles_span.w"

/*7:*/
#line 196 "./miles_span.w"

report(u,v,l)
Vertex*u,*v;
long l;
{printf("  %ld miles between %s and %s [%ld mems]\n",
l,u->name,v->name,mems);
}

/*:7*//*14:*/
#line 377 "./miles_span.w"

unsigned long krusk(g)
Graph*g;
{/*15:*/
#line 401 "./miles_span.w"

register Arc*a;
register long l;
register Vertex*u,*v,*w;
unsigned long tot_len= 0;
long n;
long components;

/*:15*/
#line 380 "./miles_span.w"

mems= 0;
/*12:*/
#line 353 "./miles_span.w"

o,n= g->n;
for(l= 0;l<64;l++)oo,aucket[l]= bucket[l]= NULL;
for(o,v= g->vertices;v<g->vertices+n;v++)
for(o,a= v->arcs;a&&(o,a->tip> v);o,a= a->next){
o,a->from= v;
o,l= a->len&0x3f;
oo,a->klink= aucket[l];
o,aucket[l]= a;
}
for(l= 63;l>=0;l--)
for(o,a= aucket[l];a;){register long ll;
register Arc*aa= a;
o,a= a->klink;
o,ll= aa->len>>6;
oo,aa->klink= bucket[ll];
o,bucket[ll]= aa;
}

/*:12*/
#line 382 "./miles_span.w"
;
if(verbose)printf("   [%ld mems to sort the edges into buckets]\n",mems);
/*17:*/
#line 434 "./miles_span.w"

for(v= g->vertices;v<g->vertices+n;v++){
oo,v->clink= v->comp= v;
o,v->csize= 1;
}
components= n;

/*:17*/
#line 384 "./miles_span.w"
;
for(l= 0;l<64;l++)
for(o,a= bucket[l];a;o,a= a->klink){
o,u= a->from;
o,v= a->tip;
/*16:*/
#line 427 "./miles_span.w"

if(oo,u->comp==v->comp)continue;

/*:16*/
#line 389 "./miles_span.w"
;
if(verbose)report(a->from,a->tip,a->len);
o,tot_len+= a->len;
if(--components==1)return tot_len;
/*18:*/
#line 457 "./miles_span.w"

u= u->comp;
v= v->comp;
if(oo,u->csize<v->csize){
w= u;u= v;v= w;
}
o,u->csize+= v->csize;
o,w= v->clink;
oo,v->clink= u->clink;
o,u->clink= w;
for(;;o,w= w->clink){
o,w->comp= u;
if(w==v)break;
}

/*:18*/
#line 393 "./miles_span.w"
;
}
return INFINITY;
}

/*:14*//*20:*/
#line 512 "./miles_span.w"

unsigned long jar_pr(g)
Graph*g;
{register Vertex*t;
long fragment_size;
unsigned long tot_len= 0;
mems= 0;
/*21:*/
#line 546 "./miles_span.w"

for(oo,t= g->vertices+g->n-1;t> g->vertices;t--)o,t->backlink= NULL;
o,t->backlink= KNOWN;
fragment_size= 1;
(*init_queue)(0L);

/*:21*/
#line 519 "./miles_span.w"
;
while(fragment_size<g->n){
/*22:*/
#line 553 "./miles_span.w"

{register Arc*a;
for(o,a= t->arcs;a;o,a= a->next){
register Vertex*v;
o,v= a->tip;
if(o,v->backlink){
if(v->backlink> KNOWN){
if(oo,a->len<v->dist){
o,v->backlink= t;
(*requeue)(v,a->len);
}
}
}else{
o,v->backlink= t;
o,(*enqueue)(v,a->len);
}
}
}

/*:22*/
#line 522 "./miles_span.w"
;
t= (*del_min)();
if(t==NULL)return INFINITY;
if(verbose)report(t->backlink,t,t->dist);
o,tot_len+= t->dist;
o,t->backlink= KNOWN;
fragment_size++;
}
return tot_len;
}

/*:20*//*55:*/
#line 1391 "./miles_span.w"

unsigned long cher_tar_kar(g)
Graph*g;
{/*56:*/
#line 1415 "./miles_span.w"

register Vertex*s,*t;
Vertex*large_list;
long frags;
unsigned long tot_len= 0;
register Vertex*u,*v;
register Arc*a;
register long j,k;

/*:56*//*61:*/
#line 1506 "./miles_span.w"

long old_size,new_size;

/*:61*/
#line 1394 "./miles_span.w"

mems= 0;
/*58:*/
#line 1438 "./miles_span.w"

o,frags= g->n;
for(hi_sqrt= 1;hi_sqrt*(hi_sqrt+1)<=frags;hi_sqrt++);
if(hi_sqrt*hi_sqrt<=frags)lo_sqrt= hi_sqrt;
else lo_sqrt= hi_sqrt-1;
large_list= NULL;
/*59:*/
#line 1476 "./miles_span.w"

o,s= g->vertices;
for(v= s;v<s+frags;v++){
if(v> s){
o,v->lsib= v-1;o,(v-1)->rsib= v;
}
o,v->comp= NULL;
o,v->csize= 1;
o,v->pq->qcount= 0;
for(o,a= v->arcs;a;o,a= a->next)qenque(v->pq,a);
}
t= v-1;

/*:59*/
#line 1444 "./miles_span.w"
;
while(frags> lo_sqrt){
/*60:*/
#line 1489 "./miles_span.w"

v= s;
o,s= s->rsib;
do{a= qdel_min(v->pq);
if(a==NULL)return INFINITY;
o,u= a->tip;
while(o,u->comp)u= u->comp;
}while(u==v);
if(verbose)/*63:*/
#line 1550 "./miles_span.w"

report((edge_trick&(siz_t)a?a-1:a+1)->tip,a->tip,a->len);

/*:63*/
#line 1497 "./miles_span.w"
;
o,tot_len+= a->len;
o,v->comp= u;
qmerge(u->pq,v->pq);
o,old_size= u->csize;
o,new_size= old_size+v->csize;
o,u->csize= new_size;
/*62:*/
#line 1517 "./miles_span.w"

if(old_size>=hi_sqrt){
if(t==v)s= NULL;
}else if(new_size<hi_sqrt){
if(u==t)goto fin;
if(u==s)o,s= u->rsib;
else{
ooo,u->rsib->lsib= u->lsib;
o,u->lsib->rsib= u->rsib;

}
o,t->rsib= u;
o,u->lsib= t;
t= u;
}else{
if(u==t){
if(u==s)goto fin;
o,t= u->lsib;
}else if(u==s)
o,s= u->rsib;
else{
ooo,u->rsib->lsib= u->lsib;
o,u->lsib->rsib= u->rsib;
}
o,u->rsib= large_list;large_list= u;
}
fin:;

/*:62*/
#line 1504 "./miles_span.w"
;

/*:60*/
#line 1446 "./miles_span.w"
;
frags--;
}

/*:58*/
#line 1396 "./miles_span.w"
;
if(verbose)printf("    [Stage 1 has used %ld mems]\n",mems);
/*64:*/
#line 1579 "./miles_span.w"

gv= g->vertices;
/*65:*/
#line 1589 "./miles_span.w"

if(s==NULL)s= large_list;
else o,t->rsib= large_list;
for(k= 0,v= s;v;o,v= v->rsib,k++)o,v->findex= k;
for(v= g->vertices;v<g->vertices+g->n;v++)
if(o,v->comp){
for(t= v->comp;o,t->comp;t= t->comp);
o,k= t->findex;
for(t= v;o,u= t->comp;t= u){
o,t->comp= NULL;
o,t->findex= k;
}
}

/*:65*/
#line 1581 "./miles_span.w"
;
/*66:*/
#line 1603 "./miles_span.w"

for(j= 0;j<lo_sqrt;j++)for(k= 0;k<lo_sqrt;k++)o,matx(j,k)= INF;
for(kk= 0;s;o,s= s->rsib,kk++)qtraverse(s->pq,note_edge);

/*:66*/
#line 1582 "./miles_span.w"
;
/*69:*/
#line 1643 "./miles_span.w"

{long d;
o,distance[0]= -1;
d= INF;
for(k= 1;k<lo_sqrt;k++){
o,distance[k]= matx(0,k);
dist_arc[k]= matx_arc(0,k);
if(distance[k]<d)d= distance[k],j= k;
}
while(frags> 1)
/*70:*/
#line 1658 "./miles_span.w"

{
if(d==INF)return INFINITY;
o,distance[j]= -1;
tot_len+= d;
if(verbose){
a= dist_arc[j];
/*63:*/
#line 1550 "./miles_span.w"

report((edge_trick&(siz_t)a?a-1:a+1)->tip,a->tip,a->len);

/*:63*/
#line 1665 "./miles_span.w"
;
}
frags--;
d= INF;
for(k= 1;k<lo_sqrt;k++)
if(o,distance[k]>=0){
if(o,matx(j,k)<distance[k]){
o,distance[k]= matx(j,k);
dist_arc[k]= matx_arc(j,k);
}
if(distance[k]<d)d= distance[k],kk= k;
}
j= kk;
}

/*:70*/
#line 1655 "./miles_span.w"
;
}

/*:69*/
#line 1583 "./miles_span.w"
;

/*:64*/
#line 1398 "./miles_span.w"
;
return tot_len;
}

/*:55*/
#line 98 "./miles_span.w"

main(argc,argv)
int argc;
char*argv[];
{unsigned long n= 100;
unsigned long n_weight= 0;
unsigned long w_weight= 0;
unsigned long p_weight= 0;
unsigned long d= 10;
long s= 0;
unsigned long r= 1;
char*file_name= NULL;
/*4:*/
#line 130 "./miles_span.w"

while(--argc){

if(sscanf(argv[argc],"-n%lu",&n)==1);
else if(sscanf(argv[argc],"-N%lu",&n_weight)==1);
else if(sscanf(argv[argc],"-W%lu",&w_weight)==1);
else if(sscanf(argv[argc],"-P%lu",&p_weight)==1);
else if(sscanf(argv[argc],"-d%lu",&d)==1);
else if(sscanf(argv[argc],"-r%lu",&r)==1);
else if(sscanf(argv[argc],"-s%ld",&s)==1);
else if(strcmp(argv[argc],"-v")==0)verbose= 1;
else if(strncmp(argv[argc],"-g",2)==0)file_name= argv[argc]+2;
else{
fprintf(stderr,
"Usage: %s [-nN][-dN][-rN][-sN][-NN][-WN][-PN][-v][-gfoo]\n",
argv[0]);
return-2;
}
}
if(file_name)r= 1;

/*:4*/
#line 110 "./miles_span.w"
;
while(r--){
if(file_name)g= restore_graph(file_name);
else g= miles(n,n_weight,w_weight,p_weight,0L,d,s);
if(g==NULL||g->n<=1){
fprintf(stderr,"Sorry, can't create the graph! (error code %ld)\n",
panic_code);
return-1;
}
/*5:*/
#line 169 "./miles_span.w"

printf("The graph %s has %ld edges,\n",g->id,g->m/2);
sp_length= krusk(g);
if(sp_length==INFINITY)printf("  and it isn't connected.\n");
else printf("  and its minimum spanning tree has length %ld.\n",sp_length);
printf(" The Kruskal/radix-sort algorithm takes %ld mems;\n",mems);
/*28:*/
#line 709 "./miles_span.w"

init_queue= init_heap;
enqueue= enq_heap;
requeue= req_heap;
del_min= del_heap;
if(sp_length!=jar_pr(g)){
printf(" ...oops, I've got a bug, please fix fix fix\n");
return-4;
}

/*:28*/
#line 175 "./miles_span.w"
;
printf(" the Jarnik/Prim/binary-heap algorithm takes %ld mems;\n",mems);
/*32:*/
#line 830 "./miles_span.w"

{register Arc*aa;
register Vertex*uu;
aa= gb_typed_alloc(g->n,Arc,g->aux_data);
if(aa==NULL){
printf(" and there isn't enough space to try the other methods.\n\n");
goto done;
}
for(uu= g->vertices;uu<g->vertices+g->n;uu++,aa++)
uu->newarc= aa;
}

/*:32*/
#line 178 "./miles_span.w"
;
/*42:*/
#line 1064 "./miles_span.w"

init_queue= init_F_heap;
enqueue= enq_F_heap;
requeue= req_F_heap;
del_min= del_F_heap;
if(sp_length!=jar_pr(g)){
printf(" ...oops, I've got a bug, please fix fix fix\n");
return-5;
}

/*:42*/
#line 180 "./miles_span.w"
;
printf(" the Jarnik/Prim/Fibonacci-heap algorithm takes %ld mems;\n",mems);
if(sp_length!=cher_tar_kar(g)){
if(gb_trouble_code)printf(" ...oops, I've run out of memory!\n");
else printf(" ...oops, I've got a bug, please fix fix fix\n");
return-3;
}
printf(" the Cheriton/Tarjan/Karp algorithm takes %ld mems.\n\n",mems);
done:;

/*:5*/
#line 120 "./miles_span.w"
;
gb_recycle(g);
s++;
}
return 0;
}

/*:2*/
