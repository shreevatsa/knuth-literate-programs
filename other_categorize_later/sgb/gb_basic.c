/*2:*/
#line 32 "./gb_basic.w"

#include "gb_graph.h" 
#define panic(c)  \
{panic_code= c; \
gb_free(working_storage) ; \
gb_trouble_code= 0; \
return NULL; \
} \

#define BUF_SIZE 4096 \

#define MAX_D 91 \

#define MAX_NNN 1000000000.0 \

#define UL_BITS 8*sizeof(unsigned long)  \

#define vert_offset(v,delta) ((Vertex*) (((siz_t) v) +delta) )  \
 \

#define tmp u.V \

#define tlen z.A \

#define mult v.I
#define minlen w.I \

#define map z.V \

#define ind z.I \

#define IND_GRAPH 1000000000
#define subst y.G \


#line 34 "./gb_basic.w"

/*3:*/
#line 42 "./gb_basic.w"

static Area working_storage;

/*:3*//*5:*/
#line 68 "./gb_basic.w"

static char buffer[BUF_SIZE];

/*:5*//*10:*/
#line 226 "./gb_basic.w"

static long nn[MAX_D+1];
static long wr[MAX_D+1];
static long del[MAX_D+1];
static long sig[MAX_D+2];
static long xx[MAX_D+1],yy[MAX_D+1];

/*:10*//*51:*/
#line 1037 "./gb_basic.w"

static char*short_imap= "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ\
abcdefghijklmnopqrstuvwxyz_^~&@,;.:?!%#$+-*/|<=>()[]{}`'";

/*:51*/
#line 35 "./gb_basic.w"

/*8:*/
#line 175 "./gb_basic.w"

Graph*board(n1,n2,n3,n4,piece,wrap,directed)
long n1,n2,n3,n4;
long piece;
long wrap;
long directed;
{/*9:*/
#line 198 "./gb_basic.w"

Graph*new_graph;
register long i,j,k;
register long d;
register Vertex*v;
register long s;

/*:9*/
#line 181 "./gb_basic.w"

long n;
long p;
long l;
/*11:*/
#line 233 "./gb_basic.w"

if(piece==0)piece= 1;
if(n1<=0){n1= n2= 8;n3= 0;}
nn[1]= n1;
if(n2<=0){k= 2;d= -n2;n3= n4= 0;}
else{
nn[2]= n2;
if(n3<=0){k= 3;d= -n3;n4= 0;}
else{
nn[3]= n3;
if(n4<=0){k= 4;d= -n4;}
else{nn[4]= n4;d= 4;goto done;}
}
}
if(d==0){d= k-1;goto done;}
/*12:*/
#line 255 "./gb_basic.w"

if(d> MAX_D)panic(bad_specs);
for(j= 1;k<=d;j++,k++)nn[k]= nn[j];

/*:12*/
#line 248 "./gb_basic.w"
;
done:

/*:11*/
#line 185 "./gb_basic.w"
;
/*13:*/
#line 265 "./gb_basic.w"

{float nnn;
for(n= 1,nnn= 1.0,j= 1;j<=d;j++){
nnn*= (float)nn[j];
if(nnn> MAX_NNN)panic(very_bad_specs);
n*= nn[j];
}
new_graph= gb_new_graph(n);
if(new_graph==NULL)
panic(no_room);
sprintf(new_graph->id,"board(%ld,%ld,%ld,%ld,%ld,%ld,%d)",
n1,n2,n3,n4,piece,wrap,directed?1:0);
strcpy(new_graph->util_types,"ZZZIIIZZZZZZZZ");
/*14:*/
#line 294 "./gb_basic.w"

{register char*q;
nn[0]= xx[0]= xx[1]= xx[2]= xx[3]= 0;
for(k= 4;k<=d;k++)xx[k]= 0;
for(v= new_graph->vertices;;v++){
q= buffer;
for(k= 1;k<=d;k++){
sprintf(q,".%ld",xx[k]);
while(*q)q++;
}
v->name= gb_save_string(&buffer[1]);
v->x.I= xx[1];v->y.I= xx[2];v->z.I= xx[3];
for(k= d;xx[k]+1==nn[k];k--)xx[k]= 0;
if(k==0)break;
xx[k]++;
}
}

/*:14*/
#line 278 "./gb_basic.w"
;
}

/*:13*/
#line 186 "./gb_basic.w"
;
/*15:*/
#line 322 "./gb_basic.w"

/*16:*/
#line 341 "./gb_basic.w"

{register long w= wrap;
for(k= 1;k<=d;k++,w>>= 1){
wr[k]= w&1;
del[k]= sig[k]= 0;
}
sig[0]= del[0]= sig[d+1]= 0;
}

/*:16*/
#line 323 "./gb_basic.w"
;
p= piece;
if(p<0)p= -p;
while(1){
/*17:*/
#line 353 "./gb_basic.w"

for(k= d;sig[k]+(del[k]+1)*(del[k]+1)> p;k--)del[k]= 0;
if(k==0)break;
del[k]++;
sig[k+1]= sig[k]+del[k]*del[k];
for(k++;k<=d;k++)sig[k+1]= sig[k];
if(sig[d+1]<p)continue;

/*:17*/
#line 327 "./gb_basic.w"
;
while(1){
/*19:*/
#line 369 "./gb_basic.w"

for(k= 1;k<=d;k++)xx[k]= 0;
for(v= new_graph->vertices;;v++){
/*20:*/
#line 388 "./gb_basic.w"

for(k= 1;k<=d;k++)yy[k]= xx[k]+del[k];
for(l= 1;;l++){
/*22:*/
#line 406 "./gb_basic.w"

for(k= 1;k<=d;k++){
if(yy[k]<0){
if(!wr[k])goto no_more;
do yy[k]+= nn[k];while(yy[k]<0);
}else if(yy[k]>=nn[k]){
if(!wr[k])goto no_more;
do yy[k]-= nn[k];while(yy[k]>=nn[k]);
}
}

/*:22*/
#line 391 "./gb_basic.w"
;
if(piece<0)/*21:*/
#line 399 "./gb_basic.w"

{
for(k= 1;k<=d;k++)if(yy[k]!=xx[k])goto unequal;
goto no_more;
unequal:;
}

/*:21*/
#line 392 "./gb_basic.w"
;
/*23:*/
#line 417 "./gb_basic.w"

for(k= 2,j= yy[1];k<=d;k++)j= nn[k]*j+yy[k];
if(directed)gb_new_arc(v,new_graph->vertices+j,l);
else gb_new_edge(v,new_graph->vertices+j,l);

/*:23*/
#line 393 "./gb_basic.w"
;
if(piece> 0)goto no_more;
for(k= 1;k<=d;k++)yy[k]+= del[k];
}
no_more:

/*:20*/
#line 372 "./gb_basic.w"
;
for(k= d;xx[k]+1==nn[k];k--)xx[k]= 0;
if(k==0)break;
xx[k]++;
}

/*:19*/
#line 329 "./gb_basic.w"
;
/*18:*/
#line 362 "./gb_basic.w"

for(k= d;del[k]<=0;k--)del[k]= -del[k];
if(sig[k]==0)break;
del[k]= -del[k];

/*:18*/
#line 331 "./gb_basic.w"
;
}
}

/*:15*/
#line 187 "./gb_basic.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
return new_graph;
}

