/*7:*/
#line 183 "./gb_gates.w"

#include "gb_flip.h"

#include "gb_graph.h"

#define val x.I
#define typ y.I
#define alt z.V
#define outs zz.A
#define is_boolean(v) ((unsigned long) (v) <=1) 
#define the_boolean(v) ((long) (v) ) 
#define tip_value(v) (is_boolean(v) ?the_boolean(v) :(v) ->val) 
#define AND '&'
#define OR '|'
#define NOT '~'
#define XOR '^' \

#define panic(c) {panic_code= c;gb_trouble_code= 0;return NULL;} \

#define start_prefix(s) strcpy(prefix,s) ;count= 0
#define numeric_prefix(a,b) sprintf(prefix,"%c%ld:",a,b) ;count= 0; \

#define DELAY 100L \

#define bar w.V
#define even_comp(s,v) ((s) &1?v:comp(v) )  \

#define first_of(n,t) new_vert(t) ;for(k= 1;k<n;k++) new_vert(t) ; \

#define do2(result,t,v1,v2)  \
{t1= v1;t2= v2; \
result= make2(t,t1,t2) ;}
#define do3(result,t,v1,v2,v3)  \
{t1= v1;t2= v2;t3= v3; \
result= make3(t,t1,t2,t3) ;}
#define do4(result,t,v1,v2,v3,v4)  \
{t1= v1;t2= v2;t3= v3;t4= v4; \
result= make4(t,t1,t2,t3,t4) ;}
#define do5(result,t,v1,v2,v3,v4,v5)  \
{t1= v1;t2= v2;t3= v3;t4= v4;t5= v5; \
result= make5(t,t1,t2,t3,t4,t5) ;} \

#define latchit(u,latch)  \
(latch) ->alt= make2(AND,u,run_bit)  \

#define bit z.I
#define print_gates p_gates \

#define foo x.V \

#define lnk w.V \

#define reverse_arc_list(alist)  \
{for(aa= alist,b= NULL;aa;b= aa,aa= a) { \
a= aa->next; \
aa->next= b; \
} \
alist= b;} \

#define a_pos(j) (j<m?j+1:m+5*((j-m) >>1) +3+(((j-m) &1) <<1) )  \

#define spec_gate(v,a,k,j,t)  \
v= next_vert++; \
sprintf(name_buf,"%c%ld:%ld",a,k,j) ; \
v->name= gb_save_string(name_buf) ; \
v->typ= t; \


#line 188 "./gb_gates.w"

/*12:*/
#line 429 "./gb_gates.w"

static Vertex*next_vert;
static char prefix[5];
static long count;
static char name_buf[100];

/*:12*/
#line 189 "./gb_gates.w"

/*48:*/
#line 1073 "./gb_gates.w"

unsigned long risc_state[18];

/*:48*/
#line 190 "./gb_gates.w"

/*11:*/
#line 411 "./gb_gates.w"

static Vertex*new_vert(t)
char t;
{register Vertex*v;
v= next_vert++;
if(count<0)v->name= gb_save_string(prefix);
else{
sprintf(name_buf,"%s%ld",prefix,count);
v->name= gb_save_string(name_buf);
count++;
}
v->typ= t;
return v;
}

/*:11*//*13:*/
#line 444 "./gb_gates.w"

static Vertex*make2(t,v1,v2)
char t;
Vertex*v1,*v2;
{register Vertex*v= new_vert(t);
gb_new_arc(v,v1,DELAY);
gb_new_arc(v,v2,DELAY);
return v;
}

static Vertex*make3(t,v1,v2,v3)
char t;
Vertex*v1,*v2,*v3;
{register Vertex*v= new_vert(t);
gb_new_arc(v,v1,DELAY);
gb_new_arc(v,v2,DELAY);
gb_new_arc(v,v3,DELAY);
return v;
}

static Vertex*make4(t,v1,v2,v3,v4)
char t;
Vertex*v1,*v2,*v3,*v4;
{register Vertex*v= new_vert(t);
gb_new_arc(v,v1,DELAY);
gb_new_arc(v,v2,DELAY);
gb_new_arc(v,v3,DELAY);
gb_new_arc(v,v4,DELAY);
return v;
}

static Vertex*make5(t,v1,v2,v3,v4,v5)
char t;
Vertex*v1,*v2,*v3,*v4,*v5;
{register Vertex*v= new_vert(t);
gb_new_arc(v,v1,DELAY);
gb_new_arc(v,v2,DELAY);
gb_new_arc(v,v3,DELAY);
gb_new_arc(v,v4,DELAY);
gb_new_arc(v,v5,DELAY);
return v;
}

/*:13*//*14:*/
#line 495 "./gb_gates.w"

static Vertex*comp(v)
Vertex*v;
{register Vertex*u;
if(v->bar)return v->bar;
u= next_vert++;
u->bar= v;v->bar= u;
sprintf(name_buf,"%s~",v->name);
u->name= gb_save_string(name_buf);
u->typ= NOT;
gb_new_arc(u,v,1L);
return u;
}

/*:14*//*15:*/
#line 513 "./gb_gates.w"

static Vertex*make_xor(u,v)
Vertex*u,*v;
{register Vertex*t1,*t2;
t1= make2(AND,u,comp(v));
t2= make2(AND,comp(u),v);
return make2(OR,t1,t2);
}

/*:15*//*38:*/
#line 875 "./gb_gates.w"

