/*1:*/
#line 21 "./queen.w"

#include "gb_graph.h" 
#include "gb_basic.h" 
#include "gb_save.h" 

main()
{Graph*g,*gg,*ggg;
g= board(3L,4L,0L,0L,-1L,0L,0L);
gg= board(3L,4L,0L,0L,-2L,0L,0L);
ggg= gunion(g,gg,0L,0L);
save_graph(ggg,"queen.gb");
/*2:*/
#line 36 "./queen.w"

if(ggg==NULL)printf("Something went wrong (panic code %ld)!\n",panic_code);
else{
register Vertex*v;
printf("Queen Moves on a 3x4 Board\n\n");
printf("  The graph whose official name is\n%s\n",ggg->id);
printf("  has %ld vertices and %ld arcs:\n\n",ggg->n,ggg->m);
for(v= ggg->vertices;v<ggg->vertices+ggg->n;v++){
register Arc*a;
printf("%s\n",v->name);
for(a= v->arcs;a;a= a->next)
printf("  -> %s, length %ld\n",a->tip->name,a->len);
}
}

/*:2*/
#line 32 "./queen.w"
;
return 0;
}

/*:1*/