/*:8*//*26:*/
#line 492 "./gb_basic.w"

Graph*simplex(n,n0,n1,n2,n3,n4,directed)
unsigned long n;
long n0,n1,n2,n3,n4;
long directed;
{/*9:*/
#line 198 "./gb_basic.w"

Graph*new_graph;
register long i,j,k;
register long d;
register Vertex*v;
register long s;

/*:9*/
#line 497 "./gb_basic.w"

/*27:*/
#line 508 "./gb_basic.w"

if(n0==0)n0= -2;
if(n0<0){k= 2;nn[0]= n;d= -n0;n1= n2= n3= n4= 0;}
else{
if(n0> n)n0= n;
nn[0]= n0;
if(n1<=0){k= 2;d= -n1;n2= n3= n4= 0;}
else{
if(n1> n)n1= n;
nn[1]= n1;
if(n2<=0){k= 3;d= -n2;n3= n4= 0;}
else{
if(n2> n)n2= n;
nn[2]= n2;
if(n3<=0){k= 4;d= -n3;n4= 0;}
else{
if(n3> n)n3= n;
nn[3]= n3;
if(n4<=0){k= 5;d= -n4;}
else{if(n4> n)n4= n;
nn[4]= n4;d= 4;goto done;}
}
}
}
}
if(d==0){d= k-2;goto done;}
nn[k-1]= nn[0];
/*12:*/
#line 255 "./gb_basic.w"

if(d> MAX_D)panic(bad_specs);
for(j= 1;k<=d;j++,k++)nn[k]= nn[j];

/*:12*/
#line 535 "./gb_basic.w"
;
done:

/*:27*/
#line 498 "./gb_basic.w"
;
/*28:*/
#line 538 "./gb_basic.w"

/*29:*/
#line 549 "./gb_basic.w"

{long nverts;
register long*coef= gb_typed_alloc(n+1,long,working_storage);
if(gb_trouble_code)panic(no_room+1);
for(k= 0;k<=nn[0];k++)coef[k]= 1;

for(j= 1;j<=d;j++)
/*30:*/
#line 571 "./gb_basic.w"

{
for(k= n,i= n-nn[j]-1;i>=0;k--,i--)coef[k]-= coef[i];
s= 1;
for(k= 1;k<=n;k++){
s+= coef[k];
if(s> 1000000000)panic(very_bad_specs);
coef[k]= s;
}
}

/*:30*/
#line 556 "./gb_basic.w"
;
nverts= coef[n];
gb_free(working_storage);
new_graph= gb_new_graph(nverts);
if(new_graph==NULL)
panic(no_room);
}

/*:29*/
#line 540 "./gb_basic.w"
;
sprintf(new_graph->id,"simplex(%lu,%ld,%ld,%ld,%ld,%ld,%d)",
n,n0,n1,n2,n3,n4,directed?1:0);
strcpy(new_graph->util_types,"VVZIIIZZZZZZZZ");

/*:28*/
#line 499 "./gb_basic.w"
;
/*31:*/
#line 599 "./gb_basic.w"

v= new_graph->vertices;
yy[d+1]= 0;sig[0]= n;
for(k= d;k>=0;k--)yy[k]= yy[k+1]+nn[k];
if(yy[0]>=n){
k= 0;xx[0]= (yy[1]>=n?0:n-yy[1]);
while(1){
/*32:*/
#line 619 "./gb_basic.w"

for(s= sig[k]-xx[k],k++;k<=d;s-= xx[k],k++){
sig[k]= s;
if(s<=yy[k+1])xx[k]= 0;
else xx[k]= s-yy[k+1];
}
if(s!=0)panic(impossible+1)

/*:32*/
#line 606 "./gb_basic.w"
;
/*34:*/
#line 646 "./gb_basic.w"

{register char*p= buffer;
for(k= 0;k<=d;k++){
sprintf(p,".%ld",xx[k]);
while(*p)p++;
}
v->name= gb_save_string(&buffer[1]);
v->x.I= xx[0];v->y.I= xx[1];v->z.I= xx[2];
}

/*:34*/
#line 607 "./gb_basic.w"
;
hash_in(v);

/*35:*/
#line 661 "./gb_basic.w"

for(j= 0;j<d;j++)
if(xx[j]){register Vertex*u;
xx[j]--;
for(k= j+1;k<=d;k++)
if(xx[k]<nn[k]){register char*p= buffer;
xx[k]++;
for(i= 0;i<=d;i++){
sprintf(p,".%ld",xx[i]);
while(*p)p++;
}
u= hash_out(&buffer[1]);
if(u==NULL)panic(impossible+2);
if(directed)gb_new_arc(u,v,1L);
else gb_new_edge(u,v,1L);
xx[k]--;
}
xx[j]++;
}

/*:35*/
#line 610 "./gb_basic.w"
;
v++;
/*33:*/
#line 630 "./gb_basic.w"

for(k= d-1;;k--){
if(xx[k]<sig[k]&&xx[k]<nn[k])break;
if(k==0)goto last;
}
xx[k]++;

/*:33*/
#line 613 "./gb_basic.w"
;
}
}
last:if(v!=new_graph->vertices+new_graph->n)
panic(impossible);

/*:31*/
#line 500 "./gb_basic.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
return new_graph;
}

/*:26*//*37:*/
#line 732 "./gb_basic.w"

