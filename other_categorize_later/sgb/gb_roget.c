/*4:*/
#line 69 "./gb_roget.w"

#include "gb_io.h" 
#include "gb_flip.h"

#include "gb_graph.h"

#define MAX_N 1022 \

#define panic(c) {panic_code= c;gb_trouble_code= 0;return NULL;} \

#define cat_no u.I \

#define iabs(x) ((x) <0?-(x) :(x) )  \


#line 75 "./gb_roget.w"

/*7:*/
#line 116 "./gb_roget.w"

static Vertex*mapping[MAX_N+1];

static long cats[MAX_N];


/*:7*/
#line 76 "./gb_roget.w"


Graph*roget(n,min_distance,prob,seed)
unsigned long n;
unsigned long min_distance;

unsigned long prob;
long seed;
{/*5:*/
#line 97 "./gb_roget.w"

Graph*new_graph;

/*:5*//*9:*/
#line 135 "./gb_roget.w"

register long j,k;
register Vertex*v;

/*:9*/
#line 84 "./gb_roget.w"

gb_init_rand(seed);
if(n==0||n> MAX_N)n= MAX_N;
/*6:*/
#line 102 "./gb_roget.w"

new_graph= gb_new_graph(n);
if(new_graph==NULL)
panic(no_room);
sprintf(new_graph->id,"roget(%lu,%lu,%lu,%ld)",n,min_distance,prob,seed);
strcpy(new_graph->util_types,"IZZZZZZZZZZZZZ");

/*:6*/
#line 87 "./gb_roget.w"
;
/*8:*/
#line 127 "./gb_roget.w"

for(k= 0;k<MAX_N;k++)
cats[k]= k+1,mapping[k+1]= NULL;
for(v= new_graph->vertices+n-1;v>=new_graph->vertices;v--){
j= gb_unif_rand(k);
mapping[cats[j]]= v;cats[j]= cats[--k];
}

/*:8*/
#line 88 "./gb_roget.w"
;
/*10:*/
#line 151 "./gb_roget.w"

if(gb_open("roget.dat")!=0)
panic(early_data_fault);

for(k= 1;!gb_eof();k++)
/*11:*/
#line 173 "./gb_roget.w"

{
if(mapping[k]){
if(gb_number(10)!=k)panic(syntax_error);
(void)gb_string(str_buf,':');
if(gb_char()!=':')panic(syntax_error+1);
v= mapping[k];
v->name= gb_save_string(str_buf);
v->cat_no= k;
/*13:*/
#line 193 "./gb_roget.w"

j= gb_number(10);
if(j==0)goto done;
while(1){
if(j> MAX_N)panic(syntax_error+2);
if(mapping[j]&&iabs(j-k)>=min_distance&&
(prob==0||((gb_next_rand()>>15)>=prob)))
gb_new_arc(v,mapping[j],1L);
switch(gb_char()){
case'\\':gb_newline();
if(gb_char()!=' ')
panic(syntax_error+3);

case' ':j= gb_number(10);break;
case'\n':goto done;
default:panic(syntax_error+4);

}
}
done:gb_newline();

/*:13*/
#line 183 "./gb_roget.w"
;
}else/*14:*/
#line 221 "./gb_roget.w"

{
if(*(gb_string(str_buf,'\n')-2)=='\\')
gb_newline();
gb_newline();
}

/*:14*/
#line 184 "./gb_roget.w"
;
}

/*:11*/
#line 157 "./gb_roget.w"
;
if(gb_close()!=0)
panic(late_data_fault);

if(k!=MAX_N+1)panic(impossible);


/*:10*/
#line 89 "./gb_roget.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
return new_graph;
}

/*:4*/
