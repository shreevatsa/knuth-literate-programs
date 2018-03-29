/*4:*/
#line 75 "./gb_plane.w"

#include "gb_flip.h"

#include "gb_graph.h" 
#include "gb_miles.h" 
#include "gb_io.h"

#define plane_miles p_miles \

#define INFTY 0x10000000L \

#define panic(c) {panic_code= c;gb_trouble_code= 0;return NULL;} \

#define z_coord z.I \

#define mate(a,b) { \
reg= max_arc-(siz_t) a; \
b= (arc*) (reg+min_arc) ; \
} \

#define nodes_per_block 127
#define new_node(x)  \
if(next_node==max_node) { \
x= gb_typed_alloc(nodes_per_block,node,working_storage) ; \
if(x==NULL) { \
gb_free(working_storage) ; \
return; \
} \
next_node= x+1;max_node= x+nodes_per_block; \
}else x= next_node++; \

#define terminal_node(x,p) {new_node(x) ; \
x->v= (Vertex*) (p) ; \
} \


#line 82 "./gb_plane.w"

/*25:*/
#line 593 "./gb_plane.w"

typedef struct a_struct{
Vertex*vert;
struct a_struct*next;

struct n_struct*inst;

}arc;

/*:25*//*29:*/
#line 648 "./gb_plane.w"

typedef struct n_struct{
Vertex*u;
Vertex*v;

struct n_struct*l;
struct n_struct*r;
}node;

/*:29*/
#line 83 "./gb_plane.w"

/*10:*/
#line 239 "./gb_plane.w"

static unsigned long gprob;
static Vertex*inf_vertex;

/*:10*/
#line 84 "./gb_plane.w"

/*13:*/
#line 282 "./gb_plane.w"

static long int_sqrt(x)
long x;
{register long y,m,q= 2;long k;
if(x<=0)return 0;
for(k= 25,m= 0x20000000;x<m;k--,m>>= 2);
if(x>=m+m)y= 1;
else y= 0;
do/*14:*/
#line 296 "./gb_plane.w"

{
if(x&m)y+= y+1;
else y+= y;
m>>= 1;
if(x&m)y+= y-q+1;
else y+= y-q;
q+= q;
if(y> q)
y-= q,q+= 2;
else if(y<=0)
q-= 2,y+= q;
m>>= 1;
k--;
}

/*:14*/
#line 291 "./gb_plane.w"

while(k);
return q>>1;
}

/*:13*//*15:*/
#line 321 "./gb_plane.w"

static long sign_test(x1,x2,x3,y1,y2,y3)
long x1,x2,x3,y1,y2,y3;
{long s1,s2,s3;
long a,b,c;
register long t;
/*16:*/
#line 334 "./gb_plane.w"

if(x1==0||y1==0)s1= 0;
else{
if(x1> 0)s1= 1;
else x1= -x1,s1= -1;
}
if(x2==0||y2==0)s2= 0;
else{
if(x2> 0)s2= 1;
else x2= -x2,s2= -1;
}
if(x3==0||y3==0)s3= 0;
else{
if(x3> 0)s3= 1;
else x3= -x3,s3= -1;
}

/*:16*/
#line 327 "./gb_plane.w"
;
/*17:*/
#line 355 "./gb_plane.w"

if((s1>=0&&s2>=0&&s3>=0)||(s1<=0&&s2<=0&&s3<=0))
return(s1+s2+s3);
if(s3==0||s3==s1){
t= s3;s3= s2;s2= t;
t= x3;x3= x2;x2= t;
t= y3;y3= y2;y2= t;
}else if(s3==s2){
t= s3;s3= s1;s1= t;
t= x3;x3= x1;x1= t;
t= y3;y3= y1;y1= t;
}

/*:17*/
#line 329 "./gb_plane.w"
;
/*18:*/
#line 372 "./gb_plane.w"

{register long lx,rx,ly,ry;
lx= x1/0x4000;rx= x1%0x4000;
ly= y1/0x4000;ry= y1%0x4000;
a= lx*ly;b= lx*ry+ly*rx;c= rx*ry;
lx= x2/0x4000;rx= x2%0x4000;
ly= y2/0x4000;ry= y2%0x4000;
a+= lx*ly;b+= lx*ry+ly*rx;c+= rx*ry;
lx= x3/0x4000;rx= x3%0x4000;
ly= y3/0x4000;ry= y3%0x4000;
a-= lx*ly;b-= lx*ry+ly*rx;c-= rx*ry;
}

/*:18*/
#line 330 "./gb_plane.w"
;
/*19:*/
#line 387 "./gb_plane.w"

if(a==0)goto ez;
if(a<0)
a= -a,b= -b,c= -c,s3= -s3;
while(c<0){
a--;c+= 0x10000000;
if(a==0)goto ez;
}
if(b>=0)return-s3;
b= -b;
a-= b/0x4000;
if(a> 0)return-s3;
if(a<=-2)return s3;
return-s3*((a*0x4000-b%0x4000)*0x4000+c);
ez:if(b>=0x8000)return-s3;
if(b<=-0x8000)return s3;
return-s3*(b*0x4000+c);

/*:19*/
#line 331 "./gb_plane.w"
;
}

