/*5:*/
#line 106 "./gb_miles.w"

#include "gb_io.h" 
#include "gb_flip.h"

#include "gb_graph.h" 
#include "gb_sort.h" 
#define MAX_N 128 \

#define panic(c) {panic_code= c;gb_trouble_code= 0;return NULL;} \

#define d(j,k) *(distance+(MAX_N*j+k) )  \

#define x_coord x.I
#define y_coord y.I
#define index_no z.I
#define people w.I \


#line 112 "./gb_miles.w"

/*9:*/
#line 165 "./gb_miles.w"

typedef struct node_struct{
long key;
struct node_struct*link;
long kk;
long lat,lon,pop;
char name[30];
}node;

/*:9*/
#line 113 "./gb_miles.w"

/*10:*/
#line 177 "./gb_miles.w"

static long min_lat= 2672,max_lat= 5042,min_lon= 7180,max_lon= 12312,
min_pop= 2521,max_pop= 875538;
static node*node_block;
static long*distance;

/*:10*/
#line 114 "./gb_miles.w"


Graph*miles(n,north_weight,west_weight,pop_weight,
max_distance,max_degree,seed)
unsigned long n;
long north_weight;
long west_weight;
long pop_weight;
unsigned long max_distance;
unsigned long max_degree;

long seed;
{/*6:*/
#line 140 "./gb_miles.w"

Graph*new_graph;
register long j,k;

/*:6*/
#line 126 "./gb_miles.w"

gb_init_rand(seed);
/*7:*/
#line 144 "./gb_miles.w"

if(n==0||n> MAX_N)n= MAX_N;
if(max_degree==0||max_degree>=n)max_degree= n-1;
if(north_weight> 100000||west_weight> 100000||pop_weight> 100
||north_weight<-100000||west_weight<-100000||pop_weight<-100)
panic(bad_specs);

/*:7*/
#line 128 "./gb_miles.w"
;
/*8:*/
#line 151 "./gb_miles.w"

new_graph= gb_new_graph(n);
if(new_graph==NULL)
panic(no_room);
sprintf(new_graph->id,"miles(%lu,%ld,%ld,%ld,%lu,%lu,%ld)",
n,north_weight,west_weight,pop_weight,max_distance,max_degree,seed);
strcpy(new_graph->util_types,"ZZIIIIZZZZZZZZ");

/*:8*/
#line 129 "./gb_miles.w"
;
/*11:*/
#line 217 "./gb_miles.w"

node_block= gb_typed_alloc(MAX_N,node,new_graph->aux_data);
distance= gb_typed_alloc(MAX_N*MAX_N,long,new_graph->aux_data);
if(gb_trouble_code){
gb_free(new_graph->aux_data);
panic(no_room+1);
}
if(gb_open("miles.dat")!=0)
panic(early_data_fault);


for(k= MAX_N-1;k>=0;k--)/*12:*/
#line 236 "./gb_miles.w"

{register node*p;
p= node_block+k;
p->kk= k;
if(k)p->link= p-1;
gb_string(p->name,'[');
if(gb_char()!='[')panic(syntax_error);
p->lat= gb_number(10);
if(p->lat<min_lat||p->lat> max_lat||gb_char()!=',')
panic(syntax_error+1);
p->lon= gb_number(10);
if(p->lon<min_lon||p->lon> max_lon||gb_char()!=']')
panic(syntax_error+2);
p->pop= gb_number(10);
if(p->pop<min_pop||p->pop> max_pop)
panic(syntax_error+3);
p->key= north_weight*(p->lat-min_lat)
+west_weight*(p->lon-min_lon)
+pop_weight*(p->pop-min_pop)+0x40000000;
/*13:*/
#line 261 "./gb_miles.w"

{
for(j= k+1;j<MAX_N;j++){
if(gb_char()!=' ')
gb_newline();
d(j,k)= d(k,j)= gb_number(10);
}
}

/*:13*/
#line 255 "./gb_miles.w"
;
gb_newline();
}

/*:12*/
#line 228 "./gb_miles.w"
;
if(gb_close()!=0)
panic(late_data_fault);


/*:11*/
#line 130 "./gb_miles.w"
;
/*14:*/
#line 279 "./gb_miles.w"

{register node*p;
register Vertex*v= new_graph->vertices;
gb_linksort(node_block+MAX_N-1);
for(j= 127;j>=0;j--)
for(p= (node*)gb_sorted[j];p;p= p->link){
if(v<new_graph->vertices+n)/*15:*/
#line 308 "./gb_miles.w"

{
v->x_coord= max_lon-p->lon;
v->y_coord= p->lat-min_lat;
v->y_coord+= (v->y_coord)>>1;
v->index_no= p->kk;
v->people= p->pop;
v->name= gb_save_string(p->name);
v++;
}

/*:15*/
#line 285 "./gb_miles.w"

else p->pop= 0;
}
}

/*:14*/
#line 131 "./gb_miles.w"
;
/*17:*/
#line 330 "./gb_miles.w"

if(max_distance> 0||max_degree> 0)
/*18:*/
#line 344 "./gb_miles.w"

{register node*p;
if(max_degree==0)max_degree= MAX_N;
if(max_distance==0)max_distance= 30000;
for(p= node_block;p<node_block+MAX_N;p++)
if(p->pop){
k= p->kk;
/*19:*/
#line 360 "./gb_miles.w"

{register node*q;
register node*s= NULL;
for(q= node_block;q<node_block+MAX_N;q++)
if(q->pop&&q!=p){
j= d(k,q->kk);
if(j> max_distance)
d(k,q->kk)= -j;
else{
q->key= max_distance-j;
q->link= s;
s= q;
}
}
gb_linksort(s);

j= 0;
for(q= (node*)gb_sorted[0];q;q= q->link)
if(++j> max_degree)
d(k,q->kk)= -d(k,q->kk);
}

/*:19*/
#line 351 "./gb_miles.w"
;
}
}

/*:18*/
#line 332 "./gb_miles.w"
;
{register Vertex*u,*v;
for(u= new_graph->vertices;u<new_graph->vertices+n;u++){
j= u->index_no;
for(v= u+1;v<new_graph->vertices+n;v++){
k= v->index_no;
if(d(j,k)> 0&&d(k,j)> 0)
gb_new_edge(u,v,d(j,k));
}
}
}

/*:17*/
#line 132 "./gb_miles.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
return new_graph;
}

/*:5*//*20:*/
#line 393 "./gb_miles.w"
long miles_distance(u,v)
Vertex*u,*v;
{
return d(u->index_no,v->index_no);
}

/*:20*/
