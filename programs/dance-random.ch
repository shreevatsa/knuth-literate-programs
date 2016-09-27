@x
The program prints the number of solutions and the total number of link
updates. It also prints every $n$th solution, if the integer command
line argument $n$ is given. A second command-line argument causes the
full search tree to be printed, and a third argument makes the output
even more verbose.
@y
Instead of finding all solutions, this variant of the program estimates
the size of the search tree and the number of updates on each level.
The first command-line argument tells the number of random trials to
be made, and the second is a seed value for the random number generator.
@z
@x
#include <string.h>
@y
#include <string.h>
#include "gb_flip.h"
@z
@x
  if (verbose) sscanf(argv[1],"%d",&spacing);
  @<Initialize the data structures@>;
  @<Backtrack through all solutions@>;
  printf("Altogether %d solutions, after %u updates.\n",count,updates);
  if (verbose) @<Print a profile of the search tree@>;
@y
  if (verbose) {
    sscanf(argv[1],"%d",&reps);
    if (verbose>1) sscanf(argv[2],"%d",&seed);
  }@+else verbose=1;
  gb_init_rand(seed);
  @<Initialize the data structures@>;
  for (cur_col=root.next;cur_col!=&root;cur_col=cur_col->next)
    correct_len[cur_col-col_array]=cur_col->len;
  for (r=1;r<=reps;r++)
    @<Do the Monte Carlo backtrack estimation@>;
  @<Print the estimated search tree profile@>;  
@z
@x
int verbose; /* $>0$ to show solutions, $>1$ to show partial ones too */
@y
int verbose; /* $>2$ to show more gory details */
int reps=1;
int seed;
int r;
double profile_est[max_level];
double upd_prof_est[max_level];
int correct_len[max_cols+2];
@z
@x
@<Backtrack through all solutions@>=
level=0;
forward: @<Set |best_col| to the best column for branching@>;
cover(best_col);
cur_node=choice[level]=best_col->head.down;
advance:if (cur_node==&(best_col->head)) goto backup;
if (verbose>1) {
  printf("L%d:",level);
  print_row(cur_node);
}
@<Cover all other columns of |cur_node|@>;
if (root.next==&root) @<Record solution and |goto recover|@>;
level++;
goto forward;
backup: uncover(best_col);
if (level==0) goto done;
level--;
cur_node=choice[level];@+best_col=cur_node->col;
recover: @<Uncover all other columns of |cur_node|@>;
cur_node=choice[level]=cur_node->down;@+goto advance;
done:if (verbose>3)
  @<Print column lengths, to make sure everything has been restored@>;
@y
@<Do the Monte...@>=
{
  register double factor=1.0;
  level=0;
forward: profile_est[level]+=(factor-profile_est[level])/(double)r;
  @<Set |best_col| to the best column for branching@>;
  updates=0;
  cover(best_col);
  if (minlen) {
    int common_updates=updates;
    updates=0;
    cur_node=best_col->head.down;
    for (j=gb_unif_rand(minlen);j;j--) cur_node=cur_node->down;
    choice[level]=cur_node;
    if (verbose>2) {
      printf("L%d:",level);
      print_row(cur_node);
    }
    @<Cover all other columns of |cur_node|@>;
    updates=common_updates+minlen*updates;
  }
  upd_prof_est[level]+=(factor*updates-upd_prof_est[level])/(double)r;
  factor*=minlen;
  level++;
  if (factor && root.next!=&root) goto forward;
  @<Restore all the data to original condition@>;
}
@z
@x
  profile[level][minlen]++;
@y
@z
@x
@*Index.
@y
@ @<Restore all the data to original condition@>=
for (j=level;profile_est[j];j++)
  profile_est[j]-=profile_est[j]/(double)r,
  upd_prof_est[j]-=upd_prof_est[j]/(double)r;
if (factor==0.0) {
  uncover(best_col);
  level--;
}
while (level>0) {
  level--;
  cur_node=choice[level];@+best_col=cur_node->col;
  @<Uncover all other columns...@>;
  uncover(best_col);
}
for (cur_col=root.next;cur_col!=&root;cur_col=cur_col->next)
  if (cur_col->len!=correct_len[cur_col-col_array])
    fprintf(stderr,"Consistency failure on round %d!\n",r);

@ @<Print the estimated search tree profile@>=
{
  register double tot_nodes=0.0,tot_updates=0.0;
  for (level=0;level<=maxl;level++) {
    printf("Level %d: %20.1f nodes, %20.1f updates\n",
           level,profile_est[level],upd_prof_est[level]);
    tot_nodes+=profile_est[level];
    tot_updates+=upd_prof_est[level];
  }
  printf("Total %20.1f nodes, %20.1f updates.\n",tot_nodes,tot_updates);
}
  
@*Index.
@z
