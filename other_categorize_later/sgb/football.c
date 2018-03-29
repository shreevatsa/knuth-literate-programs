/*2:*/
#line 53 "./football.w"

#include "gb_graph.h" 
#include "gb_games.h" 
#include "gb_flip.h" 
#define del a.I \

#define blocked u.I
#define valid v.V \

#define link w.V \

#define MAX_N 120 \

#define rank z.I
#define parent u.V
#define untagged x.A
#define min v.V \


#line 57 "./football.w"

/*10:*/
#line 188 "./football.w"

typedef struct node_struct{
Arc*game;
long tot_len;
struct node_struct*prev;
struct node_struct*next;

}node;

/*:10*/
#line 58 "./football.w"

/*4:*/
#line 88 "./football.w"

long width;
Graph*g;
Vertex*u,*v;
Arc*a;
Vertex*start,*goal;
long mm;

/*:4*//*11:*/
#line 197 "./football.w"

Area node_storage;
node*next_node;
node*bad_node;
node*cur_node;

/*:11*//*20:*/
#line 372 "./football.w"

node*list[MAX_N];
long size[MAX_N];
long m,h;
node*x;

/*:20*//*29:*/
#line 516 "./football.w"

Vertex*active_stack;
Vertex*settled_stack;
long nn;
Vertex dummy;

/*:29*/
#line 59 "./football.w"

/*7:*/
#line 139 "./football.w"

Vertex*prompt_for_team(s)
char*s;
{register char*q;
register Vertex*v;
char buffer[30];
while(1){
printf("%s team: ",s);
fflush(stdout);
fgets(buffer,30,stdin);
if(buffer[0]=='\n')return NULL;
buffer[29]= '\n';
for(q= buffer;*q!='\n';q++);
*q= '\0';
for(v= g->vertices;v<g->vertices+g->n;v++)
if(strcmp(buffer,v->name)==0)return v;
printf(" (Sorry, I don't know any team by that name.)\n");
printf(" (One team I do know is %s...)\n",
(g->vertices+gb_unif_rand(g->n))->name);
}
}

/*:7*//*13:*/
#line 206 "./football.w"

node*new_node(x,d)
node*x;
long d;
{
if(next_node==bad_node){
next_node= gb_typed_alloc(1000,node,node_storage);
if(next_node==NULL)return NULL;
bad_node= next_node+1000;
}
next_node->prev= x;
next_node->tot_len= (x?x->tot_len:0)+d;
return next_node++;
}

/*:13*/
#line 60 "./football.w"

