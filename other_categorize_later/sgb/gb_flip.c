#define gb_next_rand() (*gb_fptr>=0?*gb_fptr--:gb_flip_cycle() )  \

#define mod_diff(x,y) (((x) -(y) ) &0x7fffffff)  \

#define two_to_the_31 ((unsigned long) 0x80000000)  \

/*3:*/
#line 56 "./gb_flip.w"

/*4:*/
#line 74 "./gb_flip.w"

static long A[56]= {-1};

/*:4*/
#line 57 "./gb_flip.w"

/*5:*/
#line 86 "./gb_flip.w"

long*gb_fptr= A;

/*:5*/
#line 58 "./gb_flip.w"

/*7:*/
#line 133 "./gb_flip.w"

long gb_flip_cycle()
{register long*ii,*jj;
for(ii= &A[1],jj= &A[32];jj<=&A[55];ii++,jj++)
*ii= mod_diff(*ii,*jj);
for(jj= &A[1];ii<=&A[55];ii++,jj++)
*ii= mod_diff(*ii,*jj);
gb_fptr= &A[54];
return A[55];
}

/*:7*//*8:*/
#line 158 "./gb_flip.w"

void gb_init_rand(seed)
long seed;
{register long i;
register long prev= seed,next= 1;
seed= prev= mod_diff(prev,0);
A[55]= prev;
for(i= 21;i;i= (i+21)%55){
A[i]= next;
/*9:*/
#line 186 "./gb_flip.w"

next= mod_diff(prev,next);
if(seed&1)seed= 0x40000000+(seed>>1);
else seed>>= 1;
next= mod_diff(next,seed);

/*:9*/
#line 167 "./gb_flip.w"
;
prev= A[i];
}
/*10:*/
#line 223 "./gb_flip.w"

(void)gb_flip_cycle();
(void)gb_flip_cycle();
(void)gb_flip_cycle();
(void)gb_flip_cycle();
(void)gb_flip_cycle();

/*:10*/
#line 170 "./gb_flip.w"
;
}

/*:8*//*12:*/
#line 251 "./gb_flip.w"

long gb_unif_rand(m)
long m;
{register unsigned long t= two_to_the_31-(two_to_the_31%m);
register long r;
do{
r= gb_next_rand();
}while(t<=(unsigned long)r);
return r%m;
}

/*:12*/
#line 59 "./gb_flip.w"


/*:3*/
