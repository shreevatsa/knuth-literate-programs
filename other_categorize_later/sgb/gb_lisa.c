/*6:*/
#line 141 "./gb_lisa.w"

#include "gb_io.h" 
#include "gb_graph.h" 
#define plane_lisa p_lisa \

#define MAX_M 360
#define MAX_N 250
#define MAX_D 255 \

#define panic(c) {panic_code= c;gb_trouble_code= 0;return NULL;} \

#define el_gordo 0x7fffffff \

#define pixel_value x.I
#define first_pixel y.I
#define last_pixel z.I
#define matrix_rows uu.I
#define matrix_cols vv.I \


#line 144 "./gb_lisa.w"

/*4:*/
#line 126 "./gb_lisa.w"

char lisa_id[]= 
"lisa(360,250,9999999999,359,360,249,250,9999999999,9999999999)";

/*:4*/
#line 145 "./gb_lisa.w"

/*16:*/
#line 305 "./gb_lisa.w"

static long bit[30];

/*:16*//*22:*/
#line 358 "./gb_lisa.w"

static long in_row[MAX_N];

/*:22*/
#line 146 "./gb_lisa.w"

/*15:*/
#line 285 "./gb_lisa.w"

static long na_over_b(n,a,b)
long n,a,b;
{long nmax= el_gordo/a;
register long r,k,q,br;
long a_thresh,b_thresh;
if(n<=nmax)return(n*a)/b;
a_thresh= b-a;
b_thresh= (b+1)>>1;
k= 0;
do{bit[k]= n&1;
n>>= 1;
k++;
}while(n> nmax);
r= n*a;q= r/b;r= r-q*b;
/*17:*/
#line 308 "./gb_lisa.w"

do{k--;q<<= 1;
if(r<b_thresh)r<<= 1;
else q++,br= (b-r)<<1,r= b-br;
if(bit[k]){
if(r<a_thresh)r+= a;
else q++,r-= a_thresh;
}
}while(k);

/*:17*/
#line 301 "./gb_lisa.w"
;
return q;
}

/*:15*//*32:*/
#line 561 "./gb_lisa.w"

static void adjac(u,v)
Vertex*u,*v;
{Arc*a;
for(a= u->arcs;a;a= a->next)
if(a->tip==v)return;
gb_new_edge(u,v,1L);
}

/*:32*/
#line 147 "./gb_lisa.w"


