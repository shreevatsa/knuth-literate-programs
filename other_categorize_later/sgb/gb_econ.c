/*7:*/
#line 180 "./gb_econ.w"

#include "gb_io.h" 
#include "gb_flip.h"

#include "gb_graph.h"

#define flow a.I \

#define MAX_N 81
#define NORM_N MAX_N-2
#define ADJ_SEC MAX_N-1 \

#define SIC_codes z.A \

#define sector_total y.I \

#define panic(c) {panic_code= c;gb_trouble_code= 0;return NULL;} \


#line 186 "./gb_econ.w"

/*11:*/
#line 246 "./gb_econ.w"

typedef struct node_struct{
struct node_struct*rchild;
char title[44];
long table[MAX_N+1];
unsigned long total;
long thresh;
long SIC;
long tag;
struct node_struct*link;
Arc*SIC_list;
}node;

/*:11*/
#line 187 "./gb_econ.w"

/*12:*/
#line 264 "./gb_econ.w"

static node*stack[NORM_N+NORM_N];
static node**stack_ptr;
static node*node_block;
static node*node_index[MAX_N+1];

/*:12*//*26:*/
#line 558 "./gb_econ.w"

static Vertex*vert_index[MAX_N+1];

/*:26*/
#line 188 "./gb_econ.w"


