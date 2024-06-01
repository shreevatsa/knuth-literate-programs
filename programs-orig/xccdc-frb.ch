@x
@ After this program finds all solutions, it normally prints their total
@y
This version of {\mc XCCDC} uses a dynamic weighting scheme, namely
the ``{\mc FRB} heuristic,'' motivated by the paper
of Li, Yin, and Li in
@^Li, Hongbo@>
@^Yin, Minghao@>
@^Li, Zhanshan@>
{\sl Leibniz International Proceedings in Informatics\/ \bf210}
(2021), 9:1--9:10
[the proceedings of the 27th International Conference on Principles and
Practice of Constraint Programming, CP~2021].
When the option chosen for branching on some primary item~$i$ causes
another primary item~$i'$ to be wiped out, we say that a failure has
occurred with respect to~$i$. We branch on an item
that has a small number of options and a relatively high failure rate.
Details are discussed below.

@ After this program finds all solutions, it normally prints their total
@z
@x
@d show_max_deg 2048 /* |vbose| code for reporting maximum branching degree */
@y
@d show_max_deg 2048 /* |vbose| code for reporting maximum branching degree */
@d show_final_stats 4096 /* |vbose| code to display item stats at the end */
@z
@x
if (vbose&show_profile) @<Print the profile@>;
@y
if (vbose&show_profile) @<Print the profile@>;
if (vbose&show_final_stats) {
  fprintf(stderr,"Final primary item stats:\n");
  print_item_stats();
}
@z
@x
(The |match| field is present only in secondary items.)
@y
(The |match| field is present only in secondary items.)

Finally, a primary item $x$ also has two special fields called
|assigns| and |fails|, used in the {\mc FRB} heuristic.
Their significance is described below.
@z
@x
@d match(x) set[(x)-6] /* a required color in compatibility tests */
@d primextra 5 /* this many extra entries of |set| for each primary item */
@d secondextra 6  /* and this many for each secondary item */
@d maxextra 6 /* maximum of |primextra| and |secondextra| */
@y
@d match(x) set[(x)-6] /* a required color in compatibility tests */
@d assigns(x) set[(x)-6] /* number of assignments tried so far for |x|, plus 1 */
@d fails(x) set[(x)-7] /* how many of them failed? */
@d primextra 7 /* this many extra entries of |set| for each primary item */
@d secondextra 6  /* and this many for each secondary item */
@d maxextra 7 /* maximum of |primextra| and |secondextra| */
@z
@x
  if (c<second) fprintf(stderr," ("O"d of "O"d), length "O"d:\n",
         pos(c)+1,active,size(c));
@y
  if (c<second) fprintf(stderr," ("O"d of "O"d), fails "O"d of "O"d, length "O"d:\n",
         pos(c)+1,active,fails(c),assigns(c)-1,size(c));
@z
@x
  o,mark(j)=0;
@y
  o,mark(j)=0;
  if (k<=osecond) oo,assigns(j)=1,fails(j)=0;@+else o,match(j)=0;
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
    @<Take account of a failure for |best_itm|@>;
    goto tryagain;
  }
  if (!empty_the_queue()) {
    nmems+=mems-tmems;
    @<Take account of a failure for |best_itm|@>;
    goto tryagain;
  }
  @<Take account of a nonfailure for |best_itm|@>;
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
@ The heuristics used in this program are based on the special
fields |assigns| and |fails| of each primary item~|i|.

The |assigns| field simply counts the number of assignments made to~|i|
so far, namely the number of times we've branched on~|i| by trying
to include one of its options. However, we start it at~1, not~0,
in order to save a few nanoseconds in the running time.

An assignment {\it fails\/} if it wipes out the options for some
other primary variable that it doesn't cover. The |fails| field
simply counts the number of failures.

From these two fields we can calculate the ``failure rate,''
which Li, Yin, and Li defined to be $(|fails|+1/2)/|assigns|$
in their paper cited above.
@^Li, Hongbo@>
@^Yin, Minghao@>
@^Li, Zhanshan@>

@<Take account of a nonfailure for |best_itm|@>=
oo,assigns(best_itm)++;
if (assigns(best_itm)<=0) {
  fprintf(stderr,"Too many assignments (2^{31})!\n");
  exit(-6);
}
bmems+=2;

@ @<Take account of a failure for |best_itm|@>=
oo,assigns(best_itm)++;
if (assigns(best_itm)<=0) {
  fprintf(stderr,"Too many assignments (2^{31})!\n");
  exit(-66);
}
oo,fails(best_itm)++;
bmems+=4;

@ @<Sub...@>=
void print_item_stats(void) {
  register int k;
  for (k=0;k<itemlength;k++) if (item[k]<second && assigns(item[k])!=1) {
    print_item_name(item[k],stderr);
    fprintf(stderr," fails "O"d of "O"d\n",
           fails(item[k]),assigns(item[k])-1);
  }
}

@ The ``best item'' is considered to be an item that minimizes the
number of remaining choices, divided by the item's failure rate.
If there are several candidates with the same minimum, we
choose the first one that we encounter.

Each primary item should have at least one valid choice, because
of domain consistency.

When an item has at most one option left, we consider it
to be forced (regardless of the failure rate). In other words,
an item with one option and few failures is preferred to an item
with two options and huge failure rate.

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
      o,w=(float)fails(item[k])+0.5;
      o,w/=assigns(item[k]);
      tscore=s/w;
      if (tscore>=finfty) tscore=dangerous;
      if (tscore<score) best_itm=item[k],score=tscore,t=s;
    }
    if ((vbose&show_details) &&
        level<show_choices_max && level>=maxl-show_choices_gap) {
      print_item_name(item[k],stderr);@+
      if (t==1) fprintf(stderr,"(1)");
      else fprintf(stderr,"("O"d,"O"d/"O"d)",s,fails(item[k]),assigns(item[k]));
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