static void make_adder(n,x,y,z,carry,add)
unsigned long n;
Vertex*x[],*y[];
Vertex*z[];
Vertex*carry;
char add;
{register long k;
Vertex*t1,*t2,*t3,*t4;
if(!carry){
z[0]= make_xor(x[0],y[0]);
carry= make2(AND,even_comp(add,x[0]),y[0]);
k= 1;
}else k= 0;
for(;k<n;k++){
comp(x[k]);comp(y[k]);comp(carry);
do4(z[k],OR,
make3(AND,x[k],comp(y[k]),comp(carry)),
make3(AND,comp(x[k]),y[k],comp(carry)),
make3(AND,comp(x[k]),comp(y[k]),carry),
make3(AND,x[k],y[k],carry));
do3(carry,OR,
make2(AND,even_comp(add,x[k]),y[k]),
make2(AND,even_comp(add,x[k]),carry),
make2(AND,y[k],carry));
}
z[n]= carry;
}

/*:38*//*51:*/
#line 1145 "./gb_gates.w"

static Graph*reduce(g)
Graph*g;
{register Vertex*u,*v;
register Arc*a,*b;
Arc*aa,*bb;
Vertex*latch_ptr;
long n= 0;
Graph*new_graph;
Vertex*next_vert= NULL,*max_next_vert= NULL;
Arc*avail_arc= NULL;
Vertex*sentinel;
if(g==NULL)panic(missing_operand);
sentinel= g->vertices+g->n;
while(1){
latch_ptr= NULL;
for(v= g->vertices;v<sentinel;v++)
/*53:*/
#line 1188 "./gb_gates.w"

{
switch(v->typ){
case'L':v->v.V= latch_ptr;latch_ptr= v;break;
case'I':case'C':break;
case'=':u= v->alt;
if(u->typ=='=')
v->alt= u->alt;
else if(u->typ=='C'){
v->bit= u->bit;goto make_v_constant;
}
break;
case NOT:/*54:*/
#line 1216 "./gb_gates.w"

u= v->arcs->tip;
if(u->typ=='=')
u= v->arcs->tip= u->alt;
if(u->typ=='C'){
v->bit= 1-u->bit;goto make_v_constant;
}else if(u->bar){
v->alt= u->bar;goto make_v_eq;
}else{
u->bar= v;v->bar= u;goto done;
}

/*:54*/
#line 1200 "./gb_gates.w"
;
case AND:/*55:*/
#line 1228 "./gb_gates.w"

for(a= v->arcs,aa= NULL;a;a= a->next){
u= a->tip;
if(u->typ=='=')
u= a->tip= u->alt;
if(u->typ=='C'){
if(u->bit==0)goto make_v_0;
goto bypass_and;
}else for(b= v->arcs;b!=a;b= b->next){
if(b->tip==u)goto bypass_and;
if(b->tip==u->bar)goto make_v_0;
}
aa= a;continue;
bypass_and:if(aa)aa->next= a->next;
else v->arcs= a->next;
}
if(v->arcs==NULL)goto make_v_1;

/*:55*/
#line 1201 "./gb_gates.w"
;goto test_single_arg;
case OR:/*56:*/
#line 1246 "./gb_gates.w"

for(a= v->arcs,aa= NULL;a;a= a->next){
u= a->tip;
if(u->typ=='=')
u= a->tip= u->alt;
if(u->typ=='C'){
if(u->bit)goto make_v_1;
goto bypass_or;
}else for(b= v->arcs;b!=a;b= b->next){
if(b->tip==u)goto bypass_or;
if(b->tip==u->bar)goto make_v_1;
}
aa= a;continue;
bypass_or:if(aa)aa->next= a->next;
else v->arcs= a->next;
}
if(v->arcs==NULL)goto make_v_0;

/*:56*/
#line 1202 "./gb_gates.w"
;goto test_single_arg;
case XOR:/*57:*/
#line 1264 "./gb_gates.w"

{long cmp= 0;
for(a= v->arcs,aa= NULL;a;a= a->next){
u= a->tip;
if(u->typ=='=')
u= a->tip= u->alt;
if(u->typ=='C'){
if(u->bit)cmp= 1-cmp;
goto bypass_xor;
}else for(bb= NULL,b= v->arcs;b!=a;b= b->next){
if(b->tip==u)goto double_bypass;
if(b->tip==u->bar){
cmp= 1-cmp;
goto double_bypass;
}
bb= b;continue;
double_bypass:if(bb)bb->next= b->next;
else v->arcs= b->next;
goto bypass_xor;
}
aa= a;continue;
bypass_xor:if(aa)aa->next= a->next;
else v->arcs= a->next;
a->a.A= avail_arc;
avail_arc= a;
}
if(v->arcs==NULL){
v->bit= cmp;
goto make_v_constant;
}
if(cmp)/*58:*/
#line 1297 "./gb_gates.w"

{
for(a= v->arcs;;a= a->next){
u= a->tip;
if(u->bar)break;
if(a->next==NULL){
/*59:*/
#line 1318 "./gb_gates.w"

if(next_vert==max_next_vert){
next_vert= gb_typed_alloc(7,Vertex,g->aux_data);
if(next_vert==NULL){
gb_recycle(g);
panic(no_room+1);
}
max_next_vert= next_vert+7;
}
next_vert->typ= NOT;
sprintf(name_buf,"%s~",u->name);
next_vert->name= gb_save_string(name_buf);
next_vert->arcs= avail_arc;
avail_arc->tip= u;
avail_arc= avail_arc->a.A;
next_vert->arcs->next= NULL;
next_vert->bar= u;
next_vert->foo= u->foo;
u->foo= u->bar= next_vert++;

/*:59*/
#line 1303 "./gb_gates.w"
;
break;
}
}
a->tip= u->bar;
}

/*:58*/
#line 1294 "./gb_gates.w"
;
}

/*:57*/
#line 1203 "./gb_gates.w"
;
test_single_arg:if(v->arcs->next)break;
v->alt= v->arcs->tip;
make_v_eq:v->typ= '=';goto make_v_arcless;
make_v_1:v->bit= 1;goto make_v_constant;
make_v_0:v->bit= 0;
make_v_constant:v->typ= 'C';
make_v_arcless:v->arcs= NULL;
}
v->bar= NULL;
done:v->foo= v+1;
}

/*:53*/
#line 1162 "./gb_gates.w"
;
/*52:*/
#line 1173 "./gb_gates.w"

{char no_constants_yet= 1;
for(v= latch_ptr;v;v= v->v.V){
u= v->alt;
if(u->typ=='=')
v->alt= u->alt;
else if(u->typ=='C'){
v->typ= 'C';v->bit= u->bit;no_constants_yet= 0;
}
}
if(no_constants_yet)break;
}

/*:52*/
#line 1163 "./gb_gates.w"
;
}
/*60:*/
#line 1345 "./gb_gates.w"

{
for(v= g->vertices;v!=sentinel;v= v->foo)v->lnk= NULL;
for(a= g->outs;a;a= a->next){
v= a->tip;
if(is_boolean(v))continue;
if(v->typ=='=')
v= a->tip= v->alt;
if(v->typ=='C'){
a->tip= (Vertex*)v->bit;
continue;
}
/*61:*/
#line 1361 "./gb_gates.w"

if(v->lnk==NULL){
v->lnk= sentinel;

do{
n++;
b= v->arcs;
if(v->typ=='L'){
u= v->alt;
if(u<v)n++;
if(u->lnk==NULL){
u->lnk= v->lnk;
v= u;
}else v= v->lnk;
}else v= v->lnk;
for(;b;b= b->next){
u= b->tip;
if(u->lnk==NULL){
u->lnk= v;
v= u;
}
}
}while(v!=sentinel);
}

/*:61*/
#line 1357 "./gb_gates.w"
;
}
}

/*:60*/
#line 1165 "./gb_gates.w"
;
/*62:*/
#line 1396 "./gb_gates.w"

new_graph= gb_new_graph(n);
if(new_graph==NULL){
gb_recycle(g);
panic(no_room+2);
}
strcpy(new_graph->id,g->id);
strcpy(new_graph->util_types,"ZZZIIVZZZZZZZA");
next_vert= new_graph->vertices;
for(v= g->vertices,latch_ptr= NULL;v!=sentinel;v= v->foo){
if(v->lnk){
u= v->lnk= next_vert++;
/*63:*/
#line 1420 "./gb_gates.w"

u->name= gb_save_string(v->name);
u->typ= v->typ;
if(v->typ=='L'){
u->alt= latch_ptr;latch_ptr= v;
}
reverse_arc_list(v->arcs);
for(a= v->arcs;a;a= a->next)
gb_new_arc(u,a->tip->lnk,a->len);

/*:63*/
#line 1408 "./gb_gates.w"
;
}
}
/*64:*/
#line 1430 "./gb_gates.w"

while(latch_ptr){
u= latch_ptr->lnk;
v= u->alt;
u->alt= latch_ptr->alt->lnk;
latch_ptr= v;
if(u->alt<u)/*65:*/
#line 1447 "./gb_gates.w"

{
v= u->alt;
u->alt= next_vert++;
sprintf(name_buf,"%s>%s",v->name,u->name);
u= u->alt;
u->name= gb_save_string(name_buf);
u->typ= OR;
gb_new_arc(u,v,DELAY);gb_new_arc(u,v,DELAY);
}

/*:65*/
#line 1436 "./gb_gates.w"
;
}

/*:64*/
#line 1411 "./gb_gates.w"
;
reverse_arc_list(g->outs);
for(a= g->outs;a;a= a->next){
b= gb_virgin_arc();
b->tip= is_boolean(a->tip)?a->tip:a->tip->lnk;
b->next= new_graph->outs;
new_graph->outs= b;
}

/*:62*/
#line 1166 "./gb_gates.w"
;
gb_recycle(g);
return new_graph;
}