/*:15*//*24:*/
#line 541 "./gb_plane.w"

static long ff(t,u,v,w)
Vertex*t,*u,*v,*w;
{register long wx= w->x_coord,wy= w->y_coord;
long tx= t->x_coord-wx,ty= t->y_coord-wy;
long ux= u->x_coord-wx,uy= u->y_coord-wy;
long vx= v->x_coord-wx,vy= v->y_coord-wy;
return sign_test(ux-tx,vx-ux,tx-vx,vx*vx+vy*vy,tx*tx+ty*ty,ux*ux+uy*uy);
}
static long gg(t,u,v,w)
Vertex*t,*u,*v,*w;
{register long wx= w->x_coord,wy= w->y_coord;
long tx= t->x_coord-wx,ty= t->y_coord-wy;
long ux= u->x_coord-wx,uy= u->y_coord-wy;
long vx= v->x_coord-wx,vy= v->y_coord-wy;
return sign_test(uy-ty,vy-uy,ty-vy,vx*vx+vy*vy,tx*tx+ty*ty,ux*ux+uy*uy);
}
static long hh(t,u,v,w)
Vertex*t,*u,*v,*w;
{
return(u->x_coord-t->x_coord)*(v->y_coord-w->y_coord);
}
static long jj(t,u,v,w)
Vertex*t,*u,*v,*w;
{register long vx= v->x_coord,wy= w->y_coord;
return(u->x_coord-vx)*(u->x_coord-vx)+(u->y_coord-wy)*(u->y_coord-wy)
-(t->x_coord-vx)*(t->x_coord-vx)-(t->y_coord-wy)*(t->y_coord-wy);
}

/*:24*/
#line 85 "./gb_plane.w"

/*12:*/
#line 251 "./gb_plane.w"

static void new_euclid_edge(u,v)
Vertex*u,*v;
{register long dx,dy;
if((gb_next_rand()>>15)>=gprob){
if(u){
if(v){
dx= u->x_coord-v->x_coord;
dy= u->y_coord-v->y_coord;
gb_new_edge(u,v,int_sqrt(dx*dx+dy*dy));
}else if(inf_vertex)gb_new_edge(u,inf_vertex,INFTY);
}else if(inf_vertex)gb_new_edge(inf_vertex,v,INFTY);
}
}

/*:12*//*20:*/
#line 430 "./gb_plane.w"

static long ccw(u,v,w)
Vertex*u,*v,*w;
{register long wx= w->x_coord,wy= w->y_coord;
register long det= (u->x_coord-wx)*(v->y_coord-wy)
-(u->y_coord-wy)*(v->x_coord-wx);
Vertex*t;
if(det==0){
det= 1;
if(u->z_coord> v->z_coord){
t= u;u= v;v= t;det= -det;
}
if(v->z_coord> w->z_coord){
t= v;v= w;w= t;det= -det;
}
if(u->z_coord> v->z_coord){
t= u;u= v;v= t;det= -det;
}
if(u->x_coord> v->x_coord||(u->x_coord==v->x_coord&&
(u->y_coord> v->y_coord||(u->y_coord==v->y_coord&&
(w->x_coord> u->x_coord||
(w->x_coord==u->x_coord&&w->y_coord>=u->y_coord))))))
det= -det;
}
return(det> 0);
}