main(argc,argv)
int argc;
char*argv[];
{
/*3:*/
#line 78 "./football.w"

if(argc==3&&strcmp(argv[2],"-v")==0)verbose= argc= 2;
if(argc==1)width= 0;
else if(argc==2&&sscanf(argv[1],"%ld",&width)==1){
if(width<0)width= -width;
}else{
fprintf(stderr,"Usage: %s [searchwidth]\n",argv[0]);
return-2;
}

/*:3*/
#line 65 "./football.w"
;
/*5:*/
#line 104 "./football.w"

g= games(0L,0L,0L,0L,0L,0L,0L,0L);

if(g==NULL){
fprintf(stderr,"Sorry, can't create the graph! (error code %ld)\n",
panic_code);
return-1;
}
for(v= g->vertices;v<g->vertices+g->n;v++)
for(a= v->arcs;a;a= a->next)
if(a->tip> v){
a->del= a->len-(a+1)->len;
(a+1)->del= -a->del;
}

/*:5*/
#line 66 "./football.w"
;
while(1){
/*6:*/
#line 123 "./football.w"

putchar('\n');
restart:
if((start= prompt_for_team("Starting"))==NULL)break;
if((goal= prompt_for_team("   Other"))==NULL)goto restart;
if(start==goal){
printf(" (Um, please give me the names of two DISTINCT teams.)\n");
goto restart;
}

/*:6*/
#line 68 "./football.w"
;
/*9:*/
#line 174 "./football.w"

/*12:*/
#line 203 "./football.w"

next_node= bad_node= NULL;

/*:12*/
#line 175 "./football.w"
;
if(width==0)/*17:*/
#line 280 "./football.w"

{
for(v= g->vertices;v<g->vertices+g->n;v++)v->blocked= 0,v->valid= NULL;
cur_node= NULL;
for(v= start;v!=goal;v= cur_node->game->tip){register long d= -10000;
register Arc*best_arc;
register Arc*last_arc;
v->blocked= 1;
cur_node= new_node(cur_node,0L);
if(cur_node==NULL){
fprintf(stderr,"Oops, there isn't enough memory!\n");return-2;
}
/*18:*/
#line 308 "./football.w"

u= goal;
u->link= NULL;
u->valid= v;
do{
for(a= u->arcs,u= u->link;a;a= a->next)
if(a->tip->blocked==0&&a->tip->valid!=v){
a->tip->valid= v;
a->tip->link= u;
u= a->tip;

}
}while(u);

/*:18*/
#line 292 "./football.w"
;
for(a= v->arcs;a;a= a->next)
if(a->del> d&&a->tip->valid==v)
if(a->tip==goal)last_arc= a;
else best_arc= a,d= a->del;
cur_node->game= (d==-10000?last_arc:best_arc);

cur_node->tot_len+= cur_node->game->del;
}
}

/*:17*/
#line 177 "./football.w"

else/*19:*/
#line 350 "./football.w"

{
/*21:*/
#line 378 "./football.w"

for(m= 0;m<g->n;m++)list[m]= NULL,size[m]= 0;

/*:21*/
#line 352 "./football.w"
;
cur_node= NULL;
m= g->n-1;
do{
/*27:*/
#line 477 "./football.w"

/*28:*/
#line 505 "./football.w"

for(v= g->vertices;v<g->vertices+g->n;v++){
v->rank= 0;
v->untagged= v->arcs;
}
for(x= cur_node;x;x= x->prev)
x->game->tip->rank= g->n;
start->rank= g->n;
nn= 0;
active_stack= settled_stack= NULL;

/*:28*/
#line 479 "./football.w"
;
/*30:*/
#line 526 "./football.w"

{
v= goal;
v->parent= &dummy;
/*31:*/
#line 538 "./football.w"

v->rank= ++nn;
v->link= active_stack;
active_stack= v;
v->min= v->parent;

/*:31*/
#line 530 "./football.w"
;
do/*32:*/
#line 545 "./football.w"

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
/*31:*/
#line 538 "./football.w"

v->rank= ++nn;
v->link= active_stack;
active_stack= v;
v->min= v->parent;

/*:31*/
#line 557 "./football.w"
;
}
}else{
u= v->parent;
if(v->min==u)/*33:*/
#line 589 "./football.w"

{if(v!=goal){register Vertex*t;

long c= 0;
t= active_stack;
while(t!=v){
c++;
t->parent= v;
t= t->link;
}
active_stack= v->link;
v->parent= v;
v->rank= c+g->n;
v->link= settled_stack;
settled_stack= v;
}
}

/*:33*/
#line 563 "./football.w"

else

if(v->min->rank<u->min->rank)
u->min= v->min;
v= u;
}
}

/*:32*/
#line 532 "./football.w"

while(v!=&dummy);
/*34:*/
#line 611 "./football.w"

while(settled_stack){
v= settled_stack;
settled_stack= v->link;
v->rank+= v->min->parent->rank+1-g->n;
}

/*:34*/
#line 535 "./football.w"
;
}

/*:30*/
#line 482 "./football.w"
;
for(a= (cur_node?cur_node->game->tip:start)->arcs;a;a= a->next)
if((u= a->tip)->untagged==NULL){
x= new_node(cur_node,a->del);
if(x==NULL){
fprintf(stderr,"Oops, there isn't enough memory!\n");return-3;
}
x->game= a;
/*35:*/
#line 620 "./football.w"

h= u->parent->rank;

/*:35*/
#line 490 "./football.w"
;
/*22:*/
#line 388 "./football.w"

if((h> 0&&size[h]==width)||(h==0&&size[0]> 0)){
if(x->tot_len<=list[h]->tot_len)goto done;
list[h]= list[h]->next;
}else size[h]++;
{register node*p,*q;
for(p= list[h],q= NULL;p;q= p,p= p->next)
if(x->tot_len<=p->tot_len)break;
x->next= p;
if(q)q->next= x;else list[h]= x;
}
done:;

/*:22*/
#line 491 "./football.w"
;
}

/*:27*/
#line 357 "./football.w"
;
while(list[m]==NULL)
/*23:*/
#line 403 "./football.w"

{register node*r= NULL,*s= list[--m],*t;
while(s)t= s->next,s->next= r,r= s,s= t;
list[m]= r;
mm= 0;
}

/*:23*/
#line 359 "./football.w"
;
cur_node= list[m];
list[m]= cur_node->next;
if(verbose)/*24:*/
#line 410 "./football.w"

{
cur_node->next= (node*)((++mm<<8)+m);
printf("[%lu,%lu]=[%lu,%lu]&%s (%+ld)\n",m,mm,
cur_node->prev?((unsigned long)cur_node->prev->next)&0xff:0L,
cur_node->prev?((unsigned long)cur_node->prev->next)>>8:0L,
cur_node->game->tip->name,cur_node->tot_len);
}

/*:24*/
#line 362 "./football.w"
;
}while(m> 0);
}

/*:19*/
#line 178 "./football.w"
;
/*15:*/
#line 235 "./football.w"

next_node= NULL;
do{register node*t;
t= cur_node;
cur_node= t->prev;
t->prev= next_node;
next_node= t;
}while(cur_node);
for(v= start;v!=goal;v= u,next_node= next_node->prev){
a= next_node->game;
u= a->tip;
/*16:*/
#line 250 "./football.w"

{register long d= a->date;
if(d<=5)printf(" Aug %02ld",d+26);
else if(d<=35)printf(" Sep %02ld",d-5);
else if(d<=66)printf(" Oct %02ld",d-35);
else if(d<=96)printf(" Nov %02ld",d-66);
else if(d<=127)printf(" Dec %02ld",d-96);
else printf(" Jan 01");
printf(": %s %s %ld, %s %s %ld",v->name,v->nickname,a->len,
u->name,u->nickname,a->len-a->del);
}

/*:16*/
#line 246 "./football.w"
;
printf(" (%+ld)\n",next_node->tot_len);
}

/*:15*/
#line 179 "./football.w"
;
/*14:*/
#line 221 "./football.w"

gb_free(node_storage);

/*:14*/
#line 180 "./football.w"
;

/*:9*/
#line 69 "./football.w"
;
}
return 0;
}

/*:2*/
