/*7:*/
#line 151 "./gb_words.w"

#include "gb_io.h" 
#include "gb_flip.h"

#include "gb_graph.h" 
#include "gb_sort.h" 
#define panic(c) {gb_free(node_blocks) ; \
panic_code= c;gb_trouble_code= 0;return NULL;} \

#define nodes_per_block 111 \

#define copy5(y,x) { \
*(y) = *(x) ; \
*((y) +1) = *((x) +1) ; \
*((y) +2) = *((x) +2) ; \
*((y) +3) = *((x) +3) ; \
*((y) +4) = *((x) +4) ; \
} \

#define hash_prime 6997 \

#define weight u.I
#define loc a.I \

#define mtch(i) (*(q+i) ==*(r+i) ) 
#define match(a,b,c,d) (mtch(a) &&mtch(b) &&mtch(c) &&mtch(d) ) 
#define store_loc_of_diff(k) cur_vertex->arcs->loc= (cur_vertex->arcs-1) ->loc= k
#define ch(q) ((long) *(q) ) 
#define hdown(k) h==htab[k]?h= htab[k+1]-1:h-- \


#line 157 "./gb_words.w"

/*15:*/
#line 281 "./gb_words.w"

typedef struct node_struct{
long key;
struct node_struct*link;
char wd[5];

}node;

/*:15*//*23:*/
#line 404 "./gb_words.w"

typedef Vertex*hash_table[hash_prime];

/*:23*/
#line 158 "./gb_words.w"

/*4:*/
#line 97 "./gb_words.w"

static long max_c[]= {15194,3560,4467,460,6976,756,362};

static long default_wt_vector[]= {100,10,4,2,2,1,1,1,1};


/*:4*//*17:*/
#line 295 "./gb_words.w"

static Area node_blocks;

/*:17*//*25:*/
#line 411 "./gb_words.w"

static hash_table*htab;

/*:25*/
#line 159 "./gb_words.w"

/*10:*/
#line 209 "./gb_words.w"

static double flabs(x)
long x;
{if(x>=0)return(double)x;
return-((double)x);
}

/*:10*//*13:*/
#line 255 "./gb_words.w"

static long iabs(x)
long x;
{if(x>=0)return(long)x;
return-((long)x);
}

/*:13*/
#line 160 "./gb_words.w"


