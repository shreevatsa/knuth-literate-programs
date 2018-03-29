/*3:*/
#line 42 "./gb_graph.w"

#ifdef SYSV
#include <string.h> 
#else
#include <strings.h> 
#endif
#include <stdio.h> 
#include <stdlib.h> 
#define gb_typed_alloc(n,t,s) (t*) gb_alloc((long) ((n) *sizeof(t) ) ,s)  \

#define n_1 uu.I \

#define arcs_per_block 102 \

#define gb_new_graph gb_nugraph
#define gb_new_arc gb_nuarc
#define gb_new_edge gb_nuedge \

#define string_block_size 1016 \

#define hash_link u.V
#define hash_head v.V \

#define HASH_MULT 314159
#define HASH_PRIME 516595003 \


#line 50 "./gb_graph.w"

/*8:*/
#line 136 "./gb_graph.w"

typedef union{
struct vertex_struct*V;
struct arc_struct*A;
struct graph_struct*G;
char*S;
long I;
}util;

/*:8*//*9:*/
#line 162 "./gb_graph.w"

typedef struct vertex_struct{
struct arc_struct*arcs;
char*name;
util u,v,w,x,y,z;
}Vertex;

/*:9*//*10:*/
#line 181 "./gb_graph.w"

typedef struct arc_struct{
struct vertex_struct*tip;
struct arc_struct*next;
long len;
util a,b;
}Arc;

/*:10*//*12:*/
#line 234 "./gb_graph.w"

#define init_area(s)  *s= NULL
struct area_pointers{
char*first;
struct area_pointers*next;

};

typedef struct area_pointers*Area[1];

/*:12*//*20:*/
#line 377 "./gb_graph.w"

#define ID_FIELD_SIZE 161
typedef struct graph_struct{
Vertex*vertices;
long n;
long m;
char id[ID_FIELD_SIZE];
char util_types[15];
Area data;
Area aux_data;
util uu,vv,ww,xx,yy,zz;
}Graph;

/*:20*//*34:*/
#line 670 "./gb_graph.w"

typedef unsigned long siz_t;


/*:34*/
#line 51 "./gb_graph.w"

/*28:*/
#line 521 "./gb_graph.w"

static Arc*next_arc;
static Arc*bad_arc;
static char*next_string;
static char*bad_string;
static Arc dummy_arc[2];
static Graph dummy_graph;
static Graph*cur_graph= &dummy_graph;

/*:28*/
#line 52 "./gb_graph.w"

/*5:*/
#line 79 "./gb_graph.w"

long verbose= 0;
long panic_code= 0;

/*:5*//*14:*/
#line 289 "./gb_graph.w"

long gb_trouble_code= 0;

/*:14*//*24:*/
#line 470 "./gb_graph.w"

long extra_n= 4;
char null_string[1];

/*:24*//*32:*/
#line 654 "./gb_graph.w"

siz_t edge_trick= sizeof(Arc)-(sizeof(Arc)&(sizeof(Arc)-1));

/*:32*/
#line 53 "./gb_graph.w"

/*13:*/
#line 267 "./gb_graph.w"

char*gb_alloc(n,s)
long n;
Area s;
{long m= sizeof(char*);
Area t;
char*loc;
if(n<=0||n> 0xffff00-2*m){
gb_trouble_code|= 2;
return NULL;
}
n= ((n+m-1)/m)*m;
loc= (char*)calloc((unsigned)((n+2*m+255)/256),256);
if(loc){
*t= (struct area_pointers*)(loc+n);
(*t)->first= loc;
(*t)->next= *s;
*s= *t;
}else gb_trouble_code|= 1;
return loc;
}

/*:13*//*16:*/
#line 298 "./gb_graph.w"

void gb_free(s)
Area s;
{Area t;
while(*s){
*t= (*s)->next;
free((*s)->first);
*s= *t;
}
}

/*:16*//*23:*/
#line 443 "./gb_graph.w"

Graph*gb_new_graph(n)
long n;
{
cur_graph= (Graph*)calloc(1,sizeof(Graph));
if(cur_graph){
cur_graph->vertices= gb_typed_alloc(n+extra_n,Vertex,cur_graph->data);
if(cur_graph->vertices){Vertex*p;
cur_graph->n= n;
for(p= cur_graph->vertices+n+extra_n-1;p>=cur_graph->vertices;p--)
p->name= null_string;
sprintf(cur_graph->id,"gb_new_graph(%ld)",n);
strcpy(cur_graph->util_types,"ZZZZZZZZZZZZZZ");
}else{
free((char*)cur_graph);
cur_graph= NULL;
}
}
next_arc= bad_arc= NULL;
next_string= bad_string= NULL;
gb_trouble_code= 0;
return cur_graph;
}

/*:23*//*26:*/
#line 486 "./gb_graph.w"

void make_compound_id(g,s1,gg,s2)
Graph*g;
char*s1;
Graph*gg;
char*s2;
{int avail= ID_FIELD_SIZE-strlen(s1)-strlen(s2);
char tmp[ID_FIELD_SIZE];
strcpy(tmp,gg->id);
if(strlen(tmp)<avail)sprintf(g->id,"%s%s%s",s1,tmp,s2);
else sprintf(g->id,"%s%.*s...)%s",s1,avail-5,tmp,s2);
}

/*:26*//*27:*/
#line 499 "./gb_graph.w"

void make_double_compound_id(g,s1,gg,s2,ggg,s3)

