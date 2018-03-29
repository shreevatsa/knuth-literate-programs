/*8:*/
#line 147 "./gb_books.w"

#include "gb_io.h" 
#include "gb_flip.h" 

#include "gb_graph.h" 
#include "gb_sort.h" 
#define MAX_CHAPS 360 \

#define panic(c) {panic_code= c;gb_trouble_code= 0;return NULL;} \

#define MAX_CHARS 600 \

#define MAX_CODE 1296 \

#define desc z.S
#define in_count y.I
#define out_count x.I
#define short_code u.I \

#define chap_no a.I \


#line 153 "./gb_books.w"

/*13:*/
#line 248 "./gb_books.w"

typedef struct node_struct{
long key;
struct node_struct*link;
long code;
long in;
long out;
long chap;
Vertex*vert;
}node;

/*:13*/
#line 154 "./gb_books.w"

/*11:*/
#line 218 "./gb_books.w"

static char file_name[]= "xxxxxx.dat";

/*:11*//*14:*/
#line 261 "./gb_books.w"

static node node_block[MAX_CHARS];
static node*xnode[MAX_CODE];

/*:14*//*24:*/
#line 474 "./gb_books.w"

static Vertex*clique_table[30];


/*:24*/
#line 155 "./gb_books.w"

/*5:*/
#line 120 "./gb_books.w"

long chapters;
char*chap_name[MAX_CHAPS]= {""};

/*:5*/
#line 156 "./gb_books.w"


static Graph*bgraph(bipartite,
title,n,x,first_chapter,last_chapter,in_weight,out_weight,seed)
long bipartite;
char*title;
unsigned long n;
unsigned long x;
unsigned long first_chapter,last_chapter;

long in_weight;

long out_weight;

