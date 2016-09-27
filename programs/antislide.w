\datethis
@* Introduction. This program finds all ways to pack $2\times2\times1$ bricks
into a $4\times4\times4$ box in such a way that each face of each brick
touches the boundary of the box or the face of another brick. The program
is also designed to be readily modified so that it applies to other sorts
of pieces in other sorts of boxes.

I'm writing it primarily to gain further experience of the technique
of ``dancing links,'' which worked so nicely in the {\sc XCOVER}
routine. Also I'm having fun today; I just finished a long, boring
task and I'm rewarding myself by taking time off from other duties.

@d n1 4 /* one box dimension */
@d n2 4 /* another */
@d n3 4 /* the last */
@d verbose (argc>1)
@d very_verbose (argc>2)
@d very_very_verbose (argc>3)
@s node int

@c
#include <stdio.h>
@#
@<Type definitions@>@;
@<Global variables@>@;
tmp() {
  printf("tmp");
}
@#
main(argc,argv)
  int argc; char*argv[]; /* the usual command-line parameters */
{
  register node *p,*q,*r;
  register int stamp=0;
  @<Initialize the data structures@>;
  @<Backtrack thru all possibilities@>;
  @<Report the answers@>;
}

@* Data structures. This program deals chiefly with three kinds of lists,
representing cells, moves, and constraints.

A move list is a circular list of nodes, one for each cell occupied by
a particular placement of a piece. The nodes are doubly linked by
|left| and |right| pointers, which stay fixed throughout the algorithm.

A cell list is a circular list consisting of a header node and one additional
node for each move that occupies this cell. These nodes are doubly linked
by |up| and |down| pointers; thus each node in a move list is also a potential
member of a cell list. Nodes leave a cell list when they belong to a move
that conflicts with other moves already made. A header node is recognizable
by the fact that its |left| pointer is null.

A constraint is a sequence of pointers to cell headers, followed
by a null pointer. It represents a set of cells that should not all be
empty, based on moves made so far. A constraint list is a sequence of pointers
to constraints, followed by a null pointer.

Nodes have a |tag| field that is used in a special ``stamping'' trick
explained later. This field points to an integer; its basic property is
that two nodes have the same |tag| if and only if they are part
of the same move.

@<Type...@>=
typedef struct node_struct {
  struct node_struct *left,*right; /* adjacent nodes of a move */
  struct node_struct *up,*down; /* adjacent nodes of a cell */
  char *name; /* identification of this node for diagnostic printouts */
  struct node_struct ***clist; /* list of constraint lists for this move */
  int *tag; /* unique identification of a move */
} node;

@ The sizes of the basic arrays were determined experimentally; originally
I just set them to a large number and ran the program.

@<Glob...@>=
node headers[n1][n2][n3]; /* cell header nodes */
node nodes[432]; /* nodes in the move lists */
node * constraints[1674]; /* elements of constraints */
node ** clists[558]; /* elements of constraint lists */
char names[n1*n2*n3*4]; /* cell names */
int tags[108]; /* the |tag| fields point into this array */

@ Here's how we get everything started, when packing bricks as mentioned above.

@<Initialize the data structures@>=
{
  register node *cur_node=&nodes[0],
               **cur_con=&constraints[0],
              ***cur_clist=&clists[0];
  register char *cur_name=&names[0];
  register int *cur_tag=&tags[0];
  register int i,j,k;
  @<Make all cell lists empty@>;
  @<Initialize all moves that have constant first coordinate@>;
  @<Initialize all moves that have constant second coordinate@>;
  @<Initialize all moves that have constant third coordinate@>;
  printf("This problem involves %d namechars, %d moves, %d nodes,\n",
    (cur_name-&names[0])/4, cur_tag-&tags[0], cur_node-&nodes[0]);
  printf(" %d constraint elements, %d clist elements.\n",
    cur_con-&constraints[0], cur_clist-&clists[0]);
}

@ @<Make all cell lists empty@>=
for (i=0;i<n1;i++) for (j=0;j<n2;j++) for (k=0;k<n3;k++) {
  *cur_name=i+'0'; *(cur_name+1)=j+'0'; *(cur_name+2)=k+'0';
  headers[i][j][k].name=cur_name;
  cur_name+=4;
  headers[i][j][k].up=headers[i][j][k].down=&headers[i][j][k];
}

@ @d new_node(ii,jj,kk) {
  cur_node->right=cur_node+1;@+cur_node->left=cur_node-1;
  p=&headers[ii][jj][kk];@+q=p->down;
  cur_node->name=p->name;
  cur_node->up=p;@+cur_node->down=q;@+p->down=cur_node;@+q->up=cur_node;
  cur_node->tag=cur_tag;
  cur_node->clist=cur_clist;
  cur_node++;
}

