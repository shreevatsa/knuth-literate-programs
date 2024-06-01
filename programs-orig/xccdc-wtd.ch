@x
@ After this program finds all solutions, it normally prints their total
@y
This version of {\mc XCCDC} uses a dynamic weighting scheme, inspired by
the paper of Boussemart, Hemery, Lecoutre, and Sais in {\sl Proc.\ 16th
European Conference on Artificial Intelligence} (2004), 146--150: We increase
the weight of a primary item when its current set of options becomes null.
Items are chosen for branching based on the size of their set divided by their
current weight, unless the choice is forced.
@^Boussemart, Fr\'ed\'eric@>
@^H\'emery, Fred@>
@^Lecoutre, Christophe@>
@^Sa{\"\i}s, Lakhdar@>

@ After this program finds all solutions, it normally prints their total
@z
@x
@d show_max_deg 2048 /* |vbose| code for reporting maximum branching degree */
@y
@d show_max_deg 2048 /* |vbose| code for reporting maximum branching degree */
@d show_final_weights 4096 /* |vbose| code to display weights at the end */
@d show_weight_bumps 8192 /* |vbose| code to show new weights */
@z
@x
if (vbose&show_profile) @<Print the profile@>;
@y
if (vbose&show_profile) @<Print the profile@>;
if (vbose&show_final_weights) {
  fprintf(stderr,"Final weights:\n");
  print_weights();
}
@z
@x
(The |match| field is present only in secondary items.)
@y
(The |match| field is present only in secondary items.)

Finally, the |set| array contains a |wt| field for each primary item;
|wt(x)| occupies the position of |match(x)| in a secondary item.
This weight, initially~1, is increased by 1 whenever we run into a
situation where |x| cannot be supported.
@z
@x
@d match(x) set[(x)-6] /* a required color in compatibility tests */
@d primextra 5 /* this many extra entries of |set| for each primary item */
@y
@d match(x) set[(x)-6] /* a required color in compatibility tests */
@d wt(x) set[(x)-6] /* the current weight of item |x| */
@d primextra 6 /* this many extra entries of |set| for each primary item */
@z
@x
  if (c<second) fprintf(stderr," ("O"d of "O"d), length "O"d:\n",
         pos(c)+1,active,size(c));
@y
  if (c<second) fprintf(stderr," ("O"d of "O"d), weight "O"d, length "O"d:\n",
         pos(c)+1,active,wt(c),size(c));
@z
@x
  o,mark(j)=0;
@y
  o,mark(j)=0;
  if (k<=osecond) o,wt(j)=1;@+else o,match(j)=0;
@z
@x
      fprintf(stderr," can't cover");
      print_item_name(ii,stderr);
      fprintf(stderr,"\n");
    }
    @<Clear the queue and |return 0|@>;
@y
      if (!(vbose&show_weight_bumps)) {
        fprintf(stderr," can't cover");
        print_item_name(ii,stderr);
        fprintf(stderr,"\n");
      }
    }
    tough_itm=ii;
    @<Clear the queue and |return 0|@>;
@z
@x
  if (!include_option(cur_choice)) {
    nmems+=mems-tmems;
    goto tryagain;
  }
  if (!empty_the_queue()) {
    nmems+=mems-tmems;
    goto tryagain;
  }
@y
  if (!include_option(cur_choice)) {
    nmems+=mems-tmems;
    @<Increase the weight of |tough_itm|@>;
    goto tryagain;
  }
  if (!empty_the_queue()) {
    nmems+=mems-tmems;
    @<Increase the weight of |tough_itm|@>;
    goto tryagain;
  }
@z
@x
  if (!(o,purge_the_option(choice[level],active,"removing"))) {
    pmems+=mems-tmems;
    goto backup;
  }
  if (!empty_the_queue()) {
    pmems+=mems-tmems;
    goto backup;
  }
@y
  if (!(o,purge_the_option(choice[level],active,"removing"))) {
    pmems+=mems-tmems;
    @<Increase the weight of |tough_itm|@>;
    goto backup;
  }
  if (!empty_the_queue()) {
    pmems+=mems-tmems;
    @<Increase the weight of |tough_itm|@>;
    goto backup;
  }