/*:51*/
#line 191 "./gb_gates.w"

/*3:*/
#line 129 "./gb_gates.w"

long gate_eval(g,in_vec,out_vec)
Graph*g;
char*in_vec;
char*out_vec;
{register Vertex*v;
register Arc*a;
register char t;
if(!g)return-2;
v= g->vertices;
if(in_vec)/*4:*/
#line 153 "./gb_gates.w"

while(*in_vec&&v<g->vertices+g->n)
(v++)->val= *in_vec++-'0';

/*:4*/
#line 139 "./gb_gates.w"
;
for(;v<g->vertices+g->n;v++){
switch(v->typ){
case'I':continue;
case'L':t= v->alt->val;break;
/*6:*/
#line 164 "./gb_gates.w"

case AND:t= 1;
for(a= v->arcs;a;a= a->next)
t&= a->tip->val;
break;
case OR:t= 0;
for(a= v->arcs;a;a= a->next)
t|= a->tip->val;
break;
case XOR:t= 0;
for(a= v->arcs;a;a= a->next)
t^= a->tip->val;
break;
case NOT:t= 1-v->arcs->tip->val;
break;

/*:6*/
#line 144 "./gb_gates.w"
;
default:return-1;
}
v->val= t;
}
if(out_vec)/*5:*/
#line 157 "./gb_gates.w"

{
for(a= g->outs;a;a= a->next)
*out_vec++= '0'+tip_value(a->tip);
*out_vec= 0;
}

/*:5*/
#line 149 "./gb_gates.w"
;
return 0;
}

/*:3*/
#line 192 "./gb_gates.w"

/*49:*/
#line 1096 "./gb_gates.w"