Graph*g;
char*s1;
Graph*gg;
char*s2;
Graph*ggg;
char*s3;
{int avail= ID_FIELD_SIZE-strlen(s1)-strlen(s2)-strlen(s3);
if(strlen(gg->id)+strlen(ggg->id)<avail)
sprintf(g->id,"%s%s%s%s%s",s1,gg->id,s2,ggg->id,s3);
else sprintf(g->id,"%s%.*s...)%s%.*s...)%s",s1,avail/2-5,gg->id,
s2,(avail-9)/2,ggg->id,s3);
}

/*:27*//*29:*/
#line 550 "./gb_graph.w"

Arc*gb_virgin_arc()
{register Arc*cur_arc= next_arc;
if(cur_arc==bad_arc){
cur_arc= gb_typed_alloc(arcs_per_block,Arc,cur_graph->data);
if(cur_arc==NULL)
cur_arc= dummy_arc;
else{
next_arc= cur_arc+1;
bad_arc= cur_arc+arcs_per_block;
}
}
else next_arc++;
return cur_arc;
}

/*:29*//*30:*/
#line 582 "./gb_graph.w"

void gb_new_arc(u,v,len)
Vertex*u,*v;
long len;
{register Arc*cur_arc= gb_virgin_arc();
cur_arc->tip= v;cur_arc->next= u->arcs;cur_arc->len= len;
u->arcs= cur_arc;
cur_graph->m++;
}

/*:30*//*31:*/
#line 627 "./gb_graph.w"

void gb_new_edge(u,v,len)
Vertex*u,*v;
long len;
{register Arc*cur_arc= gb_virgin_arc();
if(cur_arc!=dummy_arc)next_arc++;
if(u<v){
cur_arc->tip= v;cur_arc->next= u->arcs;
(cur_arc+1)->tip= u;(cur_arc+1)->next= v->arcs;
u->arcs= cur_arc;v->arcs= cur_arc+1;
}else{
(cur_arc+1)->tip= v;(cur_arc+1)->next= u->arcs;
u->arcs= cur_arc+1;
cur_arc->tip= u;cur_arc->next= v->arcs;
v->arcs= cur_arc;
}
cur_arc->len= (cur_arc+1)->len= len;
cur_graph->m+= 2;
}

/*:31*//*35:*/
#line 690 "./gb_graph.w"

char*gb_save_string(s)
register char*s;
{register char*p= s;
register long len;

while(*p++);
len= p-s;
p= next_string;
if(p+len> bad_string){
long size= string_block_size;
if(len> size)
size= len;
p= gb_alloc(size,cur_graph->data);
if(p==NULL)
return null_string;
bad_string= p+size;
}
while(*s)*p++= *s++;
*p++= '\0';
next_string= p;
return p-len;
}

/*:35*//*39:*/
#line 773 "./gb_graph.w"

void switch_to_graph(g)
Graph*g;
{
cur_graph->ww.A= next_arc;cur_graph->xx.A= bad_arc;
cur_graph->yy.S= next_string;cur_graph->zz.S= bad_string;
cur_graph= (g?g:&dummy_graph);
next_arc= cur_graph->ww.A;bad_arc= cur_graph->xx.A;
next_string= cur_graph->yy.S;bad_string= cur_graph->zz.S;
cur_graph->ww.A= NULL;
cur_graph->xx.A= NULL;
cur_graph->yy.S= NULL;
cur_graph->zz.S= NULL;
}

/*:39*//*40:*/
#line 791 "./gb_graph.w"

void gb_recycle(g)
Graph*g;
{
if(g){
gb_free(g->data);
gb_free(g->aux_data);
free((char*)g);
}
}

/*:40*//*44:*/
#line 856 "./gb_graph.w"

void hash_in(v)
Vertex*v;
{register char*t= v->name;
register Vertex*u;
/*45:*/
#line 884 "./gb_graph.w"

{register long h;
for(h= 0;*t;t++){
h+= (h^(h>>1))+HASH_MULT*(unsigned char)*t;
while(h>=HASH_PRIME)h-= HASH_PRIME;
}
u= cur_graph->vertices+(h%cur_graph->n);
}

/*:45*/
#line 861 "./gb_graph.w"
;
v->hash_link= u->hash_head;
u->hash_head= v;
}

/*:44*//*46:*/
#line 899 "./gb_graph.w"

Vertex*hash_out(s)
char*s;
{register char*t= s;
register Vertex*u;
/*45:*/
#line 884 "./gb_graph.w"

{register long h;
for(h= 0;*t;t++){
h+= (h^(h>>1))+HASH_MULT*(unsigned char)*t;
while(h>=HASH_PRIME)h-= HASH_PRIME;
}
u= cur_graph->vertices+(h%cur_graph->n);
}

/*:45*/
#line 904 "./gb_graph.w"
;
for(u= u->hash_head;u;u= u->hash_link)
if(strcmp(s,u->name)==0)return u;
return NULL;
}

/*:46*//*47:*/
#line 910 "./gb_graph.w"

void hash_setup(g)
Graph*g;
{Graph*save_cur_graph;
if(g&&g->n> 0){register Vertex*v;
save_cur_graph= cur_graph;
cur_graph= g;
for(v= g->vertices;v<g->vertices+g->n;v++)v->hash_head= NULL;
for(v= g->vertices;v<g->vertices+g->n;v++)hash_in(v);
g->util_types[0]= g->util_types[1]= 'V';

cur_graph= save_cur_graph;
}
}

/*:47*//*48:*/
#line 925 "./gb_graph.w"

Vertex*hash_lookup(s,g)
char*s;
Graph*g;
{Graph*save_cur_graph;
if(g&&g->n> 0){register Vertex*v;
save_cur_graph= cur_graph;
cur_graph= g;
v= hash_out(s);
cur_graph= save_cur_graph;
return v;
}
else return NULL;
}

/*:48*/
#line 54 "./gb_graph.w"


/*:3*/