@z
@x
int saveptr; /* current size of |savestack| */
@y
int saveptr; /* current size of |savestack| */
int tough_itm; /* an item that led to difficulty */
@z
@x
@ The ``best item'' is considered to be an item that minimizes the
number of remaining choices. If there are several candidates, we
choose the first one that we encounter.

Each primary item should have at least one valid choice, because
of domain consistency.

@d infty 0x7fffffff

@<Set |best_itm| to the best item for branching...@>=
t=infty;
if ((vbose&show_details) &&
    level<show_choices_max && level>=maxl-show_choices_gap)
  fprintf(stderr,"Stage "O"d,",stage);
for (k=0;t>1 && k<active;k++) if (o,item[k]<second) {
  o,s=size(item[k]);
  if ((vbose&show_details) &&
      level<show_choices_max && level>=maxl-show_choices_gap) {
    print_item_name(item[k],stderr);
    fprintf(stderr,"("O"d)",s);
  }
  if (s<=t) {
    if (s==0) fprintf(stderr,"I'm confused.\n"); /* |hide| missed this */
    if (s<t) best_itm=item[k],t=s;
    else if (item[k]<best_itm) best_itm=item[k];
  }
}
if ((vbose&show_details) &&
    level<show_choices_max && level>=maxl-show_choices_gap) {
  if (t==infty) fprintf(stderr," solution\n");
  else {
    fprintf(stderr," branching on");
    print_item_name(best_itm,stderr);
    fprintf(stderr,"("O"d)\n",t);
  }
}
if (t>maxdeg && t<infty) maxdeg=t;
@y
@ @<Increase the weight of |tough_itm|@>=
bmems+=2,oo,wt(tough_itm)++;
if (wt(tough_itm)<=0) {
  fprintf(stderr,"Weight overflow (2^31)!\n");
  exit(-6);
}
if (vbose&show_weight_bumps) {
  print_item_name(tough_itm,stderr);
  fprintf(stderr," wt "O"d\n",wt(tough_itm));
}

@ @<Sub...@>=
void print_weights(void) {
  register int k;
  for (k=0;k<itemlength;k++) if (item[k]<second && wt(item[k])!=1) {
    print_item_name(item[k],stderr);
    fprintf(stderr," wt "O"d\n",wt(item[k]));
  }
}

@ The ``best item'' is considered to be an item that minimizes the
number of remaining choices, divided by the item's weight.
If there are several candidates with the same minimum, we
choose the first one that we encounter.

Each primary item should have at least one valid choice, because
of domain consistency.

When an item has at most one option left, we consider it
to be forced (regardless of any weights). In other words,
an item with one option and small weight is preferred to an item
with two options and huge weight.

@d dangerous 1e32f
@d infty 0x7fffffff
@d finfty 2e32f /* twice |dangerous| */

@<Set |best_itm| to the best item for branching...@>=
{
  register float score,tscore,w;
  register int force;
  score=finfty,t=infty;
  if ((vbose&show_details) &&
      level<show_choices_max && level>=maxl-show_choices_gap)
    fprintf(stderr,"Level "O"d:",level);
  for (k=0;t>1 && k<active;k++) if (o,item[k]<second) {
    o,s=size(item[k]);
    if (s<=1) {
      if (s==0) fprintf(stderr,"I'm confused.\n"); /* |include_option| missed this */
      t=1,best_itm=item[k];
    }@+else {
      o,w=wt(item[k]);
      tscore=s/w;
      if (tscore>=finfty) tscore=dangerous;
      if (tscore<score) best_itm=item[k],score=tscore,t=s;
    }
    if ((vbose&show_details) &&
        level<show_choices_max && level>=maxl-show_choices_gap) {
      print_item_name(item[k],stderr);@+
      if (t==1) fprintf(stderr,"(1)");
      else fprintf(stderr,"("O"d,"O"d)",s,wt(item[k]));
    }
  }
  if ((vbose&show_details) &&
      level<show_choices_max && level>=maxl-show_choices_gap) {
    if (t==infty) fprintf(stderr," solution\n");
    else {
      fprintf(stderr," branching on");
      print_item_name(best_itm,stderr);@+
      if (t==1) fprintf(stderr,"(forced)\n");
      else fprintf(stderr,"("O"d), score "O".4f\n",t,score);
    }
  }
  if (t>maxdeg && t<infty) maxdeg=t;
}
@z
