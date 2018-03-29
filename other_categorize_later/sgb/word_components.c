/*1:*/
#line 15 "./word_components.w"

#include "gb_graph.h" 
#include "gb_words.h" 
#define link z.V
#define master y.V
#define size x.I \


#line 18 "./word_components.w"

main()
{Graph*g= words(0L,0L,0L,0L);
Vertex*v;
Arc*a;
long n= 0;
long isol= 0;
long comp= 0;
long m= 0;
printf("Component analysis of %s\n",g->id);
for(v= g->vertices;v<g->vertices+g->n;v++){
n++,printf("%4ld: %5ld %s",n,v->weight,v->name);
/*2:*/
#line 42 "./word_components.w"

/*3:*/
#line 74 "./word_components.w"

v->link= v;
v->master= v;
v->size= 1;
isol++;
comp++;

/*:3*/
#line 43 "./word_components.w"
;
a= v->arcs;
while(a&&a->tip> v)a= a->next;
if(!a)printf("[1]");
else{long c= 0;
for(;a;a= a->next){register Vertex*u= a->tip;
m++;
/*4:*/
#line 85 "./word_components.w"

u= u->master;
if(u!=v->master){register Vertex*w= v->master,*t;
if(u->size<w->size){
if(c++> 0)printf("%s %s[%ld]",(c==2?" with":","),u->name,u->size);
w->size+= u->size;
if(u->size==1)isol--;
for(t= u->link;t!=u;t= t->link)t->master= w;
u->master= w;
}else{
if(c++> 0)printf("%s %s[%ld]",(c==2?" with":","),w->name,w->size);
if(u->size==1)isol--;
u->size+= w->size;
if(w->size==1)isol--;
for(t= w->link;t!=w;t= t->link)t->master= u;
w->master= u;
}
t= u->link;
u->link= w->link;
w->link= t;
comp--;
}

/*:4*/
#line 50 "./word_components.w"
;
}
printf(" in %s[%ld]",v->master->name,v->master->size);

}

/*:2*/
#line 31 "./word_components.w"
;
printf("; c=%ld,i=%ld,m=%ld\n",comp,isol,m);
}
/*5:*/
#line 112 "./word_components.w"

printf(
"\nThe following non-isolated words didn't join the giant component:\n");
for(v= g->vertices;v<g->vertices+g->n;v++)
if(v->master==v&&v->size> 1&&v->size+v->size<g->n){register Vertex*u;
long c= 1;
printf("%s",v->name);
for(u= v->link;u!=v;u= u->link){
if(c++==12)putchar('\n'),c= 1;
printf(" %s",u->name);
}
putchar('\n');
}

/*:5*/
#line 34 "./word_components.w"
;
return 0;
}

/*:1*/