static void pr_gate(v)
Vertex*v;
{register Arc*a;
printf("%s = ",v->name);
switch(v->typ){
case'I':printf("input");break;
case'L':printf("latch");
if(v->alt)printf("ed %s",v->alt->name);
break;
case'~':printf("~ ");break;
case'C':printf("constant %ld",v->bit);break;
case'=':printf("copy of %s",v->alt->name);
}
for(a= v->arcs;a;a= a->next){
if(a!=v->arcs)printf(" %c ",(char)v->typ);
printf(a->tip->name);
}
printf("\n");
}

void print_gates(g)
Graph*g;
{register Vertex*v;
register Arc*a;
for(v= g->vertices;v<g->vertices+g->n;v++)pr_gate(v);
for(a= g->outs;a;a= a->next)
if(is_boolean(a->tip))printf("Output %ld\n",the_boolean(a->tip));
else printf("Output %s\n",a->tip->name);
}

/*:49*/
#line 193 "./gb_gates.w"

/*8:*/
#line 214 "./gb_gates.w"

Graph*risc(regs)
unsigned long regs;
{/*9:*/
#line 228 "./gb_gates.w"

Graph*new_graph;
register long k,r;

/*:9*//*18:*/
#line 547 "./gb_gates.w"

Vertex*run_bit;
Vertex*mem[16];
Vertex*prog;
Vertex*sign;
Vertex*nonzero;
Vertex*carry;
Vertex*overflow;
Vertex*extra;
Vertex*reg[16];

/*:18*//*20:*/
#line 590 "./gb_gates.w"

Vertex*t1,*t2,*t3,*t4,*t5;
Vertex*tmp[16];
Vertex*imm;
Vertex*rel;

Vertex*dir;

Vertex*ind;
Vertex*op;
Vertex*cond;
Vertex*mod[4];
Vertex*dest[4];

/*:20*//*25:*/
#line 659 "./gb_gates.w"

Vertex*dest_match[16];
Vertex*old_dest[16];
Vertex*old_src[16];
Vertex*inc_dest[16];
Vertex*source[16];
Vertex*log[16];
Vertex*shift[18];
Vertex*sum[18];
Vertex*diff[18];
Vertex*next_loc[16];
Vertex*next_next_loc[16];
Vertex*result[18];

/*:25*//*28:*/
#line 696 "./gb_gates.w"

Vertex*change;

/*:28*//*33:*/
#line 762 "./gb_gates.w"

Vertex*jump;
Vertex*nextra;
Vertex*nzs;
Vertex*nzd;

/*:33*//*37:*/
#line 851 "./gb_gates.w"

Vertex*skip;
Vertex*hop;
Vertex*normal;
Vertex*special;


/*:37*//*40:*/
#line 925 "./gb_gates.w"

Vertex*up,*down;

/*:40*/
#line 217 "./gb_gates.w"


/*16:*/
#line 524 "./gb_gates.w"

if(regs<2||regs> 16)regs= 16;
new_graph= gb_new_graph(1400+115*regs);
if(new_graph==NULL)
panic(no_room);
sprintf(new_graph->id,"risc(%lu)",regs);
strcpy(new_graph->util_types,"ZZZIIVZZZZZZZA");
next_vert= new_graph->vertices;

/*:16*/
#line 219 "./gb_gates.w"
;
/*17:*/
#line 533 "./gb_gates.w"

/*19:*/
#line 560 "./gb_gates.w"

strcpy(prefix,"RUN");count= -1;run_bit= new_vert('I');
start_prefix("M");for(k= 0;k<16;k++)mem[k]= new_vert('I');
start_prefix("P");prog= first_of(10,'L');
strcpy(prefix,"S");count= -1;sign= new_vert('L');
strcpy(prefix,"N");nonzero= new_vert('L');
strcpy(prefix,"K");carry= new_vert('L');
strcpy(prefix,"V");overflow= new_vert('L');
strcpy(prefix,"X");extra= new_vert('L');
for(r= 0;r<regs;r++){
numeric_prefix('R',r);
reg[r]= first_of(16,'L');
}

/*:19*/
#line 534 "./gb_gates.w"
;
/*21:*/
#line 609 "./gb_gates.w"

start_prefix("D");
do3(imm,AND,comp(extra),comp(mem[4]),comp(mem[5]));
do3(rel,AND,comp(extra),mem[4],comp(mem[5]));
do3(dir,AND,comp(extra),comp(mem[4]),mem[5]);
do3(ind,AND,comp(extra),mem[4],mem[5]);
do2(op,OR,make2(AND,extra,prog),make2(AND,comp(extra),mem[6]));
do2(cond,OR,make2(AND,extra,prog+1),make2(AND,comp(extra),mem[7]));
for(k= 0;k<4;k++){
do2(mod[k],OR,make2(AND,extra,prog+2+k),make2(AND,comp(extra),mem[8+k]));
do2(dest[k],OR,make2(AND,extra,prog+6+k),make2(AND,comp(extra),mem[12+k]));
}

/*:21*/
#line 535 "./gb_gates.w"
;
/*22:*/
#line 622 "./gb_gates.w"

start_prefix("F");
/*23:*/
#line 639 "./gb_gates.w"

for(r= 0;r<regs;r++)
do4(dest_match[r],AND,even_comp(r,dest[0]),even_comp(r>>1,dest[1]),
even_comp(r>>2,dest[2]),even_comp(r>>3,dest[3]));
for(k= 0;k<16;k++){
for(r= 0;r<regs;r++)
tmp[r]= make2(AND,dest_match[r],reg[r]+k);
old_dest[k]= new_vert(OR);
for(r= 0;r<regs;r++)gb_new_arc(old_dest[k],tmp[r],DELAY);
}

/*:23*/
#line 624 "./gb_gates.w"
;
/*24:*/
#line 650 "./gb_gates.w"

for(k= 0;k<16;k++){
for(r= 0;r<regs;r++)
do5(tmp[r],AND,reg[r]+k,even_comp(r,mem[0]),even_comp(r>>1,mem[1]),
even_comp(r>>2,mem[2]),even_comp(r>>3,mem[3]));
old_src[k]= new_vert(OR);
for(r= 0;r<regs;r++)gb_new_arc(old_src[k],tmp[r],DELAY);
}

/*:24*/
#line 625 "./gb_gates.w"
;
/*39:*/
#line 909 "./gb_gates.w"

make_adder(4L,old_dest,mem,inc_dest,NULL,1);
up= make2(AND,inc_dest[4],comp(mem[3]));
down= make2(AND,comp(inc_dest[4]),mem[3]);
for(k= 4;;k++){
comp(up);comp(down);
do3(inc_dest[k],OR,
make2(AND,comp(old_dest[k]),up),
make2(AND,comp(old_dest[k]),down),
make3(AND,old_dest[k],comp(up),comp(down)));
if(k<15){
up= make2(AND,up,old_dest[k]);
down= make2(AND,down,comp(old_dest[k]));
}else break;
}

/*:39*/
#line 626 "./gb_gates.w"
;
for(k= 0;k<16;k++)
do4(source[k],OR,
make2(AND,imm,mem[k<4?k:3]),
make2(AND,rel,inc_dest[k]),
make2(AND,dir,old_src[k]),
make2(AND,extra,mem[k]));

/*:22*/
#line 536 "./gb_gates.w"
;
/*26:*/
#line 673 "./gb_gates.w"

start_prefix("L");
for(k= 0;k<16;k++)
do4(log[k],OR,
make3(AND,mod[0],comp(old_dest[k]),comp(source[k])),
make3(AND,mod[1],comp(old_dest[k]),source[k]),
make3(AND,mod[2],old_dest[k],comp(source[k])),
make3(AND,mod[3],old_dest[k],source[k]));

/*:26*/
#line 537 "./gb_gates.w"
;
/*27:*/
#line 682 "./gb_gates.w"

start_prefix("C");
do4(tmp[0],OR,
make3(AND,mod[0],comp(sign),comp(nonzero)),
make3(AND,mod[1],comp(sign),nonzero),
make3(AND,mod[2],sign,comp(nonzero)),
make3(AND,mod[3],sign,nonzero));
do4(tmp[1],OR,
make3(AND,mod[0],comp(carry),comp(overflow)),
make3(AND,mod[1],comp(carry),overflow),
make3(AND,mod[2],carry,comp(overflow)),
make3(AND,mod[3],carry,overflow));
do3(change,OR,comp(cond),make2(AND,tmp[0],comp(op)),make2(AND,tmp[1],op));

/*:27*/
#line 538 "./gb_gates.w"
;
/*41:*/
#line 931 "./gb_gates.w"

start_prefix("A");
/*42:*/
#line 943 "./gb_gates.w"

for(k= 0;k<16;k++)
do4(shift[k],OR,
(k==0?make4(AND,source[15],mod[0],comp(mod[1]),comp(mod[2])):
make3(AND,source[k-1],comp(mod[1]),comp(mod[2]))),
(k<4?make4(AND,source[k+12],mod[0],mod[1],comp(mod[2])):
make3(AND,source[k-4],mod[1],comp(mod[2]))),
(k==15?make4(AND,source[15],comp(mod[0]),comp(mod[1]),mod[2]):
make3(AND,source[k+1],comp(mod[1]),mod[2])),
(k> 11?make4(AND,source[15],comp(mod[0]),mod[1],mod[2]):
make3(AND,source[k+4],mod[1],mod[2])));
do4(shift[16],OR,
make2(AND,comp(mod[2]),source[15]),
make3(AND,comp(mod[2]),mod[1],
make3(OR,source[14],source[13],source[12])),
make3(AND,mod[2],comp(mod[1]),source[0]),
make3(AND,mod[2],mod[1],source[3]));
do3(shift[17],OR,
make3(AND,comp(mod[2]),comp(mod[1]),
make_xor(source[15],source[14])),
make4(AND,comp(mod[2]),mod[1],
make5(OR,source[15],source[14],
source[13],source[12],source[11]),
make5(OR,comp(source[15]),comp(source[14]),
comp(source[13]),
comp(source[12]),comp(source[11]))),
make3(AND,mod[2],mod[1],
make3(OR,source[0],source[1],source[2])));

/*:42*/
#line 933 "./gb_gates.w"
;
make_adder(16L,old_dest,source,sum,make2(AND,carry,mod[0]),1);
make_adder(16L,old_dest,source,diff,make2(AND,carry,mod[0]),0);
do2(sum[17],OR,
make3(AND,old_dest[15],source[15],comp(sum[15])),
make3(AND,comp(old_dest[15]),comp(source[15]),sum[15]));
do2(diff[17],OR,
make3(AND,old_dest[15],comp(source[15]),comp(diff[15])),
make3(AND,comp(old_dest[15]),source[15],diff[15]));

/*:41*/
#line 539 "./gb_gates.w"
;
/*29:*/
#line 704 "./gb_gates.w"

start_prefix("Z");
/*30:*/
#line 714 "./gb_gates.w"

next_loc[0]= comp(reg[0]);next_next_loc[0]= reg[0];
next_loc[1]= make_xor(reg[0]+1,reg[0]);next_next_loc[1]= comp(reg[0]+1);
for(t5= reg[0]+1,k= 2;k<16;t5= make2(AND,t5,reg[0]+k++)){
next_loc[k]= make_xor(reg[0]+k,make2(AND,reg[0],t5));
next_next_loc[k]= make_xor(reg[0]+k,t5);
}

/*:30*/
#line 706 "./gb_gates.w"
;
/*31:*/
#line 722 "./gb_gates.w"

jump= make5(AND,op,mod[0],mod[1],mod[2],mod[3]);
for(k= 0;k<16;k++){
do5(result[k],OR,
make2(AND,comp(op),log[k]),
make2(AND,jump,next_loc[k]),
make3(AND,op,comp(mod[3]),shift[k]),
make5(AND,op,mod[3],comp(mod[2]),comp(mod[1]),sum[k]),
make5(AND,op,mod[3],comp(mod[2]),mod[1],diff[k]));
do2(result[k],OR,
make3(AND,cond,change,source[k]),
make2(AND,comp(cond),result[k]));
}
for(k= 16;k<18;k++)
do3(result[k],OR,
make3(AND,op,comp(mod[3]),shift[k]),
make5(AND,op,mod[3],comp(mod[2]),comp(mod[1]),sum[k]),
make5(AND,op,mod[3],comp(mod[2]),mod[1],diff[k]));

/*:31*/
#line 707 "./gb_gates.w"
;
/*34:*/
#line 768 "./gb_gates.w"

t5= make2(AND,change,comp(ind));
for(r= 1;r<regs;r++){
t4= make2(AND,t5,dest_match[r]);
for(k= 0;k<16;k++){
do2(t3,OR,make2(AND,t4,result[k]),make2(AND,comp(t4),reg[r]+k));
latchit(t3,reg[r]+k);
}
}

/*:34*/
#line 708 "./gb_gates.w"
;
/*35:*/
#line 778 "./gb_gates.w"

do4(t5,OR,
make2(AND,sign,cond),
make2(AND,sign,jump),
make2(AND,sign,ind),
make4(AND,result[15],comp(cond),comp(jump),comp(ind)));
latchit(t5,sign);
do4(t5,OR,
make4(OR,result[0],result[1],result[2],result[3]),
make4(OR,result[4],result[5],result[6],result[7]),
make4(OR,result[8],result[9],result[10],result[11]),
make4(OR,result[12],result[13],result[14],
make5(AND,make2(OR,nonzero,sign),op,mod[0],comp(mod[2]),mod[3])));
do4(t5,OR,
make2(AND,nonzero,cond),
make2(AND,nonzero,jump),
make2(AND,nonzero,ind),
make4(AND,t5,comp(cond),comp(jump),comp(ind)));
latchit(t5,nonzero);
do5(t5,OR,
make2(AND,overflow,cond),
make2(AND,overflow,jump),
make2(AND,overflow,comp(op)),
make2(AND,overflow,ind),
make5(AND,result[17],comp(cond),comp(jump),comp(ind),op));
latchit(t5,overflow);
do5(t5,OR,
make2(AND,carry,cond),
make2(AND,carry,jump),
make2(AND,carry,comp(op)),
make2(AND,carry,ind),
make5(AND,result[16],comp(cond),comp(jump),comp(ind),op));
latchit(t5,carry);

/*:35*/
#line 709 "./gb_gates.w"
;
/*32:*/
#line 754 "./gb_gates.w"

for(k= 0;k<10;k++)
latchit(mem[k+6],prog+k);
do2(nextra,OR,make2(AND,ind,comp(cond)),make2(AND,ind,change));
latchit(nextra,extra);
nzs= make4(OR,mem[0],mem[1],mem[2],mem[3]);
nzd= make4(OR,dest[0],dest[1],dest[2],dest[3]);

/*:32*/
#line 710 "./gb_gates.w"
;
/*36:*/
#line 822 "./gb_gates.w"

skip= make2(AND,cond,comp(change));
hop= make2(AND,comp(cond),jump);
do4(normal,OR,
make2(AND,skip,comp(ind)),
make2(AND,skip,nzs),
make3(AND,comp(skip),ind,comp(nzs)),
make3(AND,comp(skip),comp(hop),nzd));
special= make3(AND,comp(skip),ind,nzs);
for(k= 0;k<16;k++){
do4(t5,OR,
make2(AND,normal,next_loc[k]),
make4(AND,skip,ind,comp(nzs),next_next_loc[k]),
make3(AND,hop,comp(ind),source[k]),
make5(AND,comp(skip),comp(hop),comp(ind),comp(nzd),result[k]));
do2(t4,OR,
make2(AND,special,reg[0]+k),
make2(AND,comp(special),t5));
latchit(t4,reg[0]+k);
do2(t4,OR,
make2(AND,special,old_src[k]),
make2(AND,comp(special),t5));
{register Arc*a= gb_virgin_arc();
a->tip= make2(AND,t4,run_bit);
a->next= new_graph->outs;
new_graph->outs= a;
}
}

/*:36*/
#line 712 "./gb_gates.w"
;

/*:29*/
#line 540 "./gb_gates.w"
;
if(next_vert!=new_graph->vertices+new_graph->n)
panic(impossible);

/*:17*/
#line 220 "./gb_gates.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
return new_graph;
}

