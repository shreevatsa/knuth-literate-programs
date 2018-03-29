/*4:*/
#line 86 "./gb_raman.w"

#include "gb_graph.h" 
#define panic(c) {panic_code= c;gb_trouble_code= 0;return NULL;}
#define dead_panic(c) {gb_free(working_storage) ;panic(c) ;}
#define late_panic(c) {gb_recycle(new_graph) ;dead_panic(c) ;} \

#define ref a.I \


#line 88 "./gb_raman.w"

/*18:*/
#line 411 "./gb_raman.w"

typedef struct{
long a0,a1,a2,a3;
unsigned long bar;
}quaternion;

/*:18*/
#line 89 "./gb_raman.w"

/*6:*/
#line 124 "./gb_raman.w"

static long*q_sqr;
static long*q_sqrt;
static long*q_inv;

/*:6*//*15:*/
#line 272 "./gb_raman.w"

static char name_buf[]= "(1111,1111;1,1111)";

/*:15*//*20:*/
#line 431 "./gb_raman.w"

static quaternion*gen;

/*:20*//*22:*/
#line 479 "./gb_raman.w"

static unsigned long gen_count;
static unsigned long max_gen_count;
static void deposit(a,b,c,d)
long a,b,c,d;
{
if(gen_count>=max_gen_count)
gen_count= max_gen_count+1;
else{
gen[gen_count].a0= gen[gen_count+1].a0= a;
gen[gen_count].a1= b;gen[gen_count+1].a1= -b;
gen[gen_count].a2= c;gen[gen_count+1].a2= -c;
gen[gen_count].a3= d;gen[gen_count+1].a3= -d;
if(a){
gen[gen_count].bar= gen_count+1;
gen[gen_count+1].bar= gen_count;
gen_count+= 2;
}else{
gen[gen_count].bar= gen_count;
gen_count++;
}
}
}

/*:22*//*30:*/
#line 697 "./gb_raman.w"

static long lin_frac(a,k)
long a;
long k;
{register long q= q_inv[0];
long a00= gen[k].a0,a01= gen[k].a1,a10= gen[k].a2,
a11= gen[k].a3;
register long num,den;
if(a==q)num= a00,den= a10;
else num= (a00*a+a01)%q,den= (a10*a+a11)%q;
if(den==0)return q;
else return(num*q_inv[den])%q;
}

/*:30*/
#line 90 "./gb_raman.w"