long*lisa(m,n,d,m0,m1,n0,n1,d0,d1,area)
unsigned long m,n;
unsigned long d;
unsigned long m0,m1;
unsigned long n0,n1;
unsigned long d0,d1;
Area area;
{/*7:*/
#line 163 "./gb_lisa.w"

long*matx= NULL;
register long k,l;
register long i,j;
long cap_M,cap_N;
long cap_D;

/*:7*//*11:*/
#line 221 "./gb_lisa.w"

long*cur_pix;
long lambda;
long lam;
long next_lam;

/*:11*//*14:*/
#line 268 "./gb_lisa.w"

long kappa;
long kap;
long next_kap;
long f;
long*out_row;

/*:14*/
#line 156 "./gb_lisa.w"

/*8:*/
#line 170 "./gb_lisa.w"

if(m1==0||m1> MAX_M)m1= MAX_M;
if(m1<=m0)panic(bad_specs+1);
if(n1==0||n1> MAX_N)n1= MAX_N;
if(n1<=n0)panic(bad_specs+2);
cap_M= m1-m0;cap_N= n1-n0;
if(m==0)m= cap_M;
if(n==0)n= cap_N;
if(d==0)d= MAX_D;
if(d1==0)d1= MAX_D*cap_M*cap_N;
if(d1<=d0)panic(bad_specs+3);
if(d1>=0x80000000)panic(bad_specs+4);
cap_D= d1-d0;
sprintf(lisa_id,"lisa(%lu,%lu,%lu,%lu,%lu,%lu,%lu,%lu,%lu)",
m,n,d,m0,m1,n0,n1,d0,d1);

/*:8*/
#line 157 "./gb_lisa.w"
;
/*9:*/
#line 186 "./gb_lisa.w"

matx= gb_typed_alloc(m*n,long,area);
if(gb_trouble_code)panic(no_room+1);

/*:9*/
#line 158 "./gb_lisa.w"
;
/*10:*/
#line 190 "./gb_lisa.w"

/*19:*/
#line 331 "./gb_lisa.w"

if(gb_open("lisa.dat")!=0)
panic(early_data_fault);
for(i= 0;i<m0;i++)
for(j= 0;j<5;j++)gb_newline();

/*:19*/
#line 191 "./gb_lisa.w"
;
/*13:*/
#line 247 "./gb_lisa.w"

kappa= 0;
out_row= matx;
for(k= kap= 0;k<m;k++){
for(l= 0;l<n;l++)*(out_row+l)= 0;
next_kap= kap+cap_M;
do{register long nk;
if(kap>=kappa){
/*21:*/
#line 344 "./gb_lisa.w"

{register long dd;
for(j= 15,cur_pix= &in_row[0];;cur_pix+= 4){
dd= gb_digit(85);dd= dd*85+gb_digit(85);dd= dd*85+gb_digit(85);
if(cur_pix==&in_row[MAX_N-2])break;
dd= dd*85+gb_digit(85);dd= dd*85+gb_digit(85);
*(cur_pix+3)= dd&0xff;dd= (dd>>8)&0xffffff;
*(cur_pix+2)= dd&0xff;dd>>= 8;
*(cur_pix+1)= dd&0xff;*cur_pix= dd>>8;
if(--j==0)gb_newline(),j= 15;
}
*(cur_pix+1)= dd&0xff;*cur_pix= dd>>8;gb_newline();
}

/*:21*/
#line 255 "./gb_lisa.w"
;
kappa+= m;
}
if(kappa<next_kap)nk= kappa;
else nk= next_kap;
f= nk-kap;
/*12:*/
#line 227 "./gb_lisa.w"

lambda= n;cur_pix= in_row+n0;
for(l= lam= 0;l<n;l++){register long sum= 0;
next_lam= lam+cap_N;
do{register long nl;
if(lam>=lambda)cur_pix++,lambda+= n;
if(lambda<next_lam)nl= lambda;
else nl= next_lam;
sum+= (nl-lam)*(*cur_pix);
lam= nl;
}while(lam<next_lam);
*(out_row+l)+= f*sum;
}

/*:12*/
#line 261 "./gb_lisa.w"
;
kap= nk;
}while(kap<next_kap);
for(l= 0;l<n;l++,out_row++)
/*18:*/
#line 318 "./gb_lisa.w"

if(*out_row<=d0)*out_row= 0;
else if(*out_row>=d1)*out_row= d;
else*out_row= na_over_b(d,*out_row-d0,cap_D);

/*:18*/
#line 265 "./gb_lisa.w"
;
}

/*:13*/
#line 192 "./gb_lisa.w"
;
/*20:*/
#line 337 "./gb_lisa.w"

for(i= m1;i<MAX_M;i++)
for(j= 0;j<5;j++)gb_newline();
if(gb_close()!=0)
panic(late_data_fault);


/*:20*/
#line 193 "./gb_lisa.w"
;

/*:10*/
#line 159 "./gb_lisa.w"
;
return matx;
}