Graph*subsets(n,n0,n1,n2,n3,n4,size_bits,directed)
unsigned long n;
long n0,n1,n2,n3,n4;
unsigned long size_bits;
long directed;
{/*9:*/
#line 198 "./gb_basic.w"

Graph*new_graph;
register long i,j,k;
register long d;
register Vertex*v;
register long s;

/*:9*/
#line 738 "./gb_basic.w"

/*27:*/
#line 508 "./gb_basic.w"

if(n0==0)n0= -2;
if(n0<0){k= 2;nn[0]= n;d= -n0;n1= n2= n3= n4= 0;}
else{
if(n0> n)n0= n;
nn[0]= n0;
if(n1<=0){k= 2;d= -n1;n2= n3= n4= 0;}
else{
if(n1> n)n1= n;
nn[1]= n1;
if(n2<=0){k= 3;d= -n2;n3= n4= 0;}
else{
if(n2> n)n2= n;
nn[2]= n2;
if(n3<=0){k= 4;d= -n3;n4= 0;}
else{
if(n3> n)n3= n;
nn[3]= n3;
if(n4<=0){k= 5;d= -n4;}
else{if(n4> n)n4= n;
nn[4]= n4;d= 4;goto done;}
}
}
}
}
if(d==0){d= k-2;goto done;}
nn[k-1]= nn[0];
/*12:*/
#line 255 "./gb_basic.w"

if(d> MAX_D)panic(bad_specs);
for(j= 1;k<=d;j++,k++)nn[k]= nn[j];

/*:12*/
#line 535 "./gb_basic.w"
;
done:

/*:27*/
#line 739 "./gb_basic.w"
;
/*38:*/
#line 749 "./gb_basic.w"

/*29:*/
#line 549 "./gb_basic.w"

{long nverts;
register long*coef= gb_typed_alloc(n+1,long,working_storage);
if(gb_trouble_code)panic(no_room+1);
for(k= 0;k<=nn[0];k++)coef[k]= 1;

for(j= 1;j<=d;j++)
/*30:*/
#line 571 "./gb_basic.w"

{
for(k= n,i= n-nn[j]-1;i>=0;k--,i--)coef[k]-= coef[i];
s= 1;
for(k= 1;k<=n;k++){
s+= coef[k];
if(s> 1000000000)panic(very_bad_specs);
coef[k]= s;
}
}

/*:30*/
#line 556 "./gb_basic.w"
;
nverts= coef[n];
gb_free(working_storage);
new_graph= gb_new_graph(nverts);
if(new_graph==NULL)
panic(no_room);
}

/*:29*/
#line 751 "./gb_basic.w"
;
sprintf(new_graph->id,"subsets(%lu,%ld,%ld,%ld,%ld,%ld,0x%lx,%d)",
n,n0,n1,n2,n3,n4,size_bits,directed?1:0);
strcpy(new_graph->util_types,"ZZZIIIZZZZZZZZ");


/*:38*/
#line 740 "./gb_basic.w"
;
/*39:*/
#line 759 "./gb_basic.w"

v= new_graph->vertices;
yy[d+1]= 0;sig[0]= n;
for(k= d;k>=0;k--)yy[k]= yy[k+1]+nn[k];
if(yy[0]>=n){
k= 0;xx[0]= (yy[1]>=n?0:n-yy[1]);
while(1){
/*32:*/
#line 619 "./gb_basic.w"

for(s= sig[k]-xx[k],k++;k<=d;s-= xx[k],k++){
sig[k]= s;
if(s<=yy[k+1])xx[k]= 0;
else xx[k]= s-yy[k+1];
}
if(s!=0)panic(impossible+1)

/*:32*/
#line 766 "./gb_basic.w"
;
/*34:*/
#line 646 "./gb_basic.w"

{register char*p= buffer;
for(k= 0;k<=d;k++){
sprintf(p,".%ld",xx[k]);
while(*p)p++;
}
v->name= gb_save_string(&buffer[1]);
v->x.I= xx[0];v->y.I= xx[1];v->z.I= xx[2];
}

/*:34*/
#line 767 "./gb_basic.w"
;
/*40:*/
#line 787 "./gb_basic.w"

{register Vertex*u;
for(u= new_graph->vertices;u<=v;u++){register char*p= u->name;
long ss= 0;
for(j= 0;j<=d;j++,p++){
for(s= (*p++)-'0';*p>='0';p++)s= 10*s+*p-'0';

if(xx[j]<s)ss+= xx[j];
else ss+= s;
}
if(ss<UL_BITS&&(size_bits&(((unsigned long)1)<<ss))){
if(directed)gb_new_arc(u,v,1L);
else gb_new_edge(u,v,1L);
}
}
}

/*:40*/
#line 768 "./gb_basic.w"
;
v++;
/*33:*/
#line 630 "./gb_basic.w"

for(k= d-1;;k--){
if(xx[k]<sig[k]&&xx[k]<nn[k])break;
if(k==0)goto last;
}
xx[k]++;

/*:33*/
#line 771 "./gb_basic.w"
;
}
}
last:if(v!=new_graph->vertices+new_graph->n)
panic(impossible);

/*:39*/
#line 741 "./gb_basic.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
return new_graph;
}

/*:37*//*43:*/
#line 886 "./gb_basic.w"

Graph*perms(n0,n1,n2,n3,n4,max_inv,directed)
long n0,n1,n2,n3,n4;
unsigned long max_inv;
long directed;
{/*9:*/
#line 198 "./gb_basic.w"

Graph*new_graph;
register long i,j,k;
register long d;
register Vertex*v;
register long s;

/*:9*/
#line 891 "./gb_basic.w"

register long n;
/*44:*/
#line 903 "./gb_basic.w"

if(n0==0){n0= 1;n1= 0;}
else if(n0<0){n1= n0;n0= 1;}
n= BUF_SIZE;
/*27:*/
#line 508 "./gb_basic.w"

if(n0==0)n0= -2;
if(n0<0){k= 2;nn[0]= n;d= -n0;n1= n2= n3= n4= 0;}
else{
if(n0> n)n0= n;
nn[0]= n0;
if(n1<=0){k= 2;d= -n1;n2= n3= n4= 0;}
else{
if(n1> n)n1= n;
nn[1]= n1;
if(n2<=0){k= 3;d= -n2;n3= n4= 0;}
else{
if(n2> n)n2= n;
nn[2]= n2;
if(n3<=0){k= 4;d= -n3;n4= 0;}
else{
if(n3> n)n3= n;
nn[3]= n3;
if(n4<=0){k= 5;d= -n4;}
else{if(n4> n)n4= n;
nn[4]= n4;d= 4;goto done;}
}
}
}
}
if(d==0){d= k-2;goto done;}
nn[k-1]= nn[0];
/*12:*/
#line 255 "./gb_basic.w"

if(d> MAX_D)panic(bad_specs);
for(j= 1;k<=d;j++,k++)nn[k]= nn[j];

/*:12*/
#line 535 "./gb_basic.w"
;
done:

/*:27*/
#line 907 "./gb_basic.w"
;
/*45:*/
#line 914 "./gb_basic.w"

{register long ss;
for(k= 0,s= ss= 0;k<=d;ss+= s*nn[k],s+= nn[k],k++)
if(nn[k]>=BUF_SIZE)panic(bad_specs);

if(s>=BUF_SIZE)panic(bad_specs+1);
n= s;
if(max_inv==0||max_inv> ss)max_inv= ss;
}

/*:45*/
#line 908 "./gb_basic.w"
;

/*:44*/
#line 893 "./gb_basic.w"
;
/*46:*/
#line 932 "./gb_basic.w"

{long nverts;
register long*coef= gb_typed_alloc(max_inv+1,long,working_storage);
if(gb_trouble_code)panic(no_room+1);
coef[0]= 1;
for(j= 1,s= nn[0];j<=d;s+= nn[j],j++)
/*47:*/
#line 958 "./gb_basic.w"

for(k= 1;k<=nn[j];k++){register long ii;
for(i= max_inv,ii= i-k-s;ii>=0;ii--,i--)coef[i]-= coef[ii];
for(i= k,ii= 0;i<=max_inv;i++,ii++){
coef[i]+= coef[ii];
if(coef[i]> 1000000000)panic(very_bad_specs+1);
}
}

/*:47*/
#line 939 "./gb_basic.w"
;
for(k= 1,nverts= 1;k<=max_inv;k++){
nverts+= coef[k];
if(nverts> 1000000000)panic(very_bad_specs);
}
gb_free(working_storage);
new_graph= gb_new_graph(nverts);
if(new_graph==NULL)
panic(no_room);
sprintf(new_graph->id,"perms(%ld,%ld,%ld,%ld,%ld,%lu,%d)",
n0,n1,n2,n3,n4,max_inv,directed?1:0);
strcpy(new_graph->util_types,"VVZZZZZZZZZZZZ");
}

/*:46*/
#line 894 "./gb_basic.w"
;
/*48:*/
#line 980 "./gb_basic.w"

{register long*xtab,*ytab,*ztab;
long m= 0;
/*49:*/
#line 996 "./gb_basic.w"

xtab= gb_typed_alloc(3*n+3,long,working_storage);
if(gb_trouble_code){
gb_recycle(new_graph);panic(no_room+2);}
ytab= xtab+(n+1);
ztab= ytab+(n+1);
for(j= 0,k= 1,s= nn[0];;k++){
xtab[k]= ztab[k]= j;
if(k==s){
if(++j> d)break;
else s+= nn[j];
}
}

/*:49*/
#line 983 "./gb_basic.w"
;
v= new_graph->vertices;
while(1){
/*52:*/
#line 1041 "./gb_basic.w"

{register char*p;register long*q;
for(p= &buffer[n-1],q= &xtab[n];q> xtab;p--,q--)*p= short_imap[*q];
v->name= gb_save_string(buffer);
hash_in(v);

}

/*:52*/
#line 986 "./gb_basic.w"
;
/*53:*/
#line 1054 "./gb_basic.w"

for(j= 1;j<n;j++)
if(xtab[j]> xtab[j+1]){register Vertex*u;

buffer[j-1]= short_imap[xtab[j+1]];buffer[j]= short_imap[xtab[j]];
u= hash_out(buffer);
if(u==NULL)panic(impossible+2);
if(directed)gb_new_arc(u,v,1L);
else gb_new_edge(u,v,1L);
buffer[j-1]= short_imap[xtab[j]];buffer[j]= short_imap[xtab[j+1]];
}

/*:53*/
#line 987 "./gb_basic.w"
;
v++;
/*50:*/
#line 1015 "./gb_basic.w"

for(k= n;k;k--){
if(m<max_inv&&ytab[k]<k-1)
if(ytab[k]<ytab[k-1]||ztab[k]> ztab[k-1])goto move;
if(ytab[k]){
for(j= k-ytab[k];j<k;j++)xtab[j]= xtab[j+1];
m-= ytab[k];
ytab[k]= 0;
xtab[k]= ztab[k];
}
}
goto last;
move:j= k-ytab[k];
xtab[j]= xtab[j-1];xtab[j-1]= ztab[k];
ytab[k]++;m++;

/*:50*/
#line 989 "./gb_basic.w"
;
}
last:if(v!=new_graph->vertices+new_graph->n)
panic(impossible);
gb_free(working_storage);
}

/*:48*/
#line 895 "./gb_basic.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
return new_graph;
}

