@x
@ After this program finds all solutions, it normally prints their total
@y
@ This version of the program includes a very special feature:
Whenever we backtrack from a choice at level~0, 
we also cover the secondary column at
the very end of its row! (Perhaps someday I will think of a suitable
generalization for which this action sounds sensible.) Here's why:
Several applications of {\mc DLX2} have equivalence relations between
their solutions. For example, if I'm generating word squares, the
transpose of every solution is a solution. Suppose I put
secondary column \.{foo} at the end of the options for placing \.{foo}
in row~1 and column~1. Then the word chosen for column~1 will always
come later than the word chosen for row~1.

After this program finds all the desired solutions,
it normally prints their total
@z
@x here's where the kludge happens
recover: @<Uncover all other columns of |cur_node|@>;
@y
recover: @<Uncover all other columns of |cur_node|@>;
if (level==0) {
  for (p=cur_node-1;o,nd[p].col>0;p--) ;
  oo,p=nd[p].down,cc=nd[p].col; /* fetch the last item of the row */
  if (cc>=second && !nd[p].color)
    cover(cc); /* cover it, if secondary and uncolored */
}
@z
