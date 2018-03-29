/*2:*/
#line 39 "./roget_components.w"

#include "gb_graph.h" 
#include "gb_roget.h" 
#include "gb_save.h" 
#define specs(v) (filename?v-g->vertices+1L:v->cat_no) ,v->name \
 \

#define rank z.I \

#define parent y.V \

#define untagged x.A \
 \

#define link w.V \

#define min v.V \

#define infinity g->n \

#define arc_from x.V \


#line 43 "./roget_components.w"

/*5:*/
#line 113 "./roget_components.w"

long nn;

/*:5*//*8:*/
#line 156 "./roget_components.w"

Vertex*active_stack;
Vertex*settled_stack;

/*:8*//*11:*/
#line 237 "./roget_components.w"

Vertex*vv;

/*:11*/
#line 44 "./roget_components.w"

main(argc,argv)
int argc;
char*argv[];
{Graph*g;
register Vertex*v;
unsigned long n= 0;
unsigned long d= 0;
unsigned long p= 0;
long s= 0;
char*filename= NULL;
/*3:*/
#line 67 "./roget_components.w"

while(--argc){

if(sscanf(argv[argc],"-n%lu",&n)==1);
else if(sscanf(argv[argc],"-d%lu",&d)==1);
else if(sscanf(argv[argc],"-p%lu",&p)==1);
else if(sscanf(argv[argc],"-s%ld",&s)==1);
else if(strncmp(argv[argc],"-g",2)==0)filename= argv[argc]+2;
else{
fprintf(stderr,"Usage: %s [-nN][-dN][-pN][-sN][-gfoo]\n",argv[0]);
return-2;
}
}

/*:3*/
#line 55 "./roget_components.w"
;
g= (filename?restore_graph(filename):roget(n,d,p,s));
if(g==NULL){
fprintf(stderr,"Sorry, can't create the graph! (error code %ld)\n",
panic_code);
return-1;
}
printf("Reachability analysis of %s\n\n",g->id);
/*10:*/
#line 228 "./roget_components.w"

/*12:*/
#line 243 "./roget_components.w"

for(v= g->vertices+g->n-1;v>=g->vertices;v--){
v->rank= 0;
v->untagged= v->arcs;
}
nn= 0;
active_stack= settled_stack= NULL;

/*:12*/
#line 229 "./roget_components.w"
;
for(vv= g->vertices;vv<g->vertices+g->n;vv++)
if(vv->rank==0)
/*13:*/
#line 254 "./roget_components.w"

{
v= vv;
v->parent= NULL;
/*14:*/
#line 264 "./roget_components.w"

v->rank= ++nn;
v->link= active_stack;
active_stack= v;
v->min= v;

/*:14*/
#line 258 "./roget_components.w"
;
do/*15:*/
#line 277 "./roget_components.w"

{register Vertex*u;
register Arc*a= v->untagged;
if(a){
u= a->tip;
v->untagged= a->next;
if(u->rank){
if(u->rank<v->min->rank)
v->min= u;
}else{
u->parent= v;
v= u;
/*14:*/
#line 264 "./roget_components.w"

v->rank= ++nn;
v->link= active_stack;
active_stack= v;
v->min= v;

/*:14*/
#line 289 "./roget_components.w"
;
}
}else{
u= v->parent;
if(v->min==v)/*16:*/
#line 347 "./roget_components.w"

{register Vertex*t;

t= active_stack;
active_stack= v->link;
v->link= settled_stack;
settled_stack= t;
printf("Strong component `%ld %s'",specs(v));
if(t==v)putchar('\n');
else{
printf(" also includes:\n");
while(t!=v){
printf(" %ld %s (from %ld %s; ..to %ld %s)\n",
specs(t),specs(t->parent),specs(t->min));
t->rank= infinity;
t->parent= v;
t= t->link;
}
}
v->rank= infinity;
v->parent= v;
}

/*:16*/
#line 294 "./roget_components.w"

else

if(v->min->rank<u->min->rank)
u->min= v->min;
v= u;
}
}

/*:15*/
#line 260 "./roget_components.w"

while(v!=NULL);
}

/*:13*/
#line 233 "./roget_components.w"
;
/*17:*/
#line 383 "./roget_components.w"

printf("\nLinks between components:\n");
for(v= settled_stack;v;v= v->link){register Vertex*u= v->parent;
register Arc*a;
u->arc_from= u;
for(a= v->arcs;a;a= a->next){register Vertex*w= a->tip->parent;
if(w->arc_from!=u){
w->arc_from= u;
printf("%ld %s -> %ld %s (e.g., %ld %s -> %ld %s)\n",
specs(u),specs(w),specs(v),specs(a->tip));
}
}
}

/*:17*/
#line 235 "./roget_components.w"
;

/*:10*/
#line 63 "./roget_components.w"
;
return 0;
}

/*:2*/