Graph*raman(p,q,type,reduce)
long p;
long q;
unsigned long type;
unsigned long reduce;
{/*5:*/
#line 110 "./gb_raman.w"

Graph*new_graph;
Area working_storage;

/*:5*//*9:*/
#line 151 "./gb_raman.w"

register long a,aa,k;
long b,bb,c,cc,d,dd;
long n;
long n_factor;
register Vertex*v;

/*:9*/
#line 97 "./gb_raman.w"

/*7:*/
#line 129 "./gb_raman.w"

if(q<3||q> 46337)panic(very_bad_specs);

if(p<2)panic(very_bad_specs+1);
init_area(working_storage);
q_sqr= gb_typed_alloc(3*q,long,working_storage);
if(q_sqr==0)panic(no_room+1);
q_sqrt= q_sqr+q;
q_inv= q_sqrt+q;
/*8:*/
#line 142 "./gb_raman.w"

for(a= 1;a<q;a++)q_sqrt[a]= -1;
for(a= 1,aa= 1;a<q;aa= (aa+a+a+1)%q,a++){
q_sqr[a]= aa;
q_sqrt[aa]= q-a;
q_inv[aa]= -1;

}

/*:8*/
#line 138 "./gb_raman.w"
;
/*10:*/
#line 163 "./gb_raman.w"

for(a= 2;;a++)
if(q_inv[a]==0){
for(b= a,k= 1;b!=1&&k<q;aa= b,b= (a*b)%q,k++)q_inv[b]= -1;
if(k>=q)dead_panic(bad_specs+1);
if(k==q-1)break;
}

/*:10*/
#line 139 "./gb_raman.w"
;
/*11:*/
#line 177 "./gb_raman.w"

for(b= a,bb= aa;b!=bb;b= (a*b)%q,bb= (aa*bb)%q)q_inv[b]= bb,q_inv[bb]= b;
q_inv[1]= 1;q_inv[b]= b;
q_inv[0]= q;

/*:11*/
#line 140 "./gb_raman.w"
;

/*:7*/
#line 98 "./gb_raman.w"
;
/*12:*/
#line 187 "./gb_raman.w"

if(p==2){
if(q_sqrt[13%q]<0||q_sqrt[q-2]<0)
dead_panic(bad_specs+2);
}
if((a= p%q)==0)dead_panic(bad_specs+3);
if(type==0)type= (q_sqrt[a]> 0?3:4);
n_factor= (type==3?(q-1)/2:q-1);
switch(type){
case 1:n= q+1;break;
case 2:n= q*(q+1)/2;break;
default:if((q_sqrt[a]> 0&&type!=3)||(q_sqrt[a]<0&&type!=4))
dead_panic(bad_specs+4);
if(q> 1289)dead_panic(bad_specs+5);
n= n_factor*q*(q+1);
break;
}
if(p>=(long)(0x3fffffff/n))dead_panic(bad_specs+6);

/*:12*/
#line 99 "./gb_raman.w"
;
/*13:*/
#line 244 "./gb_raman.w"

new_graph= gb_new_graph(n);
if(new_graph==NULL)
dead_panic(no_room);
sprintf(new_graph->id,"raman(%ld,%ld,%lu,%lu)",p,q,type,reduce);
strcpy(new_graph->util_types,"ZZZIIZIZZZZZZZ");
v= new_graph->vertices;
switch(type){
case 1:/*14:*/
#line 260 "./gb_raman.w"

new_graph->util_types[4]= 'Z';
for(a= 0;a<q;a++){
sprintf(name_buf,"%ld",a);
v->name= gb_save_string(name_buf);
v->x.I= a;
v++;
}
v->name= gb_save_string("INF");
v->x.I= q;
v++;

/*:14*/
#line 252 "./gb_raman.w"
;break;
case 2:/*16:*/
#line 279 "./gb_raman.w"

for(a= 0;a<q;a++)
for(aa= a+1;aa<=q;aa++){
if(aa==q)sprintf(name_buf,"{%ld,INF}",a);
else sprintf(name_buf,"{%ld,%ld}",a,aa);
v->name= gb_save_string(name_buf);
v->x.I= a;v->y.I= aa;
v++;
}

/*:16*/
#line 253 "./gb_raman.w"
;break;
default:/*17:*/
#line 300 "./gb_raman.w"

new_graph->util_types[5]= 'I';
for(c= 0;c<=q;c++)
for(b= 0;b<q;b++)
for(a= 1;a<=n_factor;a++){
v->z.I= c;
if(c==q){
v->y.I= b;
v->x.I= (type==3?q_sqr[a]:a);
sprintf(name_buf,"(%ld,%ld;0,1)",v->x.I,b);
}else{
v->x.I= b;
v->y.I= (b*c+q-(type==3?q_sqr[a]:a))%q;

sprintf(name_buf,"(%ld,%ld;1,%ld)",b,v->y.I,c);
}
v->name= gb_save_string(name_buf);
v++;
}

/*:17*/
#line 254 "./gb_raman.w"
;break;
}

/*:13*/
#line 100 "./gb_raman.w"
;
/*19:*/
#line 422 "./gb_raman.w"

gen= gb_typed_alloc(p+2,quaternion,working_storage);
if(gen==NULL)late_panic(no_room+2);
gen_count= 0;max_gen_count= p+1;
if(p==2)/*25:*/
#line 584 "./gb_raman.w"

{long s= q_sqrt[q-2],t= (q_sqrt[13%q]*s)%q;
gen[0].a0= 1;gen[0].a1= gen[0].a2= 0;gen[0].a3= q-1;gen[0].bar= 0;
gen[1].a0= gen[2].a3= (2+s)%q;
gen[1].a1= gen[1].a2= t;
gen[2].a1= gen[2].a2= q-t;
gen[1].a3= gen[2].a0= (q+2-s)%q;
gen[1].bar= 2;gen[2].bar= 1;
gen_count= 3;
}

/*:25*/
#line 426 "./gb_raman.w"

else/*21:*/
#line 454 "./gb_raman.w"

{long sa,sb;
long pp= (p>>1)&1;
for(a= 1-pp,sa= p-a;sa> 0;sa-= (a+1)<<2,a+= 2)
for(b= pp,sb= sa-b,bb= sb-b-b;bb>=0;bb-= 12*(b+1),sb-= (b+1)<<2,b+= 2)
for(c= b,cc= bb;cc>=0;cc-= (c+1)<<3,c+= 2)
for(d= c,aa= cc;aa>=0;aa-= (d+1)<<2,d+= 2)
if(aa==0)/*23:*/
#line 503 "./gb_raman.w"

{
deposit(a,b,c,d);
if(b){
deposit(a,-b,c,d);deposit(a,-b,-c,d);
}
if(c)deposit(a,b,-c,d);
if(b<c){
deposit(a,c,b,d);deposit(a,-c,b,d);deposit(a,c,d,b);
deposit(a,-c,d,b);
if(b){
deposit(a,c,-b,d);deposit(a,-c,-b,d);deposit(a,c,d,-b);
deposit(a,-c,d,-b);
}
}
if(c<d){
deposit(a,b,d,c);deposit(a,d,b,c);
if(b){
deposit(a,-b,d,c);deposit(a,-b,d,-c);deposit(a,d,-b,c);
deposit(a,d,-b,-c);
}
if(c){
deposit(a,b,d,-c);deposit(a,d,b,-c);
}
if(b<c){
deposit(a,d,c,b);deposit(a,d,-c,b);
if(b){
deposit(a,d,c,-b);deposit(a,d,-c,-b);
}
}
}
}

/*:23*/
#line 461 "./gb_raman.w"
;
/*24:*/
#line 552 "./gb_raman.w"

{register long g,h;
long a00,a01,a10,a11;
for(k= q-1;q_sqrt[k]<0;k--);
g= q_sqrt[k];h= q_sqrt[q-1-k];
for(k= p;k>=0;k--){
a00= (gen[k].a0+g*gen[k].a1+h*gen[k].a3)%q;
if(a00<0)a00+= q;
a11= (gen[k].a0-g*gen[k].a1-h*gen[k].a3)%q;
if(a11<0)a11+= q;
a01= (gen[k].a2+g*gen[k].a3-h*gen[k].a1)%q;
if(a01<0)a01+= q;
a10= (-gen[k].a2+g*gen[k].a3-h*gen[k].a1)%q;
if(a10<0)a10+= q;
gen[k].a0= a00;gen[k].a1= a01;gen[k].a2= a10;gen[k].a3= a11;
}
}

/*:24*/
#line 462 "./gb_raman.w"
;
}

/*:21*/
#line 428 "./gb_raman.w"
;
if(gen_count!=max_gen_count)late_panic(bad_specs+7);

/*:19*/
#line 101 "./gb_raman.w"
;
/*26:*/
#line 629 "./gb_raman.w"

for(k= p;k>=0;k--){long kk;
if((kk= gen[k].bar)<=k)
for(v= new_graph->vertices;v<new_graph->vertices+n;v++){
register Vertex*u;
/*27:*/
#line 663 "./gb_raman.w"

if(type<3)/*31:*/
#line 715 "./gb_raman.w"

if(type==1)u= new_graph->vertices+lin_frac(v->x.I,k);
else{
a= lin_frac(v->x.I,k);aa= lin_frac(v->y.I,k);
u= new_graph->vertices+(a<aa?(a*(2*q-1-a))/2+aa-1:
(aa*(2*q-1-aa))/2+a-1);
}

/*:31*/
#line 665 "./gb_raman.w"

else{long a00= gen[k].a0,a01= gen[k].a1,a10= gen[k].a2,a11= gen[k].a3;
a= v->x.I;b= v->y.I;
if(v->z.I==q)c= 0,d= 1;
else c= 1,d= v->z.I;
/*28:*/
#line 676 "./gb_raman.w"

aa= (a*a00+b*a10)%q;
bb= (a*a01+b*a11)%q;
cc= (c*a00+d*a10)%q;
dd= (c*a01+d*a11)%q;

/*:28*/
#line 670 "./gb_raman.w"
;
a= (cc?q_inv[cc]:q_inv[dd]);
d= (a*dd)%q;c= (a*cc)%q;b= (a*bb)%q;a= (a*aa)%q;
/*29:*/
#line 682 "./gb_raman.w"

if(c==0)d= q,aa= a;
else{
aa= (a*d-b)%q;
if(aa<0)aa+= q;
b= a;
}
u= new_graph->vertices+((d*q+b)*n_factor+(type==3?q_sqrt[aa]:aa)-1);

/*:29*/
#line 673 "./gb_raman.w"
;
}

/*:27*/
#line 635 "./gb_raman.w"
;
if(u==v){
if(!reduce){
gb_new_edge(v,v,1L);
v->arcs->ref= kk;(v->arcs+1)->ref= k;

}
}else{register Arc*ap;
if(u->arcs&&u->arcs->ref==kk)
continue;
else if(reduce)
for(ap= v->arcs;ap;ap= ap->next)
if(ap->tip==u)goto done;

gb_new_edge(v,u,1L);
v->arcs->ref= k;u->arcs->ref= kk;
if((ap= v->arcs->next)!=NULL&&ap->ref==kk){
v->arcs->next= ap->next;ap->next= v->arcs;v->arcs= ap;
}
done:;
}
}
}

/*:26*/
#line 102 "./gb_raman.w"
;
if(gb_trouble_code)
late_panic(alloc_fault);

gb_free(working_storage);
return new_graph;
}

/*:4*/
