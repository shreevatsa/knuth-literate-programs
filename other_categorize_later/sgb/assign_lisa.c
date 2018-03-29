/*2:*/
#line 68 "./assign_lisa.w"

#include "gb_graph.h" 
#include "gb_lisa.h" 
#define o mems++
#define oo mems+= 2
#define ooo mems+= 3 \

#define aa(k,l) *(mtx+k*n+l)  \

#define INF 0x7fffffff \


#line 71 "./assign_lisa.w"

/*3:*/
#line 98 "./assign_lisa.w"

Area working_storage;
long*mtx;
long mems;


/*:3*//*29:*/
#line 675 "./assign_lisa.w"

FILE*eps_file;

/*:29*/
#line 72 "./assign_lisa.w"

main(argc,argv)
int argc;
char*argv[];
{/*4:*/
#line 106 "./assign_lisa.w"

unsigned long m= 0,n= 0;
unsigned long d= 0;
unsigned long m0= 0,m1= 0;
unsigned long n0= 0,n1= 0;
unsigned long d0= 0,d1= 0;
long compl= 0;
long heur= 0;
long printing= 0;
long PostScript= 0;

/*:4*//*13:*/
#line 320 "./assign_lisa.w"

register long k;
register long l;
register long j;
register long s;

/*:13*//*14:*/
#line 362 "./assign_lisa.w"

long*col_mate;
long*row_mate;
long*parent_row;
long*unchosen_row;
long t;
long q;
long*row_dec;
long*col_inc;
long*slack;
long*slack_row;
long unmatched;

/*:14*//*26:*/
#line 615 "./assign_lisa.w"

long*tmtx;
long transposed;

/*:26*/
#line 76 "./assign_lisa.w"

/*5:*/
#line 117 "./assign_lisa.w"

while(--argc){

if(sscanf(argv[argc],"m=%lu",&m)==1);
else if(sscanf(argv[argc],"n=%lu",&n)==1);
else if(sscanf(argv[argc],"d=%lu",&d)==1);
else if(sscanf(argv[argc],"m0=%lu",&m0)==1);
else if(sscanf(argv[argc],"m1=%lu",&m1)==1);
else if(sscanf(argv[argc],"n0=%lu",&n0)==1);
else if(sscanf(argv[argc],"n1=%lu",&n1)==1);
else if(sscanf(argv[argc],"d0=%lu",&d0)==1);
else if(sscanf(argv[argc],"d1=%lu",&d1)==1);
else if(strcmp(argv[argc],"-s")==0){
smile;
d1= 100000;
}else if(strcmp(argv[argc],"-e")==0){
eyes;
d1= 200000;
}else if(strcmp(argv[argc],"-c")==0)compl= 1;
else if(strcmp(argv[argc],"-h")==0)heur= 1;
else if(strcmp(argv[argc],"-v")==0)verbose= 1;
else if(strcmp(argv[argc],"-V")==0)verbose= 2;
else if(strcmp(argv[argc],"-p")==0)printing= 1;
else if(strcmp(argv[argc],"-P")==0)PostScript= 1;
else{
fprintf(stderr,
"Usage: %s [param=value] [-s] [-c] [-h] [-v] [-p] [-P]\n",argv[0]);
return-2;
}
}

/*:5*/
#line 77 "./assign_lisa.w"
;
mtx= lisa(m,n,d,m0,m1,n0,n1,d0,d1,working_storage);
if(mtx==NULL){
fprintf(stderr,"Sorry, can't create the matrix! (error code %ld)\n",
panic_code);
return-1;
}
printf("Assignment problem for %s%s\n",lisa_id,(compl?", complemented":""));
sscanf(lisa_id,"lisa(%lu,%lu,%lu",&m,&n,&d);
if(m!=n)heur= 0;
if(printing)/*6:*/
#line 148 "./assign_lisa.w"

for(k= 0;k<m;k++){
for(l= 0;l<n;l++)printf("% 4ld",compl?d-*(mtx+k*n+l):*(mtx+k*n+l));
printf("\n");
}

/*:6*/
#line 87 "./assign_lisa.w"
;
if(PostScript)/*28:*/
#line 656 "./assign_lisa.w"

{
eps_file= fopen("lisa.eps","w");
if(!eps_file){
fprintf(stderr,"Sorry, I can't open the file `lisa.eps'!\n");
PostScript= 0;
}else{
fprintf(eps_file,"%%!PS-Adobe-3.0 EPSF-3.0\n");

fprintf(eps_file,"%%%%BoundingBox: -1 -1 %ld %ld\n",n+1,m+1);
fprintf(eps_file,"/buffer %ld string def\n",n);
fprintf(eps_file,"%ld %ld 8 [%ld 0 0 -%ld 0 %ld]\n",n,m,n,m,m);
fprintf(eps_file,"{currentfile buffer readhexstring pop} bind\n");
fprintf(eps_file,"gsave %ld %ld scale image\n",n,m);
for(k= 0;k<m;k++)/*30:*/
#line 682 "./assign_lisa.w"

{register float conv= 255.0/(float)d;register long x;
for(l= 0;l<n;l++){
x= (long)(conv*(float)(compl?d-aa(k,l):aa(k,l)));
fprintf(eps_file,"%02lx",x> 255?255L:x);
if((l&0x1f)==0x1f)fprintf(eps_file,"\n");
}
if(n&0x1f)fprintf(eps_file,"\n");
}

/*:30*/
#line 670 "./assign_lisa.w"
;
fprintf(eps_file,"grestore\n");
}
}

/*:28*/
#line 88 "./assign_lisa.w"
;
mems= 0;
/*24:*/
#line 591 "./assign_lisa.w"

if(m> n)/*25:*/
#line 601 "./assign_lisa.w"

{
if(verbose> 1)printf("Temporarily transposing rows and columns...\n");
tmtx= gb_typed_alloc(m*n,long,working_storage);
if(tmtx==NULL){
fprintf(stderr,"Sorry, out of memory!\n");return-4;
}
for(k= 0;k<m;k++)for(l= 0;l<n;l++)
*(tmtx+l*m+k)= *(mtx+k*n+l);
m= n;n= k;
mtx= tmtx;
transposed= 1;
}

/*:25*/
#line 592 "./assign_lisa.w"

else transposed= 0;
/*15:*/
#line 375 "./assign_lisa.w"

col_mate= gb_typed_alloc(m,long,working_storage);
row_mate= gb_typed_alloc(n,long,working_storage);
parent_row= gb_typed_alloc(n,long,working_storage);
unchosen_row= gb_typed_alloc(m,long,working_storage);
row_dec= gb_typed_alloc(m,long,working_storage);
col_inc= gb_typed_alloc(n,long,working_storage);
slack= gb_typed_alloc(n,long,working_storage);
slack_row= gb_typed_alloc(n,long,working_storage);
if(gb_trouble_code){
fprintf(stderr,"Sorry, out of memory!\n");return-3;
}

/*:15*/
#line 594 "./assign_lisa.w"
;
if(compl==0)
for(k= 0;k<m;k++)for(l= 0;l<n;l++)
aa(k,l)= d-aa(k,l);
if(heur)/*12:*/
#line 307 "./assign_lisa.w"

{
for(l= 0;l<n;l++){
o,s= aa(0,l);
for(k= 1;k<n;k++)
if(o,aa(k,l)<s)s= aa(k,l);
if(s!=0)
for(k= 0;k<n;k++)
oo,aa(k,l)-= s;
}
if(verbose)printf(" The heuristic has cost %ld mems.\n",mems);
}

/*:12*/
#line 598 "./assign_lisa.w"
;
/*18:*/
#line 442 "./assign_lisa.w"

/*16:*/
#line 398 "./assign_lisa.w"

t= 0;
for(l= 0;l<n;l++){
o,row_mate[l]= -1;
o,parent_row[l]= -1;
o,col_inc[l]= 0;
o,slack[l]= INF;
}
for(k= 0;k<m;k++){
o,s= aa(k,0);
for(l= 1;l<n;l++)if(o,aa(k,l)<s)s= aa(k,l);
o,row_dec[k]= s;
for(l= 0;l<n;l++)
if((o,s==aa(k,l))&&(o,row_mate[l]<0)){
o,col_mate[k]= l;
o,row_mate[l]= k;
if(verbose> 1)printf(" matching col %ld==row %ld\n",l,k);
goto row_done;
}
o,col_mate[k]= -1;
if(verbose> 1)printf("  node %ld: unmatched row %ld\n",t,k);
o,unchosen_row[t++]= k;
row_done:;
}

/*:16*/
#line 443 "./assign_lisa.w"
;
if(t==0)goto done;
unmatched= t;
while(1){
if(verbose)printf(" After %ld mems I've matched %ld rows.\n",mems,m-t);
q= 0;
while(1){
while(q<t){
/*19:*/
#line 465 "./assign_lisa.w"

{
o,k= unchosen_row[q];
o,s= row_dec[k];
for(l= 0;l<n;l++)
if(o,slack[l]){register long del;
oo,del= aa(k,l)-s+col_inc[l];
if(del<slack[l]){
if(del==0){
if(o,row_mate[l]<0)goto breakthru;
o,slack[l]= 0;
o,parent_row[l]= k;
if(verbose> 1)printf("  node %ld: row %ld==col %ld--row %ld\n",
t,row_mate[l],l,k);
oo,unchosen_row[t++]= row_mate[l];
}else{
o,slack[l]= del;
o,slack_row[l]= k;
}
}
}
}

/*:19*/
#line 452 "./assign_lisa.w"
;
q++;
}
/*21:*/
#line 510 "./assign_lisa.w"

s= INF;
for(l= 0;l<n;l++)
if(o,slack[l]&&slack[l]<s)
s= slack[l];
for(q= 0;q<t;q++)
ooo,row_dec[unchosen_row[q]]+= s;
for(l= 0;l<n;l++)
if(o,slack[l]){
o,slack[l]-= s;
if(slack[l]==0)/*22:*/
#line 535 "./assign_lisa.w"

{
o,k= slack_row[l];
if(verbose> 1)
printf(" Decreasing uncovered elements by %ld produces zero at [%ld,%ld]\n",
s,k,l);
if(o,row_mate[l]<0){
for(j= l+1;j<n;j++)
if(o,slack[j]==0)oo,col_inc[j]+= s;
goto breakthru;
}else{
o,parent_row[l]= k;
if(verbose> 1)printf("  node %ld: row %ld==col %ld--row %ld\n",
t,row_mate[l],l,k);
oo,unchosen_row[t++]= row_mate[l];
}
}

/*:22*/
#line 521 "./assign_lisa.w"
;
}else oo,col_inc[l]+= s;

/*:21*/
#line 456 "./assign_lisa.w"
;
}
breakthru:/*20:*/
#line 493 "./assign_lisa.w"

if(verbose)printf(" Breakthrough at node %ld of %ld!\n",q,t);
while(1){
o,j= col_mate[k];
o,col_mate[k]= l;
o,row_mate[l]= k;
if(verbose> 1)printf(" rematching col %ld==row %ld\n",l,k);
if(j<0)break;
o,k= parent_row[j];
l= j;
}

/*:20*/
#line 458 "./assign_lisa.w"
;
if(--unmatched==0)goto done;
/*17:*/
#line 426 "./assign_lisa.w"

t= 0;
for(l= 0;l<n;l++){
o,parent_row[l]= -1;
o,slack[l]= INF;
}
for(k= 0;k<m;k++)
if(o,col_mate[k]<0){
if(verbose> 1)printf("  node %ld: unmatched row %ld\n",t,k);
o,unchosen_row[t++]= k;
}

/*:17*/
#line 460 "./assign_lisa.w"
;
}
done:/*23:*/
#line 561 "./assign_lisa.w"

for(k= 0;k<m;k++)
for(l= 0;l<n;l++)
if(aa(k,l)<row_dec[k]-col_inc[l]){
fprintf(stderr,"Oops, I made a mistake!\n");
return-6;
}
for(k= 0;k<m;k++){
l= col_mate[k];
if(l<0||aa(k,l)!=row_dec[k]-col_inc[l]){
fprintf(stderr,"Oops, I blew it!\n");return-66;
}
}
k= 0;
for(l= 0;l<n;l++)if(col_inc[l])k++;
if(k> m){
fprintf(stderr,"Oops, I adjusted too many columns!\n");
return-666;
}

/*:23*/
#line 462 "./assign_lisa.w"
;

/*:18*/
#line 599 "./assign_lisa.w"
;

/*:24*/
#line 90 "./assign_lisa.w"
;
if(printing)/*27:*/
#line 619 "./assign_lisa.w"

{
printf("The following entries produce an optimum assignment:\n");
for(k= 0;k<m;k++)
printf(" [%ld,%ld]\n",
transposed?col_mate[k]:k,
transposed?k:col_mate[k]);
}

/*:27*/
#line 91 "./assign_lisa.w"
;
if(PostScript)/*31:*/
#line 692 "./assign_lisa.w"

{
fprintf(eps_file,
"/bx {moveto 0 1 rlineto 1 0 rlineto 0 -1 rlineto closepath\n");
fprintf(eps_file," gsave .3 setlinewidth 1 setgray clip stroke");
fprintf(eps_file," grestore stroke} bind def\n");
fprintf(eps_file," .1 setlinewidth\n");
for(k= 0;k<m;k++)
fprintf(eps_file," %ld %ld bx\n",
transposed?k:col_mate[k],
transposed?n-1-col_mate[k]:m-1-k);
fclose(eps_file);
}

/*:31*/
#line 92 "./assign_lisa.w"
;
printf("Solved in %ld mems%s.\n",mems,
(heur?" with square-matrix heuristic":""));
return 0;
}

/*:2*/
