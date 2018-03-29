/*2:*/
#line 38 "./gb_rand.w"

#include "gb_graph.h" 
#include "gb_flip.h"

#define random_graph r_graph
#define random_bigraph r_bigraph
#define random_lengths r_lengths \

#define panic(c) {panic_code= c;gb_trouble_code= 0;return NULL;} \

#define dist_code(x) (x?"dist":"0")  \

#define rand_len (min_len==max_len?min_len:min_len+gb_unif_rand(max_len-min_len+1) )  \


#line 42 "./gb_rand.w"

/*8:*/
#line 189 "./gb_rand.w"

static char name_buffer[]= "9999999999";

/*:8*//*14:*/
#line 303 "./gb_rand.w"

typedef struct{
long prob;
long inx;
}magic_entry;

/*:14*//*17:*/
#line 359 "./gb_rand.w"

typedef struct node_struct{
long key;
struct node_struct*link;
long j;
}node;
static Area temp_nodes;
static node*base_node;

/*:17*//*25:*/
#line 546 "./gb_rand.w"

static char buffer[]= "1,-1000000001,-1000000000,dist,1000000000)";

/*:25*/
#line 43 "./gb_rand.w"

/*18:*/
#line 368 "./gb_rand.w"

static magic_entry*walker(n,nn,dist,g)
long n;
long nn;
register long*dist;

Graph*g;
{magic_entry*table;
long t;
node*hi= NULL,*lo= NULL;
register node*p,*q;
base_node= gb_typed_alloc(nn,node,temp_nodes);
table= gb_typed_alloc(nn,magic_entry,g->aux_data);
if(!gb_trouble_code){
/*19:*/
#line 391 "./gb_rand.w"

t= 0x40000000/nn;
p= base_node;
while(nn> n){
p->key= 0;
p->link= lo;
p->j= --nn;
lo= p++;
}
for(dist= dist+n-1;n> 0;dist--,p++){
p->key= *dist;
p->j= --n;
if(*dist> t)
p->link= hi,hi= p;
else p->link= lo,lo= p;
}

/*:19*/
#line 382 "./gb_rand.w"
;
while(hi)/*20:*/
#line 412 "./gb_rand.w"

{register magic_entry*r;register long x;
p= hi,hi= p->link;
q= lo,lo= q->link;
r= table+q->j;
x= t*q->j+q->key-1;
r->prob= x+x+1;
r->inx= p->j;


if((p->key-= t-q->key)> t)
p->link= hi,hi= p;
else p->link= lo,lo= p;
}

/*:20*/
#line 384 "./gb_rand.w"
;
while(lo)/*21:*/
#line 430 "./gb_rand.w"

{register magic_entry*r;register long x;
q= lo,lo= q->link;
r= table+q->j;
x= t*q->j+t-1;
r->prob= x+x+1;

}

/*:21*/
#line 385 "./gb_rand.w"
;
}
gb_free(temp_nodes);
return table;
}

/*:18*/
#line 44 "./gb_rand.w"

/*5:*/
#line 138 "./gb_rand.w"