@d start_con *cur_clist=cur_con /* begin making a constraint list */
@d new_con(ii,jj,kk)  *cur_con++=&headers[ii][jj][kk] /* add a cell to it */
@d wrap_con cur_con++,cur_clist++ /* finish making a constraint list */

@<Initialize all moves that have constant first coordinate@>=
for (i=0;i<n1;i++) for (j=0;j+1<n2;j++) for (k=0;k+1<n3;k++) {
  register node *first_node=cur_node;
  new_node(i,j,k);
  new_node(i,j,k+1);
  new_node(i,j+1,k);
  new_node(i,j+1,k+1);
  first_node->left=cur_node-1;
  (cur_node-1)->right=first_node;
  if (i>0) { start_con;
    new_con(i-1,j,k); new_con(i-1,j,k+1);
    new_con(i-1,j+1,k); new_con(i-1,j+1,k+1); wrap_con; }
  if (i+1<n1) { start_con;
    new_con(i+1,j,k); new_con(i+1,j,k+1);
    new_con(i+1,j+1,k); new_con(i+1,j+1,k+1); wrap_con; }
  if (j>0) { start_con; new_con(i,j-1,k); new_con(i,j-1,k+1); wrap_con; }
  if (j+2<n2) { start_con; new_con(i,j+2,k); new_con(i,j+2,k+1); wrap_con; }
  if (k>0) { start_con; new_con(i,j,k-1); new_con(i,j+1,k-1); wrap_con; }
  if (k+2<n3) { start_con; new_con(i,j,k+2); new_con(i,j+1,k+2); wrap_con; }
  cur_clist++; cur_tag++;
  if (very_very_verbose) @<Print the move that starts with |first_node|@>;
}

@ @<Initialize all moves that have constant second coordinate@>=
for (i=0;i+1<n1;i++) for (j=0;j<n2;j++) for (k=0;k+1<n3;k++) {
  register node *first_node=cur_node;
  new_node(i,j,k);
  new_node(i,j,k+1);
  new_node(i+1,j,k);
  new_node(i+1,j,k+1);
  first_node->left=cur_node-1;
  (cur_node-1)->right=first_node;
  if (j>0) { start_con;
    new_con(i,j-1,k); new_con(i,j-1,k+1);
    new_con(i+1,j-1,k); new_con(i+1,j-1,k+1); wrap_con; }
  if (j+1<n2) { start_con;
    new_con(i,j+1,k); new_con(i,j+1,k+1);
    new_con(i+1,j+1,k); new_con(i+1,j+1,k+1); wrap_con; }
  if (i>0) { start_con; new_con(i-1,j,k); new_con(i-1,j,k+1); wrap_con; }
  if (i+2<n1) { start_con; new_con(i+2,j,k); new_con(i+2,j,k+1); wrap_con; }
  if (k>0) { start_con; new_con(i,j,k-1); new_con(i+1,j,k-1); wrap_con; }
  if (k+2<n3) { start_con; new_con(i,j,k+2); new_con(i+1,j,k+2); wrap_con; }
  cur_clist++; cur_tag++;
  if (very_very_verbose) @<Print the move that starts with |first_node|@>;
}

@ @<Initialize all moves that have constant third coordinate@>=
for (i=0;i+1<n1;i++) for (j=0;j+1<n2;j++) for (k=0;k<n3;k++) {
  register node *first_node=cur_node;
  new_node(i,j,k);
  new_node(i+1,j,k);
  new_node(i,j+1,k);
  new_node(i+1,j+1,k);
  first_node->left=cur_node-1;
  (cur_node-1)->right=first_node;
  if (k>0) { start_con;
    new_con(i,j,k-1); new_con(i+1,j,k-1);
    new_con(i,j+1,k-1); new_con(i+1,j+1,k-1); wrap_con; }
  if (k+1<n3) { start_con;
    new_con(i,j,k+1); new_con(i+1,j,k+1);
    new_con(i,j+1,k+1); new_con(i+1,j+1,k+1); wrap_con; }
  if (j>0) { start_con; new_con(i,j-1,k); new_con(i+1,j-1,k); wrap_con; }
  if (j+2<n2) { start_con; new_con(i,j+2,k); new_con(i+1,j+2,k); wrap_con; }
  if (i>0) { start_con; new_con(i-1,j,k); new_con(i-1,j+1,k); wrap_con; }
  if (i+2<n1) { start_con; new_con(i+2,j,k); new_con(i+2,j+1,k); wrap_con; }
  cur_clist++; cur_tag++;
  if (very_very_verbose) @<Print the move that starts with |first_node|@>;
}

