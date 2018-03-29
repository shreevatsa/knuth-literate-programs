/*1:*/
#line 9 "./gb_sort.w"

#include <stdio.h>  
#include "gb_flip.h" 

#line 12 "./gb_sort.w"

/*2:*/
#line 63 "./gb_sort.w"

typedef struct node_struct{
long key;
struct node_struct*link;
}node;

/*:2*//*4:*/
#line 87 "./gb_sort.w"

node*gb_sorted[256];
static node*alt_sorted[256];


/*:4*/
#line 13 "./gb_sort.w"

/*5:*/
#line 94 "./gb_sort.w"

void gb_linksort(l)
node*l;
{register long k;
register node**pp;
register node*p,*q;
/*6:*/
#line 108 "./gb_sort.w"

for(pp= alt_sorted+255;pp>=alt_sorted;pp--)*pp= NULL;

for(p= l;p;p= q){
k= gb_next_rand()>>23;
q= p->link;
p->link= alt_sorted[k];
alt_sorted[k]= p;
}

/*:6*/
#line 100 "./gb_sort.w"
;
/*7:*/
#line 118 "./gb_sort.w"

for(pp= gb_sorted+255;pp>=gb_sorted;pp--)*pp= NULL;

for(pp= alt_sorted+255;pp>=alt_sorted;pp--)
for(p= *pp;p;p= q){
k= gb_next_rand()>>23;
q= p->link;
p->link= gb_sorted[k];
gb_sorted[k]= p;
}

/*:7*/
#line 101 "./gb_sort.w"
;
/*8:*/
#line 129 "./gb_sort.w"

for(pp= alt_sorted+255;pp>=alt_sorted;pp--)*pp= NULL;

for(pp= gb_sorted+255;pp>=gb_sorted;pp--)
for(p= *pp;p;p= q){
k= p->key&0xff;
q= p->link;
p->link= alt_sorted[k];
alt_sorted[k]= p;
}

/*:8*/
#line 102 "./gb_sort.w"
;
/*9:*/
#line 144 "./gb_sort.w"

for(pp= gb_sorted+255;pp>=gb_sorted;pp--)*pp= NULL;

for(pp= alt_sorted;pp<alt_sorted+256;pp++)
for(p= *pp;p;p= q){
k= (p->key>>8)&0xff;
q= p->link;
p->link= gb_sorted[k];
gb_sorted[k]= p;
}

/*:9*/
#line 103 "./gb_sort.w"
;
/*10:*/
#line 155 "./gb_sort.w"

for(pp= alt_sorted+255;pp>=alt_sorted;pp--)*pp= NULL;

for(pp= gb_sorted+255;pp>=gb_sorted;pp--)
for(p= *pp;p;p= q){
k= (p->key>>16)&0xff;
q= p->link;
p->link= alt_sorted[k];
alt_sorted[k]= p;
}

/*:10*/
#line 104 "./gb_sort.w"
;
/*11:*/
#line 171 "./gb_sort.w"

for(pp= gb_sorted+255;pp>=gb_sorted;pp--)*pp= NULL;

for(pp= alt_sorted;pp<alt_sorted+256;pp++)
for(p= *pp;p;p= q){
k= (p->key>>24)&0xff;
q= p->link;
p->link= gb_sorted[k];
gb_sorted[k]= p;
}

/*:11*/
#line 105 "./gb_sort.w"
;
}

/*:5*/
#line 14 "./gb_sort.w"


/*:1*/