Graph*random_graph(n,m,multi,self,directed,dist_from,dist_to,min_len,max_len,
seed)
unsigned long n;
unsigned long m;
long multi;
long self;
long directed;
long*dist_from;
long*dist_to;
long min_len,max_len;
long seed;
{/*6:*/
#line 170 "./gb_rand.w"

Graph*new_graph;
long mm;
register long k;

/*:6*//*12:*/
#line 282 "./gb_rand.w"

long nn= 1;
long kk= 31;
magic_entry*from_table,*to_table;

/*:12*/
#line 150 "./gb_rand.w"


if(n==0)panic(bad_specs);
if(min_len> max_len)panic(very_bad_specs);
if(((unsigned long)(max_len))-((unsigned long)(min_len))>=
((unsigned long)0x80000000))panic(bad_specs+1);
/*11:*/
#line 247 "./gb_rand.w"

{register long acc;
register long*p;
if(dist_from){
for(acc= 0,p= dist_from;p<dist_from+n;p++){
if(*p<0)panic(invalid_operand);

if(*p> 0x40000000-acc)panic(invalid_operand+1);

acc+= *p;
}
if(acc!=0x40000000)
panic(invalid_operand+2);
}
if(dist_to){
for(acc= 0,p= dist_to;p<dist_to+n;p++){
if(*p<0)panic(invalid_operand+5);

if(*p> 0x40000000-acc)panic(invalid_operand+6);

acc+= *p;
}
if(acc!=0x40000000)
panic(invalid_operand+7);
}
}

/*:11*/
#line 156 "./gb_rand.w"
;
gb_init_rand(seed);
/*7:*/
#line 177 "./gb_rand.w"

new_graph= gb_new_graph(n);
if(new_graph==NULL)
panic(no_room);
for(k= 0;k<n;k++){
sprintf(name_buffer,"%ld",k);
(new_graph->vertices+k)->name= gb_save_string(name_buffer);
}
sprintf(new_graph->id,"random_graph(%lu,%lu,%d,%d,%d,%s,%s,%ld,%ld,%ld)",
n,m,multi> 0?1:multi<0?-1:0,self?1:0,directed?1:0,
dist_code(dist_from),dist_code(dist_to),min_len,max_len,seed);

/*:7*/
#line 158 "./gb_rand.w"
;
/*13:*/
#line 287 "./gb_rand.w"

{
if(dist_from){
while(nn<n)nn+= nn,kk--;
from_table= walker(n,nn,dist_from,new_graph);
}
if(dist_to){
while(nn<n)nn+= nn,kk--;
to_table= walker(n,nn,dist_to,new_graph);
}
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
}

/*:13*/
#line 159 "./gb_rand.w"
;
for(mm= m;mm;mm--)
/*9:*/
#line 194 "./gb_rand.w"

{register Vertex*u,*v;
repeat:
if(dist_from)
/*15:*/
#line 312 "./gb_rand.w"

{register magic_entry*magic;
register long uu= gb_next_rand();
k= uu>>kk;
magic= from_table+k;
if(uu<=magic->prob)u= new_graph->vertices+k;
else u= new_graph->vertices+magic->inx;
}

/*:15*/
#line 198 "./gb_rand.w"

else u= new_graph->vertices+gb_unif_rand(n);
if(dist_to)
/*16:*/
#line 321 "./gb_rand.w"

{register magic_entry*magic;
register long uu= gb_next_rand();
k= uu>>kk;
magic= to_table+k;
if(uu<=magic->prob)v= new_graph->vertices+k;
else v= new_graph->vertices+magic->inx;
}

/*:16*/
#line 201 "./gb_rand.w"

else v= new_graph->vertices+gb_unif_rand(n);
if(u==v&&!self)goto repeat;
if(multi<=0)
/*10:*/
#line 221 "./gb_rand.w"

if(gb_trouble_code)goto trouble;
else{register Arc*a;
long len;
for(a= u->arcs;a;a= a->next)
if(a->tip==v)
if(multi==0)goto repeat;
else{
len= rand_len;
if(len<a->len){
a->len= len;
if(!directed){
if(u<=v)(a+1)->len= len;
else(a-1)->len= len;
}
}
goto done;
}
}

/*:10*/
#line 205 "./gb_rand.w"
;
if(directed)gb_new_arc(u,v,rand_len);
else gb_new_edge(u,v,rand_len);
done:;
}

/*:9*/
#line 161 "./gb_rand.w"
;
trouble:if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
gb_free(new_graph->aux_data);
return new_graph;
}

/*:5*//*22:*/
#line 453 "./gb_rand.w"

