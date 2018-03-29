/*2:*/
#line 30 "./take_risc.w"

#include "gb_graph.h" 
#include "gb_gates.h" 
#define prompt(s)  \
{printf(s) ;fflush(stdout) ; \
if(fgets(buffer,99,stdin) ==NULL) break;} \

#define div 7
#define mult 10
#define memry_size 34 \


#line 33 "./take_risc.w"

/*3:*/
#line 58 "./take_risc.w"

Graph*g;
long o,p,q,r;
long trace;
long m,n;
char buffer[100];

/*:3*//*6:*/
#line 118 "./take_risc.w"

unsigned long memry[memry_size]= {

0x2ff0,
0x1111,
0x1a30,
0x3333,
0x7f70,

0x5555,
0x0f8f,
0x3a21,
0x1a01,
0x0a12,
0x3a01,
0x4000,
0x5000,
0x6000,
0x2a63,
0x0f95,
0x3063,
0x1061,
0x6ac1,
0x5fd1,
0x2a63,
0x039b,
0x0843,
0x3463,
0x1561,
0x2863,
0x0c94,
0x4861,
0x6ac1,
0x2a63,
0x5a41,
0x0398,
0x6666,
0x0fa7};


/*:6*/
#line 34 "./take_risc.w"

main(argc,argv)
int argc;
char*argv[];
{
trace= (argc> 1?8:0);
if((g= risc(8L))==NULL){
printf("Sorry, I couldn't generate the graph (trouble code %ld)!\n",
panic_code);
return(-1);
}
printf("Welcome to the world of microRISC.\n");
while(1){
/*4:*/
#line 69 "./take_risc.w"

prompt("\nGimme a number: ");
step0:if(sscanf(buffer,"%ld",&m)!=1)break;
step1:if(m<=0){
prompt("Excuse me, I meant a positive number: ");
if(sscanf(buffer,"%ld",&m)!=1)break;
if(m<=0)break;
}
while(m> 0x7fff){
prompt("That number's too big; please try again: ");
if(sscanf(buffer,"%ld",&m)!=1)goto step0;
if(m<=0)goto step1;
}
/*5:*/
#line 84 "./take_risc.w"

prompt("OK, now gimme another: ");
if(sscanf(buffer,"%ld",&n)!=1)break;
step2:if(n<=0){
prompt("Excuse me, I meant a positive number: ");
if(sscanf(buffer,"%ld",&n)!=1)break;
if(n<=0)break;
}
while(n> 0x7fff){
prompt("That number's too big; please try again: ");
if(sscanf(buffer,"%ld",&n)!=1)goto step0;
if(n<=0)goto step2;
}

/*:5*/
#line 82 "./take_risc.w"
;

/*:4*/
#line 47 "./take_risc.w"
;
/*7:*/
#line 158 "./take_risc.w"

memry[1]= m;
memry[3]= n;
memry[5]= mult;
run_risc(g,memry,memry_size,trace);
p= (long)risc_state[4];
o= (long)risc_state[16]&1;

/*:7*/
#line 48 "./take_risc.w"
;
printf("The product of %ld and %ld is %ld%s.\n",m,n,p,
o?" (overflow occurred)":"");
/*8:*/
#line 166 "./take_risc.w"

memry[5]= div;
run_risc(g,memry,memry_size,trace);
q= (long)risc_state[4];
r= ((long)(risc_state[2]+n))&0x7fff;

/*:8*/
#line 52 "./take_risc.w"
;
printf("The quotient is %ld, and the remainder is %ld.\n",q,r);
}
return 0;
}

/*:2*/
