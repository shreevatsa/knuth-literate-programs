@x a change file for SSXCC [not SSXCC-BINARY]
@ After this program finds all solutions, it normally prints their total
@y
This program differs from {\mc SSXCC} by choosing the item on which
to branch based on a ``weighted'' heuristic motivated by the paper
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

It's the same heuristic as in {\mc SSXCC-FRB}. But that version uses
binary branching, while this one (like {\mc SSXCC} itself)
uses $d$-way branching.

@ After this program finds all solutions, it normally prints their total
@z
@x
done:@+if (vbose&show_profile) @<Print the profile@>;
@y
if (vbose&show_profile) @<Print the profile@>;
done:@+if (vbose&show_profile) @<Print the profile@>;
  if (vbose&show_final_stats) {
  fprintf(stderr,"Final primary item stats:\n");
  print_item_stats();
}
@z
@x
@d show_max_deg 2048 /* |vbose| code for reporting maximum branching degree */
@y
@d show_max_deg 2048 /* |vbose| code for reporting maximum branching degree */
@d show_final_stats 4096 /* |vbose| code to display item stats at the end */
@z
@x
The given options are stored sequentially in the |nd| array, with one node
@y
Each primary item in the |set| array also contains two special fields called
|assigns| and |fails|, which are used in the {\mc FRB} heuristic.
Their significance is described below.

The given options are stored sequentially in the |nd| array, with one node
@z
@x
@d primextra 4 /* this many extra entries of |set| for each primary item */
@d secondextra 4  /* and this many for each secondary item */
@d maxextra 4 /* maximum of |primextra| and |secondextra| */
@y
@d assigns(x) set[(x)-5] /* number of assignments tried so far for |x|, plus 1 */
@d fails(x) set[(x)-6] /* how many of them failed? */
@d primextra 6 /* this many extra entries of |set| for each primary item */
@d secondextra 4  /* and this many for each secondary item */
@d maxextra 6 /* maximum of |primextra| and |secondextra| */
@z
@x
  if (c<second) fprintf(stderr," ("O"d of "O"d), length "O"d:\n",
         pos(c)+1,active,size(c));
@y
  if (c<second) fprintf(stderr," ("O"d of "O"d), fails "O"d of "O"d, length "O"d:\n",
         pos(c)+1,active,fails(c),assigns(c)-1,size(c));
@z
@x
  oo,rname(j)=rname(k<<2),lname(j)=lname(k<<2);
@y
  oo,rname(j)=rname(k<<2),lname(j)=lname(k<<2);
  if (k<=osecond) oo,assigns(j)=1,fails(j)=0;
@z
@x
  if (t==max_nodes) @<Visit a solution and |goto backup|@>;
@y
  if (t==infty) @<Visit a solution and |goto backup|@>;
@z
@x
  @<Hide the other options of those items, or |goto abort|@>;
@y
  @<Hide the other options of those items, or |goto abort|@>;
  @<Take account of a nonfailure for |best_itm|@>;
@z
@x
abort:@+if (o,cur_choice+1>=best_itm+size(best_itm)) goto backup;
@y
  goto try_again;
abort:@+@<Take account of a failure for |best_itm|@>;
try_again:@+if (o,cur_choice+1>=best_itm+size(best_itm)) goto backup;
@z
@x
@ The ``best item'' is considered to be an item that minimizes the
number of remaining choices. All candidates of size~1, if any, are
put on the |force| stack. If there are several candidates of size $>1$,
we choose the leftmost.

Notice that a secondary item is active if and only if it has not
been purified (that is, if and only if it hasn't yet appeared in
a chosen option).

(This program explores the search space in a slightly different order
from {\mc DLX2}, because the ordering of items in the active list
is no longer fixed. But ties are broken in the same way when $s>1$.)

@<Set |best_itm| to the best item for branching@>=
t=max_nodes,tmems=mems;
if ((vbose&show_details) &&
    level<show_choices_max && level>=maxl-show_choices_gap)
  fprintf(stderr,"Level "O"d:",level);