/*:20*//*21:*/
#line 473 "./gb_plane.w"

static long incircle(t,u,v,w)
Vertex*t,*u,*v,*w;
{register long wx= w->x_coord,wy= w->y_coord;
long tx= t->x_coord-wx,ty= t->y_coord-wy;
long ux= u->x_coord-wx,uy= u->y_coord-wy;
long vx= v->x_coord-wx,vy= v->y_coord-wy;
register long det= sign_test(tx*uy-ty*ux,ux*vy-uy*vx,vx*ty-vy*tx,
vx*vx+vy*vy,tx*tx+ty*ty,ux*ux+uy*uy);
Vertex*s;
if(det==0){
/*22:*/
#line 490 "./gb_plane.w"

det= 1;
if(t->z_coord> u->z_coord){
s= t;t= u;u= s;det= -det;
}
if(v->z_coord> w->z_coord){
s= v;v= w;w= s;det= -det;
}
if(t->z_coord> v->z_coord){
s= t;t= v;v= s;det= -det;
}
if(u->z_coord> w->z_coord){
s= u;u= w;w= s;det= -det;
}
if(u->z_coord> v->z_coord){
s= u;u= v;v= s;det= -det;
}

/*:22*/
#line 484 "./gb_plane.w"
;
/*23:*/
#line 525 "./gb_plane.w"

{long dd;
if((dd= ff(t,u,v,w))<0||(dd==0&&
((dd= gg(t,u,v,w))<0||(dd==0&&
((dd= ff(u,t,w,v))<0||(dd==0&&
((dd= gg(u,t,w,v))<0||(dd==0&&
((dd= ff(v,w,t,u))<0||(dd==0&&
((dd= gg(v,w,t,u))<0||(dd==0&&
((dd= hh(t,u,v,w))<0||(dd==0&&
((dd= jj(t,u,v,w))<0||(dd==0&&
((dd= hh(v,t,u,w))<0||(dd==0&&
((dd= jj(v,t,u,w))<0||(dd==0&&
jj(t,w,u,v)<0))))))))))))))))))))
det= -det;
}

/*:23*/
#line 485 "./gb_plane.w"
;
}
return(det> 0);
}

/*:21*//*40:*/
#line 881 "./gb_plane.w"

static void flip(c,d,e,t,tp,tpp,p,xp,xpp)
arc*c,*d,*e;
Vertex*t,*tp,*tpp,*p;
node*xp,*xpp;
{register arc*ep= e->next,*cp= c->next,*cpp= cp->next;
e->next= c;c->next= cpp;cpp->next= e;
e->inst= c->inst= cpp->inst= xp;
c->vert= p;
d->next= ep;ep->next= cp;cp->next= d;
d->inst= ep->inst= cp->inst= xpp;
d->vert= tpp;
}

/*:40*//*44:*/
#line 981 "./gb_plane.w"

static void new_mile_edge(u,v)
Vertex*u,*v;
{
if((gb_next_rand()>>15)>=gprob){
if(u){
if(v)gb_new_edge(u,v,-miles_distance(u,v));
else if(inf_vertex)gb_new_edge(u,inf_vertex,INFTY);
}else if(inf_vertex)gb_new_edge(inf_vertex,v,INFTY);
}
}

/*:44*/
#line 86 "./gb_plane.w"

/*9:*/
#line 225 "./gb_plane.w"

