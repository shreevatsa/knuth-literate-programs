/*7:*/
#line 163 "./gb_games.w"

#include "gb_io.h" 
#include "gb_flip.h"

#include "gb_graph.h" 
#include "gb_sort.h" 
#define MAX_N 120
#define MAX_DAY 128
#define MAX_WEIGHT 131072
#define ap u.I
#define upi v.I \

#define conference z.S \

#define nickname y.S
#define abbr x.S \

#define HOME 1
#define NEUTRAL 2
#define AWAY 3
#define venue a.I
#define date b.I \

#define panic(c) {panic_code= c;gb_trouble_code= 0;return NULL;} \

#define HASH_PRIME 1009 \


#line 169 "./gb_games.w"

/*11:*/
#line 230 "./gb_games.w"

typedef struct node_struct{
long key;
struct node_struct*link;
char name[24];
char nick[22];
char abb[6];
long a0,u0,a1,u1;
char*conf;
struct node_struct*hash_link;
Vertex*vert;
}node;

/*:11*/
#line 170 "./gb_games.w"

/*13:*/
#line 279 "./gb_games.w"

static long ma0= 1451,mu0= 666,ma1= 1475,mu1= 847;

static node*node_block;
static node**hash_block;
static Area working_storage;
static char**conf_block;
static long m;

/*:13*/
#line 171 "./gb_games.w"

/*23:*/
#line 439 "./gb_games.w"

static Vertex*team_lookup()
{register char*q= str_buf;
register long h= 0;
register node*p;
while(gb_digit(10)<0){
*q= gb_char();
h= (h+h+*q)%HASH_PRIME;
q++;
}
gb_backup();
*q= '\0';
for(p= hash_block[h];p;p= p->hash_link)
if(strcmp(p->abb,str_buf)==0)return p->vert;
return NULL;
}

/*:23*/
#line 172 "./gb_games.w"