long seed;
{/*9:*/
#line 199 "./gb_books.w"

Graph*new_graph;
register long j,k;
long characters;
register node*p;

/*:9*//*21:*/
#line 433 "./gb_books.w"

Vertex*chap_base;


/*:21*/
#line 171 "./gb_books.w"

gb_init_rand(seed);
/*10:*/
#line 207 "./gb_books.w"

if(n==0)n= MAX_CHARS;
if(first_chapter==0)first_chapter= 1;
if(last_chapter==0)last_chapter= MAX_CHAPS;
if(in_weight> 1000000||in_weight<-1000000||
out_weight> 1000000||out_weight<-1000000)
panic(bad_specs);
sprintf(file_name,"%.6s.dat",title);
if(gb_open(file_name)!=0)
panic(early_data_fault);

/*:10*/
#line 173 "./gb_books.w"
;
/*15:*/
#line 269 "./gb_books.w"

/*16:*/
#line 278 "./gb_books.w"

for(k= 0;k<MAX_CODE;k++)xnode[k]= NULL;
{register long c;
p= node_block;
while((c= gb_number(36))!=0){
if(c>=MAX_CODE||gb_char()!=' ')panic(syntax_error);

if(p>=&node_block[MAX_CHARS])
panic(syntax_error+1);
p->link= (p==node_block?NULL:p-1);
p->code= c;
xnode[c]= p;
p->in= p->out= p->chap= 0;
p->vert= NULL;
p++;
gb_newline();
}
characters= p-node_block;
gb_newline();
}

/*:16*/
#line 271 "./gb_books.w"
;
/*19:*/
#line 368 "./gb_books.w"

for(k= 1;k<MAX_CHAPS&&!gb_eof();k++){
gb_string(str_buf,':');
if(str_buf[0]=='&')k--;
while(gb_char()!='\n'){register long c= gb_number(36);
if(c>=MAX_CODE)
panic(syntax_error+4);
p= xnode[c];
if(p==NULL)panic(syntax_error+5);
if(p->chap!=k){
p->chap= k;
if(k>=first_chapter&&k<=last_chapter)p->in++;
else p->out++;
}
}
gb_newline();
}
if(k==MAX_CHAPS)panic(syntax_error+6);
chapters= k-1;

/*:19*/
#line 273 "./gb_books.w"
;
if(gb_close()!=0)
panic(late_data_fault);


/*:15*/
#line 175 "./gb_books.w"
;
/*27:*/
#line 498 "./gb_books.w"

if(n> characters)n= characters;
if(x> n)x= n;
if(last_chapter> chapters)last_chapter= chapters;
if(first_chapter> last_chapter)first_chapter= last_chapter+1;
new_graph= gb_new_graph(n-x+(bipartite?last_chapter-first_chapter+1:0));
if(new_graph==NULL)panic(no_room);
strcpy(new_graph->util_types,"IZZIISIZZZZZZZ");

sprintf(new_graph->id,"%sbook(\"%s\",%lu,%lu,%lu,%lu,%ld,%ld,%ld)",
bipartite?"bi_":"",title,n,x,first_chapter,last_chapter,
in_weight,out_weight,seed);
if(bipartite){
mark_bipartite(new_graph,n-x);
chap_base= new_graph->vertices+(new_graph->n_1-first_chapter);
}
/*28:*/
#line 516 "./gb_books.w"

for(p= node_block;p<node_block+characters;p++)
p->key= in_weight*(p->in)+out_weight*(p->out)+0x40000000;
gb_linksort(node_block+characters-1);
k= n;
{register Vertex*v= new_graph->vertices;
for(j= 127;j>=0;j--)
for(p= (node*)gb_sorted[j];p;p= p->link){
if(x> 0)x--;
else p->vert= v++;
if(--k==0)goto done;
}
}
done:;

/*:28*/
#line 514 "./gb_books.w"
;

/*:27*/
#line 176 "./gb_books.w"
;
/*29:*/
#line 533 "./gb_books.w"

if(gb_open(file_name)!=0)
panic(impossible+1);

/*17:*/
#line 312 "./gb_books.w"

{register long c;
while((c= gb_number(36))!=0){register Vertex*v= xnode[c]->vert;
if(v){
if(gb_char()!=' ')panic(impossible);
gb_string(str_buf,',');
v->name= gb_save_string(str_buf);
if(gb_char()!=',')
panic(syntax_error+2);
if(gb_char()!=' ')
panic(syntax_error+3);
gb_string(str_buf,'\n');
v->desc= gb_save_string(str_buf);
v->in_count= xnode[c]->in;
v->out_count= xnode[c]->out;
v->short_code= c;
}
gb_newline();
}
gb_newline();
}

/*:17*/
#line 538 "./gb_books.w"
;
if(bipartite)
/*20:*/
#line 402 "./gb_books.w"

{
for(p= node_block;p<node_block+characters;p++)p->chap= 0;
for(k= 1;!gb_eof();k++){
gb_string(str_buf,':');
if(str_buf[0]=='&')k--;
else{
if(str_buf[strlen(str_buf)-1]=='\n')str_buf[strlen(str_buf)-1]= '\0';
chap_name[k]= gb_save_string(str_buf);
}
if(k>=first_chapter&&k<=last_chapter){register Vertex*u= chap_base+k;
if(str_buf[0]!='&'){
u->name= chap_name[k];
u->desc= null_string;
u->in_count= u->out_count= 0;
}
while(gb_char()!='\n'){register long c= gb_number(36);
p= xnode[c];
if(p->chap!=k){register Vertex*v= p->vert;
p->chap= k;
if(v){
gb_new_edge(v,u,1L);
u->in_count++;
}else u->out_count++;
}
}
}
gb_newline();
}
}

/*:20*/
#line 541 "./gb_books.w"

else/*22:*/
#line 445 "./gb_books.w"

for(k= 1;!gb_eof();k++){char*s;
s= gb_string(str_buf,':');
if(str_buf[0]=='&')k--;
else{if(*(s-2)=='\n')*(s-2)= '\0';
chap_name[k]= gb_save_string(str_buf);
}
if(k>=first_chapter&&k<=last_chapter){register long c= gb_char();
while(c!='\n'){register Vertex**pp= clique_table;
register Vertex**qq,**rr;
do{
c= gb_number(36);
if(xnode[c]->vert)
*pp++= xnode[c]->vert;

c= gb_char();
}while(c==',');
for(qq= clique_table;qq+1<pp;qq++)
for(rr= qq+1;rr<pp;rr++)
/*25:*/
#line 478 "./gb_books.w"

{register Vertex*u= *qq,*v= *rr;
register Arc*a;
for(a= u->arcs;a;a= a->next)
if(a->tip==v)goto found;
gb_new_edge(u,v,1L);
if(u<v)a= u->arcs;
else a= v->arcs;
a->chap_no= (a+1)->chap_no= k;
found:;
}

/*:25*/
#line 465 "./gb_books.w"
;
}
}
gb_newline();
}

/*:22*/
#line 543 "./gb_books.w"
;
if(gb_close()!=0)
panic(impossible+2);

/*:29*/
#line 177 "./gb_books.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);

}
return new_graph;
}

Graph*book(title,n,x,first_chapter,last_chapter,in_weight,out_weight,seed)
char*title;
unsigned long n,x,first_chapter,last_chapter;
long in_weight,out_weight,seed;
{return bgraph(0L,title,n,x,first_chapter,last_chapter,
in_weight,out_weight,seed);}
Graph*bi_book(title,n,x,first_chapter,last_chapter,in_weight,out_weight,seed)
char*title;
unsigned long n,x,first_chapter,last_chapter;
long in_weight,out_weight,seed;
{return bgraph(1L,title,n,x,first_chapter,last_chapter,
in_weight,out_weight,seed);}

/*:8*/