for (k=0;k<active;k++) if (o,item[k]<second) {
  o,s=size(item[k]);
  if ((vbose&show_details) &&
      level<show_choices_max && level>=maxl-show_choices_gap) {
    print_item_name(item[k],stderr);
    fprintf(stderr,"("O"d)",s);
  }
  if (s<=1) {
      if (s==0) fprintf(stderr,"I'm confused.\n"); /* |hide| missed this */
      else o,force[forced++]=item[k];
  }@+else if (s<=t) {
    if (s<t) best_itm=item[k],t=s;
    else if (item[k]<best_itm) best_itm=item[k]; /* suggested by P. Weigel */
  }
}
if ((vbose&show_details) &&
    level<show_choices_max && level>=maxl-show_choices_gap) {
  if (forced) fprintf(stderr," found "O"d forced\n",forced);
  else if (t==max_nodes) fprintf(stderr," solution\n");
  else {
    fprintf(stderr," branching on");
    print_item_name(best_itm,stderr);
    fprintf(stderr,"("O"d)\n",t);
  }
}
if (t>maxdeg && t<max_nodes && !forced) maxdeg=t;
if (shape_file) {
  if (t==max_nodes) fprintf(shape_file,"sol\n");
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
cmems+=2;

@ @<Take account of a failure for |best_itm|@>=
oo,assigns(best_itm)++;
if (assigns(best_itm)<=0) {
  fprintf(stderr,"Too many assignments (2^{31})!\n");
  exit(-66);
}
oo,fails(best_itm)++;
cmems+=4;

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

However, all candidates of size~1, if any, are put only the |force| stack.
Thus an item with one option and few failures is preferred to an item
with two options and huge failure rate.

A somewhat surprising case arises, because a candidate can now have
size~0; this isn't possible when the {\mc MRV} heuristic is used,
as in {\mc SSXCC}, because |hide| will nip such cases in the bud.
It arises when there's an item $i$ whose options all include another
item~$j$, and when $j$ is chosen for branching. Then $i$ will have
no options left when we use an option that includes $j$ but not~$i$.

@d dangerous 1e32f
@d infty 0x7fffffff
@d finfty 2e32f /* twice |dangerous| */

@<Set |best_itm| to the best item for branching...@>=
{
  register float score,tscore,w;
  tmems=mems,score=finfty,t=infty;
  if ((vbose&show_details) &&
      level<show_choices_max && level>=maxl-show_choices_gap)
    fprintf(stderr,"Level "O"d:",level);
  for (k=0;k<active;k++) if (o,item[k]<second) {
    o,s=size(item[k]);
    if (s<=1) {
        if (s==0) @<Forget about |best_itm| and |goto backup|@>;
        o,force[forced++]=item[k];
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
      if (s==1) fprintf(stderr,"(1)");
      else fprintf(stderr,"("O"d,"O"d/"O"d)",s,fails(item[k]),assigns(item[k]));
    }
  }
  if ((vbose&show_details) &&
      level<show_choices_max && level>=maxl-show_choices_gap) {
    if (forced) fprintf(stderr," found "O"d forced\n",forced);
    else if (t==infty) fprintf(stderr," solution\n");
    else {
      fprintf(stderr," branching on");
      print_item_name(best_itm,stderr);
      fprintf(stderr,"("O"d), score "O".4f\n",t,score);
    }
  }
  if (t>maxdeg && t<infty) maxdeg=t;
}
if (t>maxdeg && t<infty && !forced) maxdeg=t;
if (shape_file) {
  if (t==infty) fprintf(shape_file,"sol\n");
@z
@x
@ @<Maybe do a forced move@>=
@y
@ Oops --- we've run into a case where the current choice at |level-1|
has wiped out |item[k]|. Thus |item[k]|, which manifestly has the
smallest option list, is a |best_item| doomed to fail.

@<Forget about |best_itm| and |goto backup|@>=
{
  if ((vbose&show_details) &&
      level<show_choices_max && level>=maxl-show_choices_gap) {
    fprintf(stderr,"\n--- Item ");
    print_item_name(item[k],stderr);
    fprintf(stderr," has been wiped out!\n");
  }
  best_itm=item[k];
  @<Take account of a failure for |best_itm|@>;
  forced=0;
  goto backup;
}

@ @<Maybe do a forced move@>=
@z