/*:43*//*55:*/
#line 1098 "./gb_basic.w"

Graph*parts(n,max_parts,max_size,directed)
unsigned long n;
unsigned long max_parts;
unsigned long max_size;
long directed;
{/*9:*/
#line 198 "./gb_basic.w"

Graph*new_graph;
register long i,j,k;
register long d;
register Vertex*v;
register long s;

/*:9*/
#line 1104 "./gb_basic.w"

if(max_parts==0||max_parts> n)max_parts= n;
if(max_size==0||max_size> n)max_size= n;
if(max_parts> MAX_D)panic(bad_specs);
/*56:*/
#line 1122 "./gb_basic.w"

{long nverts;
register long*coef= gb_typed_alloc(n+1,long,working_storage);
if(gb_trouble_code)panic(no_room+1);
coef[0]= 1;
for(k= 1;k<=max_parts;k++){
for(j= n,i= n-k-max_size;i>=0;i--,j--)coef[j]-= coef[i];
for(j= k,i= 0;j<=n;i++,j++){
coef[j]+= coef[i];
if(coef[j]> 1000000000)panic(very_bad_specs);
}
}
nverts= coef[n];
gb_free(working_storage);
new_graph= gb_new_graph(nverts);
if(new_graph==NULL)
panic(no_room);
sprintf(new_graph->id,"parts(%lu,%lu,%lu,%d)",
n,max_parts,max_size,directed?1:0);
strcpy(new_graph->util_types,"VVZZZZZZZZZZZZ");
}

/*:56*/
#line 1108 "./gb_basic.w"
;
/*57:*/
#line 1152 "./gb_basic.w"

v= new_graph->vertices;
xx[0]= max_size;sig[1]= n;
for(k= max_parts,s= 1;k> 0;k--,s++)yy[k]= s;
if(max_size*max_parts>=n){
k= 1;xx[1]= (n-1)/max_parts+1;
while(1){
/*58:*/
#line 1170 "./gb_basic.w"

for(s= sig[k]-xx[k],k++;s;k++){
sig[k]= s;
xx[k]= (s-1)/yy[k]+1;
s-= xx[k];
}
d= k-1;

/*:58*/
#line 1159 "./gb_basic.w"
;
/*60:*/
#line 1189 "./gb_basic.w"

{register char*p= buffer;
for(k= 1;k<=d;k++){
sprintf(p,"+%ld",xx[k]);
while(*p)p++;
}
v->name= gb_save_string(&buffer[1]);
hash_in(v);

}

/*:60*/
#line 1160 "./gb_basic.w"
;
/*61:*/
#line 1206 "./gb_basic.w"

if(d<max_parts){
xx[d+1]= 0;
for(j= 1;j<=d;j++){
if(xx[j]!=xx[j+1]){long a,b;
for(b= xx[j]/2,a= xx[j]-b;b;a++,b--)
/*62:*/
#line 1225 "./gb_basic.w"

{register Vertex*u;
register char*p= buffer;
for(k= j+1;xx[k]> a;k++)nn[k-1]= xx[k];
nn[k-1]= a;
for(;xx[k]> b;k++)nn[k]= xx[k];
nn[k]= b;
for(;k<=d;k++)nn[k+1]= xx[k];
for(k= 1;k<=d+1;k++){
sprintf(p,"+%ld",nn[k]);
while(*p)p++;
}
u= hash_out(&buffer[1]);
if(u==NULL)panic(impossible+2);
if(directed)gb_new_arc(v,u,1L);
else gb_new_edge(v,u,1L);
}

/*:62*/
#line 1214 "./gb_basic.w"
;
}
nn[j]= xx[j];
}
}

/*:61*/
#line 1161 "./gb_basic.w"
;
v++;
/*59:*/
#line 1181 "./gb_basic.w"

if(d==1)goto last;
for(k= d-1;;k--){
if(xx[k]<sig[k]&&xx[k]<xx[k-1])break;
if(k==1)goto last;
}
xx[k]++;

/*:59*/
#line 1164 "./gb_basic.w"
;
}
}
last:if(v!=new_graph->vertices+new_graph->n)
panic(impossible);

/*:57*/
#line 1109 "./gb_basic.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);

}
return new_graph;
}

/*:55*//*64:*/
#line 1290 "./gb_basic.w"