Graph*words(n,wt_vector,wt_threshold,seed)
unsigned long n;
long wt_vector[];
long wt_threshold;
long seed;
{/*8:*/
#line 179 "./gb_words.w"

Graph*new_graph;

/*:8*//*14:*/
#line 264 "./gb_words.w"

register long wt;
char word[5];
long nn= 0;

/*:14*//*16:*/
#line 289 "./gb_words.w"

node*next_node;
node*bad_node;
node*stack_ptr;
node*cur_node;

/*:16*//*24:*/
#line 407 "./gb_words.w"

Vertex*cur_vertex;
char*next_string;

/*:24*/
#line 167 "./gb_words.w"

gb_init_rand(seed);
/*9:*/
#line 196 "./gb_words.w"

if(!wt_vector)wt_vector= default_wt_vector;
else{register double flacc;
register long*p,*q;
register long acc;
/*11:*/
#line 229 "./gb_words.w"

p= wt_vector;
flacc= flabs(*p++);
if(flacc<flabs(*p))flacc= flabs(*p);

for(q= &max_c[0];q<&max_c[7];q++)
flacc+= *q*flabs(*++p);
if(flacc>=(double)0x60000000)

panic(very_bad_specs);

/*:11*/
#line 202 "./gb_words.w"
;
/*12:*/
#line 245 "./gb_words.w"

p= wt_vector;
acc= iabs(*p++);
if(acc<iabs(*p))acc= iabs(*p);

for(q= &max_c[0];q<&max_c[7];q++)
acc+= *q*iabs(*++p);
if(acc>=0x40000000)
panic(bad_specs);

/*:12*/
#line 203 "./gb_words.w"
;
}

/*:9*/
#line 169 "./gb_words.w"
;
/*18:*/
#line 298 "./gb_words.w"

next_node= bad_node= stack_ptr= NULL;
if(gb_open("words.dat")!=0)
panic(early_data_fault);


do/*19:*/
#line 310 "./gb_words.w"

{register long j;
for(j= 0;j<5;j++)word[j]= gb_char();
/*21:*/
#line 349 "./gb_words.w"

{register long*p,*q;
register long c;
switch(gb_char()){
case'*':wt= wt_vector[0];break;
case'+':wt= wt_vector[1];break;
case' ':case'\n':wt= 0;break;
default:panic(syntax_error);
}
p= &max_c[0];q= &wt_vector[2];
do{
if(p==&max_c[7])
panic(syntax_error+1);
c= gb_number(10);
if(c> *p++)
panic(syntax_error+2);
wt+= c**q++;
}while(gb_char()==',');
}

/*:21*/
#line 313 "./gb_words.w"
;
if(wt>=wt_threshold){
/*20:*/
#line 329 "./gb_words.w"

if(next_node==bad_node){
cur_node= gb_typed_alloc(nodes_per_block,node,node_blocks);
if(cur_node==NULL)
panic(no_room+1);
next_node= cur_node+1;
bad_node= cur_node+nodes_per_block;
}else cur_node= next_node++;
cur_node->key= wt+0x40000000;
cur_node->link= stack_ptr;
copy5(cur_node->wd,word);
stack_ptr= cur_node;

/*:20*/
#line 315 "./gb_words.w"
;
nn++;
}
gb_newline();
}

/*:19*/
#line 304 "./gb_words.w"

while(!gb_eof());
if(gb_close()!=0)
panic(late_data_fault);


/*:18*/
#line 170 "./gb_words.w"
;
/*22:*/
#line 381 "./gb_words.w"

gb_linksort(stack_ptr);
/*27:*/
#line 425 "./gb_words.w"

if(n==0||nn<n)
n= nn;
new_graph= gb_new_graph(n);
if(new_graph==NULL)
panic(no_room);
if(wt_vector==default_wt_vector)
sprintf(new_graph->id,"words(%lu,0,%ld,%ld)",n,wt_threshold,seed);
else sprintf(new_graph->id,
"words(%lu,{%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld},%ld,%ld)",
n,wt_vector[0],wt_vector[1],wt_vector[2],wt_vector[3],wt_vector[4],
wt_vector[5],wt_vector[6],wt_vector[7],wt_vector[8],wt_threshold,seed);
strcpy(new_graph->util_types,"IZZZZZIZZZZZZZ");
cur_vertex= new_graph->vertices;
next_string= gb_typed_alloc(6*n,char,new_graph->data);
htab= gb_typed_alloc(5,hash_table,new_graph->aux_data);

/*:27*/
#line 383 "./gb_words.w"
;
if(gb_trouble_code==0&&n){
register long j;
register node*p;
nn= n;
for(j= 127;j>=0;j--)
for(p= (node*)gb_sorted[j];p;p= p->link){
/*28:*/
#line 442 "./gb_words.w"

{register char*q;
q= cur_vertex->name= next_string;
next_string+= 6;
copy5(q,p->wd);
cur_vertex->weight= p->key-0x40000000;
/*29:*/
#line 461 "./gb_words.w"

{register char*r;
register Vertex**h;
register long raw_hash;
raw_hash= (((((((ch(q)<<5)+ch(q+1))<<5)+ch(q+2))<<5)+ch(q+3))<<5)+ch(q+4);
for(h= htab[0]+(raw_hash-(ch(q)<<20))%hash_prime;*h;hdown(0)){
r= (*h)->name;
if(match(1,2,3,4))
gb_new_edge(cur_vertex,*h,1L),store_loc_of_diff(0);
}
*h= cur_vertex;
for(h= htab[1]+(raw_hash-(ch(q+1)<<15))%hash_prime;*h;hdown(1)){
r= (*h)->name;
if(match(0,2,3,4))
gb_new_edge(cur_vertex,*h,1L),store_loc_of_diff(1);
}
*h= cur_vertex;
for(h= htab[2]+(raw_hash-(ch(q+2)<<10))%hash_prime;*h;hdown(2)){
r= (*h)->name;
if(match(0,1,3,4))
gb_new_edge(cur_vertex,*h,1L),store_loc_of_diff(2);
}
*h= cur_vertex;
for(h= htab[3]+(raw_hash-(ch(q+3)<<5))%hash_prime;*h;hdown(3)){
r= (*h)->name;
if(match(0,1,2,4))
gb_new_edge(cur_vertex,*h,1L),store_loc_of_diff(3);
}
*h= cur_vertex;
for(h= htab[4]+(raw_hash-ch(q+4))%hash_prime;*h;hdown(4)){
r= (*h)->name;
if(match(0,1,2,3))
gb_new_edge(cur_vertex,*h,1L),store_loc_of_diff(4);
}
*h= cur_vertex;
}

/*:29*/
#line 448 "./gb_words.w"
;
cur_vertex++;
}

/*:28*/
#line 390 "./gb_words.w"
;
if(--nn==0)goto done;
}
}
done:gb_free(node_blocks);

/*:22*/
#line 171 "./gb_words.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
return new_graph;
}

/*:7*//*30:*/
#line 508 "./gb_words.w"
Vertex*find_word(q,f)
char*q;
void(*f)();

{register char*r;
register Vertex**h;
register long raw_hash;
raw_hash= (((((((ch(q)<<5)+ch(q+1))<<5)+ch(q+2))<<5)+ch(q+3))<<5)+ch(q+4);
for(h= htab[0]+(raw_hash-(ch(q)<<20))%hash_prime;*h;hdown(0)){
r= (*h)->name;
if(mtch(0)&&match(1,2,3,4))
return*h;
}
/*31:*/
#line 525 "./gb_words.w"

if(f){
for(h= htab[0]+(raw_hash-(ch(q)<<20))%hash_prime;*h;hdown(0)){
r= (*h)->name;
if(match(1,2,3,4))
(*f)(*h);
}
for(h= htab[1]+(raw_hash-(ch(q+1)<<15))%hash_prime;*h;hdown(1)){
r= (*h)->name;
if(match(0,2,3,4))
(*f)(*h);
}
for(h= htab[2]+(raw_hash-(ch(q+2)<<10))%hash_prime;*h;hdown(2)){
r= (*h)->name;
if(match(0,1,3,4))
(*f)(*h);
}
for(h= htab[3]+(raw_hash-(ch(q+3)<<5))%hash_prime;*h;hdown(3)){
r= (*h)->name;
if(match(0,1,2,4))
(*f)(*h);
}
for(h= htab[4]+(raw_hash-ch(q+4))%hash_prime;*h;hdown(4)){
r= (*h)->name;
if(match(0,1,2,3))
(*f)(*h);
}
}

/*:31*/
#line 521 "./gb_words.w"
;
return NULL;
}

/*:30*/
