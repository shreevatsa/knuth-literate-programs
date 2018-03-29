/*2:*/
#line 33 "./gb_flip.w"

#include <stdio.h> 
#include "gb_flip.h"   

int main()
{long j;
gb_init_rand(-314159L);
if(gb_next_rand()!=119318998){
fprintf(stderr,"Failure on the first try!\n");return-1;
}
for(j= 1;j<=133;j++)
gb_next_rand();
if(gb_unif_rand(0x55555555L)!=748103812){
fprintf(stderr,"Failure on the second try!\n");return-2;
}
fprintf(stderr,"OK, the gb_flip routines seem to work!\n");
return 0;
}

/*:2*/
