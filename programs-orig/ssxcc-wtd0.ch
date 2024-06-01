@x a change file for SSXCC [not SSXCC-BINARY]
@ After this program finds all solutions, it normally prints their total
@y
This program differs from {\mc SSXCC} by choosing the item on which
to branch based on a ``weighted'' heuristic proposed by
Boussemart, Hemery, Lecoutre, and Sais in {\sl Proc.\ 16th
European Conference on Artificial Intelligence} (2004), 146--150: We increase
the weight of a primary item when its current set of options becomes null.
Items are chosen for branching based on the size of their set divided by their
current weight, unless the choice is forced.
@^Boussemart, Fr\'ed\'eric@>
@^H\'emery, Fred@>
@^Lecoutre, Christophe@>
@^Sa{\"\i}s, Lakhdar@>

It's the same heuristic as in {\mc SSXCC-WTD}. But that version uses
binary branching, while this one (like {\mc SSXCC} itself)
uses $d$-way branching.

@ After this program finds all solutions, it normally prints their total
@z
@x
done:@+if (vbose&show_profile) @<Print the profile@>;
@y
done:@+if (vbose&show_profile) @<Print the profile@>;
if (vbose&show_final_weights) {
  fprintf(stderr,"Final weights:\n");
  print_weights();
}
@z
@x
@d show_max_deg 2048 /* |vbose| code for reporting maximum branching degree */
@y
@d show_max_deg 2048 /* |vbose| code for reporting maximum branching degree */
@d show_final_weights 4096 /* |vbose| code to display weights at the end */
@d show_weight_bumps 8192 /* |vbose| code to show new weights */
@z
@x
The given options are stored sequentially in the |nd| array, with one node
@y
The |set| array contains a |wt| field for each primary item.
This weight, initially~1, is increased by 1 whenever we run into a
situation where |x| cannot be supported.

The given options are stored sequentially in the |nd| array, with one node
@z
@x
@d primextra 4 /* this many extra entries of |set| for each primary item */
@d secondextra 4  /* and this many for each secondary item */
@d maxextra 4 /* maximum of |primextra| and |secondextra| */
@y
@d wt(x) set[(x)-5] /* the current weight of item |x| */
@d primextra 5 /* this many extra entries of |set| for each primary item */
@d secondextra 4  /* and this many for each secondary item */
@d maxextra 5 /* maximum of |primextra| and |secondextra| */
@z
@x
int forced; /* the number of items on that stack */
@y
int forced; /* the number of items on that stack */
int tough_itm; /* an item that led to difficulty */
@z
@x
  if (c<second) fprintf(stderr," ("O"d of "O"d), length "O"d:\n",
         pos(c)+1,active,size(c));
@y
  if (c<second) fprintf(stderr," ("O"d of "O"d), weight "O"d, length "O"d:\n",
         pos(c)+1,active,wt(c),size(c));
@z
@x
  oo,rname(j)=rname(k<<2),lname(j)=lname(k<<2);
@y
  oo,rname(j)=rname(k<<2),lname(j)=lname(k<<2);
  if (k<=osecond) o,wt(j)=1;
@z
@x
  if (t==max_nodes) @<Visit a solution and |goto backup|@>;
@y
  if (t==infty) @<Visit a solution and |goto backup|@>;
@z
@x
abort:@+if (o,cur_choice+1>=best_itm+size(best_itm)) goto backup;
@y
  goto try_again;
abort:@+@<Increase the weight of |tough_itm|@>;
try_again:@+if (o,cur_choice+1>=best_itm+size(best_itm)) goto backup;
@z
@x
          return 0;
@y
          tough_itm=uu;
          return 0;
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
@ @<Increase the weight of |tough_itm|@>=
cmems+=2,oo,wt(tough_itm)++;
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

However, all candidates of size~1, if any, are put only the |force| stack.
Thus an item with one option and small weight is preferred to an item
with two options and huge weight.

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
  score=finfty,t=infty,tmems=mems;
  if ((vbose&show_details) &&
      level<show_choices_max && level>=maxl-show_choices_gap)
    fprintf(stderr,"Level "O"d:",level);
  for (k=0;k<active;k++) if (o,item[k]<second) {
    o,s=size(item[k]);
    if (s<=1) {
        if (s==0) @<Forget about |best_itm| and |goto backup|@>;
        o,force[forced++]=item[k];
    }@+else {
      o,w=wt(item[k]);
      tscore=s/w;
      if (tscore>=finfty) tscore=dangerous;
      if (tscore<score) best_itm=item[k],score=tscore,t=s;
    }
    if ((vbose&show_details) &&
        level<show_choices_max && level>=maxl-show_choices_gap) {
      print_item_name(item[k],stderr);@+
      if (s==1) fprintf(stderr,"(1)");
      else fprintf(stderr,"("O"d,"O"d)",s,wt(item[k]));
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
has wiped out |item[k]|. Thus |item[k]| is not a ``best item'' for branching,
even though it manifestly has the smallest option list; it's really
a ``tough item.'' (Impossibly good.)

@<Forget about |best_itm| and |goto backup|@>=
{
  if ((vbose&show_details) &&
      level<show_choices_max && level>=maxl-show_choices_gap) {
    fprintf(stderr,"\n--- Item ");
    print_item_name(item[k],stderr);
    fprintf(stderr," has been wiped out!\n");
  }
  tough_itm=item[k];
  cmems+=mems-tmems;
  @<Increase the weight of |tough_itm|@>;
  forced=0;
  goto backup;
}

@ @<Maybe do a forced move@>=
@z
