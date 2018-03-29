/*2:*/
#line 32 "./multiply.w"

#include "gb_graph.h" 
#include "gb_gates.h" 
#define prompt(s)  \
{printf(s) ;fflush(stdout) ; \
if(fgets(buffer,999,stdin) ==NULL) break;}
#define retry(s,t)  \
{printf(s) ;goto t;} \

#define dp u.I \


#line 35 "./multiply.w"

/*4:*/
#line 88 "./multiply.w"

Graph*g;
long m,n;
long seed;
char x[302],y[302],z[603];
char buffer[2000];

/*:4*/
#line 36 "./multiply.w"

/*10:*/
#line 199 "./multiply.w"

decimal_to_binary(x,s,n)
char*x;
char*s;
long n;
{register long k;
register char*p,*q;
register long r;
for(k= 0;k<n;k++,s++){
if(*x==0)*s= '0';
else{
if(*x> '1')p= x,r= 0;
else p= x+1,r= *x-'0';
for(q= x;*p;p++,q++){
r= 10*r+*p-'0';
*q= (r>>1)+'0';
r= r&1;
}
*q= 0;
*s= '0'+r;
}
}
*s= 0;
}

/*:10*//*13:*/
#line 281 "./multiply.w"

long depth(g)
Graph*g;
{register Vertex*v;
register Arc*a;
long d;
if(!g)return-1;
for(v= g->vertices;v<g->vertices+g->n;v++){
switch(v->typ){
case'I':case'L':case'C':v->dp= 0;break;
default:/*14:*/
#line 299 "./multiply.w"

d= 0;
for(a= v->arcs;a;a= a->next)
if(a->tip->dp> d)d= a->tip->dp;

/*:14*/
#line 291 "./multiply.w"
;
v->dp= 1+d;
}
}
/*15:*/
#line 304 "./multiply.w"

d= 0;
for(a= g->outs;a;a= a->next)
if(!is_boolean(a->tip)&&a->tip->dp> d)d= a->tip->dp;

/*:15*/
#line 295 "./multiply.w"
;
return d;
}

/*:13*/
#line 37 "./multiply.w"

main(argc,argv)
int argc;
char*argv[];
{
/*5:*/
#line 95 "./multiply.w"

register char*p,*q,*r;
register long a,b;

/*:5*/
#line 42 "./multiply.w"
;
/*6:*/
#line 99 "./multiply.w"


if(argc<3||argc> 4||sscanf(argv[1],"%ld",&m)!=1||
sscanf(argv[2],"%ld",&n)!=1){
fprintf(stderr,"Usage: %s m n [seed]\n",argv[0]);
return-2;
}
if(m<0)m= -m;
if(n<0)n= -n;
seed= -1;
if(argc==4&&sscanf(argv[3],"%ld",&seed)==1&&seed<0)
seed= -seed;

/*:6*/
#line 43 "./multiply.w"
;
/*3:*/
#line 71 "./multiply.w"

if(m<2)m= 2;
if(n<2)n= 2;
if(m> 999||n> 999){
printf("Sorry, I'm set up only for precision less than 1000 bits.\n");
return-1;
}
if((g= prod(m,n))==NULL){
printf("Sorry, I couldn't generate the graph (not enough memory for %s)!\n",
panic_code==no_room?"the gates":panic_code==alloc_fault?"the wires":
"local optimization");
return-3;
}

/*:3*/
#line 44 "./multiply.w"
;
if(seed<0)
printf("Here I am, ready to multiply %ld-bit numbers by %ld-bit numbers.\n",
m,n);
else{
g= partial_gates(g,m,0L,seed,buffer);
if(g){
/*9:*/
#line 163 "./multiply.w"

*y= '0';*(y+1)= 0;
for(r= buffer+strlen(buffer)-1;r>=buffer;r--){

if(*y>='5')a= 0,p= y;
else a= *y-'0',p= y+1;
for(q= y;*p;a= b,p++,q++){
if(*p>='5'){
b= *p-'5';
*q= 2*a+'1';
}else{
b= *p-'0';
*q= 2*a+'0';
}
}
if(*r=='1')*q= 2*a+'1';
else*q= 2*a+'0';
*++q= 0;
}
if(strcmp(y,"0")==0){
printf("Please try another seed value; %d makes the answer zero!\n",seed);
return(-5);
}

/*:9*/
#line 51 "./multiply.w"
;
printf("OK, I'm ready to multiply any %ld-bit number by %s.\n",m,y);
}else{


printf("Sorry, I couldn't process the graph (trouble code %ld)!\n",
panic_code);
return-9;
}
}
printf("(I'm simulating a logic circuit with %ld gates, depth %ld.)\n",
g->n,depth(g));
while(1){
/*7:*/
#line 120 "./multiply.w"

step1:prompt("\nNumber, please? ");
for(p= buffer;*p=='0';p++);
if(*p=='\n'){
if(p> buffer)p--;
else break;
}
for(q= p;*q>='0'&&*q<='9';q++);
if(*q!='\n')retry(
"Excuse me... I'm looking for a nonnegative sequence of decimal digits.",
step1);
*q= 0;
if(strlen(p)> 301)
retry("Sorry, that's too big.",step1);
strcpy(x,p);
if(seed<0){
/*8:*/
#line 139 "./multiply.w"

step2:prompt("Another? ");
for(p= buffer;*p=='0';p++);
if(*p=='\n'){
if(p> buffer)p--;
else break;
}
for(q= p;*q>='0'&&*q<='9';q++);
if(*q!='\n')retry(
"Excuse me... I'm looking for a nonnegative sequence of decimal digits.",
step2);
*q= 0;
if(strlen(p)> 301)
retry("Sorry, that's too big.",step2);
strcpy(y,p);

/*:8*/
#line 136 "./multiply.w"
;
}

/*:7*/
#line 64 "./multiply.w"
;
/*11:*/
#line 224 "./multiply.w"

strcpy(z,x);
decimal_to_binary(z,buffer,m);
if(*z){
printf("(Sorry, %s has more than %ld bits.)\n",x,m);
continue;
}
if(seed<0){
strcpy(z,y);
decimal_to_binary(z,buffer+m,n);
if(*z){
printf("(Sorry, %s has more than %ld bits.)\n",y,n);
continue;
}
}
if(gate_eval(g,buffer,buffer)<0){
printf("??? An internal error occurred!");
return 666;
}
/*12:*/
#line 249 "./multiply.w"

*z= '0';*(z+1)= 0;
for(r= buffer;*r;r++){

if(*z>='5')a= 0,p= z;
else a= *z-'0',p= z+1;
for(q= z;*p;a= b,p++,q++){
if(*p>='5'){
b= *p-'5';
*q= 2*a+'1';
}else{
b= *p-'0';
*q= 2*a+'0';
}
}
if(*r=='1')*q= 2*a+'1';
else*q= 2*a+'0';
*++q= 0;
}

/*:12*/
#line 243 "./multiply.w"
;

/*:11*/
#line 65 "./multiply.w"
;
printf("%sx%s=%s%s.\n",x,y,(strlen(x)+strlen(y)> 35?"\n ":""),z);
}
return 0;
}

/*:2*/