/*:8*/
#line 194 "./gb_gates.w"

/*43:*/
#line 991 "./gb_gates.w"

long run_risc(g,rom,size,trace_regs)
Graph*g;
unsigned long rom[];
unsigned long size;
unsigned long trace_regs;
{register unsigned long l;
register unsigned long m;
register Vertex*v;
register Arc*a;
register long k,r;
long x,s,n,c,o;
if(trace_regs)/*44:*/
#line 1023 "./gb_gates.w"

{
for(r= 0;r<trace_regs;r++)printf(" r%-2ld ",r);
printf(" P XSNKV MEM\n");
}

/*:44*/
#line 1003 "./gb_gates.w"
;
r= gate_eval(g,"0",NULL);
if(r<0)return r;
g->vertices->val= 1;
while(1){
for(a= g->outs,l= 0;a;a= a->next)l= 2*l+a->tip->val;

if(trace_regs)/*46:*/
#line 1035 "./gb_gates.w"

{for(r= 0;r<trace_regs;r++){
v= g->vertices+(16*r+47);
m= 0;
if(v->typ=='L')
for(k= 0,m= 0;k<16;k++,v--)m= 2*m+v->alt->val;
printf("%04lx ",m);
}
for(k= 0,m= 0,v= g->vertices+26;k<10;k++,v--)m= 2*m+v->alt->val;
x= (g->vertices+31)->alt->val;
s= (g->vertices+27)->alt->val;
n= (g->vertices+28)->alt->val;
c= (g->vertices+29)->alt->val;
o= (g->vertices+30)->alt->val;
printf("%03lx%c%c%c%c%c ",m<<2,
x?'X':'.',s?'S':'.',n?'N':'.',c?'K':'.',o?'V':'.');
if(l>=size)printf("????\n");
else printf("%04lx\n",rom[l]);
}

/*:46*/
#line 1010 "./gb_gates.w"
;
if(l>=size)break;
for(v= g->vertices+1,m= rom[l];v<=g->vertices+16;v++,m>>= 1)
v->val= m&1;
gate_eval(g,NULL,NULL);
}
if(trace_regs)/*45:*/
#line 1029 "./gb_gates.w"

printf("Execution terminated with memory address %04lx.\n",l);

/*:45*/
#line 1016 "./gb_gates.w"
;
/*47:*/
#line 1055 "./gb_gates.w"

for(r= 0;r<16;r++){
v= g->vertices+(16*r+47);
m= 0;
if(v->typ=='L')
for(k= 0,m= 0;k<16;k++,v--)m= 2*m+v->alt->val;
risc_state[r]= m;
}
for(k= 0,m= 0,v= g->vertices+26;k<10;k++,v--)m= 2*m+v->alt->val;
m= 4*m+(g->vertices+31)->alt->val;
m= 2*m+(g->vertices+27)->alt->val;
m= 2*m+(g->vertices+28)->alt->val;
m= 2*m+(g->vertices+29)->alt->val;
m= 2*m+(g->vertices+30)->alt->val;
risc_state[16]= m;
risc_state[17]= l;


/*:47*/
#line 1017 "./gb_gates.w"
;
return 0;
}

