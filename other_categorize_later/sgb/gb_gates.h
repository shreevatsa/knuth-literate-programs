/*1:*/
#line 25 "./gb_gates.w"

#define print_gates p_gates 
extern Graph*risc();
extern Graph*prod();
extern void print_gates();
extern long gate_eval();
extern Graph*partial_gates();
extern long run_risc();
extern unsigned long risc_state[];

/*:1*//*2:*/
#line 99 "./gb_gates.w"

#define val  x.I 
#define typ  y.I
#define alt  z.V
#define outs  zz.A
#define is_boolean(v)  ((unsigned long)(v)<=1)
#define the_boolean(v)  ((long)(v))
#define tip_value(v)  (is_boolean(v)? the_boolean(v): (v)->val)
#define AND  '&'
#define OR  '|'
#define NOT  '~'
#define XOR  '^'

/*:2*//*50:*/
#line 1127 "./gb_gates.w"

#define bit  z.I

/*:50*/