/*:6*//*23:*/
#line 405 "./gb_lisa.w"
Graph*plane_lisa(m,n,d,m0,m1,n0,n1,d0,d1)
unsigned long m,n;
unsigned long d;
unsigned long m0,m1;
unsigned long n0,n1;
unsigned long d0,d1;
{/*24:*/
#line 424 "./gb_lisa.w"

Graph*new_graph;
register long j,k,l;
Area working_storage;
long*a;
long regs= 0;

/*:24*//*27:*/
#line 480 "./gb_lisa.w"

unsigned long*f;

long*apos;

/*:27*//*31:*/
#line 552 "./gb_lisa.w"

Vertex**u;
Vertex*v;
Vertex*w;
long aloc;

/*:31*/
#line 411 "./gb_lisa.w"

init_area(working_storage);
/*26:*/
#line 468 "./gb_lisa.w"

a= lisa(m,n,d,m0,m1,n0,n1,d0,d1,working_storage);
if(a==NULL)return NULL;
sscanf(lisa_id,"lisa(%lu,%lu,",&m,&n);
f= gb_typed_alloc(n,unsigned long,working_storage);
if(f==NULL){
gb_free(working_storage);
panic(no_room+2);
}
/*28:*/
#line 493 "./gb_lisa.w"

for(k= m,apos= a+n*(m+1)-1;k>=0;k--)
for(l= n-1;l>=0;l--,apos--){
if(k<m){
if(k> 0&&*(apos-n)==*apos){
for(j= l;f[j]!=j;j= f[j]);
f[j]= l;
*apos= l;
}else if(f[l]==l)*apos= -1-*apos,regs++;
else*apos= f[l];
}
if(k> 0&&l<n-1&&*(apos-n)==*(apos-n+1))f[l+1]= l;
f[l]= l;
}

/*:28*/
#line 478 "./gb_lisa.w"
;

/*:26*/
#line 413 "./gb_lisa.w"
;
/*29:*/
#line 508 "./gb_lisa.w"

new_graph= gb_new_graph(regs);
if(new_graph==NULL)
panic(no_room);
sprintf(new_graph->id,"plane_%s",lisa_id);
strcpy(new_graph->util_types,"ZZZIIIZZIIZZZZ");
new_graph->matrix_rows= m;
new_graph->matrix_cols= n;

/*:29*/
#line 414 "./gb_lisa.w"
;
/*30:*/
#line 530 "./gb_lisa.w"

regs= 0;
u= (Vertex**)f;
for(l= 0;l<n;l++)u[l]= NULL;
for(k= 0,apos= a,aloc= 0;k<m;k++)
for(l= 0;l<n;l++,apos++,aloc++){
w= u[l];
if(*apos<0){
sprintf(str_buf,"%ld",regs);
v= new_graph->vertices+regs;
v->name= gb_save_string(str_buf);
v->pixel_value= -*apos-1;
v->first_pixel= aloc;
regs++;
}else v= u[*apos];
u[l]= v;
v->last_pixel= aloc;
if(gb_trouble_code)goto trouble;
if(k> 0&&v!=w)adjac(v,w);
if(l> 0&&v!=u[l-1])adjac(v,u[l-1]);
}

/*:30*/
#line 415 "./gb_lisa.w"
;
trouble:gb_free(working_storage);
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
return new_graph;
}

/*:23*//*33:*/
#line 591 "./gb_lisa.w"
Graph*bi_lisa(m,n,m0,m1,n0,n1,thresh,c)
unsigned long m,n;
unsigned long m0,m1;
unsigned long n0,n1;
unsigned long thresh;
long c;
{/*34:*/
#line 609 "./gb_lisa.w"

Graph*new_graph;
register long k,l;
Area working_storage;
long*a;
long*apos;
register Vertex*u,*v;

/*:34*/
#line 597 "./gb_lisa.w"

init_area(working_storage);
/*35:*/
#line 617 "./gb_lisa.w"

a= lisa(m,n,65535L,m0,m1,n0,n1,0L,0L,working_storage);
if(a==NULL)return NULL;
sscanf(lisa_id,"lisa(%lu,%lu,65535,%lu,%lu,%lu,%lu",&m,&n,&m0,&m1,&n0,&n1);
new_graph= gb_new_graph(m+n);
if(new_graph==NULL)
panic(no_room);
sprintf(new_graph->id,"bi_lisa(%lu,%lu,%lu,%lu,%lu,%lu,%lu,%c)",
m,n,m0,m1,n0,n1,thresh,c?'1':'0');
new_graph->util_types[7]= 'I';
mark_bipartite(new_graph,m);
for(k= 0,v= new_graph->vertices;k<m;k++,v++){
sprintf(str_buf,"r%ld",k);
v->name= gb_save_string(str_buf);
}
for(l= 0;l<n;l++,v++){
sprintf(str_buf,"c%ld",l);

v->name= gb_save_string(str_buf);
}

/*:35*/
#line 599 "./gb_lisa.w"
;
/*36:*/
#line 641 "./gb_lisa.w"

for(u= new_graph->vertices,apos= a;u<new_graph->vertices+m;u++)
for(v= new_graph->vertices+m;v<new_graph->vertices+m+n;apos++,v++){
if(c?*apos<thresh:*apos>=thresh){
gb_new_edge(u,v,1L);
u->arcs->b.I= v->arcs->b.I= *apos;
}
}

/*:36*/
#line 600 "./gb_lisa.w"
;
gb_free(working_storage);
if(gb_trouble_code){
gb_recycle(new_graph);
panic(alloc_fault);
}
return new_graph;
}

/*:33*/