void delaunay(g,f)
Graph*g;
void(*f)();
{/*26:*/
#line 618 "./gb_plane.w"

register siz_t reg;
siz_t min_arc,max_arc;
arc*next_arc;

/*:26*//*30:*/
#line 683 "./gb_plane.w"

node*next_node;

node*max_node;

node root_node;
Area working_storage;

/*:30*//*32:*/
#line 706 "./gb_plane.w"

Vertex*p,*q,*r,*s,*t,*tp,*tpp,*u,*v;
arc*a,*aa,*b,*c,*d,*e;
node*x,*y,*yp,*ypp;

/*:32*/
#line 229 "./gb_plane.w"
;
/*34:*/
#line 736 "./gb_plane.w"

if(g->n<2)return;
/*31:*/
#line 695 "./gb_plane.w"

next_node= max_node= NULL;
init_area(working_storage);
/*27:*/
#line 623 "./gb_plane.w"

next_arc= gb_typed_alloc(6*g->n-6,arc,working_storage);
if(next_arc==NULL)return;
min_arc= (siz_t)next_arc;
max_arc= (siz_t)(next_arc+(6*g->n-7));

/*:27*/
#line 698 "./gb_plane.w"
;
u= g->vertices;
v= u+1;
/*33:*/
#line 711 "./gb_plane.w"

root_node.u= u;root_node.v= v;
a= next_arc;
terminal_node(x,a+1);
root_node.l= x;
a->vert= v;a->next= a+1;a->inst= x;
(a+1)->next= a+2;(a+1)->inst= x;

(a+2)->vert= u;(a+2)->next= a;(a+2)->inst= x;
mate(a,b);
terminal_node(x,b-2);
root_node.r= x;
b->vert= u;b->next= b-2;b->inst= x;
(b-2)->next= b-1;(b-2)->inst= x;

(b-1)->vert= v;(b-1)->next= b;(b-1)->inst= x;
next_arc+= 3;

/*:33*/
#line 701 "./gb_plane.w"
;

/*:31*/
#line 738 "./gb_plane.w"
;
for(p= g->vertices+2;p<g->vertices+g->n;p++){
/*35:*/
#line 749 "./gb_plane.w"

x= &root_node;
do{
if(ccw(x->u,x->v,p))
x= x->l;
else x= x->r;
}while(x->u);
a= (arc*)x->v;

/*:35*/
#line 740 "./gb_plane.w"
;
/*36:*/
#line 784 "./gb_plane.w"

b= a->next;c= b->next;
q= a->vert;r= b->vert;s= c->vert;
/*37:*/
#line 802 "./gb_plane.w"

terminal_node(yp,a);terminal_node(ypp,next_arc);terminal_node(y,c);
c->inst= y;a->inst= yp;b->inst= ypp;
mate(next_arc,e);
a->next= e;b->next= e-1;c->next= e-2;
next_arc->vert= q;next_arc->next= b;next_arc->inst= ypp;
(next_arc+1)->vert= r;(next_arc+1)->next= c;(next_arc+1)->inst= y;
(next_arc+2)->vert= s;(next_arc+2)->next= a;(next_arc+2)->inst= yp;
e->vert= (e-1)->vert= (e-2)->vert= p;
e->next= next_arc+2;(e-1)->next= next_arc;(e-2)->next= next_arc+1;
e->inst= yp;(e-1)->inst= ypp;(e-2)->inst= y;
next_arc+= 3;

/*:37*/
#line 787 "./gb_plane.w"
;
if(q==NULL)/*38:*/
#line 826 "./gb_plane.w"

{register node*xp;
x->u= r;x->v= p;x->l= ypp;
new_node(xp);
xp->u= s;xp->v= p;xp->l= y;xp->r= yp;
x->r= xp;
mate(a,aa);d= aa->next;t= d->vert;
while(t!=r&&(ccw(p,s,t))){register node*xpp;
terminal_node(xpp,d);
xp->r= d->inst;
xp= d->inst;
xp->u= t;xp->v= p;xp->l= xpp;xp->r= yp;
flip(a,aa,d,s,NULL,t,p,xpp,yp);
a= aa->next;mate(a,aa);d= aa->next;
s= t;t= d->vert;
yp->v= (Vertex*)a;
}
terminal_node(xp,d->next);
x= d->inst;x->u= s;x->v= p;x->l= xp;x->r= yp;
d->inst= xp;d->next->inst= xp;d->next->next->inst= xp;
r= s;
}

/*:38*/
#line 788 "./gb_plane.w"

else{register node*xp;
x->u= r;x->v= p;
new_node(xp);
xp->u= q;xp->v= p;xp->l= yp;xp->r= ypp;
x->l= xp;
new_node(xp);
xp->u= s;xp->v= p;xp->l= y;xp->r= yp;
x->r= xp;
}

/*:36*/
#line 741 "./gb_plane.w"
;
/*39:*/
#line 854 "./gb_plane.w"

while(1){
mate(c,d);e= d->next;
t= d->vert;tp= c->vert;tpp= e->vert;
if(tpp&&incircle(tpp,tp,t,p)){
register node*xp,*xpp;
terminal_node(xp,e);
terminal_node(xpp,d);
x= c->inst;x->u= tpp;x->v= p;x->l= xp;x->r= xpp;
x= d->inst;x->u= tpp;x->v= p;x->l= xp;x->r= xpp;
flip(c,d,e,t,tp,tpp,p,xp,xpp);
c= e;
}
else if(tp==r)break;
else{
mate(c->next,aa);
c= aa->next;
}
}

/*:39*/
#line 743 "./gb_plane.w"
;
}

/*:34*/
#line 231 "./gb_plane.w"
;
/*28:*/
#line 629 "./gb_plane.w"

a= (arc*)min_arc;
b= (arc*)max_arc;
for(;a<next_arc;a++,b--)
(*f)(a->vert,b->vert);

/*:28*/
#line 232 "./gb_plane.w"
;
gb_free(working_storage);
}