Graph*binary(n,max_height,directed)
unsigned long n;
unsigned long max_height;
long directed;
{/*9:*/
#line 198 "./gb_basic.w"

Graph*new_graph;
register long i,j,k;
register long d;
register Vertex*v;
register long s;

/*:9*/
#line 1295 "./gb_basic.w"

if(2*n+2> BUF_SIZE)panic(bad_specs);
if(max_height==0||max_height> n)max_height= n;
if(max_height> 30)panic(very_bad_specs);
/*65:*/
#line 1323 "./gb_basic.w"

{long nverts;
if(n>=20&&max_height>=6)/*66:*/
#line 1348 "./gb_basic.w"

{register float ss;
d= (1L<<max_height)-1-n;
if(d> 8)panic(bad_specs+1);
if(d<0)nverts= 0;
else{
nn[0]= nn[1]= 1;
for(k= 2;k<=d;k++)nn[k]= 0;
for(j= 2;j<=max_height;j++){
for(k= d;k;k--){
for(ss= 0.0,i= k;i>=0;i--)ss+= ((float)nn[i])*((float)nn[k-i]);
if(ss> MAX_NNN)panic(very_bad_specs+1);
for(s= 0,i= k;i>=0;i--)s+= nn[i]*nn[k-i];
nn[k]= s;
}
i= (1L<<j)-1;
if(i<=d)nn[i]++;
}
nverts= nn[d];
}
}

/*:66*/
#line 1325 "./gb_basic.w"

else{
nn[0]= nn[1]= 1;
for(k= 2;k<=n;k++)nn[k]= 0;
for(j= 2;j<=max_height;j++)
for(k= n-1;k;k--){
for(s= 0,i= k;i>=0;i--)s+= nn[i]*nn[k-i];
nn[k+1]= s;
}
nverts= nn[n];
}
new_graph= gb_new_graph(nverts);
if(new_graph==NULL)
panic(no_room);
sprintf(new_graph->id,"binary(%lu,%lu,%d)",
n,max_height,directed?1:0);
strcpy(new_graph->util_types,"VVZZZZZZZZZZZZ");
}

/*:65*/
#line 1299 "./gb_basic.w"
;
/*67:*/
#line 1409 "./gb_basic.w"

{register long*xtab,*ytab,*ltab,*stab;
/*68:*/
#line 1429 "./gb_basic.w"

xtab= gb_typed_alloc(8*n+4,long,working_storage);
if(gb_trouble_code){
gb_recycle(new_graph);panic(no_room+2);}
d= n+n;
ytab= xtab+(d+1);
ltab= ytab+(d+1);
stab= ltab+(d+1);
ltab[0]= 1L<<max_height;
stab[0]= n;

/*:68*/
#line 1411 "./gb_basic.w"
;
v= new_graph->vertices;
if(ltab[0]> n){
k= 0;xtab[0]= n?1:0;
while(1){
/*69:*/
#line 1440 "./gb_basic.w"

for(j= k+1;j<=d;j++){
if(xtab[j-1]){
ltab[j]= ltab[j-1]>>1;
ytab[j]= ytab[j-1]+ltab[j];
stab[j]= stab[j-1];
}else{
ytab[j]= ytab[j-1]&(ytab[j-1]-1);
ltab[j]= ytab[j-1]-ytab[j];
stab[j]= stab[j-1]-1;
}
if(stab[j]<=ytab[j])xtab[j]= 0;
else xtab[j]= 1;
}

/*:69*/
#line 1416 "./gb_basic.w"
;
/*71:*/
#line 1477 "./gb_basic.w"

{register char*p= buffer;
for(k= 0;k<=d;k++,p++)*p= (xtab[k]?'.':'x');
v->name= gb_save_string(buffer);
hash_in(v);

}

/*:71*/
#line 1417 "./gb_basic.w"
;
/*72:*/
#line 1493 "./gb_basic.w"

for(j= 0;j<d;j++)
if(xtab[j]==1&&xtab[j+1]==1){
for(i= j+1,s= 0;s>=0;s+= (xtab[i+1]<<1)-1,i++)xtab[i]= xtab[i+1];
xtab[i]= 1;
{register char*p= buffer;
register Vertex*u;
for(k= 0;k<=d;k++,p++)*p= (xtab[k]?'.':'x');
u= hash_out(buffer);
if(u){
if(directed)gb_new_arc(v,u,1L);
else gb_new_edge(v,u,1L);
}
}
for(i--;i> j;i--)xtab[i+1]= xtab[i];
xtab[i+1]= 1;
}

/*:72*/
#line 1418 "./gb_basic.w"
;
v++;
/*70:*/
#line 1459 "./gb_basic.w"

for(k= d-1;;k--){
if(k<=0)goto last;
if(xtab[k])break;
}
for(k--;;k--){
if(xtab[k]==0&&ltab[k]> 1)break;
if(k==0)goto last;
}
xtab[k]++;

/*:70*/
#line 1421 "./gb_basic.w"
;
}
}
}
last:if(v!=new_graph->vertices+new_graph->n)
panic(impossible);
gb_free(working_storage);

/*:67*/
#line 1300 "./gb_basic.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
return new_graph;
}

/*:64*//*74:*/
#line 1545 "./gb_basic.w"

Graph*complement(g,copy,self,directed)
Graph*g;
long copy;
long self;
long directed;
{/*9:*/
#line 198 "./gb_basic.w"

Graph*new_graph;
register long i,j,k;
register long d;
register Vertex*v;
register long s;

/*:9*/
#line 1551 "./gb_basic.w"

register long n;
register Vertex*u;
register siz_t delta;
if(g==NULL)panic(missing_operand);
/*75:*/
#line 1576 "./gb_basic.w"

n= g->n;
new_graph= gb_new_graph(n);
if(new_graph==NULL)
panic(no_room);
delta= ((siz_t)(new_graph->vertices))-((siz_t)(g->vertices));
for(u= new_graph->vertices,v= g->vertices;v<g->vertices+n;u++,v++)
u->name= gb_save_string(v->name);

/*:75*/
#line 1556 "./gb_basic.w"
;
sprintf(buffer,",%d,%d,%d)",copy?1:0,self?1:0,directed?1:0);
make_compound_id(new_graph,"complement(",g,buffer);
/*76:*/
#line 1591 "./gb_basic.w"

for(v= g->vertices;v<g->vertices+n;v++){register Vertex*vv;
u= vert_offset(v,delta);

{register Arc*a;
for(a= v->arcs;a;a= a->next)vert_offset(a->tip,delta)->tmp= u;
}
if(directed){
for(vv= new_graph->vertices;vv<new_graph->vertices+n;vv++)
if((vv->tmp==u&&copy)||(vv->tmp!=u&&!copy))
if(vv!=u||self)gb_new_arc(u,vv,1L);
}else{
for(vv= (self?u:u+1);vv<new_graph->vertices+n;vv++)
if((vv->tmp==u&&copy)||(vv->tmp!=u&&!copy))
gb_new_edge(u,vv,1L);
}
}
for(v= new_graph->vertices;v<new_graph->vertices+n;v++)v->tmp= NULL;

/*:76*/
#line 1559 "./gb_basic.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);

}
return new_graph;
}

/*:74*//*78:*/
#line 1642 "./gb_basic.w"

