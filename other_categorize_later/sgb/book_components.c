/*2:*/
#line 50 "./book_components.w"

#include "gb_graph.h" 
#include "gb_books.h" 
#include "gb_io.h" 
#include "gb_save.h" 
#define rank z.I \

#define parent y.V \

#define untagged x.A \
 \

#define link w.V \

#define min v.V \


#line 55 "./book_components.w"

/*7:*/
#line 163 "./book_components.w"

long nn;

/*:7*//*8:*/
#line 179 "./book_components.w"

Vertex dummy;

/*:8*//*10:*/
#line 206 "./book_components.w"

Vertex*active_stack;

/*:10*//*13:*/
#line 294 "./book_components.w"

Vertex*vv;

/*:13*//*20:*/
#line 435 "./book_components.w"

Vertex*artic_pt;


/*:20*/
#line 56 "./book_components.w"

/*4:*/
#line 108 "./book_components.w"

char*filename= NULL;
char code_name[3][3];
char*vertex_name(v,i)
Vertex*v;
char i;
{
if(filename)return v->name;
code_name[i][0]= imap_chr(v->short_code/36);
code_name[i][1]= imap_chr(v->short_code%36);
return code_name[i];
}

/*:4*/
#line 57 "./book_components.w"

main(argc,argv)
int argc;
char*argv[];
{Graph*g;
register Vertex*v;
char*t= "anna";
unsigned long n= 0;
unsigned long x= 0;
unsigned long f= 0;
unsigned long l= 0;
long i= 1;
long o= 1;
long s= 0;
/*3:*/
#line 85 "./book_components.w"

while(--argc){

if(strncmp(argv[argc],"-t",2)==0)t= argv[argc]+2;
else if(sscanf(argv[argc],"-n%lu",&n)==1);
else if(sscanf(argv[argc],"-x%lu",&x)==1);
else if(sscanf(argv[argc],"-f%lu",&f)==1);
else if(sscanf(argv[argc],"-l%lu",&l)==1);
else if(sscanf(argv[argc],"-i%ld",&i)==1);
else if(sscanf(argv[argc],"-o%ld",&o)==1);
else if(sscanf(argv[argc],"-s%ld",&s)==1);
else if(strcmp(argv[argc],"-v")==0)verbose= 1;
else if(strcmp(argv[argc],"-V")==0)verbose= 2;
else if(strncmp(argv[argc],"-g",2)==0)filename= argv[argc]+2;
else{
fprintf(stderr,
"Usage: %s [-ttitle][-nN][-xN][-fN][-lN][-iN][-oN][-sN][-v][-gfoo]\n",
argv[0]);
return-2;
}
}
if(filename)verbose= 0;

/*:3*/
#line 71 "./book_components.w"
;
if(filename)g= restore_graph(filename);
else g= book(t,n,x,f,l,i,o,s);
if(g==NULL){
fprintf(stderr,"Sorry, can't create the graph! (error code %ld)\n",
panic_code);
return-1;
}
printf("Biconnectivity analysis of %s\n\n",g->id);
if(verbose)/*5:*/
#line 121 "./book_components.w"

{
for(v= g->vertices;v<g->vertices+g->n;v++){
if(verbose==1)printf("%s=%s\n",vertex_name(v,0),v->name);
else printf("%s=%s, %s [weight %ld]\n",vertex_name(v,0),v->name,v->desc,
i*v->in_count+o*v->out_count);
}
printf("\n");
}

/*:5*/
#line 80 "./book_components.w"
;
/*12:*/
#line 287 "./book_components.w"

/*14:*/
#line 300 "./book_components.w"

for(v= g->vertices;v<g->vertices+g->n;v++){
v->rank= 0;
v->untagged= v->arcs;
}
nn= 0;
active_stack= NULL;
dummy.rank= 0;

/*:14*/
#line 288 "./book_components.w"
;
for(vv= g->vertices;vv<g->vertices+g->n;vv++)
if(vv->rank==0)
/*15:*/
#line 312 "./book_components.w"

{
v= vv;
v->parent= &dummy;
/*16:*/
#line 322 "./book_components.w"

v->rank= ++nn;
v->link= active_stack;
active_stack= v;
v->min= v->parent;

/*:16*/
#line 316 "./book_components.w"
;
do/*17:*/
#line 335 "./book_components.w"

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
/*16:*/
#line 322 "./book_components.w"

v->rank= ++nn;
v->link= active_stack;
active_stack= v;
v->min= v->parent;

/*:16*/
#line 347 "./book_components.w"
;
}
}else{
u= v->parent;
if(v->min==u)/*19:*/
#line 407 "./book_components.w"

if(u==&dummy){
if(artic_pt)
printf(" and %s (this ends a connected component of the graph)\n",
vertex_name(artic_pt,0));
else printf("Isolated vertex %s\n",vertex_name(v,0));
active_stack= artic_pt= NULL;
}else{register Vertex*t;

if(artic_pt)
printf(" and articulation point %s\n",vertex_name(artic_pt,0));
t= active_stack;
active_stack= v->link;
printf("Bicomponent %s",vertex_name(v,0));
if(t==v)putchar('\n');
else{
printf(" also includes:\n");
while(t!=v){
printf(" %s (from %s; ..to %s)\n",
vertex_name(t,0),vertex_name(t->parent,1),vertex_name(t->min,2));
t= t->link;
}
}
artic_pt= u;
}

/*:19*/
#line 353 "./book_components.w"

else

if(v->min->rank<u->min->rank)
u->min= v->min;
v= u;
}
}

/*:17*/
#line 318 "./book_components.w"

while(v!=&dummy);
}

/*:15*/
#line 292 "./book_components.w"
;

/*:12*/
#line 81 "./book_components.w"
;
return 0;
}

/*:2*/