/*:9*/
#line 87 "./gb_plane.w"

/*5:*/
#line 91 "./gb_plane.w"

Graph*plane(n,x_range,y_range,extend,prob,seed)
unsigned long n;
unsigned long x_range,y_range;
unsigned long extend;
unsigned long prob;
long seed;
{Graph*new_graph;
register Vertex*v;
register long k;
gb_init_rand(seed);
if(x_range> 16384||y_range> 16384)panic(bad_specs);
if(n<2)panic(very_bad_specs);
if(x_range==0)x_range= 16384;
if(y_range==0)y_range= 16384;
/*6:*/
#line 127 "./gb_plane.w"

if(extend)extra_n++;
new_graph= gb_new_graph(n);
if(new_graph==NULL)
panic(no_room);
sprintf(new_graph->id,"plane(%lu,%lu,%lu,%lu,%lu,%ld)",
n,x_range,y_range,extend,prob,seed);
strcpy(new_graph->util_types,"ZZZIIIZZZZZZZZ");
for(k= 0,v= new_graph->vertices;k<n;k++,v++){
v->x_coord= gb_unif_rand(x_range);
v->y_coord= gb_unif_rand(y_range);
v->z_coord= ((long)(gb_next_rand()/n))*n+k;
sprintf(str_buf,"%ld",k);v->name= gb_save_string(str_buf);
}
if(extend){
v->name= gb_save_string("INF");
v->x_coord= v->y_coord= v->z_coord= -1;
extra_n--;
}

/*:6*/
#line 106 "./gb_plane.w"
;
/*11:*/
#line 245 "./gb_plane.w"

gprob= prob;
if(extend)inf_vertex= new_graph->vertices+n;
else inf_vertex= NULL;
delaunay(new_graph,new_euclid_edge);

/*:11*/
#line 109 "./gb_plane.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
if(extend)new_graph->n++;
return new_graph;
}

/*:5*/
#line 88 "./gb_plane.w"

/*41:*/
#line 930 "./gb_plane.w"

Graph*plane_miles(n,north_weight,west_weight,pop_weight,extend,prob,seed)
unsigned long n;
long north_weight;
long west_weight;
long pop_weight;
unsigned long extend;
unsigned long prob;
long seed;
{Graph*new_graph;
/*42:*/
#line 958 "./gb_plane.w"

if(extend)extra_n++;
if(n==0||n> MAX_N)n= MAX_N;
new_graph= miles(n,north_weight,west_weight,pop_weight,1L,0L,seed);
if(new_graph==NULL)return NULL;
sprintf(new_graph->id,"plane_miles(%lu,%ld,%ld,%ld,%lu,%lu,%ld)",
n,north_weight,west_weight,pop_weight,extend,prob,seed);
if(extend)extra_n--;

/*:42*/
#line 940 "./gb_plane.w"
;
/*43:*/
#line 969 "./gb_plane.w"

gprob= prob;
if(extend){
inf_vertex= new_graph->vertices+new_graph->n;
inf_vertex->name= gb_save_string("INF");
inf_vertex->x_coord= inf_vertex->y_coord= inf_vertex->z_coord= -1;
}else inf_vertex= NULL;
delaunay(new_graph,new_mile_edge);

/*:43*/
#line 943 "./gb_plane.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
gb_free(new_graph->aux_data);
if(extend)new_graph->n++;
return new_graph;
}

/*:41*/
#line 89 "./gb_plane.w"


/*:4*/
