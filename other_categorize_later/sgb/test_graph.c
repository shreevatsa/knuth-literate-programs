/*2:*/
#line 24 "./gb_graph.w"

#include "gb_graph.h"  
/*19:*/
#line 347 "./gb_graph.w"

Area s;

/*:19*//*37:*/
#line 726 "./gb_graph.w"

Graph*g;
Vertex*u,*v;

/*:37*/
#line 26 "./gb_graph.w"


int main()
{
/*36:*/
#line 716 "./gb_graph.w"

g= gb_new_graph(2L);
if(g==NULL){
fprintf(stderr,"Oops, I couldn't even create a trivial graph!\n");
return-4;
}
u= g->vertices;v= u+1;
u->name= gb_save_string("vertex 0");
v->name= gb_save_string("vertex 1");

/*:36*/
#line 30 "./gb_graph.w"
;
/*18:*/
#line 327 "./gb_graph.w"

if(gb_alloc(0L,s)!=NULL||gb_trouble_code!=2){
fprintf(stderr,"Allocation error 2 wasn't reported properly!\n");return-2;
}
for(;g->vv.I<100;g->vv.I++)if(gb_alloc(100000L,s)){
g->uu.I++;
printf(".");
fflush(stdout);
}
if(g->uu.I<100&&gb_trouble_code!=3){
fprintf(stderr,"Allocation error 1 wasn't reported properly!\n");return-1;
}
if(g->uu.I==0){
fprintf(stderr,"I couldn't allocate any memory!\n");return-3;
}
gb_free(s);
printf("Hey, I allocated %ld00000 bytes successfully. Terrific...\n",g->uu.I);

gb_trouble_code= 0;

/*:18*/
#line 31 "./gb_graph.w"
;
/*38:*/
#line 735 "./gb_graph.w"

if(strncmp(u->name,v->name,7)){
fprintf(stderr,"Something is fouled up in the string storage machinery!\n");
return-5;
}
gb_new_edge(v,u,-1L);
gb_new_edge(u,u,1L);
gb_new_arc(v,u,-1L);
if((edge_trick&(siz_t)(u->arcs))||
(edge_trick&(siz_t)(u->arcs->next->next))||
!(edge_trick&(siz_t)(v->arcs->next)))
printf("Warning: The \"edge trick\" failed!\n");
if(v->name[7]+g->n!=v->arcs->next->tip->name[7]+g->m-2){

fprintf(stderr,"Sorry, the graph data structures aren't working yet.\n");
return-6;
}

/*:38*/
#line 32 "./gb_graph.w"
;
printf("OK, the gb_graph routines seem to work!\n");
return 0;
}

/*:2*/