Graph*econ(n,omit,threshold,seed)
unsigned long n;
unsigned long omit;
unsigned long threshold;
long seed;
{/*8:*/
#line 214 "./gb_econ.w"

Graph*new_graph;
register long j,k;
Area working_storage;

/*:8*//*13:*/
#line 270 "./gb_econ.w"

register node*p,*pl,*pr;
register node*q;

/*:13*/
#line 195 "./gb_econ.w"

gb_init_rand(seed);
init_area(working_storage);
/*9:*/
#line 219 "./gb_econ.w"

if(omit> 2)omit= 2;
if(n==0||n> MAX_N-omit)n= MAX_N-omit;
else if(n+omit<3)omit= 3-n;
if(threshold> 65536)threshold= 65536;

/*:9*/
#line 198 "./gb_econ.w"
;
/*10:*/
#line 225 "./gb_econ.w"

new_graph= gb_new_graph(n);
if(new_graph==NULL)
panic(no_room);
sprintf(new_graph->id,"econ(%lu,%lu,%lu,%ld)",n,omit,threshold,seed);
strcpy(new_graph->util_types,"ZZZZIAIZZZZZZZ");

/*:10*/
#line 199 "./gb_econ.w"
;
/*14:*/
#line 274 "./gb_econ.w"

node_block= gb_typed_alloc(2*MAX_N-3,node,working_storage);
if(gb_trouble_code)panic(no_room+1);
if(gb_open("econ.dat")!=0)
panic(early_data_fault);

/*15:*/
#line 300 "./gb_econ.w"

stack_ptr= stack;
for(p= node_block;p<node_block+NORM_N+NORM_N-1;p++){register long c;
gb_string(p->title,':');
if(strlen(p->title)> 43)panic(syntax_error);
if(gb_char()!=':')panic(syntax_error+1);
p->SIC= c= gb_number(10);
if(c==0)
*stack_ptr++= p;
else{
node_index[c]= p;
if(stack_ptr> stack)(*--stack_ptr)->rchild= p+1;
}
if(gb_char()!='\n')panic(syntax_error+2);
gb_newline();
}
if(stack_ptr!=stack)panic(syntax_error+3);
for(k= NORM_N;k;k--)if(node_index[k]==0)
panic(syntax_error+4);
strcpy(p->title,"Adjustments");p->SIC= ADJ_SEC;node_index[ADJ_SEC]= p;
strcpy((p+1)->title,"Users");node_index[MAX_N]= p+1;

/*:15*/
#line 280 "./gb_econ.w"
;
for(k= 1;k<=MAX_N;k++)
/*16:*/
#line 332 "./gb_econ.w"

{register long s= 0;
register long x;
if(gb_char()!='\n')panic(syntax_error+5);

gb_newline();
p= node_index[k];
for(j= 1;j<MAX_N;j++){
p->table[j]= x= gb_number(10);s+= x;
node_index[j]->total+= x;
if((j%10)==0){
if(gb_char()!='\n')panic(syntax_error+6);

gb_newline();
}else if(gb_char()!=',')panic(syntax_error+7);

}
p->table[MAX_N]= s;
}

/*:16*/
#line 282 "./gb_econ.w"
;

/*:14*/
#line 200 "./gb_econ.w"
;
/*17:*/
#line 358 "./gb_econ.w"

{long l= n+omit-2;
if(l==NORM_N)/*18:*/
#line 368 "./gb_econ.w"

for(k= NORM_N;k;k--)node_index[k]->tag= 1;

/*:18*/
#line 360 "./gb_econ.w"

else if(seed)/*21:*/
#line 443 "./gb_econ.w"

{
node_block->tag= l;
for(p= node_index[ADJ_SEC]-1;p> node_block;p--)
if(p->rchild)/*22:*/
#line 465 "./gb_econ.w"

{
pl= p+1;pr= p->rchild;
p->table[1]= p->table[2]= 1;
if(pl->rchild==0){
if(pr->rchild==0)p->table[0]= 2;
else{
for(k= 2;k<=pr->table[0];k++)p->table[1+k]= pr->table[k];
p->table[0]= pr->table[0]+1;
}
}else if(pr->rchild==0){
for(k= 2;k<=pl->table[0];k++)p->table[1+k]= pl->table[k];
p->table[0]= pl->table[0]+1;
}else{
/*23:*/
#line 485 "./gb_econ.w"

p->table[2]= 0;
for(j= pl->table[0];j;j--){register long t= pl->table[j];
for(k= pr->table[0];k;k--)
p->table[j+k]+= t*pr->table[k];
}

/*:23*/
#line 480 "./gb_econ.w"
;
p->table[0]= pl->table[0]+pr->table[0];
}
}

/*:22*/
#line 447 "./gb_econ.w"
;
for(p= node_block;p<node_index[ADJ_SEC];p++)
if(p->tag> 1){
l= p->tag;
pl= p+1;pr= p->rchild;
if(pl->rchild==NULL){
pl->tag= 1;pr->tag= l-1;
}else if(pr->rchild==NULL){
pl->tag= l-1;pr->tag= 1;
}else/*24:*/
#line 492 "./gb_econ.w"

{register long ss,rr;
j= 0;
if(p==node_block){
ss= 0;
if(l> 29&&l<67){
j= 1;
for(k= (l> pr->table[0]?l-pr->table[0]:1);k<=pl->table[0]&&k<l;k++)
ss+= ((pl->table[k]+0x3ff)>>10)*pr->table[l-k];

}else
for(k= (l> pr->table[0]?l-pr->table[0]:1);k<=pl->table[0]&&k<l;k++)
ss+= pl->table[k]*pr->table[l-k];
}else ss= p->table[l];
rr= gb_unif_rand(ss);
if(j)
for(ss= 0,k= (l> pr->table[0]?l-pr->table[0]:1);ss<=rr;k++)
ss+= ((pl->table[k]+0x3ff)>>10)*pr->table[l-k];
else for(ss= 0,k= (l> pr->table[0]?l-pr->table[0]:1);ss<=rr;k++)
ss+= pl->table[k]*pr->table[l-k];
pl->tag= k-1;pr->tag= l-k+1;
}

/*:24*/
#line 457 "./gb_econ.w"
;
}
}

/*:21*/
#line 361 "./gb_econ.w"

else/*19:*/
#line 383 "./gb_econ.w"

{register node*special= node_index[MAX_N];

for(p= node_index[ADJ_SEC]-1;p>=node_block;p--)
if(p->rchild)
p->total= (p+1)->total+p->rchild->total;
special->link= node_block;node_block->link= special;
k= 1;
while(k<l)/*20:*/
#line 397 "./gb_econ.w"

{
p= special->link;
special->link= p->link;
if(p->rchild==0)p->tag= 1;
else{
pl= p+1;pr= p->rchild;
for(q= special;q->link->total> pl->total;q= q->link);
pl->link= q->link;q->link= pl;
for(q= special;q->link->total> pr->total;q= q->link);
pr->link= q->link;q->link= pr;
k++;
}
}

/*:20*/
#line 392 "./gb_econ.w"
;
for(p= special->link;p!=special;p= p->link)
p->tag= 1;
}

/*:19*/
#line 362 "./gb_econ.w"
;
}

/*:17*/
#line 201 "./gb_econ.w"
;
/*25:*/
#line 532 "./gb_econ.w"

/*28:*/
#line 578 "./gb_econ.w"

for(p= node_index[ADJ_SEC];p>=node_block;p--){
if(p->SIC){
p->SIC_list= gb_virgin_arc();
p->SIC_list->len= p->SIC;
}else{
pl= p+1;pr= p->rchild;
if(p->tag==0)p->tag= pl->tag+pr->tag;
if(p->tag<=1)/*29:*/
#line 590 "./gb_econ.w"

{register Arc*a= pl->SIC_list;
register long jj= pl->SIC,kk= pr->SIC;
p->SIC_list= a;
while(a->next)a= a->next;
a->next= pr->SIC_list;
for(k= MAX_N;k;k--)
if((q= node_index[k])!=NULL){
if(q!=pl&&q!=pr)q->table[jj]+= q->table[kk];
p->table[k]= pl->table[k]+pr->table[k];
}
p->total= pl->total+pr->total;
p->SIC= jj;
p->table[jj]+= p->table[kk];
node_index[jj]= p;
node_index[kk]= NULL;
}

/*:29*/
#line 586 "./gb_econ.w"
;
}
}

/*:28*/
#line 534 "./gb_econ.w"
;
/*30:*/
#line 624 "./gb_econ.w"

if(omit==2)node_index[ADJ_SEC]= node_index[MAX_N]= NULL;
else if(omit==1)node_index[MAX_N]= NULL;
else{
for(k= ADJ_SEC;k;k--)
if((p= node_index[k])!=NULL)p->table[MAX_N]= p->total-p->table[MAX_N];
p= node_index[MAX_N];
p->total= p->table[MAX_N];
p->table[MAX_N]= 0;
}

/*:30*/
#line 535 "./gb_econ.w"
;
/*27:*/
#line 569 "./gb_econ.w"

for(k= MAX_N;k;k--)
if((p= node_index[k])!=NULL){
if(threshold==0)p->thresh= -99999999;
else p->thresh= ((p->total>>16)*threshold)+
(((p->total&0xffff)*threshold)>>16);
}

/*:27*/
#line 536 "./gb_econ.w"
;
{register Vertex*v= new_graph->vertices+n;
for(k= MAX_N;k;k--)
if((p= node_index[k])!=NULL){
vert_index[k]= --v;
v->name= gb_save_string(p->title);
v->SIC_codes= p->SIC_list;
v->sector_total= p->total;
}else vert_index[k]= NULL;
if(v!=new_graph->vertices)
panic(impossible);
for(j= MAX_N;j;j--)
if((p= node_index[j])!=NULL){register Vertex*u= vert_index[j];
for(k= MAX_N;k;k--)
if((v= vert_index[k])!=NULL)
if(p->table[k]!=0&&p->table[k]> node_index[k]->thresh){
gb_new_arc(u,v,1L);
u->arcs->flow= p->table[k];
}
}
}

/*:25*/
#line 202 "./gb_econ.w"
;
if(gb_close()!=0)
panic(late_data_fault);

gb_free(working_storage);
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
return new_graph;
}

/*:7*/
