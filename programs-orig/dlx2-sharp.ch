@x in search for best_itm, give pref to items whose name begins with #
t=max_nodes,tmems=mems;
if ((vbose&show_details) &&
    level<show_choices_max && level>=maxl-show_choices_gap)
  fprintf(stderr,"Level "O"d:",level);
for (o,k=cl[root].next;t&&k!=root;o,k=cl[k].next) {
  if ((vbose&show_details) &&
      level<show_choices_max && level>=maxl-show_choices_gap)
    fprintf(stderr," "O".8s("O"d)",cl[k].name,nd[k].len);
  if (o,nd[k].len<=t) {
    if (nd[k].len<t) best_itm=k,t=nd[k].len,p=1;
@y
t=0x7fffffff,tmems=mems;
if ((vbose&show_details) &&
    level<show_choices_max && level>=maxl-show_choices_gap)
  fprintf(stderr,"Level "O"d:",level);
for (o,k=cl[root].next;t&&k!=root;o,k=cl[k].next) {
  register int lam;
  if ((vbose&show_details) &&
      level<show_choices_max && level>=maxl-show_choices_gap)
    fprintf(stderr," "O".8s("O"d)",cl[k].name,nd[k].len);
  o,lam=nd[k].len;
  if (lam<=t && lam>1 && (o,cl[k].name[0]!='#')) lam+=last_node;
  if (lam<=t) {
    if (lam<t) best_itm=k,t=lam,p=1;
@z
@x
  fprintf(stderr," branching on "O".8s("O"d)\n",cl[best_itm].name,t);
@y
  fprintf(stderr,
    " branching on "O".8s("O"d)\n",cl[best_itm].name,nd[best_itm].len);
@z