Graph*games(n,ap0_weight,upi0_weight,ap1_weight,upi1_weight,
first_day,last_day,seed)
unsigned long n;
long ap0_weight;
long ap1_weight;
long upi0_weight;
long upi1_weight;
long first_day;
long last_day;
long seed;
{/*8:*/
#line 202 "./gb_games.w"

Graph*new_graph;
register long j,k;

/*:8*/
#line 184 "./gb_games.w"

gb_init_rand(seed);
/*9:*/
#line 206 "./gb_games.w"

if(n==0||n> MAX_N)n= MAX_N;
if(ap0_weight> MAX_WEIGHT||ap0_weight<-MAX_WEIGHT||
upi0_weight> MAX_WEIGHT||upi0_weight<-MAX_WEIGHT||
ap1_weight> MAX_WEIGHT||ap1_weight<-MAX_WEIGHT||
upi1_weight> MAX_WEIGHT||upi1_weight<-MAX_WEIGHT)
panic(bad_specs);
if(first_day<0)first_day= 0;
if(last_day==0||last_day> MAX_DAY)last_day= MAX_DAY;

/*:9*/
#line 186 "./gb_games.w"
;
/*10:*/
#line 216 "./gb_games.w"

new_graph= gb_new_graph(n);
if(new_graph==NULL)
panic(no_room);
sprintf(new_graph->id,"games(%lu,%ld,%ld,%ld,%ld,%ld,%ld,%ld)",
n,ap0_weight,upi0_weight,ap1_weight,upi1_weight,first_day,last_day,seed);
strcpy(new_graph->util_types,"IIZSSSIIZZZZZZ");

/*:10*/
#line 187 "./gb_games.w"
;
/*14:*/
#line 288 "./gb_games.w"

node_block= gb_typed_alloc(MAX_N+2,node,working_storage);

hash_block= gb_typed_alloc(HASH_PRIME,node*,working_storage);
conf_block= gb_typed_alloc(MAX_N,char*,working_storage);
m= 0;
if(gb_trouble_code){
gb_free(working_storage);
panic(no_room+1);
}
if(gb_open("games.dat")!=0)
panic(early_data_fault);

for(k= 0;k<MAX_N;k++)/*15:*/
#line 303 "./gb_games.w"

{register node*p;
register char*q;
p= node_block+k;
if(k)p->link= p-1;
q= gb_string(p->abb,' ');
if(q> &p->abb[6]||gb_char()!=' ')
panic(syntax_error);
/*16:*/
#line 323 "./gb_games.w"

{long h= 0;
for(q= p->abb;*q;q++)
h= (h+h+*q)%HASH_PRIME;
p->hash_link= hash_block[h];
hash_block[h]= p;
}

/*:16*/
#line 311 "./gb_games.w"
;
q= gb_string(p->name,'(');
if(q> &p->name[24]||gb_char()!='(')
panic(syntax_error+1);
q= gb_string(p->nick,')');
if(q> &p->nick[22]||gb_char()!=')')
panic(syntax_error+2);
/*17:*/
#line 331 "./gb_games.w"

{
gb_string(str_buf,';');
if(gb_char()!=';')panic(syntax_error+3);
if(strcmp(str_buf,"Independent")!=0){
for(j= 0;j<m;j++)
if(strcmp(str_buf,conf_block[j])==0)goto found;
conf_block[m++]= gb_save_string(str_buf);
found:p->conf= conf_block[j];
}
}

/*:17*/
#line 318 "./gb_games.w"
;
/*18:*/
#line 346 "./gb_games.w"

p->a0= gb_number(10);
if(p->a0> ma0||gb_char()!=',')panic(syntax_error+4);

p->u0= gb_number(10);
if(p->u0> mu0||gb_char()!=';')panic(syntax_error+5);

p->a1= gb_number(10);
if(p->a1> ma1||gb_char()!=',')panic(syntax_error+6);

p->u1= gb_number(10);
if(p->u1> mu1||gb_char()!='\n')panic(syntax_error+7);

p->key= ap0_weight*(p->a0)+upi0_weight*(p->u0)
+ap1_weight*(p->a1)+upi1_weight*(p->u1)+0x40000000;

/*:18*/
#line 319 "./gb_games.w"
;
gb_newline();
}

/*:15*/
#line 301 "./gb_games.w"
;

/*:14*/
#line 188 "./gb_games.w"
;
/*19:*/
#line 370 "./gb_games.w"

{register node*p;
register Vertex*v= new_graph->vertices;
gb_linksort(node_block+MAX_N-1);
for(j= 127;j>=0;j--)
for(p= (node*)gb_sorted[j];p;p= p->link){
if(v<new_graph->vertices+n)/*20:*/
#line 381 "./gb_games.w"

{
v->ap= ((long)(p->a0)<<16)+p->a1;
v->upi= ((long)(p->u0)<<16)+p->u1;
v->abbr= gb_save_string(p->abb);
v->nickname= gb_save_string(p->nick);
v->conference= p->conf;
v->name= gb_save_string(p->name);
p->vert= v++;
}

/*:20*/
#line 376 "./gb_games.w"

else p->abb[0]= '\0';
}
}

/*:19*/
#line 189 "./gb_games.w"
;
/*21:*/
#line 397 "./gb_games.w"

{register Vertex*u,*v;
register long today= 0;
long su,sv;
long ven;
while(!gb_eof()){
if(gb_char()=='>')/*22:*/
#line 421 "./gb_games.w"

{register char c= gb_char();
register long d;
switch(c){
case'A':d= -26;break;
case'S':d= 5;break;
case'O':d= 35;break;
case'N':d= 66;break;
case'D':d= 96;break;
case'J':d= 127;break;
default:d= 1000;
}
d+= gb_number(10);
if(d<0||d> MAX_DAY)panic(syntax_error-1);
today= d;
gb_newline();
}

/*:22*/
#line 403 "./gb_games.w"

else gb_backup();
u= team_lookup();
su= gb_number(10);
ven= gb_char();
if(ven=='@')ven= HOME;
else if(ven==',')ven= NEUTRAL;
else panic(syntax_error+8);
v= team_lookup();
sv= gb_number(10);
if(gb_char()!='\n')panic(syntax_error+9);

if(u!=NULL&&v!=NULL&&today>=first_day&&today<=last_day)
/*24:*/
#line 459 "./gb_games.w"

{register Arc*a;
if(u> v){register Vertex*w;register long sw;
w= u;u= v;v= w;
sw= su;su= sv;sv= sw;
ven= HOME+AWAY-ven;
}
gb_new_arc(u,v,su);
gb_new_arc(v,u,sv);
a= u->arcs;
if(v->arcs!=a+1)panic(impossible+9);
a->venue= ven;(a+1)->venue= HOME+AWAY-ven;
a->date= (a+1)->date= today;
}

/*:24*/
#line 416 "./gb_games.w"
;
gb_newline();
}
}

/*:21*/
#line 190 "./gb_games.w"
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
