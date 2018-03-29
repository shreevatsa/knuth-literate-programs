/*6:*/
#line 103 "./gb_flip.w"

#define gb_next_rand() (*gb_fptr>=0?*gb_fptr--:gb_flip_cycle())
extern long*gb_fptr;
extern long gb_flip_cycle();

/*:6*//*11:*/
#line 230 "./gb_flip.w"

extern void gb_init_rand();

/*:11*//*13:*/
#line 262 "./gb_flip.w"

extern long gb_unif_rand();

/*:13*/
