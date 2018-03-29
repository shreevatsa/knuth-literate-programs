/*1:*/
#line 15 "./gb_basic.w"

extern Graph*board();
extern Graph*simplex();
extern Graph*subsets();
extern Graph*perms();
extern Graph*parts();
extern Graph*binary();

extern Graph*complement();
extern Graph*gunion();
extern Graph*intersection();
extern Graph*lines();
extern Graph*product();
extern Graph*induced();

/*:1*//*7:*/
#line 168 "./gb_basic.w"

#define complete(n) board((long)(n),0L,0L,0L,-1L,0L,0L)
#define transitive(n) board((long)(n),0L,0L,0L,-1L,0L,1L)
#define empty(n) board((long)(n),0L,0L,0L,2L,0L,0L)
#define circuit(n) board((long)(n),0L,0L,0L,1L,1L,0L)
#define cycle(n) board((long)(n),0L,0L,0L,1L,1L,1L)

/*:7*//*36:*/
#line 728 "./gb_basic.w"

#define disjoint_subsets(n,k) subsets((long)(k),1L,(long)(1-(n)),0L,0L,0L,1L,0L)
#define petersen() disjoint_subsets(5,2)

/*:36*//*41:*/
#line 858 "./gb_basic.w"

#define all_perms(n,directed) perms((long)(1-(n)),0L,0L,0L,0L,0L,\
   (long)(directed))

/*:41*//*54:*/
#line 1092 "./gb_basic.w"

#define all_parts(n,directed) parts((long)(n),0L,0L,(long)(directed))

/*:54*//*63:*/
#line 1284 "./gb_basic.w"

#define all_trees(n,directed) binary((long)(n),0L,(long)(directed))

/*:63*//*94:*/
#line 2005 "./gb_basic.w"

#define cartesian 0
#define direct 1
#define strong 2

/*:94*//*100:*/
#line 2163 "./gb_basic.w"

#define ind z.I 

/*:100*//*102:*/
#line 2213 "./gb_basic.w"

#define IND_GRAPH 1000000000
#define subst y.G

/*:102*//*104:*/
#line 2244 "./gb_basic.w"

extern Graph*bi_complete();
extern Graph*wheel();

/*:104*/
