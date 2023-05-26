@x
for (o,k=cl[root].next;t&&k!=root;o,k=cl[k].next) {
  if ((vbose&show_details) &&
      level<show_choices_max && level>=maxl-show_choices_gap)
    fprintf(stderr," "O".8s("O"d)",cl[k].name,nd[k].len);
  if (o,nd[k].len<=t) {
    if (nd[k].len<t) best_itm=k,t=nd[k].len,p=1;
    else {
      p++; /* this many items achieve the min */
      if (randomizing && (mems+=4,!gb_unif_rand(p))) best_itm=k;
    }
  }
}
@y
if ((vbose&show_details) &&
    level<show_choices_max && level>=maxl-show_choices_gap) {
  for (k=cl[root].next;k!=root;k=cl[k].next)
    fprintf(stderr," "O".8s("O"d)",cl[k].name,nd[k].len);
}
for (o,k=cl[root].next;k!=root;o,k=cl[k].next) if (o,nd[k].len==0) {
  t=0,best_itm=k;
  break;
}
if (k==root) oo,best_itm=cl[root].next,t=nd[best_itm].len;
@z
