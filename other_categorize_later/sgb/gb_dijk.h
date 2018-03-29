/*3:*/
#line 67 "./gb_dijk.w"

extern long dijkstra();
#define print_dijkstra_result p_dijkstra_result 
extern void print_dijkstra_result();

/*:3*//*5:*/
#line 118 "./gb_dijk.w"

#define dist z.I
#define backlink y.V

/*:5*//*6:*/
#line 142 "./gb_dijk.w"

extern void(*init_queue)();

extern void(*enqueue)();
extern void(*requeue)();
extern Vertex*(*del_min)();

/*:6*//*7:*/
#line 155 "./gb_dijk.w"

#define hh_val x.I

/*:7*//*25:*/
#line 441 "./gb_dijk.w"

extern void init_dlist();
extern void enlist();
extern void reenlist();
extern Vertex*del_first();
extern void init_128();
extern Vertex*del_128();
extern void enq_128();
extern void req_128();

/*:25*/