@ @<Print the move that starts with |first_node|@>=
{ node **p1, ***c1;
  for (p=first_node;;p=p->right) {
    printf("%s ",p->name);
    if (p->right==first_node) break;
  }
  printf("=>");
  for (c1=p->clist;*c1;c1++) {
    for (p1=*c1;*p1;p1++) printf("%s,",(*p1)->name);
    printf(" ");
  }
  printf("\n");
}

@* Backtracking. At level |l|, we've made |l| moves, and we assume that
we've got to satisfy constraints |c| for |constr[l]<=c<ctop|. We decide which
of those constraints is strongest, in the sense that it a minimal number
of moves will satisfy it; we record those moves in an array of pointers
|m| to move nodes, for |first[l]<=m<mtop|, and we try each of them in turn.

@d move_stack_size 1000
@d constr_stack_size 1000
@d max_level (((n1*n2*n3)>>2)-2)

@<Glob...@>=
node *move_stack[move_stack_size];
node **constr_stack[constr_stack_size];
node **first[max_level]; /* beginning move on a given level */
node **move[max_level]; /* current move being explored */
node ***constr[max_level]; /* first constraint on a given level */
int totsols[max_level]; /* the number of solutions we found */

@ I'm using |goto| statements, as usual when I backtrack.

@<Backtrack thru all possibilities@>=
{
  register node **mtop=&move_stack[0];
  register node ***ctop=&constr_stack[0];
  register node **pp, ***cc;
  register int l=0;
  constr[0]=ctop;
  @<Put the initial constraints onto the constraint stack@>;
newlevel: first[l]=mtop;
  if (constr[l]==ctop) {
    @<Record a solution@>;
    if (l==max_level-1) goto backtrack;
    @<Put all remaining moves on the move stack@>;
  }
  else if (l==max_level-1) goto backtrack;
  else @<Find a constraint to branch on, and put its moves on the move stack@>;
  pp=first[l];
  goto advance;
backtrack: @<Reinstate all moves from this level@>;
  mtop=first[l];
  if (l==0) goto done;
  l--; pp=move[l];
  @<Unmake move |*pp|@>;
  @<Disallow move |*pp|@>;
  pp++;
advance: if (pp==mtop) goto backtrack;
  move[l]=pp;
  @<Make move |*pp|@>;
  if (very_verbose) @<Print a progress report@>;
  l++;
  goto newlevel;
done:;
}

@ @<Find a constraint to branch on...@>=
{
  register int count;
  node **cbest; int best_count=100000;
  for (cc=constr[l];cc<ctop;cc++) {
    @<If constraint |*cc| has smaller count than |best_count|,
        set |cbest=*cc|@>;
  }
  @<Put the moves for |cbest| on the move stack@>;
}

@ Here's where the tag fields become important. Pay attention now.

A constraint is a list of cells, at least one of which must be occupied
by a future move. We find all ways to satisfy the constraint by going through
all moves on those cell lists. But we don't want to count a move twice
when it covers more than one cell on the list. So we put a time stamp in the
|tag| field of each move, telling us whether we've already seen that move
while processing the current constraint.

@<If constraint |*cc| has smaller count than |best_count|...@>=
count=0;
stamp++;
for (pp=*cc;*pp;pp++)
  for (p=(*pp)->down;p->left;p=p->down)
    if (*(p->tag)!=stamp) count++,*(p->tag)=stamp;
if (very_verbose) {
  printf("Constraint ");
  for (pp=*cc;*pp;pp++) printf("%s,",(*pp)->name);
  printf(" %d\n",count);
}
if (count<best_count) best_count=count,cbest=*cc;

@ @d panic(s) { printf("s stack overflow!\n"); exit(-1); }

@<Put the moves for |cbest| on the move stack@>=
stamp++;
for (pp=cbest;*pp;pp++)
  for (p=(*pp)->down;p->left;p=p->down)
    if (*(p->tag)!=stamp) *mtop++=p,*(p->tag)=stamp;
if (mtop>=&move_stack[move_stack_size]) panic(move);

@ Here I'm sorta cheating. Strictly speaking, this problem has no
constraints, so the empty solution is one valid answer; then we have
to try every possible move. But to take advantage of symmetry, I'm
forcing the first move to be in the corner. This will miss solutions
that don't occupy any corner, put I'm taking care of them with
the change file \.{antislide-nocorner.ch}.

