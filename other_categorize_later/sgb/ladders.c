/*3:*/
#line 83 "./ladders.w"

#include <ctype.h>  
#include "gb_graph.h" 
#include "gb_words.h" 
#include "gb_dijk.h" 
#define quit_if(x,c)  \
if(x) { \
fprintf(stderr, \
"Sorry, I couldn't build a dictionary (trouble code %ld)!\n",c) ; \
return c; \
} \

#define a_dist(k) (*(p+k) <*(q+k) ?*(q+k) -*(p+k) :*(p+k) -*(q+k) )  \

#define h_dist(k) (*(p+k) ==*(q+k) ?0:1)  \


#line 88 "./ladders.w"

/*4:*/
#line 111 "./ladders.w"

char alph= 0;
char freq= 0;
char heur= 0;
char echo= 0;
unsigned long n= 0;
char randm= 0;
long seed= 0;

/*:4*//*7:*/
#line 156 "./ladders.w"

Graph*g;
long zero_vector[9];


/*:7*//*12:*/
#line 239 "./ladders.w"

Graph*gg;
char start[6],goal[6];

Vertex*uu,*vv;

/*:12*//*23:*/
#line 347 "./ladders.w"

long min_dist;

/*:23*/
#line 89 "./ladders.w"

/*11:*/
#line 216 "./ladders.w"

long freq_cost(v)
Vertex*v;
{register long acc= v->weight;
register long k= 16;
while(acc)k--,acc>>= 1;
return(k<0?0:k);
}

/*:11*//*17:*/
#line 284 "./ladders.w"

long alph_dist(p,q)
register char*p,*q;
{
return a_dist(0)+a_dist(1)+a_dist(2)+a_dist(3)+a_dist(4);
}

/*:17*//*18:*/
#line 291 "./ladders.w"

void plant_new_edge(v)
Vertex*v;
{Vertex*u= gg->vertices+gg->n;
gb_new_edge(u,v,1L);
if(alph)
u->arcs->len= (u->arcs-1)->len= alph_dist(u->name,v->name);
else if(freq){
u->arcs->len= freq_cost(v);
(u->arcs-1)->len= 20;
}
}

/*:18*//*20:*/
#line 324 "./ladders.w"

long hamm_dist(p,q)
register char*p,*q;
{
return h_dist(0)+h_dist(1)+h_dist(2)+h_dist(3)+h_dist(4);
}

/*:20*//*22:*/
#line 338 "./ladders.w"

long alph_heur(v)
Vertex*v;
{return alph_dist(v->name,goal);}

long hamm_heur(v)
Vertex*v;
{return hamm_dist(v->name,goal);}

/*:22*//*27:*/
#line 380 "./ladders.w"

long prompt_for_five(s,p)
char*s;
register char*p;
{register char*q;
register long c;
while(1){
printf("%s word: ",s);
fflush(stdout);
q= p;
while(1){
c= getchar();
if(c==EOF)return-1;
if(echo)putchar(c);
if(c=='\n')break;
if(!islower(c))q= p+5;
else if(q<p+5)*q= c;
q++;
}
if(q==p+5)return 0;
if(q==p)return 1;
printf("(Please type five lowercase letters and RETURN.)\n");
}
}

/*:27*/
#line 90 "./ladders.w"