Graph*gunion(g,gg,multi,directed)
Graph*g,*gg;
long multi;
long directed;
{/*9:*/
#line 198 "./gb_basic.w"

Graph*new_graph;
register long i,j,k;
register long d;
register Vertex*v;
register long s;

/*:9*/
#line 1647 "./gb_basic.w"

register long n;
register Vertex*u;
register siz_t delta,ddelta;
if(g==NULL||gg==NULL)panic(missing_operand);

/*75:*/
#line 1576 "./gb_basic.w"

n= g->n;
new_graph= gb_new_graph(n);
if(new_graph==NULL)
panic(no_room);
delta= ((siz_t)(new_graph->vertices))-((siz_t)(g->vertices));
for(u= new_graph->vertices,v= g->vertices;v<g->vertices+n;u++,v++)
u->name= gb_save_string(v->name);

/*:75*/
#line 1653 "./gb_basic.w"
;
sprintf(buffer,",%d,%d)",multi?1:0,directed?1:0);
make_double_compound_id(new_graph,"gunion(",g,",",gg,buffer);
ddelta= ((siz_t)(new_graph->vertices))-
((siz_t)(gg->vertices));
/*79:*/
#line 1666 "./gb_basic.w"

for(v= g->vertices;v<g->vertices+n;v++){
register Arc*a;
register Vertex*vv= vert_offset(v,delta);

register Vertex*vvv= vert_offset(vv,-ddelta);

for(a= v->arcs;a;a= a->next){
u= vert_offset(a->tip,delta);
/*80:*/
#line 1701 "./gb_basic.w"

{register Arc*b;
if(directed){
if(multi||u->tmp!=vv)gb_new_arc(vv,u,a->len);
else{
b= u->tlen;
if(a->len<b->len)b->len= a->len;
}
u->tmp= vv;
u->tlen= vv->arcs;
}else if(u>=vv){
if(multi||u->tmp!=vv)gb_new_edge(vv,u,a->len);
else{
b= u->tlen;
if(a->len<b->len)b->len= (b+1)->len= a->len;
}
u->tmp= vv;
u->tlen= vv->arcs;
if(u==vv&&a->next==a+1)a++;
}
}

/*:80*/
#line 1675 "./gb_basic.w"
;
}
if(vvv<gg->vertices+gg->n)for(a= vvv->arcs;a;a= a->next){
u= vert_offset(a->tip,ddelta);
if(u<new_graph->vertices+n)
/*80:*/
#line 1701 "./gb_basic.w"

{register Arc*b;
if(directed){
if(multi||u->tmp!=vv)gb_new_arc(vv,u,a->len);
else{
b= u->tlen;
if(a->len<b->len)b->len= a->len;
}
u->tmp= vv;
u->tlen= vv->arcs;
}else if(u>=vv){
if(multi||u->tmp!=vv)gb_new_edge(vv,u,a->len);
else{
b= u->tlen;
if(a->len<b->len)b->len= (b+1)->len= a->len;
}
u->tmp= vv;
u->tlen= vv->arcs;
if(u==vv&&a->next==a+1)a++;
}
}

/*:80*/
#line 1680 "./gb_basic.w"
;
}
}
for(v= new_graph->vertices;v<new_graph->vertices+n;v++)
v->tmp= NULL,v->tlen= NULL;

/*:79*/
#line 1658 "./gb_basic.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
return new_graph;
}

/*:78*//*81:*/
#line 1723 "./gb_basic.w"

Graph*intersection(g,gg,multi,directed)
Graph*g,*gg;
long multi;
long directed;
{/*9:*/
#line 198 "./gb_basic.w"

Graph*new_graph;
register long i,j,k;
register long d;
register Vertex*v;
register long s;

/*:9*/
#line 1728 "./gb_basic.w"

register long n;
register Vertex*u;
register siz_t delta,ddelta;
if(g==NULL||gg==NULL)panic(missing_operand);
/*75:*/
#line 1576 "./gb_basic.w"

n= g->n;
new_graph= gb_new_graph(n);
if(new_graph==NULL)
panic(no_room);
delta= ((siz_t)(new_graph->vertices))-((siz_t)(g->vertices));
for(u= new_graph->vertices,v= g->vertices;v<g->vertices+n;u++,v++)
u->name= gb_save_string(v->name);

/*:75*/
#line 1733 "./gb_basic.w"
;
sprintf(buffer,",%d,%d)",multi?1:0,directed?1:0);
make_double_compound_id(new_graph,"intersection(",g,",",gg,buffer);
ddelta= ((siz_t)(new_graph->vertices))-
((siz_t)(gg->vertices));
/*82:*/
#line 1751 "./gb_basic.w"

for(v= g->vertices;v<g->vertices+n;v++){register Arc*a;
register Vertex*vv= vert_offset(v,delta);

register Vertex*vvv= vert_offset(vv,-ddelta);

if(vvv>=gg->vertices+gg->n)continue;
/*85:*/
#line 1797 "./gb_basic.w"

for(a= v->arcs;a;a= a->next){
u= vert_offset(a->tip,delta);
if(u->tmp==vv){
u->mult++;
if(a->len<u->minlen)u->minlen= a->len;
}else u->tmp= vv,u->mult= 0,u->minlen= a->len;
if(u==vv&&!directed&&a->next==a+1)a++;

}

/*:85*/
#line 1758 "./gb_basic.w"
;
for(a= vvv->arcs;a;a= a->next){
u= vert_offset(a->tip,ddelta);
if(u>=new_graph->vertices+n)continue;
if(u->tmp==vv){long l= u->minlen;
if(a->len> l)l= a->len;
if(u->mult<0)/*84:*/
#line 1789 "./gb_basic.w"

{register Arc*b= u->tlen;
if(l<b->len){
b->len= l;
if(!directed)(b+1)->len= l;
}
}

/*:84*/
#line 1764 "./gb_basic.w"

else/*83:*/
#line 1772 "./gb_basic.w"

{
if(directed)gb_new_arc(vv,u,l);
else{
if(vv<=u)gb_new_edge(vv,u,l);
if(vv==u&&a->next==a+1)a++;
}
if(!multi){
u->tlen= vv->arcs;
u->mult= -1;
}else if(u->mult==0)u->tmp= NULL;
else u->mult--;
}

/*:83*/
#line 1766 "./gb_basic.w"
;
}
}
}
/*86:*/
#line 1808 "./gb_basic.w"

for(v= new_graph->vertices;v<new_graph->vertices+n;v++){
v->tmp= NULL;
v->tlen= NULL;
v->mult= 0;
v->minlen= 0;
}

/*:86*/
#line 1770 "./gb_basic.w"
;

/*:82*/
#line 1738 "./gb_basic.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
return new_graph;
}

/*:81*//*87:*/
#line 1836 "./gb_basic.w"

