/*4:*/
#line 63 "./gb_graph.w"

#include <stdio.h> 
#include <stdlib.h> 
#ifdef SYSV
#include <string.h> 
#else
#include <strings.h> 
#endif
#undef min
/*8:*/
#line 136 "./gb_graph.w"

typedef union{
struct vertex_struct*V;
struct arc_struct*A;
struct graph_struct*G;
char*S;
long I;
}util;

/*:8*//*9:*/
#line 162 "./gb_graph.w"

typedef struct vertex_struct{
struct arc_struct*arcs;
char*name;
util u,v,w,x,y,z;
}Vertex;

/*:9*//*10:*/
#line 181 "./gb_graph.w"

typedef struct arc_struct{
struct vertex_struct*tip;
struct arc_struct*next;
long len;
util a,b;
}Arc;

/*:10*//*12:*/
#line 234 "./gb_graph.w"

#define init_area(s)  *s= NULL
struct area_pointers{
char*first;
struct area_pointers*next;

};

typedef struct area_pointers*Area[1];

/*:12*//*20:*/
#line 377 "./gb_graph.w"

#define ID_FIELD_SIZE 161
typedef struct graph_struct{
Vertex*vertices;
long n;
long m;
char id[ID_FIELD_SIZE];
char util_types[15];
Area data;
Area aux_data;
util uu,vv,ww,xx,yy,zz;
}Graph;

/*:20*//*34:*/
#line 670 "./gb_graph.w"

typedef unsigned long siz_t;


/*:34*/
#line 72 "./gb_graph.w"


/*:4*//*6:*/
#line 88 "./gb_graph.w"

extern long verbose;
extern long panic_code;

/*:6*//*7:*/
#line 105 "./gb_graph.w"

#define alloc_fault (-1) 
#define no_room 1 
#define early_data_fault 10 
#define late_data_fault 11 
#define syntax_error 20 
#define bad_specs 30 
#define very_bad_specs 40 
#define missing_operand 50 
#define invalid_operand 60 
#define impossible 90 

/*:7*//*15:*/
#line 292 "./gb_graph.w"

extern long gb_trouble_code;

/*:15*//*17:*/
#line 312 "./gb_graph.w"

extern char*gb_alloc();
#define gb_typed_alloc(n,t,s) \
               (t*)gb_alloc((long)((n)*sizeof(t)),s)
extern void gb_free();

/*:17*//*22:*/
#line 429 "./gb_graph.w"

#define n_1  uu.I
#define mark_bipartite(g,n1) g->n_1= n1,g->util_types[8]= 'I'

/*:22*//*25:*/
#line 474 "./gb_graph.w"

extern long extra_n;

extern char null_string[];
extern void make_compound_id();

extern void make_double_compound_id();

/*:25*//*33:*/
#line 657 "./gb_graph.w"

extern siz_t edge_trick;

/*:33*//*41:*/
#line 802 "./gb_graph.w"

#define gb_new_graph gb_nugraph 
#define gb_new_arc gb_nuarc
#define gb_new_edge gb_nuedge
extern Graph*gb_new_graph();
extern void gb_new_arc();
extern Arc*gb_virgin_arc();
extern void gb_new_edge();
extern char*gb_save_string();
extern void switch_to_graph();
extern void gb_recycle();

/*:41*//*42:*/
#line 840 "./gb_graph.w"

extern void hash_in();
extern Vertex*hash_out();
extern void hash_setup();
extern Vertex*hash_lookup();

/*:42*/
