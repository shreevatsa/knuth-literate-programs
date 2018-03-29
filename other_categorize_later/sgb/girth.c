/*2:*/
#line 60 "./girth.w"

#include "gb_graph.h" 
#include "gb_raman.h" 
#define prompt(s)  \
{printf(s) ;fflush(stdout) ; \
if(fgets(buffer,15,stdin) ==NULL) break;} \

#define link w.V
#define dist v.I
#define back u.V \


#line 63 "./girth.w"

/*3:*/
#line 86 "./girth.w"

Graph*g;
long p;
long q;
char buffer[16];

/*:3*//*11:*/
#line 271 "./girth.w"

long gl,gu,dl,du;
long pp;
long s;
long n;
char bipartite;

/*:11*/
#line 64 "./girth.w"

main()
{
printf(
"This program explores the girth and diameter of Ramanujan graphs.\n");
printf("The bipartite graphs have q^3-q vertices, and the non-bipartite\n");
printf("graphs have half that number. Each vertex has degree p+1.\n");
printf("Both p and q should be odd prime numbers;\n");
printf("  or you can try p = 2 with q = 17 or 43.\n");
while(1){
/*4:*/
#line 96 "./girth.w"

prompt("\nChoose a branching factor, p: ");
if(sscanf(buffer,"%ld",&p)!=1)break;
prompt("OK, now choose the cube root of graph size, q: ");
if(sscanf(buffer,"%ld",&q)!=1)break;

/*:4*/
#line 74 "./girth.w"
;
g= raman(p,q,0L,0L);
if(g==NULL)/*5:*/
#line 102 "./girth.w"

printf(" Sorry, I couldn't make that graph (%s).\n",
panic_code==very_bad_specs?"q is out of range":
panic_code==very_bad_specs+1?"p is out of range":
panic_code==bad_specs+5?"q is too big":
panic_code==bad_specs+6?"p is too big":
panic_code==bad_specs+1?"q isn't prime":
panic_code==bad_specs+7?"p isn't prime":
panic_code==bad_specs+3?"p is a multiple of q":
panic_code==bad_specs+2?"q isn't compatible with p=2":
"not enough memory");

/*:5*/
#line 76 "./girth.w"

else{
/*10:*/
#line 250 "./girth.w"

n= g->n;
if(n==(q+1)*q*(q-1))bipartite= 1;
else bipartite= 0;
printf(
"The graph has %ld vertices, each of degree %ld, and it is %sbipartite.\n",
n,p+1,bipartite?"":"not ");
/*6:*/
#line 135 "./girth.w"

s= p+2;dl= 1;pp= p;gu= 3;
while(s<n){
s+= pp;
if(s<=n)gu++;
dl++;
pp*= p;
s+= pp;
if(s<=n)gu++;
}

/*:6*/
#line 257 "./girth.w"
;
printf("Any such graph must have diameter >= %ld and girth <= %ld;\n",
dl,gu);
/*8:*/
#line 218 "./girth.w"

{long nn= (bipartite?n:2*n);
for(du= 0,pp= 1;pp<nn;du+= 2,pp*= p);
/*9:*/
#line 232 "./girth.w"

{long qq= pp/nn;
if(qq*qq> p)du--;
else if((qq+1)*(qq+1)> p){
long aa= qq,bb= p-aa*aa,parity= 0;
pp-= qq*nn;
while(1){
long x= (aa+qq)/bb,y= nn-x*pp;
if(y<=0)break;
aa= bb*x-aa;
bb= (p-aa*aa)/bb;
nn= pp;pp= y;
parity^= 1;
}
if(!parity)du--;
}
}

/*:9*/
#line 221 "./girth.w"
;
if(bipartite)du++;
}

/*:8*/
#line 260 "./girth.w"
;
printf("theoretical considerations tell us that this one's diameter is <= %ld",
du);
if(p==2)printf(".\n");
else{
/*7:*/
#line 195 "./girth.w"

if(bipartite){long b= q*q;
for(gl= 1,pp= p;pp<=b;gl++,pp*= p);
gl+= gl;
}else{long b1= 1+4*q*q,b2= 4+3*q*q;
for(gl= 1,pp= p;pp<b1;gl++,pp*= p){
if(pp>=b2&&(gl&1)&&(p&2))break;
}
}

/*:7*/
#line 265 "./girth.w"
;
printf(",\nand its girth is >= %ld.\n",gl);
}

/*:10*/
#line 78 "./girth.w"
;
/*12:*/
#line 299 "./girth.w"

printf("Starting at any given vertex, there are\n");
{long k;
long c;
register Vertex*v;
register Vertex*u;
Vertex*sentinel= g->vertices+n;
long girth= 999;
k= 0;
u= g->vertices;
u->link= sentinel;
c= 1;
while(c){
for(v= u,u= sentinel,c= 0,k++;v!=sentinel;v= v->link)
/*13:*/
#line 320 "./girth.w"

{register Arc*a;
for(a= v->arcs;a;a= a->next){register Vertex*w;

w= a->tip;
if(w->link==NULL){
w->link= u;
w->dist= k;
w->back= v;
u= w;
c++;
}else if(w->dist+k<girth&&w!=v->back)
girth= w->dist+k;
}
}

/*:13*/
#line 314 "./girth.w"
;
printf("%8ld vertices at distance %ld%s\n",c,k,c> 0?",":".");
}
printf("So the diameter is %ld, and the girth is %ld.\n",k-1,girth);
}

/*:12*/
#line 79 "./girth.w"
;
gb_recycle(g);
}
}
return 0;
}

/*:2*/
