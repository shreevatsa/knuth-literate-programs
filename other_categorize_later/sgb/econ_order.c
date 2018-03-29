/*2:*/
#line 74 "./econ_order.w"

#include "gb_graph.h" 
#include "gb_flip.h" 
#include "gb_econ.h" 
#define INF 0x7fffffff \

#define sec_name(k) (g->vertices+mapping[k]) ->name \


#line 78 "./econ_order.w"

/*3:*/
#line 111 "./econ_order.w"

Graph*g;
long mat[79][79];
long del[79][79];
long best_score= INF;

/*:3*//*7:*/
#line 189 "./econ_order.w"

long mapping[79];
long score;
long steps;

/*:7*//*12:*/
#line 264 "./econ_order.w"

long best_d;
long best_k,best_j;

/*:12*/
#line 79 "./econ_order.w"

main(argc,argv)
int argc;
char*argv[];
{unsigned long n= 79;
long s= 0;
long t= 0;
unsigned long r= 1;
long greedy= 0;
register long j,k;
/*4:*/
#line 117 "./econ_order.w"

while(--argc){

if(sscanf(argv[argc],"-n%lu",&n)==1);
else if(sscanf(argv[argc],"-r%lu",&r)==1);
else if(sscanf(argv[argc],"-s%ld",&s)==1);
else if(sscanf(argv[argc],"-t%ld",&t)==1);
else if(strcmp(argv[argc],"-v")==0)verbose= 1;
else if(strcmp(argv[argc],"-V")==0)verbose= 2;
else if(strcmp(argv[argc],"-g")==0)greedy= 1;
else{
fprintf(stderr,"Usage: %s [-nN][-rN][-sN][-tN][-g][-v][-V]\n",argv[0]);
return-2;
}
}

/*:4*/
#line 89 "./econ_order.w"
;
g= econ(n,2L,0L,s);
if(g==NULL){
fprintf(stderr,"Sorry, can't create the matrix! (error code %ld)\n",
panic_code);
return-1;
}
printf("Ordering the sectors of %s, using seed %ld:\n",g->id,t);
printf(" (%s descent method)\n",greedy?"Steepest":"Cautious");
/*5:*/
#line 137 "./econ_order.w"

{register Vertex*v;
register Arc*a;
n= g->n;
for(v= g->vertices;v<g->vertices+n;v++)
for(a= v->arcs;a;a= a->next)
mat[v-g->vertices][a->tip-g->vertices]= a->flow;
for(j= 0;j<n;j++)
for(k= 0;k<n;k++)
del[j][k]= mat[j][k]-mat[k][j];
}

/*:5*/
#line 98 "./econ_order.w"
;
/*6:*/
#line 171 "./econ_order.w"

{register long sum= 0;
for(j= 1;j<n;j++)
for(k= 0;k<j;k++)
if(mat[j][k]<=mat[k][j])sum+= mat[j][k];
else sum+= mat[k][j];
printf("(The amount of feed-forward must be at least %ld.)\n",sum);
}

/*:6*/
#line 99 "./econ_order.w"
;
gb_init_rand(t);
while(r--)
/*8:*/
#line 194 "./econ_order.w"

{
/*9:*/
#line 217 "./econ_order.w"

steps= score= 0;
for(k= 0;k<n;k++){
j= gb_unif_rand(k+1);
mapping[k]= mapping[j];
mapping[j]= k;
}
for(j= 1;j<n;j++)for(k= 0;k<j;k++)score+= mat[mapping[j]][mapping[k]];
if(verbose> 1){
printf("\nInitial permutation:\n");
for(k= 0;k<n;k++)printf(" %s\n",sec_name(k));
}

/*:9*/
#line 196 "./econ_order.w"
;
while(1){
/*10:*/
#line 241 "./econ_order.w"

best_d= greedy?0:INF;
best_k= -1;
for(k= 0;k<n;k++){register long d= 0;
for(j= k-1;j>=0;j--){
d+= del[mapping[k]][mapping[j]];
/*11:*/
#line 257 "./econ_order.w"

if(d> 0&&(greedy?d> best_d:d<best_d)){
best_k= k;
best_j= j;
best_d= d;
}

/*:11*/
#line 247 "./econ_order.w"
;
}
d= 0;
for(j= k+1;j<n;j++){
d+= del[mapping[j]][mapping[k]];
/*11:*/
#line 257 "./econ_order.w"

if(d> 0&&(greedy?d> best_d:d<best_d)){
best_k= k;
best_j= j;
best_d= d;
}

/*:11*/
#line 252 "./econ_order.w"
;
}
}
if(best_k<0)break;

/*:10*/
#line 198 "./econ_order.w"
;
if(verbose)printf("%8ld after step %ld\n",score,steps);
else if(steps%1000==0&&steps> 0){
putchar('.');
fflush(stdout);
}
/*13:*/
#line 268 "./econ_order.w"

if(verbose> 1)
printf("Now move %s to the %s, past\n",sec_name(best_k),
best_j<best_k?"left":"right");
j= best_k;
k= mapping[j];
do{
if(best_j<best_k)mapping[j]= mapping[j-1],j--;
else mapping[j]= mapping[j+1],j++;
if(verbose> 1)printf("    %s (%ld)\n",sec_name(j),
best_j<best_k?del[mapping[j+1]][k]:
del[k][mapping[j-1]]);
}while(j!=best_j);
mapping[j]= k;
score-= best_d;
steps++;

/*:13*/
#line 204 "./econ_order.w"
;
}
printf("\n%s is %ld, found after %ld step%s.\n",
best_score==INF?"Local minimum feed-forward":
"Another local minimum",
score,steps,steps==1?"":"s");
if(verbose||score<best_score){
printf("The corresponding economic order is:\n");
for(k= 0;k<n;k++)printf(" %s\n",sec_name(k));
if(score<best_score)best_score= score;
}
}

/*:8*/
#line 102 "./econ_order.w"
;
return 0;
}

/*:2*/