Graph*lines(g,directed)
Graph*g;
long directed;
{/*9:*/
#line 198 "./gb_basic.w"

Graph*new_graph;
register long i,j,k;
register long d;
register Vertex*v;
register long s;

/*:9*/
#line 1840 "./gb_basic.w"

register long m;
register Vertex*u;
if(g==NULL)panic(missing_operand);
/*89:*/
#line 1891 "./gb_basic.w"

m= (directed?g->m:(g->m)/2);
new_graph= gb_new_graph(m);
if(new_graph==NULL)
panic(no_room);
make_compound_id(new_graph,"lines(",g,directed?",1)":",0)");
u= new_graph->vertices;
for(v= g->vertices+g->n-1;v>=g->vertices;v--){register Arc*a;
register long mapped= 0;
for(a= v->arcs;a;a= a->next){register Vertex*vv= a->tip;
if(!directed){
if(vv<v)continue;
if(vv>=g->vertices+g->n)goto near_panic;

}
/*91:*/
#line 1930 "./gb_basic.w"

u->u.V= v;
u->v.V= vv;
u->w.A= a;
if(!directed){
if(u>=new_graph->vertices+m||(a+1)->tip!=v)goto near_panic;
if(v==vv&&a->next==a+1)a++;
else(a+1)->tip= u;
}
sprintf(buffer,"%.*s-%c%.*s",(BUF_SIZE-3)/2,v->name,
directed?'>':'-',BUF_SIZE/2-1,vv->name);
u->name= gb_save_string(buffer);

/*:91*/
#line 1906 "./gb_basic.w"
;
if(!mapped){
u->map= v->map;

v->map= u;
mapped= 1;
}
u++;
}
}
if(u!=new_graph->vertices+m)goto near_panic;

/*:89*/
#line 1844 "./gb_basic.w"
;
if(directed)/*92:*/
#line 1943 "./gb_basic.w"

for(u= new_graph->vertices;u<new_graph->vertices+m;u++){
v= u->v.V;
if(v->arcs){
v= v->map;
do{gb_new_arc(u,v,1L);
v++;
}while(v->u.V==u->v.V);
}
}

/*:92*/
#line 1845 "./gb_basic.w"

else/*93:*/
#line 1962 "./gb_basic.w"

for(u= new_graph->vertices;u<new_graph->vertices+m;u++){register Vertex*vv;
register Arc*a;register long mapped= 0;
v= u->u.V;
for(vv= v->map;vv<u;vv++)gb_new_edge(u,vv,1L);
v= u->v.V;
for(a= v->arcs;a;a= a->next){
vv= a->tip;
if(vv<u&&vv>=new_graph->vertices)gb_new_edge(u,vv,1L);
else if(vv>=v&&vv<g->vertices+g->n)mapped= 1;
}
if(mapped&&v> u->u.V)
for(vv= v->map;vv->u.V==v;vv++)gb_new_edge(u,vv,1L);
}

/*:93*/
#line 1846 "./gb_basic.w"
;
/*88:*/
#line 1876 "./gb_basic.w"

for(u= new_graph->vertices,v= NULL;u<new_graph->vertices+m;u++){
if(u->u.V!=v){
v= u->u.V;
v->map= u->map;
u->map= NULL;
}
if(!directed)((u->w.A)+1)->tip= v;
}

/*:88*/
#line 1847 "./gb_basic.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
return new_graph;
near_panic:/*90:*/
#line 1918 "./gb_basic.w"

m= u-new_graph->vertices;
/*88:*/
#line 1876 "./gb_basic.w"

for(u= new_graph->vertices,v= NULL;u<new_graph->vertices+m;u++){
if(u->u.V!=v){
v= u->u.V;
v->map= u->map;
u->map= NULL;
}
if(!directed)((u->w.A)+1)->tip= v;
}

/*:88*/
#line 1920 "./gb_basic.w"
;
gb_recycle(new_graph);
panic(invalid_operand);


/*:90*/
#line 1853 "./gb_basic.w"
;
}

/*:87*//*95:*/
#line 2010 "./gb_basic.w"

Graph*product(g,gg,type,directed)
Graph*g,*gg;
long type;
long directed;
{/*9:*/
#line 198 "./gb_basic.w"

Graph*new_graph;
register long i,j,k;
register long d;
register Vertex*v;
register long s;

/*:9*/
#line 2015 "./gb_basic.w"

register Vertex*u,*vv;
register long n;
if(g==NULL||gg==NULL)panic(missing_operand);
/*96:*/
#line 2037 "./gb_basic.w"

{float test_product= ((float)(g->n))*((float)(gg->n));
if(test_product> MAX_NNN)panic(very_bad_specs);
}
n= (g->n)*(gg->n);
new_graph= gb_new_graph(n);
if(new_graph==NULL)
panic(no_room);
for(u= new_graph->vertices,v= g->vertices,vv= gg->vertices;
u<new_graph->vertices+n;u++){
sprintf(buffer,"%.*s,%.*s",BUF_SIZE/2-1,v->name,(BUF_SIZE-1)/2,vv->name);
u->name= gb_save_string(buffer);
if(++vv==gg->vertices+gg->n)vv= gg->vertices,v++;
}
sprintf(buffer,",%d,%d)",(type?2:0)-(int)(type&1),directed?1:0);
make_double_compound_id(new_graph,"product(",g,",",gg,buffer);

/*:96*/
#line 2019 "./gb_basic.w"
;
if((type&1)==0)/*97:*/
#line 2054 "./gb_basic.w"

{register Vertex*uu,*uuu;
register Arc*a;
register siz_t delta;
delta= ((siz_t)(new_graph->vertices))-((siz_t)(gg->vertices));
for(u= gg->vertices;u<gg->vertices+gg->n;u++)
for(a= u->arcs;a;a= a->next){
v= a->tip;
if(!directed){
if(u> v)continue;
if(u==v&&a->next==a+1)a++;
}
for(uu= vert_offset(u,delta),vv= vert_offset(v,delta);
uu<new_graph->vertices+n;uu+= gg->n,vv+= gg->n)
if(directed)gb_new_arc(uu,vv,a->len);
else gb_new_edge(uu,vv,a->len);
}
/*98:*/
#line 2074 "./gb_basic.w"

for(u= g->vertices,uu= new_graph->vertices;uu<new_graph->vertices+n;
u++,uu+= gg->n)
for(a= u->arcs;a;a= a->next){
v= a->tip;
if(!directed){
if(u> v)continue;
if(u==v&&a->next==a+1)a++;
}
vv= new_graph->vertices+((gg->n)*(v-g->vertices));
for(uuu= uu;uuu<uu+gg->n;uuu++,vv++)
if(directed)gb_new_arc(uuu,vv,a->len);
else gb_new_edge(uuu,vv,a->len);
}

/*:98*/
#line 2071 "./gb_basic.w"
;
}

/*:97*/
#line 2020 "./gb_basic.w"
;
if(type)/*99:*/
#line 2089 "./gb_basic.w"

{Vertex*uu;Arc*a;
siz_t delta0= 
((siz_t)(new_graph->vertices))-((siz_t)(gg->vertices));
siz_t del= (gg->n)*sizeof(Vertex);
register siz_t delta,ddelta;
for(uu= g->vertices,delta= delta0;uu<g->vertices+g->n;uu++,delta+= del)
for(a= uu->arcs;a;a= a->next){
vv= a->tip;
if(!directed){
if(uu> vv)continue;
if(uu==vv&&a->next==a+1)a++;
}
ddelta= delta0+del*(vv-g->vertices);
for(u= gg->vertices;u<gg->vertices+gg->n;u++){register Arc*aa;
for(aa= u->arcs;aa;aa= aa->next){long length= a->len;
if(length> aa->len)length= aa->len;
v= aa->tip;
if(directed)
gb_new_arc(vert_offset(u,delta),vert_offset(v,ddelta),length);
else gb_new_edge(vert_offset(u,delta),
vert_offset(v,ddelta),length);
}
}
}
}

/*:99*/
#line 2021 "./gb_basic.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);

}
return new_graph;
}

/*:95*//*105:*/
#line 2248 "./gb_basic.w"