@<Put the initial constraints onto the constraint stack@>=
pp=first[0]=mtop;
*mtop++=&nodes[0];
goto advance; /* yes, I'm jumping right into the thick of things */

@ This step changes |pp|, inside of section |@<If constraint |pp...@>|.
(I could have used another variable, but I'm from an older generation
that tries to conserve the number of registers used. Silly of me.)

@<Make move |*pp|@>=
if (stamp==1620) tmp();
for (p=*pp;;p=p->right) {
  @<Remove all other moves in the cell list containing |p| from their
     other cell lists@>;
  if (p->right==*pp) break;
}
constr[l+1]=ctop;
for (cc=constr[l];cc<constr[l+1];cc++)
  @<If constraint |pp=*cc| is not satisfied, put it on the constraint stack@>;
for (cc=p->clist;*cc;cc++)
  @<If constraint |pp=*cc| is not satisfied, put it on the constraint stack@>;
if (ctop>=&constr_stack[constr_stack_size]) panic(constraint);

@ When a cell is occupied by the move at level |l|, we put |l+1| into
the |right| field of its header node. That way we can tell if the
cell is occupied.

The ``dancing links'' trick is used here: When node |r| is removed from
its list, we don't change |r->up| and |r->down|, and we don't lose the
links that led us to |r|. That means it will be easy to restore the
list when backtracking.

@<Remove all other moves in the cell list containing |p| from their
     other cell lists@>=
for (q=p->down;q!=p;q=q->down) {
  if (q->left==NULL) q->right=(node*)(l+1);
  else for (r=q->left;r!=q;r=r->left) {
      r->up->down=r->down;
      r->down->up=r->up;
    }
}

@ @<If constraint |pp=*cc| is not satisfied, put it on the constraint stack@>=
{
  for (pp=*cc;*pp;pp++) if ((*pp)->right) break;
  if (!*pp) *ctop++=*cc;
}

@ The links do their dance in this step. We have to reconstruct the lists
in exact reverse order of the way we constructed them. (That's why I provided
both |left| and |right| links in the move lists. Otherwise the program
would try to insert a node into its list twice.)

The significant aspect to note about dancing links in this algorithm is the
order in which moves are disallowed and reinstated, as well as the order
in which they are make and unmade.

@<Unmake move |*pp|@>=
for (p=(*pp)->left;;p=p->left) {
  @<Unremove all other moves in the cell list containing |p| from their
         other cell lists@>;
  if (p==*pp) break;
}
ctop=constr[l+1];

@ @<Unremove all other moves in the cell list containing |p| from their
         other cell lists@>=
for (q=p->up;q!=p;q=q->up) {
  if (q->left==NULL) q->right=NULL;
  else for (r=q->right;r!=q;r=r->right) {
      r->up->down=r;
      r->down->up=r;
    }
}

@ @<Disallow move |*pp|@>=
for (p=(*pp)->right;;p=p->right) {
  q=p->down; r=p->up;
  q->up=r; r->down=q;
  if (p==*pp) break;
}

@ @<Reinstate...@>=
for (pp=mtop-1;pp>=first[l];pp--)
  for (p=(*pp)->right;;p=p->right) {
    q=p->down; r=p->up;
    q->up=r->down=p;
    if (p==*pp) break;
  }

@ @<Put all remaining moves on the move stack@>=
{
  stamp++;
  for (p=&headers[0][0][0];p<&headers[n1][0][0];p++) if (!p->right)
    for (q=p->down;q!=p;q=q->down)
      if (*(q->tag)!=stamp) *mtop++=q,*(q->tag)=stamp;
}

@ @<Print a progress report@>=
{
  printf("Move %d:",l+1);
  for (p=(*move[l])->right;;p=p->right) {
    printf(" %s",p->name);
    if (p==*move[l]) break;
  }
  printf(" (%d)\n",stamp);
}

@ @<Record a solution@>=
totsols[l]++;
if (verbose) {
  int ii,jj,kk;
  printf("%d.%d:",l,totsols[l]);
  for (ii=0;ii<n1;ii++) {
    printf(" ");
    for (jj=0;jj<n2;jj++) for (kk=0;kk<n3;kk++) {
      register int c=(int)headers[ii][jj][kk].right;
      printf("%c",c>9? c-10+'a': c+'0');
    }
  }
  printf("\n");
}

@ @<Report the answers@>=
printf("Total solutions found:\n");
{ register int lev;
  for (lev=0;lev<max_level;lev++) if (totsols[lev])
    printf("  level %d, %d\n",lev,totsols[lev]);
}

@*Index.
