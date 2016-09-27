% This change file keeps removing rows at the bottom, thereby finding
% all solutions having minimax row number.

@x
node node_array[max_nodes]; /* place for nodes */
@y
node node_array[max_nodes]; /* place for nodes */
node *cutoff=&node_array[max_nodes]; /* upper bound on active rows */
@z
@x uncovering: uses fact that columns stay in order (up is really upward)
  for (rr=c->head.up;rr!=&(c->head);rr=rr->up)
    for (nn=rr->left;nn!=rr;nn=nn->left) {
      uu=nn->up;@+dd=nn->down;
@y
  for (rr=c->head.up;rr>=cutoff;rr=rr->up) {
    if (rr==&(c->head)) break;
    c->len--;
  }
  c->head.up=rr, rr->down=&(c->head);
  for (;rr!=&(c->head);rr=rr->up)
    for (nn=rr->left;nn!=rr;nn=nn->left) {
      uu=nn->up;@+dd=nn->down;
      if (dd>=cutoff) nn->down=dd=&(nn->col->head);
@z
@x
  count++;
@y
  count++;
  @<Recompute the row-cutoff threshold@>;
  @<Prune the columns currently in use@>;
@z
@x unpurifying: like uncovering, but needn't maintain nonprimary column length
  for (rr=c->head.up;rr!=&(c->head);rr=rr->up)
    if (rr->color<0) rr->color=x;
    else if (rr!=p) {
      for (nn=rr->left;nn!=rr;nn=nn->left) {
        uu=nn->up;@+dd=nn->down;
@y
  for (rr=c->head.up;rr>=cutoff;rr=rr->up) if (rr==&(c->head)) break;
  c->head.up=rr, rr->down=&(c->head);
  for (;rr!=&(c->head);rr=rr->up)
    if (rr->color<0) rr->color=x;
    else if (rr!=p) {
      for (nn=rr->left;nn!=rr;nn=nn->left) {
        uu=nn->up;@+dd=nn->down;
        if (dd>=cutoff) nn->down=dd=&(nn->col->head);
@z
@x
@*Index.
@y
@*Added material. Here we use the fact that the nodes have been
allocated sequentially.

@<Recompute the row-cutoff threshold@>=
for (k=0,cutoff=NULL;k<=level;k++) if (choice[k]>=cutoff) {
  for (pp=choice[k];pp->right>pp;pp=pp->right);
  cutoff=pp+1;
}

@ @<Prune the columns currently in use@>=
for (k=0; k<=level; k++) {
  cur_col=choice[k]->col;
  for (pp=cur_col->head.up,j=0; pp>=cutoff; pp=pp->up) j++;
  if (j) {
    pp->down=&(cur_col->head);
    cur_col->head.up=pp;
    cur_col->len-=j;
  }
}

@*Index.
@z