Graph*induced(g,description,self,multi,directed)
Graph*g;
char*description;
long self;
long multi;
long directed;
{/*9:*/
#line 198 "./gb_basic.w"

Graph*new_graph;
register long i,j,k;
register long d;
register Vertex*v;
register long s;

/*:9*/
#line 2255 "./gb_basic.w"

register Vertex*u;
register long n= 0;
register long nn= 0;
if(g==NULL)panic(missing_operand);
/*106:*/
#line 2270 "./gb_basic.w"

/*107:*/
#line 2280 "./gb_basic.w"

for(v= g->vertices;v<g->vertices+g->n;v++)
if(v->ind> 0){
if(n> IND_GRAPH)panic(very_bad_specs);
if(v->ind>=IND_GRAPH){
if(v->subst==NULL)panic(missing_operand+1);

n+= v->subst->n;
}else n+= v->ind;
}else if(v->ind<-nn)nn= -(v->ind);
if(n> IND_GRAPH||nn> IND_GRAPH)panic(very_bad_specs+1);
n+= nn;

/*:107*/
#line 2271 "./gb_basic.w"
;
new_graph= gb_new_graph(n);
if(new_graph==NULL)
panic(no_room);
/*108:*/
#line 2307 "./gb_basic.w"

for(k= 1,u= new_graph->vertices;k<=nn;k++,u++){
u->mult= -k;
sprintf(buffer,"%ld",-k);
u->name= gb_save_string(buffer);
}
for(v= g->vertices;v<g->vertices+g->n;v++)
if((k= v->ind)<0)v->map= (new_graph->vertices)-(k+1);
else if(k> 0){
u->mult= k;
v->map= u;
if(k<=2){
u->name= gb_save_string(v->name);
u++;
if(k==2){
sprintf(buffer,"%s'",v->name);
u->name= gb_save_string(buffer);
u++;
}
}else if(k>=IND_GRAPH)/*114:*/
#line 2422 "./gb_basic.w"

{register Graph*gg= v->subst;
register Vertex*vv= gg->vertices;
register Arc*a;
siz_t delta= ((siz_t)u)-((siz_t)vv);
for(j= 0;j<v->subst->n;j++,u++,vv++){
sprintf(buffer,"%.*s:%.*s",BUF_SIZE/2-1,v->name,(BUF_SIZE-1)/2,vv->name);
u->name= gb_save_string(buffer);
for(a= vv->arcs;a;a= a->next){register Vertex*vvv= a->tip;
Vertex*uu= vert_offset(vvv,delta);
if(vvv==vv&&!self)continue;
if(uu->tmp==u&&!multi)/*113:*/
#line 2410 "./gb_basic.w"

{register Arc*b= uu->tlen;
if(a->len<b->len){
b->len= a->len;
if(!directed)(b+1)->len= a->len;
}
continue;
}

/*:113*/
#line 2433 "./gb_basic.w"
;
if(!directed){
if(vvv<vv)continue;
if(vvv==vv&&a->next==a+1)a++;
gb_new_edge(u,uu,a->len);
}else gb_new_arc(u,uu,a->len);
uu->tmp= u;
uu->tlen= ((directed||u<=uu)?u->arcs:uu->arcs);
}
}
}

/*:114*/
#line 2326 "./gb_basic.w"

else for(j= 0;j<k;j++,u++){
sprintf(buffer,"%.*s:%ld",BUF_SIZE-12,v->name,j);
u->name= gb_save_string(buffer);
}
}

/*:108*/
#line 2275 "./gb_basic.w"
;
sprintf(buffer,",%s,%d,%d,%d)",description?description:null_string,
self?1:0,multi?1:0,directed?1:0);
make_compound_id(new_graph,"induced(",g,buffer);

/*:106*/
#line 2260 "./gb_basic.w"
;
/*110:*/
#line 2356 "./gb_basic.w"

for(v= g->vertices;v<g->vertices+g->n;v++){
u= v->map;
if(u){register Arc*a;register Vertex*uu,*vv;
k= u->mult;
if(k<0)k= 1;
else if(k>=IND_GRAPH)k= v->subst->n;
for(;k;k--,u++){
if(!multi)
/*111:*/
#line 2392 "./gb_basic.w"

for(a= u->arcs;a;a= a->next){
a->tip->tmp= u;
if(directed||a->tip> u||a->next==a+1)a->tip->tlen= a;
else a->tip->tlen= a+1;
}

/*:111*/
#line 2365 "./gb_basic.w"
;
for(a= v->arcs;a;a= a->next){
vv= a->tip;
uu= vv->map;
if(uu==NULL)continue;
j= uu->mult;
if(j<0)j= 1;
else if(j>=IND_GRAPH)j= vv->subst->n;
if(!directed){
if(vv<v)continue;
if(vv==v){
if(a->next==a+1)a++;
j= k,uu= u;
}
}
/*112:*/
#line 2399 "./gb_basic.w"

for(;j;j--,uu++){
if(u==uu&&!self)continue;
if(uu->tmp==u&&!multi)
/*113:*/
#line 2410 "./gb_basic.w"

{register Arc*b= uu->tlen;
if(a->len<b->len){
b->len= a->len;
if(!directed)(b+1)->len= a->len;
}
continue;
}

/*:113*/
#line 2403 "./gb_basic.w"
;
if(directed)gb_new_arc(u,uu,a->len);
else gb_new_edge(u,uu,a->len);
uu->tmp= u;
uu->tlen= ((directed||u<=uu)?u->arcs:uu->arcs);
}

/*:112*/
#line 2381 "./gb_basic.w"
;
}
}
}
}

/*:110*/
#line 2261 "./gb_basic.w"
;
/*109:*/
#line 2333 "./gb_basic.w"

for(v= g->vertices;v<g->vertices+g->n;v++)
if(v->map)v->ind= v->map->mult;
for(v= new_graph->vertices;v<new_graph->vertices+n;v++)
v->u.I= v->v.I= v->z.I= 0;

/*:109*/
#line 2262 "./gb_basic.w"
;
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
return new_graph;
}

/*:105*/
#line 36 "./gb_basic.w"

/*101:*/
#line 2170 "./gb_basic.w"

Graph*bi_complete(n1,n2,directed)
unsigned long n1;
unsigned long n2;
long directed;
{Graph*new_graph= board(2L,0L,0L,0L,1L,0L,directed);
if(new_graph){
new_graph->vertices->ind= n1;
(new_graph->vertices+1)->ind= n2;
new_graph= induced(new_graph,NULL,0L,0L,directed);
if(new_graph){
sprintf(new_graph->id,"bi_complete(%lu,%lu,%d)",
n1,n2,directed?1:0);
mark_bipartite(new_graph,n1);
}
}
return new_graph;
}

/*:101*//*103:*/
#line 2223 "./gb_basic.w"

Graph*wheel(n,n1,directed)
unsigned long n;
unsigned long n1;
long directed;
{Graph*new_graph= board(2L,0L,0L,0L,1L,0L,directed);

if(new_graph){
new_graph->vertices->ind= n1;
(new_graph->vertices+1)->ind= IND_GRAPH;
(new_graph->vertices+1)->subst= board(n,0L,0L,0L,1L,1L,directed);

new_graph= induced(new_graph,NULL,0L,0L,directed);
if(new_graph){
sprintf(new_graph->id,"wheel(%lu,%lu,%d)",
n,n1,directed?1:0);
}
}
return new_graph;
}

/*:103*/
#line 37 "./gb_basic.w"


/*:2*/
