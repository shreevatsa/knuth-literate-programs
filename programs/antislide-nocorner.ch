change file for the "other cases"
@x
node * constraints[1674]; /* elements of constraints */
@y
node * constraints[1674]; /* elements of constraints */
node * special_constraints[2]; /* we'll use this at level 0 */
@z
@x
  register node *first_node=cur_node;
@y
  register node *first_node=cur_node;
  if ((i==0||i+1==n1)&&(j==0||j+2==n2)&&(k==0||k+2==n3)) continue;
@z
@x
  register node *first_node=cur_node;
@y
  register node *first_node=cur_node;
  if ((i==0||i+2==n1)&&(j==0||j+1==n2)&&(k==0||k+2==n3)) continue;
@z
@x
  register node *first_node=cur_node;
@y
  register node *first_node=cur_node;
  if ((i==0||i+2==n1)&&(j==0||j+2==n2)&&(k==0||k+1==n3)) continue;
@z
@x
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
@y
@ In this variation, we have omitted all moves that occupy the corners.
It's easy to see that it is then necessary to occupy at least one cell
next to a corner. So I make that the initial constraint.

@<Put the initial constraints onto the constraint stack@>=
special_constraints[0]=&headers[0][0][1];
*ctop++=&special_constraints[0];
@z