main(argc,argv)
int argc;
char*argv[];
{
/*5:*/
#line 120 "./ladders.w"

while(--argc){

if(strcmp(argv[argc],"-v")==0)verbose= 1;
else if(strcmp(argv[argc],"-a")==0)alph= 1;
else if(strcmp(argv[argc],"-f")==0)freq= 1;
else if(strcmp(argv[argc],"-h")==0)heur= 1;
else if(strcmp(argv[argc],"-e")==0)echo= 1;
else if(sscanf(argv[argc],"-n%lu",&n)==1)randm= 0;
else if(sscanf(argv[argc],"-r%lu",&n)==1)randm= 1;
else if(sscanf(argv[argc],"-s%ld",&seed)==1);
else{
fprintf(stderr,"Usage: %s [-v][-a][-f][-h][-e][-nN][-rN][-sN]\n",argv[0]);
return-2;
}
}
if(alph||randm)freq= 0;
if(freq)heur= 0;

/*:5*/
#line 95 "./ladders.w"
;
/*6:*/
#line 149 "./ladders.w"

g= words(n,(randm?zero_vector:NULL),0L,seed);
quit_if(g==NULL,panic_code);
/*8:*/
#line 165 "./ladders.w"

if(verbose){
if(alph)printf("(alphabetic distance selected)\n");
if(freq)printf("(frequency-based distances selected)\n");
if(heur)
printf("(lowerbound heuristic will be used to focus the search)\n");
if(randm)printf("(random selection of %ld words with seed %ld)\n",
g->n,seed);
else printf("(the graph has %ld words)\n",g->n);
}

/*:8*/
#line 152 "./ladders.w"
;
/*9:*/
#line 183 "./ladders.w"

if(alph){register Vertex*u;
for(u= g->vertices+g->n-1;u>=g->vertices;u--){register Arc*a;
register char*p= u->name;
for(a= u->arcs;a;a= a->next){register char*q= a->tip->name;
a->len= a_dist(a->loc);
}
}
}else if(freq){register Vertex*u;
for(u= g->vertices+g->n-1;u>=g->vertices;u--){register Arc*a;
for(a= u->arcs;a;a= a->next)
a->len= freq_cost(a->tip);
}
}

/*:9*/
#line 153 "./ladders.w"
;
/*10:*/
#line 202 "./ladders.w"

if(alph||freq||heur){
init_queue= init_128;
del_min= del_128;
enqueue= enq_128;
requeue= req_128;
}

/*:10*/
#line 154 "./ladders.w"
;

/*:6*/
#line 96 "./ladders.w"
;
while(1){
/*26:*/
#line 373 "./ladders.w"

putchar('\n');
restart:

if(prompt_for_five("Starting",start)!=0)break;
if(prompt_for_five("    Goal",goal)!=0)goto restart;

/*:26*/
#line 98 "./ladders.w"
;
/*13:*/
#line 245 "./ladders.w"

/*14:*/
#line 251 "./ladders.w"

gg= gb_new_graph(0L);
quit_if(gg==NULL,no_room+5);
gg->vertices= g->vertices;
gg->n= g->n;
/*15:*/
#line 266 "./ladders.w"

(gg->vertices+gg->n)->name= start;
uu= find_word(start,plant_new_edge);
if(!uu)
uu= gg->vertices+gg->n++;

/*:15*/
#line 256 "./ladders.w"
;
/*16:*/
#line 272 "./ladders.w"

if(strncmp(start,goal,5)==0)vv= uu;
else{
(gg->vertices+gg->n)->name= goal;
vv= find_word(goal,plant_new_edge);
if(!vv)
vv= gg->vertices+gg->n++;
}

/*:16*/
#line 257 "./ladders.w"
;
if(gg->n==g->n+2)/*19:*/
#line 311 "./ladders.w"

if(hamm_dist(start,goal)==1){
gg->n--;
plant_new_edge(uu);
gg->n++;
}

/*:19*/
#line 258 "./ladders.w"
;
quit_if(gb_trouble_code,no_room+6);

/*:14*/
#line 246 "./ladders.w"
;
/*21:*/
#line 333 "./ladders.w"

if(!heur)min_dist= dijkstra(uu,vv,gg,NULL);
else if(alph)min_dist= dijkstra(uu,vv,gg,alph_heur);
else min_dist= dijkstra(uu,vv,gg,hamm_heur);

/*:21*/
#line 247 "./ladders.w"
;
/*24:*/
#line 350 "./ladders.w"

if(min_dist<0)printf("Sorry, there's no ladder from %s to %s.\n",start,goal);
else print_dijkstra_result(vv);

/*:24*/
#line 248 "./ladders.w"
;
/*25:*/
#line 360 "./ladders.w"

for(uu= g->vertices+gg->n-1;uu>=g->vertices+g->n;uu--){register Arc*a;
for(a= uu->arcs;a;a= a->next){
vv= a->tip;
vv->arcs= vv->arcs->next;
}
uu->arcs= NULL;
}
gb_recycle(gg);

/*:25*/
#line 249 "./ladders.w"
;

/*:13*/
#line 100 "./ladders.w"
;
}
return 0;
}

/*:3*/