Graph*random_bigraph(n1,n2,m,multi,dist1,dist2,min_len,max_len,seed)
unsigned long n1,n2;
unsigned long m;
long multi;
long*dist1,*dist2;
long min_len,max_len;
long seed;
{unsigned long n= n1+n2;
Area new_dists;
long*dist_from,*dist_to;
Graph*new_graph;
init_area(new_dists);
if(n1==0||n2==0)panic(bad_specs);
if(min_len> max_len)panic(very_bad_specs);
if(((unsigned long)(max_len))-((unsigned long)(min_len))>=
((unsigned long)0x80000000))panic(bad_specs+1);
dist_from= gb_typed_alloc(n,long,new_dists);
dist_to= gb_typed_alloc(n,long,new_dists);
if(gb_trouble_code){
gb_free(new_dists);
panic(no_room+2);
}
/*23:*/
#line 492 "./gb_rand.w"

{register long*p,*q;
register long k;
p= dist1;q= dist_from;
if(p)
while(p<dist1+n1)*q++= *p++;
else for(k= 0;k<n1;k++)*q++= (0x40000000+k)/n1;
p= dist2;q= dist_to+n1;
if(p)
while(p<dist2+n2)*q++= *p++;
else for(k= 0;k<n2;k++)*q++= (0x40000000+k)/n2;
}

/*:23*/
#line 476 "./gb_rand.w"
;
new_graph= random_graph(n,m,multi,0L,0L,
dist_from,dist_to,min_len,max_len,seed);
sprintf(new_graph->id,"random_bigraph(%lu,%lu,%lu,%d,%s,%s,%ld,%ld,%ld)",
n1,n2,m,multi> 0?1:multi<0?-1:0,dist_code(dist1),dist_code(dist2),
min_len,max_len,seed);
mark_bipartite(new_graph,n1);
gb_free(new_dists);
return new_graph;
}

/*:22*//*24:*/
#line 522 "./gb_rand.w"

long random_lengths(g,directed,min_len,max_len,dist,seed)
Graph*g;
long directed;
long min_len,max_len;
long*dist;
long seed;
{register Vertex*u,*v;
register Arc*a;
long nn= 1,kk= 31;
magic_entry*dist_table;
if(g==NULL)return missing_operand;
gb_init_rand(seed);
if(min_len> max_len)return very_bad_specs;
if(((unsigned long)(max_len))-((unsigned long)(min_len))>=
((unsigned long)0x80000000))return bad_specs;
/*26:*/
#line 549 "./gb_rand.w"

if(dist){register long acc;
register long*p;
register long n= max_len-min_len+1;
for(acc= 0,p= dist;p<dist+n;p++){
if(*p<0)return-1;
if(*p> 0x40000000-acc)return 1;
acc+= *p;
}
if(acc!=0x40000000)return 2;
while(nn<n)nn+= nn,kk--;
dist_table= walker(n,nn,dist,g);
if(gb_trouble_code){
gb_trouble_code= 0;
return alloc_fault;
}
}

/*:26*/
#line 538 "./gb_rand.w"
;
sprintf(buffer,",%d,%ld,%ld,%s,%ld)",directed?1:0,
min_len,max_len,dist_code(dist),seed);
make_compound_id(g,"random_lengths(",g,buffer);
/*27:*/
#line 567 "./gb_rand.w"

for(u= g->vertices;u<g->vertices+g->n;u++)
for(a= u->arcs;a;a= a->next){
v= a->tip;
if(directed==0&&u> v)a->len= (a-1)->len;
else{register long len;
if(dist==0)len= rand_len;
else{long uu= gb_next_rand();
long k= uu>>kk;
magic_entry*magic= dist_table+k;
if(uu<=magic->prob)len= min_len+k;
else len= min_len+magic->inx;
}
a->len= len;
if(directed==0&&u==v&&a->next==a+1)(++a)->len= len;
}
}

/*:27*/
#line 542 "./gb_rand.w"
;
return 0;
}

/*:24*/
#line 45 "./gb_rand.w"


/*:2*/