/*:43*/
#line 195 "./gb_gates.w"

/*66:*/
#line 1486 "./gb_gates.w"

Graph*prod(m,n)
unsigned long m,n;
{/*68:*/
#line 1536 "./gb_gates.w"

unsigned long m_plus_n;
long f;
Graph*g;
long*long_tables;
Vertex**vert_tables;

/*:68*//*71:*/
#line 1607 "./gb_gates.w"

register long i,j,k,l;
register Vertex*v;
Vertex*x,*y;
Vertex*alpha,*beta;

/*:71*//*77:*/
#line 1766 "./gb_gates.w"

Vertex*uu,*vv;
Vertex**w;
Vertex**c;

Vertex*cc,*dd;
long*flog;
long*down;
long*anc;

/*:77*/
#line 1489 "./gb_gates.w"


if(m<2)m= 2;
if(n<2)n= 2;
/*67:*/
#line 1523 "./gb_gates.w"

m_plus_n= m+n;/*69:*/
#line 1543 "./gb_gates.w"

f= 4;j= 3;k= 5;
while(k<m_plus_n){
k= k+j;
j= k-j;
f++;
}

/*:69*/
#line 1524 "./gb_gates.w"
;
g= gb_new_graph((6*m-7+3*f)*m_plus_n);
if(g==NULL)panic(no_room);
sprintf(g->id,"prod(%lu,%lu)",m,n);
strcpy(g->util_types,"ZZZIIVZZZZZZZA");
long_tables= gb_typed_alloc(2*m_plus_n+f,long,g->aux_data);
vert_tables= gb_typed_alloc(f*m_plus_n,Vertex*,g->aux_data);
if(gb_trouble_code){
gb_recycle(g);
panic(no_room+1);
}

/*:67*/
#line 1493 "./gb_gates.w"
;
/*70:*/
#line 1597 "./gb_gates.w"

next_vert= g->vertices;
start_prefix("X");x= first_of(m,'I');
start_prefix("Y");y= first_of(n,'I');
/*72:*/
#line 1613 "./gb_gates.w"

for(j= 0;j<m;j++){
numeric_prefix('A',j);
for(k= 0;k<j;k++){
v= new_vert('C');v->bit= 0;
}
for(k= 0;k<n;k++)
make2(AND,x+j,y+k);
for(k= j+n;k<m_plus_n;k++){
v= new_vert('C');v->bit= 0;
}
}

/*:72*/
#line 1601 "./gb_gates.w"
;
/*73:*/
#line 1631 "./gb_gates.w"

for(j= 0;j<m-2;j++){
alpha= g->vertices+(a_pos(3*j)*m_plus_n);
beta= g->vertices+(a_pos(3*j+1)*m_plus_n);
numeric_prefix('P',j);
for(k= 0;k<m_plus_n;k++)
make2(XOR,alpha+k,beta+k);
numeric_prefix('Q',j);
for(k= 0;k<m_plus_n;k++)
make2(AND,alpha+k,beta+k);
alpha= next_vert-2*m_plus_n;
beta= g->vertices+(a_pos(3*j+2)*m_plus_n);
numeric_prefix('A',(long)m+2*j);
for(k= 0;k<m_plus_n;k++)
make2(XOR,alpha+k,beta+k);
numeric_prefix('R',j);
for(k= 0;k<m_plus_n;k++)
make2(AND,alpha+k,beta+k);
alpha= next_vert-3*m_plus_n;
beta= next_vert-m_plus_n;
numeric_prefix('A',(long)m+2*j+1);
v= new_vert('C');v->bit= 0;
for(k= 0;k<m_plus_n-1;k++)
make2(OR,alpha+k,beta+k);
}

/*:73*/
#line 1603 "./gb_gates.w"
;
/*74:*/
#line 1661 "./gb_gates.w"

alpha= g->vertices+(a_pos(3*m-6)*m_plus_n);
beta= g->vertices+(a_pos(3*m-5)*m_plus_n);
start_prefix("U");
for(k= 0;k<m_plus_n;k++)
make2(XOR,alpha+k,beta+k);
start_prefix("V");
for(k= 0;k<m_plus_n;k++)
make2(AND,alpha+k,beta+k);

/*:74*/
#line 1604 "./gb_gates.w"
;
/*75:*/
#line 1732 "./gb_gates.w"

/*76:*/
#line 1748 "./gb_gates.w"

w= vert_tables;
c= w+m_plus_n;
flog= long_tables;
down= flog+m_plus_n+1;
anc= down+m_plus_n;
flog[1]= 0;flog[2]= 2;
down[1]= 0;down[2]= 1;
for(i= 3,j= 2,k= 3,l= 3;l<=m_plus_n;l++){
if(l> k){
k= k+j;
j= k-j;
i++;
}
flog[l]= i;
down[l]= l-k+j;
}

/*:76*/
#line 1733 "./gb_gates.w"
;
/*78:*/
#line 1777 "./gb_gates.w"

vv= next_vert-m_plus_n;uu= vv-m_plus_n;
start_prefix("W");
v= new_vert('C');v->bit= 0;w[0]= v;
v= new_vert('=');v->alt= vv;w[1]= v;
for(k= 2;k<m_plus_n;k++){
/*79:*/
#line 1807 "./gb_gates.w"

for(l= 0,j= k;;l++,j= down[j]){
anc[l]= j;
if(j==2)break;
}

/*:79*/
#line 1784 "./gb_gates.w"
;
i= 1;cc= vv+k-1;dd= uu+k-1;
while(1){
j= anc[l];

/*80:*/
#line 1819 "./gb_gates.w"

spec_gate(v,'B',k,j,AND);
gb_new_arc(v,dd,DELAY);
f= flog[j-i];
gb_new_arc(v,f> 0?c[k-i+(f-2)*m_plus_n]:vv+k-i-1,DELAY);

/*:80*/
#line 1789 "./gb_gates.w"
;
/*81:*/
#line 1825 "./gb_gates.w"

if(l){
spec_gate(v,'C',k,j,OR);
}else v= new_vert(OR);
gb_new_arc(v,cc,DELAY);
gb_new_arc(v,next_vert-2,DELAY);

/*:81*/
#line 1790 "./gb_gates.w"
;
if(flog[j]<flog[j+1])
c[k+(flog[j]-2)*m_plus_n]= v;
if(l==0)break;
cc= v;
/*82:*/
#line 1834 "./gb_gates.w"

spec_gate(v,'D',k,j,AND);
gb_new_arc(v,dd,DELAY);
gb_new_arc(v,f> 0?c[k-i+(f-2)*m_plus_n]+1:uu+k-i-1,DELAY);


/*:82*/
#line 1795 "./gb_gates.w"
;
dd= v;
i= j;
l--;
}
w[k]= v;
}

/*:78*/
#line 1735 "./gb_gates.w"
;
/*83:*/
#line 1844 "./gb_gates.w"

start_prefix("Z");
for(k= 0;k<m_plus_n;k++){register Arc*a= gb_virgin_arc();
a->tip= make2(XOR,uu+k,w[k]);
a->next= g->outs;
g->outs= a;
}

/*:83*/
#line 1737 "./gb_gates.w"
;
g->n= next_vert-g->vertices;

/*:75*/
#line 1605 "./gb_gates.w"
;

/*:70*/
#line 1494 "./gb_gates.w"
;
if(gb_trouble_code){
gb_recycle(g);panic(alloc_fault);
}
g= reduce(g);
return g;
}

/*:66*/
#line 196 "./gb_gates.w"

/*84:*/
#line 1896 "./gb_gates.w"

Graph*partial_gates(g,r,prob,seed,buf)
Graph*g;
unsigned long r;
unsigned long prob;

long seed;
char*buf;
{register Vertex*v;
if(g==NULL)panic(missing_operand);
gb_init_rand(seed);
for(v= g->vertices+r;v<g->vertices+g->n;v++)
switch(v->typ){
case'C':case'=':continue;
case'I':if((gb_next_rand()>>15)>=prob){
v->typ= 'C';v->bit= gb_next_rand()>>30;
if(buf)*buf++= v->bit+'0';
}else if(buf)*buf++= '*';
break;
default:goto done;
}
done:if(buf)*buf= 0;
g= reduce(g);
/*85:*/
#line 1926 "./gb_gates.w"

if(g){
strcpy(name_buf,g->id);
if(strlen(name_buf)> 54)strcpy(name_buf+51,"...");
sprintf(g->id,"partial_gates(%s,%lu,%lu,%ld)",name_buf,r,prob,seed);
}

/*:85*/
#line 1919 "./gb_gates.w"
;
return g;
}

/*:84*/
#line 197 "./gb_gates.w"


/*:7*/
